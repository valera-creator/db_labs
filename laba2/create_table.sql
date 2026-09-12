CREATE TABLE solution
(
	card INT PRIMARY KEY NOT NULL,
	name VARCHAR(30) NOT NULL,
	surname VARCHAR(30) NOT NULL,
	answer TEXT,
	score DECIMAL(3,2) NOT NULL, -- DECIMAL (3,2): 3 цифры в числе всего, две после запятой
	review VARCHAR(250),
	has_pass ENUM ('T', 'F')
)