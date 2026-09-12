import csv

import dotenv
import mariadb
import csv

config = dotenv.dotenv_values()


def read_csv(csv_file):
    with open(csv_file, encoding="UTF-8") as file:
        reader = csv.reader(file)
        header = next(reader)
        rows = [row for row in reader]
    return rows


def main():
    path_csv = "solutions.csv"
    data = read_csv(path_csv)
    print(data)


if __name__ == '__main__':
    main()
