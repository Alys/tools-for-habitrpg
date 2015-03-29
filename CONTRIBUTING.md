## Setting up for local development and testing

These instructions were based around a Fedora 21 workstation, but may be adapted to anything with apache.

### Ensure httpd is installed and running
```
sudo systemctl status httpd
```

### Get sample data for testing

Download these files and place them in `/var/www/cgi-bin`. I also added outer braces and removed the comma at the end of these files so they were valid JSON. That way I could read them in as JSON files, then insert that test habit data into my user json:

* http://oldgods.net/habitrpg/habits-many.json
* http://oldgods.net/habitrpg/habits-very-many.json

Get sample user, content, and tavern data and put them in `/var/www/cgi-bin` too. You can get that info from peaking at the requests made by oldgods.net with your browser's dev tools

### Add cgi scripts.

Here is what I used, where `user.json`, `content.json`, and `tavern.json` have the json responses from the corresponding requests on oldgods.net with my user info. These should be modified to your needs, and only serve as an example.

#### /var/www/cgi-bin/hrpg_user.pl

```perl
#! /usr/bin/perl
use CGI;
use JSON;
print CGI::header('application/json');
{
    local $/;
    open( my $userFile, '<', 'user.json' );
    $user_json = <$userFile>;
    $user = decode_json( $user_json );
    close($userFile);
}
{
    local $/;
    open( my $habitsFile, '<', 'habits-many.json' );
    $habits_json = <$habitsFile>;
    $habits = decode_json( $habits_json );
    close($habitsFile);
}
$user->{habits} = $habits->{habits};  # Use the test habit data instead of your own
print encode_json($user);
```

#### /var/www/cgi-bin/hrpg_content.pl

```perl
#! /usr/bin/perl
use CGI;
print CGI::header('application/json');
$file = 'content.json';
print `cat $file`;
```

#### /var/www/cgi-bin/hrpg_tavern.pl:

```perl
#! /usr/bin/perl
use CGI;
print CGI::header('application/json');
$file = 'tavern.json';
print `cat $file`;
```

### Make all files accessible by apache

```sh
cd /var/www/cgi-bin;  # assuming you're not already there
sudo chmod apache.apache *
sudo chcon -t httpd_sys_content_t *.json
sudo chcon -t httpd_sys_script_exec_t *.pl
ls -lhatZ
```

Check the ownership and SELinux labels to make sure it's all kosher.


### Configure CORS in apache

This way we needn't worry about our scripts phoning home instead of a real target.
In `/etc/httpd/conf/httpd.conf`, add these Header configurations (I chose at the `/var/www` level).

```
<Directory "/var/www">
    ...
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept, x-api-user, x-api-key"
    ...
</Directory>
```

For good measure, if you aren't using your httpd server for anything else then you probably
want to disable it for everyone except yourself with this line in the `httpd.conf`:

```
Listen 127.0.0.1:80
```

### Uncomment TST section of main page

Doing so will cause the subsequent requests to re-route to your local server, bypassing unneeded auth and enabling
the use of test data!
