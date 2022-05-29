To build the website on your pc:

$ cd beisbol-analitica/website/
$ datasette /dir/that/contains/database/baseball.db --metadata metadata.json --static assets:static-files/ --template-dir templates
