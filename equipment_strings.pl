#!/opt/local/bin/perl

# Converts a list of filenames into a string containing the code for a 
# JavaScript object that lists equipment keys and the associated image
# file paths (intended to be pasted into habitrpg_user_data_display.html).
# Create the list of filenames with commands like this:
#     cd ~/Sites; find gear -type f

use strict;
use warnings;
use Data::Dumper; $Data::Dumper::Sortkeys= 1;

my $paths = '

gear/armor/shop/shop_armor_healer_1.png
gear/armor/shop/shop_armor_healer_2.png
gear/armor/shop/shop_armor_healer_3.png
gear/armor/shop/shop_armor_healer_4.png
gear/armor/shop/shop_armor_healer_5.png
gear/armor/shop/shop_armor_rogue_1.png
gear/armor/shop/shop_armor_rogue_2.png
gear/armor/shop/shop_armor_rogue_3.png
gear/armor/shop/shop_armor_rogue_4.png
gear/armor/shop/shop_armor_rogue_5.png
gear/armor/shop/shop_armor_special_0.png
gear/armor/shop/shop_armor_special_1.png
gear/armor/shop/shop_armor_special_2.png
gear/armor/shop/shop_armor_warrior_1.png
gear/armor/shop/shop_armor_warrior_2.png
gear/armor/shop/shop_armor_warrior_3.png
gear/armor/shop/shop_armor_warrior_4.png
gear/armor/shop/shop_armor_warrior_5.png
gear/armor/shop/shop_armor_wizard_1.png
gear/armor/shop/shop_armor_wizard_2.png
gear/armor/shop/shop_armor_wizard_3.png
gear/armor/shop/shop_armor_wizard_4.png
gear/armor/shop/shop_armor_wizard_5.png
gear/events/birthday/shop_armor_special_birthday.png
gear/events/fall/shop/shop_armor_special_fallHealer.png
gear/events/fall/shop/shop_armor_special_fallMage.png
gear/events/fall/shop/shop_armor_special_fallRogue.png
gear/events/fall/shop/shop_armor_special_fallWarrior.png
gear/events/fall/shop/shop_head_special_fallHealer.png
gear/events/fall/shop/shop_head_special_fallMage.png
gear/events/fall/shop/shop_head_special_fallRogue.png
gear/events/fall/shop/shop_head_special_fallWarrior.png
gear/events/fall/shop/shop_shield_special_fallHealer.png
gear/events/fall/shop/shop_shield_special_fallRogue.png
gear/events/fall/shop/shop_shield_special_fallWarrior.png
gear/events/fall/shop/shop_weapon_special_fallHealer.png
gear/events/fall/shop/shop_weapon_special_fallMage.png
gear/events/fall/shop/shop_weapon_special_fallRogue.png
gear/events/fall/shop/shop_weapon_special_fallWarrior.png
gear/events/gaymerx/shop_armor_special_gaymerx.png
gear/events/gaymerx/shop_head_special_gaymerx.png
gear/events/mystery_201402/shop_armor_mystery_201402.png
gear/events/mystery_201402/shop_back_mystery_201402.png
gear/events/mystery_201402/shop_head_mystery_201402.png
gear/events/mystery_201403/shop_armor_mystery_201403.png
gear/events/mystery_201403/shop_headAccessory_mystery_201403.png
gear/events/mystery_201404/shop_back_mystery_201404.png
gear/events/mystery_201404/shop_headAccessory_mystery_201404.png
gear/events/mystery_201405/shop_armor_mystery_201405.png
gear/events/mystery_201405/shop_head_mystery_201405.png
gear/events/mystery_201406/shop_armor_mystery_201406.png
gear/events/mystery_201406/shop_head_mystery_201406.png
gear/events/mystery_201407/shop_armor_mystery_201407.png
gear/events/mystery_201407/shop_head_mystery_201407.png
gear/events/mystery_201408/shop_armor_mystery_201408.png
gear/events/mystery_201408/shop_head_mystery_201408.png
gear/events/mystery_201409/shop_armor_mystery_201409.png
gear/events/mystery_201409/shop_headAccessory_mystery_201409.png
gear/events/spring/shop/shop_armor_special_springHealer.png
gear/events/spring/shop/shop_armor_special_springMage.png
gear/events/spring/shop/shop_armor_special_springRogue.png
gear/events/spring/shop/shop_armor_special_springWarrior.png
gear/events/spring/shop/shop_head_special_springHealer.png
gear/events/spring/shop/shop_head_special_springMage.png
gear/events/spring/shop/shop_head_special_springRogue.png
gear/events/spring/shop/shop_head_special_springWarrior.png
gear/events/spring/shop/shop_headAccessory_special_springHealer.png
gear/events/spring/shop/shop_headAccessory_special_springMage.png
gear/events/spring/shop/shop_headAccessory_special_springRogue.png
gear/events/spring/shop/shop_headAccessory_special_springWarrior.png
gear/events/spring/shop/shop_shield_special_springHealer.png
gear/events/spring/shop/shop_shield_special_springRogue.png
gear/events/spring/shop/shop_shield_special_springWarrior.png
gear/events/spring/shop/shop_weapon_special_springHealer.png
gear/events/spring/shop/shop_weapon_special_springMage.png
gear/events/spring/shop/shop_weapon_special_springRogue.png
gear/events/spring/shop/shop_weapon_special_springWarrior.png
gear/events/summer/shop/shop_armor_special_summerHealer.png
gear/events/summer/shop/shop_armor_special_summerMage.png
gear/events/summer/shop/shop_armor_special_summerRogue.png
gear/events/summer/shop/shop_armor_special_summerWarrior.png
gear/events/summer/shop/shop_body_special_summerHealer.png
gear/events/summer/shop/shop_body_special_summerMage.png
gear/events/summer/shop/shop_head_special_summerHealer.png
gear/events/summer/shop/shop_head_special_summerMage.png
gear/events/summer/shop/shop_head_special_summerRogue.png
gear/events/summer/shop/shop_head_special_summerWarrior.png
gear/events/summer/shop/shop_headAccessory_special_summerRogue.png
gear/events/summer/shop/shop_headAccessory_special_summerWarrior.png
gear/events/summer/shop/shop_shield_special_summerHealer.png
gear/events/summer/shop/shop_shield_special_summerRogue.png
gear/events/summer/shop/shop_shield_special_summerWarrior.png
gear/events/summer/shop/shop_weapon_special_summerHealer.png
gear/events/summer/shop/shop_weapon_special_summerMage.png
gear/events/summer/shop/shop_weapon_special_summerRogue.png
gear/events/summer/shop/shop_weapon_special_summerWarrior.png
gear/events/winter/shop/shop_armor_special_candycane.png
gear/events/winter/shop/shop_armor_special_ski.png
gear/events/winter/shop/shop_armor_special_snowflake.png
gear/events/winter/shop/shop_armor_special_yeti.png
gear/events/winter/shop/shop_head_special_candycane.png
gear/events/winter/shop/shop_head_special_nye.png
gear/events/winter/shop/shop_head_special_ski.png
gear/events/winter/shop/shop_head_special_snowflake.png
gear/events/winter/shop/shop_head_special_yeti.png
gear/events/winter/shop/shop_shield_special_ski.png
gear/events/winter/shop/shop_shield_special_snowflake.png
gear/events/winter/shop/shop_shield_special_yeti.png
gear/events/winter/shop/shop_weapon_special_candycane.png
gear/events/winter/shop/shop_weapon_special_ski.png
gear/events/winter/shop/shop_weapon_special_snowflake.png
gear/events/winter/shop/shop_weapon_special_yeti.png
gear/events/wondercon/shop/shop_back_special_wondercon_black.png
gear/events/wondercon/shop/shop_back_special_wondercon_red.png
gear/events/wondercon/shop/shop_body_special_wondercon_black.png
gear/events/wondercon/shop/shop_body_special_wondercon_gold.png
gear/events/wondercon/shop/shop_body_special_wondercon_red.png
gear/events/wondercon/shop/shop_headAccessory_special_wondercon_black.png
gear/events/wondercon/shop/shop_headAccessory_special_wondercon_red.png
gear/head/shop/shop_head_healer_1.png
gear/head/shop/shop_head_healer_2.png
gear/head/shop/shop_head_healer_3.png
gear/head/shop/shop_head_healer_4.png
gear/head/shop/shop_head_healer_5.png
gear/head/shop/shop_head_rogue_1.png
gear/head/shop/shop_head_rogue_2.png
gear/head/shop/shop_head_rogue_3.png
gear/head/shop/shop_head_rogue_4.png
gear/head/shop/shop_head_rogue_5.png
gear/head/shop/shop_head_special_0.png
gear/head/shop/shop_head_special_1.png
gear/head/shop/shop_head_special_2.png
gear/head/shop/shop_head_warrior_1.png
gear/head/shop/shop_head_warrior_2.png
gear/head/shop/shop_head_warrior_3.png
gear/head/shop/shop_head_warrior_4.png
gear/head/shop/shop_head_warrior_5.png
gear/head/shop/shop_head_wizard_1.png
gear/head/shop/shop_head_wizard_2.png
gear/head/shop/shop_head_wizard_3.png
gear/head/shop/shop_head_wizard_4.png
gear/head/shop/shop_head_wizard_5.png
gear/shield/shop/shop_shield_healer_1.png
gear/shield/shop/shop_shield_healer_2.png
gear/shield/shop/shop_shield_healer_3.png
gear/shield/shop/shop_shield_healer_4.png
gear/shield/shop/shop_shield_healer_5.png
gear/shield/shop/shop_shield_rogue_0.png
gear/shield/shop/shop_shield_rogue_1.png
gear/shield/shop/shop_shield_rogue_2.png
gear/shield/shop/shop_shield_rogue_3.png
gear/shield/shop/shop_shield_rogue_4.png
gear/shield/shop/shop_shield_rogue_5.png
gear/shield/shop/shop_shield_rogue_6.png
gear/shield/shop/shop_shield_special_0.png
gear/shield/shop/shop_shield_special_1.png
gear/shield/shop/shop_shield_warrior_1.png
gear/shield/shop/shop_shield_warrior_2.png
gear/shield/shop/shop_shield_warrior_3.png
gear/shield/shop/shop_shield_warrior_4.png
gear/shield/shop/shop_shield_warrior_5.png
gear/weapon/shop/shop_weapon_healer_0.png
gear/weapon/shop/shop_weapon_healer_1.png
gear/weapon/shop/shop_weapon_healer_2.png
gear/weapon/shop/shop_weapon_healer_3.png
gear/weapon/shop/shop_weapon_healer_4.png
gear/weapon/shop/shop_weapon_healer_5.png
gear/weapon/shop/shop_weapon_healer_6.png
gear/weapon/shop/shop_weapon_rogue_0.png
gear/weapon/shop/shop_weapon_rogue_1.png
gear/weapon/shop/shop_weapon_rogue_2.png
gear/weapon/shop/shop_weapon_rogue_3.png
gear/weapon/shop/shop_weapon_rogue_4.png
gear/weapon/shop/shop_weapon_rogue_5.png
gear/weapon/shop/shop_weapon_rogue_6.png
gear/weapon/shop/shop_weapon_special_0.png
gear/weapon/shop/shop_weapon_special_1.png
gear/weapon/shop/shop_weapon_special_2.png
gear/weapon/shop/shop_weapon_special_3.png
gear/weapon/shop/shop_weapon_special_critical.png
gear/weapon/shop/shop_weapon_warrior_0.png
gear/weapon/shop/shop_weapon_warrior_1.png
gear/weapon/shop/shop_weapon_warrior_2.png
gear/weapon/shop/shop_weapon_warrior_3.png
gear/weapon/shop/shop_weapon_warrior_4.png
gear/weapon/shop/shop_weapon_warrior_5.png
gear/weapon/shop/shop_weapon_warrior_6.png
gear/weapon/shop/shop_weapon_wizard_0.png
gear/weapon/shop/shop_weapon_wizard_1.png
gear/weapon/shop/shop_weapon_wizard_2.png
gear/weapon/shop/shop_weapon_wizard_3.png
gear/weapon/shop/shop_weapon_wizard_4.png
gear/weapon/shop/shop_weapon_wizard_5.png
gear/weapon/shop/shop_weapon_wizard_6.png

';

my %lookups;
my $output = "var gearLookups = {\n";
foreach my $path (split /\n/, $paths) {
	next unless $path;
	if ($path =~ m"^(.*shop_(.+)\.png)$") {
		$lookups{$2} = $1;
		$output .= "    '$2': '$1',\n";
	}
	else {
		die "wtf path: $path\n";
	}
}
$output .= "};\n";
print "$output\n"; # TST
