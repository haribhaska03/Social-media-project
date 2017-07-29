# MySQL-Front 5.1  (Build 1.5)

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE */;
/*!40101 SET SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES */;
/*!40103 SET SQL_NOTES='ON' */;


# Host: localhost    Database: socialnetworkingmaster
# ------------------------------------------------------
# Server version 5.0.24a-community-nt

DROP DATABASE IF EXISTS `socialnetworkingmaster`;
CREATE DATABASE `socialnetworkingmaster` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `socialnetworkingmaster`;

#
# Source for table allpost
#

CREATE TABLE `allpost` (
  `Id` int(11) NOT NULL auto_increment,
  `userid` int(11) NOT NULL default '0',
  `postmsg` varchar(255) default NULL,
  `postimg` varchar(255) default NULL,
  `viewmode` varchar(255) default NULL,
  `likes` int(11) default '0',
  `commentcount` int(11) default '0',
  `sharecount` int(11) default '0',
  `likeduser` varchar(255) default '.',
  `comment` varchar(1024) default '.',
  `shareduser` varchar(255) default '.',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table allshare
#

CREATE TABLE `allshare` (
  `Id` int(11) NOT NULL auto_increment,
  `postid` int(11) default NULL,
  `shareduserid` int(11) default NULL,
  `posteduserid` int(11) default NULL,
  `mode` varchar(255) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table chat
#

CREATE TABLE `chat` (
  `Id` int(11) NOT NULL auto_increment,
  `message` varchar(1024) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table chatdetails
#

CREATE TABLE `chatdetails` (
  `Id` int(11) NOT NULL auto_increment,
  `fromid` int(11) default NULL,
  `toid` int(11) default NULL,
  `msgid` int(11) default NULL,
  PRIMARY KEY  (`Id`),
  KEY `fromid` (`fromid`),
  KEY `toid` (`toid`),
  KEY `msgid` (`msgid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table comments
#

CREATE TABLE `comments` (
  `Id` int(11) NOT NULL auto_increment,
  `postid` int(11) default NULL,
  `userid` int(11) default NULL,
  `comment` varchar(1024) default NULL,
  `mode` varchar(255) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table friendrequesthandler
#

CREATE TABLE `friendrequesthandler` (
  `userid` int(11) default NULL,
  `request` varchar(255) default '.',
  `friends` varchar(255) default '.',
  `sendrequest` varchar(255) default '.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table post
#

CREATE TABLE `post` (
  `userid` int(11) default NULL,
  `postid` varchar(255) default '.',
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table userdetails
#

CREATE TABLE `userdetails` (
  `Id` int(11) NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `mobileno` bigint(10) default NULL,
  `dob` date default NULL,
  `gender` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `lastlogin` varchar(255) default 'none',
  `profilepics` varchar(255) default 'assets\\img\\user.png',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for table waitingapproval
#

CREATE TABLE `waitingapproval` (
  `Id` int(11) NOT NULL auto_increment,
  `postid` int(11) default NULL,
  `posteduserid` int(11) default NULL,
  `requesteduserid` int(11) default NULL,
  `relationship` varchar(255) default NULL,
  `requestedmode` varchar(255) default NULL,
  PRIMARY KEY  (`Id`),
  KEY `postid` (`postid`),
  KEY `posteduserid` (`posteduserid`),
  KEY `requesteduserid` (`requesteduserid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Source for procedure send_friend_request
#

CREATE DEFINER=`root`@`localhost` PROCEDURE `send_friend_request`(IN `fromname` varchar(70),IN `toname` varchar(70))
BEGIN
DECLARE fromid int(11);
DECLARE toid int(11);
SELECT Id INTO fromid FROM userdetails WHERE username=fromname;
SELECT Id INTO toid FROM userdetails WHERE username=toname;
update friendrequesthandler set sendrequest=CONCAT(friendrequesthandler.sendrequest,toid,'.') where userid=fromid;
update friendrequesthandler set request=CONCAT(friendrequesthandler.request,fromid,'.') where userid=toid;
END;

#
# Source for procedure reject_friend_request
#

CREATE DEFINER=`root`@`localhost` PROCEDURE `reject_friend_request`(IN `fromname` varchar(70),IN `toname` varchar(70))
BEGIN
DECLARE fromid int(11);
DECLARE toid int(11);
SELECT Id INTO fromid FROM userdetails WHERE username=fromname;
SELECT Id INTO toid FROM userdetails WHERE username=toname;
UPDATE friendrequesthandler SET request = REPLACE (request,CONCAT(fromid,'.'),'') WHERE userid=toid;
UPDATE friendrequesthandler SET sendrequest = REPLACE (sendrequest,CONCAT(toid,'.'),'') WHERE userid=fromid;
END;

#
# Source for procedure accept_friend_request
#

CREATE DEFINER=`root`@`localhost` PROCEDURE `accept_friend_request`(IN `fromname` varchar(70),IN `toname` varchar(70))
BEGIN
DECLARE fromid int(11);
DECLARE toid int(11);
SELECT Id INTO fromid FROM userdetails WHERE username=fromname;
SELECT Id INTO toid FROM userdetails WHERE username=toname;
UPDATE friendrequesthandler SET request = REPLACE (request,CONCAT(fromid,'.'),'') WHERE userid=toid;
UPDATE friendrequesthandler SET sendrequest = REPLACE (sendrequest,CONCAT(toid,'.'),'') WHERE userid=fromid;
update friendrequesthandler set friends = CONCAT(friendrequesthandler.friends,fromid,'.') where userid=toid;
update friendrequesthandler set friends = CONCAT(friendrequesthandler.friends,toid,'.') where userid=fromid;
END;

#
#  Foreign keys for table chatdetails
#

ALTER TABLE `chatdetails`
ADD CONSTRAINT `chatdetails_ibfk_1` FOREIGN KEY (`fromid`) REFERENCES `userdetails` (`Id`),
ADD CONSTRAINT `chatdetails_ibfk_2` FOREIGN KEY (`toid`) REFERENCES `userdetails` (`Id`),
ADD CONSTRAINT `chatdetails_ibfk_3` FOREIGN KEY (`msgid`) REFERENCES `chat` (`Id`);

#
#  Foreign keys for table post
#

ALTER TABLE `post`
ADD CONSTRAINT `userid` FOREIGN KEY (`userid`) REFERENCES `userdetails` (`Id`);

#
#  Foreign keys for table waitingapproval
#

ALTER TABLE `waitingapproval`
ADD CONSTRAINT `waitingapproval_ibfk_1` FOREIGN KEY (`postid`) REFERENCES `allpost` (`Id`),
ADD CONSTRAINT `waitingapproval_ibfk_2` FOREIGN KEY (`posteduserid`) REFERENCES `userdetails` (`Id`),
ADD CONSTRAINT `waitingapproval_ibfk_3` FOREIGN KEY (`requesteduserid`) REFERENCES `userdetails` (`Id`);


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
