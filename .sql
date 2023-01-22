INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_ubere','Uber Eats',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_ubere','Uber Eats',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_ubere', 'Uber Eats', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('ubere', "Uber Eats")
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('ubere', 0, 'novice', 'Apprenti', 200, 'null', 'null'),
('ubere', 1, 'expert', 'Vendeur', 400, 'null', 'null'),
('ubere', 2, 'chef', "Expert", 600, 'null', 'null'),
('ubere', 3, 'boss', 'Patron', 1000, 'null', 'null')
;

CREATE TABLE IF NOT EXISTS `courses` (
  `playerid` int(4) NOT NULL,
  `client` varchar(255) NOT NULL,
  `label` longtext NOT NULL,
  `position` longtext NOT NULL,
  `take` varchar(120) NOT NULL DEFAULT 'non',
  `num` varchar(25) NOT NULL,
  PRIMARY KEY (`playerid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
COMMIT;