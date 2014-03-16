#!/opt/local/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper; $Data::Dumper::Sortkeys= 1; $Data::Dumper::Deepcopy = 1;

########################################################################
# 
# File   :  habitrpg_content_parser.pl
# History:  2014-03-06 (LadyAlys) script creation
#           2014-03-07 (LadyAlys) severe gutting and rewriting for
#                      improved reusability
# 
# Licence:  http://creativecommons.org/licenses/by-nc-sa/3.0/
# 
# Contact Details:
#           LadyAlys: http://habitrpg.wikia.com/wiki/User:LadyAlys
#                     alice.harris@oldgods.net
#
########################################################################
#
# This script parses the JSON data that describe's HabitRPG's "content"
# (equipment, etc). It produces output depending on the command-line
# parameter(s).
#
# HabitRPG: http://habitrpg.com/
#           http://habitrpg.wikia.com/
# 
########################################################################



my $control = $ARGV[0];
########################################################################
# COMMAND LINE ARGUMENT - what you want this script to do
# For a list of all possibilities, search the code for $control ;)
# Some controls allow second command line arguments - search for $ARG
########################################################################
unless ($control) {
    die "\nSpecify a command line parameter to control what this script"
      . " will do.\n"
      . "To find the allowed parameters, search the script for"
      . " '\$control'\n\n";
}



my $data_file = "/Users/alys/bin/hrpg/.content.json";
########################################################################
# SOURCE OF DATA - CUSTOMISE THAT $data_file LINE!
# It should point to a file that contains the full content from
# this API call:
#     https://habitrpg.com:443/api/v2/content
# I.e., the contents of the file should look somthing vaguely
# like this (spaces and line breaks are not significant):
#   {
#     "gear": {
#       "tree": {
#         "weapon": {
#           "base": {
#             "0": {
#               "text": "No Weapon",
#         ....
#         ....
#         ....
#         {
#           "name": "afternoon"
#         },
#         {
#           "name": "evening"
#         }
#       ]
#     }
#   }
# 
# See the bottom of this script (under __END__ line) for sample data
# to get an idea of the data structure that this script uses after it
# has parsed the JSON data.
########################################################################


my %image_for_key = create_image_lookup_table();
########################################################################
# IMAGE FILENAMES IN WIKI
# When images are added to the wiki, or when existing images have their
# filenames changed, you'll need to edit the data in that subroutine.
########################################################################


########################################################################
# END OF CUSTOMISATION (unless you want to change the code of course)
########################################################################


my $all_data_href = get_all_data($data_file);
# warn Dumper($all_data_href)."\n";
# See the bottom of this script (under __END__ line) for sample data
# to get an idea of useful parts of the data structure in $all_data_href


if ($control eq "listgearkeys") {
    my $format = $ARGV[1] || ""; # if not specified, a default is used
    my $gear_href = $all_data_href->{'gear'}{'flat'};
    foreach my $key (sort keys %$gear_href) {
        my $text  = $gear_href->{$key}{'text'}; # item name (e.g., Dagger)
        if ($format eq "hash") {
            # Output the item keys and names in the correct format
            # for creating a Perl hash array (e.g., to put into
            # another script).
            print "'$key' => '$text',\n";
        }
        else {
            # DEFAULT (if user specified any other format option, or none)
            print "$key :: $text\n";
        }
    }
  exit;
}


elsif ($control eq "infobox") {
    my $desired_key = $ARGV[1] || "";
    unless ($desired_key) {
        print "\n"
            . "To get an infobox for an item, specify the item's key, e.g.:\n"
            . "$0 infobox weapon_warrior_1\n"
            . "\n"
            . "To find the allowed keys, do this:\n"
            . "$0 listgearkeys\n"
            . "\n"
            . "Specify 'all' instead of a key to get infoboxes for"
            . " all items.\n"
            . "\n";
  exit;
    }
    my @keys = ($desired_key eq "all")
             ? sort keys %{$all_data_href->{'gear'}{'flat'}}
             : ($desired_key); 

    foreach my $key (@keys) {
        my $data_href = $all_data_href->{'gear'}{'flat'}{$key};
        unless (defined $data_href) {
            die "ERROR: Unknown key '$key'";
        }
        my %data = %{ $all_data_href->{'gear'}{'flat'}{$key} };
        # warn Dumper(\%data)."\n";
        my $image = $image_for_key{$key} || "NO IMAGE YET";
        my $stats = make_stats_string(\%data, "infobox");
        print "\n";
        print "{{infobox item\n";
        print " | title         = $data{'text'}\n";
        print " | image         = $image\n";
        print " | imagecaption  = $data{'notes'}\n";
        print " | buy           = $data{'value'}g\n";
        print " | sell          = N/A\n";
        print " | bonus         = $stats\n";
        print "}}";
        print "\n\n";
        # NOTE: Separate print statements make it much easier to
        # troubleshoot when you get "uninitialised value" warnings!
    }
  exit;
}


else {
    die "\nERROR: The parameter '$control' is unknown.\n"
      . "To find the allowed parameters, search the script for"
      . "'\$control'\n\n";
}



exit;


sub make_stats_string {
    my ($data_href, $format) = @_;
    $format ||= "infobox";  # how the stats will be formatted
    my $output = "";
    foreach my $attribute ('con', 'int', 'per', 'str') {
        my $value = $data_href->{$attribute} || 0;
        if ($format eq "infobox") {
            next if $value == 0;
            $output .= "; " if $output;
            $output .= "+$value to " . uc($attribute);
        }
        else {
            die "ERROR: Don't know how to format stats as '$format'";
        }
    }
    return $output;
}


sub get_all_data {
    my ($file) = @_;

    open FILE, $file or die "ERROR: Can't read file '$file': $!";
    my $utf8_encoded_json_text = join "\n", (<FILE>);
    close FILE;
    my $all_data_href = decode_json $utf8_encoded_json_text;
    # warn Dumper(\$all_data_href)."\n";
    return $all_data_href;
}


sub create_image_lookup_table {
    # IMAGE FILENAMES IN WIKI
    # When images are added to the wiki, or when existing images
    # have their filenames changed, you'll need to edit the data
    # in the $raw_data string below. It's designed for ease of editing:
    # - The first word on each line is the key for an item (see
    # the listgearkeys option for $control).
    # - After that is any amount of whitespace (but not line breaks).
    # - The word(s) after the whitespace are the filename of the
    # image on the wiki. Spaces are acceptable in the filename
    # if the person who uploaded it was foolish enough to include them.
    # To get the filename, look in the wiki for a "File:" link that
    # would be used to display the image, and subtract [[File: and ]].
    # For example, for [[File:Sapphireblade.png]], the line in $raw_data
    # would be:
    #      weapon_warrior_4   Sapphireblade.png

    # XXX - NEED TO FIND IMAGES FOR THESE:
    # back_mystery_201402   (Golden Wings)
    # armor_mystery_201402  (Messenger Robes)
    # head_mystery_201402   (Winged Helm)
    my $raw_image_data = qq|

armor_healer_1              Acolyterobe.png
armor_healer_2              Medicrobe.png
armor_healer_3              Defendervestment.png
armor_healer_4              Priestvestment.png
armor_healer_5              Royalvestment.png
armor_rogue_1               Oiledleatherarmor.png
armor_rogue_2               Blackleatherarmor.png
armor_rogue_3               Camoarmor.png
armor_rogue_4               Penumbralarmor.png
armor_rogue_5               Umbralarmor.png
armor_special_0             BackerOnly-Equip-ShadeArmor.gif
armor_special_1             ContributorOnly-Equip-CrystalArmor.gif
armor_special_2             Chalard_Tunic.png
armor_special_birthday      Absurd_Party_Robes_40x40px.png
armor_special_candycane     Candycanerobe.png
armor_special_ski           SkisassinParka.png
armor_special_snowflake     SnowflakeRobe.png
armor_special_yeti          Yetitamerrobe.png
armor_warrior_1             A1.png
armor_warrior_2             A2.png
armor_warrior_3             A3.png
armor_warrior_4             A4.png
armor_warrior_5             A5.png
armor_wizard_1              Magicianrobe.png
armor_wizard_2              Wizardrobe.png
armor_wizard_3              Robeofmysteries.png
armor_wizard_4              Archmagerobe.png
armor_wizard_5              Royalmagusrobe.png
head_healer_1               Quartzcirclet.png
head_healer_2               Amethystcirclet.png
head_healer_3               Sapphire_circlet.png
head_healer_4               Emeralddiadem.png
head_healer_5               Royaldiadem.png
head_rogue_1                Leatherhood.png
head_rogue_2                Blackleatherhood.png
head_rogue_3                Camohood.png
head_rogue_4                Penumbralhood.png
head_rogue_5                Umbralhood.png
head_special_0              BackerOnly-Equip-ShadeHelmet.gif
head_special_1              ContributorOnly-Equip-CrystalHelmet.gif
head_special_2              Nameless_Helm.png
head_special_candycane      Candycanehat.png
head_special_nye            Absurd_Party_Hat.png
head_special_ski            SkisassinHelm.png
head_special_snowflake      SnowflakeCrown.png
head_special_yeti           Yetitamerhelm.png
head_warrior_1              H1.png
head_warrior_2              H1.png
head_warrior_3              H3.png
head_warrior_4              H4.png
head_warrior_5              H5.png
head_wizard_1               Magicianhat.png
head_wizard_2               Cornuthaum.png
head_wizard_3               Astrologerhat.png
head_wizard_4               Archmagehat.png
head_wizard_5               Head_wizard_5.png
shield_healer_1             Medicbuckler.png
shield_healer_2             Kiteshield.png
shield_healer_3             Hospitalershield.png
shield_healer_4             Saviorshield.png
shield_healer_5             Royalshield.png
shield_rogue_0              Dagger.png
shield_rogue_1              Shortsword.png
shield_rogue_2              Scimitar.png
shield_rogue_3              Kukri.png
shield_rogue_4              Nunchaku.png
shield_rogue_5              Ninja-to.png
shield_rogue_6              Hooksword.png
shield_special_0            BackerOnly-Shield-TormentedSkull.gif
shield_special_1            Contributor_Shield.png
shield_special_ski          SkisassinPoleL.png
shield_special_snowflake    SnowflakeShield.png
shield_special_yeti         Yetitamershield.png
shield_warrior_1            S1.png
shield_warrior_2            S2.png
shield_warrior_3            S3.png
shield_warrior_4            S4.png
shield_warrior_5            S5.png
weapon_healer_0             Novicerod.png
weapon_healer_1             Acolyterod.png
weapon_healer_2             Quartzrod.png
weapon_healer_3             Amethystrod.png
weapon_healer_4             Priestrod.png
weapon_healer_5             Royalcrosier.png
weapon_healer_6             Goldencrosier.png
weapon_rogue_0              Dagger.png
weapon_rogue_1              Shortsword.png
weapon_rogue_2              Scimitar.png
weapon_rogue_3              Kukri.png
weapon_rogue_4              Nunchaku.png
weapon_rogue_5              Ninja-to.png
weapon_rogue_6              Hooksword.png
weapon_special_0            BackerOnly-Weapon-DarkSoulsBlade.gif
weapon_special_1            ContributorOnly-Equip-CrystalBlade.png
weapon_special_2            Weber_Shaft.png
weapon_special_3            Mustaine_Morning_Star.png
weapon_special_candycane    Candycanestaff.png
weapon_special_critical     Glow_hammer_gif_by_zoebeagle.gif
weapon_special_ski          SkisassinPoleR.png
weapon_special_snowflake    SnowflakeWand.png
weapon_special_yeti         Yetitamerspear.png
weapon_warrior_0            Trainingsword.png
weapon_warrior_1            WarriorSword.png
weapon_warrior_2            Axe.png
weapon_warrior_3            Morningstar.png
weapon_warrior_4            Sapphireblade.png
weapon_warrior_5            Redsword.png
weapon_warrior_6            Goldensword.png
weapon_wizard_0             Apprenticestaff.png
weapon_wizard_1             Woodenstaff.png
weapon_wizard_2             Jeweledstaff.png
weapon_wizard_3             Ironstaff.png
weapon_wizard_4             Brassstaff.png
weapon_wizard_5             Archmagestaff.png
weapon_wizard_6             Weapon_wizard_6.png

|;

    my %image_for_key;
    foreach my $line (split /\n/, $raw_image_data) {
        next if $line =~ m/^\s*$/; # blank lines
        if ($line =~ m/^\s*(\S+)\s+(.+?)\s*$/) {
            my ($key, $filename) = ($1, $2);
            if ($image_for_key{$key} and $image_for_key{$key} ne $filename) {
                die "ERROR: We already have an image for '$key'"
                  . " ($image_for_key{$key}) and now we've found a new one"
                  . " ($filename). Please remove the incorrect one"
                  . " from \$raw_image_data\n";
            }
            else {
                $image_for_key{$key} = $filename;
            }
        }
        else {
            die "\nERROR: This line in \$raw_image_data is not in the"
              . " correct format:\n'$line'\n\n";
        }
    }

    return %image_for_key;
}




__END__

Useful top-level items from the $all_data_href data structure:

'gearTypes' => [
                 'armor',
                 'weapon',
                 'shield',
                 'head',
                 'back'
               ],


'gear' => {
    'flat' => {
            'armor_base_0' => {
                                'con' => 0,
                                'index' => '0',
                                'int' => 0,
                                'key' => 'armor_base_0',
                                'klass' => 'base',
                                'notes' => 'Ordinary clothing. Confers no benefit.',
                                'per' => 0,
                                'str' => 0,
                                'text' => 'Plain Clothing',
                                'type' => 'armor',
                                'value' => 0
                              },
            'armor_healer_1' => {
                                  'con' => 6,
                                  'index' => '1',
                                  'int' => 0,
                                   .....
                                   .....
                                   .....
                                 }
          },
    'tree' => {
        'armor' => {
             'base' => {
                 '0' => {
                  'con' => 0,
                  'index' => '0',
                  'int' => 0,
                  'key' => 'armor_base_0',
                  'klass' => 'base',
                  'notes' => 'Ordinary clothing. Confers no benefit.',
                  'per' => 0,
                  'str' => 0,
                  'text' => 'Plain Clothing',
                  'type' => 'armor',
                      'value' => 0
                    }
           },
             'healer' => {
                   '1' => {
                    'con' => 6,
                        'index' => '1',
                                'int' => 0,
                                'key' => 'armor_healer_1',
                               .....
                               .....
                               .....
                               }
                      }
        }
    }
},
