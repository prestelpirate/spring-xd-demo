## Overview

This is a simple demo, showing Spring XD ingesting data from Twitter, filtering it, and 
then keeping track of specific field contents via some counters.

The main point of the code here is to document:
- a (reasonably) portable nginx config file, to serve the visualisation dashboard
- the D3 javascript library setup

You can find the D3 javascript library at http://d3js.org/ and the
tutorial documentation at https://github.com/mbostock/d3/wiki/Tutorials

## Files and directories

The directory structure is straightforward:
- nginx.conf and startup script lives under analytics-dashboard
	- execute startup script from within that directory with ```./start-nginx.sh```
- the main dashboard page, and all the supporting D3 files, live under ```public```
- once running, the URL to hit to get your dashboard page is ```http://localhost:9889/public/dashboard.html```

There are already existing access.log and error.log files in the directory tree - saves
any file permission or creation problems, and also gives you some data to look at so you
know the format if you need to debug any issues.

There is also an existing Spring XD output file - twitteranon.out.out - which has some
sample tweets pulled from Twitter via Spring XD.

## Spring XD config that was used in this demo

If you want to refresh the data, here's the Spring XD commands I used to set it up:

Initially, we define a steam called ```tweets``` - we grab tweets that mention ```anonymous``` anywhere:
```stream create tweets --definition "twitterstream --track='anonymous' | file --name=twitteranon.out --dir=analytics-dashboard"```

Next we want to create a tap that pulls out the languages being used and tracks them with a counter - we deploy this immediately:
```stream create tweetlang  --definition "tap:stream:tweets > field-value-counter --fieldName=lang" --deploy```

Then we want a tap that gives us an aggregate counter of how many tweets are being collected:
```stream create tweetcount --definition "tap:stream:tweets > aggregate-counter" --deploy```

And finally we want a tap that counts how many times each hashtag is mentioned - this is 
where we can get the good stuff about how often specific Op hashtags come up:
```stream create tagcount --definition "tap:stream:tweets > field-value-counter --fieldName=entities.hashtags.text --name=hashtags" --deploy```

Once everything is in place, we deploy the ```tweets``` stream and start collecting our data:
```stream deploy tweets```

## What data we collect and visualise, and why

The aim of the demo is to collect any tweets that mention 'anonymous' anywhere, so that
we can then look at the hashtags being used, and visualise how many mention ```Ops```, 
and how often those Ops are mentioned.

This lets us quickly visualise how active discussion around a particular Op is, which 
would be a good indicator that the Op is active/going ahead and would warrant further
investigation.

The idea is to use all of this to show how easy it can be to use Spring XD to visualise
security and threat information.