# SQLServerScripts
A repository containing scripts and SQL files capable of running on a Microsoft SQL Server.

# Transaction-Template-01.sql 
This file is a template that I've written, and use currently.  I use this when I need to make a data-update directly into a database table, to resolve a production issue.  I've templated out most of the transaction-specific code that I'd normally need to write every time, and now all I have to do is open this file up and "save as" a new file.  There's a print statement in the center of the file indicating where the actual implementation code should go.  I normally begin a new implementation by deleting that line, and writing the specific insert/update statements accordingly. 
