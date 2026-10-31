USE ValeriiLarionovWorld;

-- Вывод списка регионов (упорядоченных по алфавиту) с указанием числа городов в них.
SELECT Country.Region as Region, COUNT(City.Name) as Cities FROM
Country LEFT JOIN City
ON City.CountryCode = Country.Code
GROUP BY Region
ORDER BY Region;

-- Вывод списка названий стран (упорядоченных по алфавиту), общего числа городов в них и числа городов с населением больше 500 тысяч человек. 
-- Если в стране нет городов с населением более 500 тысяч человек, нужно вывести 0. Подсказка: используйте функцию COALESCE.
SELECT
	Country.Name as Country,
	COUNT(City.Name) as City,
	COALESCE(SUM(CASE WHEN City.Population > 500000 THEN 1 END), 0) as City_big_500000
FROM
	City LEFT JOIN Country
		ON City.CountryCode = Country.Code
GROUP BY Country.Name
ORDER BY Country.Name;


-- Вывод списка стран, самый крупный город в которых не является их столицей, с указанием как самого крупного города, так и столицы. 
-- Гарантируется, что у всех городов разное население.
WITH Max_pop_country AS
	(
	SELECT 
		Country.Code, 
		Country.Name, 
		MAX(City.Population) as Population,
		Country.Capital
	FROM Country LEFT JOIN City
	ON City.CountryCode = Country.Code
	GROUP BY Country.Code, Country.Name, Country.Capital
	)
SELECT 
	Max_pop_country.Name as Name_country, 
	City.Name as Name_city, 
	(SELECT City.Name FROM City WHERE City.ID = Max_pop_country.Capital) as Capital
FROM Max_pop_country
	LEFT JOIN City 
		ON City.CountryCode = Max_pop_country.Code AND Max_pop_country.Population = City.Population
WHERE Max_pop_country.Capital != City.ID;


-- Вывод списка стран, в которых 2 и более языка используются более чем 5% населения. Подсказка: используйте оператор HAVING.
SELECT Country.Name
FROM Country 
JOIN CountryLanguage ON Country.Code = CountryLanguage.CountryCode
WHERE CountryLanguage.Percentage > 5 
  AND CountryLanguage.IsOfficial = 'T'
GROUP BY Country.Name
HAVING COUNT(CountryLanguage.Language) >= 2;

-- Вывод списка стран, в которых 2 и более языка используются более чем 5% населения, с указанием этих языков в алфавитном порядке, 
-- через запятую. Подсказка: используйте функцию GROUP_CONCAT.
WITH Percentage_more_5 AS 
(
	SELECT 
		Country.Name, 
		CountryLanguage.Language,
		CountryLanguage.Percentage
	FROM Country JOIN CountryLanguage
	ON Country.Code = CountryLanguage.CountryCode
	WHERE CountryLanguage.Percentage > 5 AND CountryLanguage.IsOfficial = 'T'
)
SELECT 
	Percentage_more_5.Name,
	GROUP_CONCAT(Percentage_more_5.Language ORDER BY Percentage_more_5.Language SEPARATOR ', ') AS Languages
FROM Percentage_more_5
GROUP BY Name
HAVING COUNT(Percentage_more_5.Percentage) >= 2;

