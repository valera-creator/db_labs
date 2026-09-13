import csv

import dotenv
import mariadb

config = dotenv.dotenv_values()


def read_csv(csv_file):
    with open(csv_file, encoding="UTF-8") as file:
        reader = csv.reader(file)
        header = next(reader)
        rows = [row for row in reader]
    return rows


def clean_data(data):
    """преобразование пустых строк в None, проверка корректности значений"""
    processing_data = []
    for row in data:
        name, surname, card, answer, score, review, has_pass = row

        name = name if name != '' else None
        surname = surname if surname != '' else None
        answer = answer if answer != '' else None
        review = review if review != '' else None
        has_pass = has_pass if has_pass != '' else None

        try:
            card = int(card)
        except Exception:
            quit(f"Ошибка: некорректное значение card: {card}")

        try:
            score = float(score)
            assert 0 <= score <= 5
        except Exception:
            quit(f"Ошибка: некорректное значение score: {score}")

        new_row = {
            "card": card,
            "name": name,
            "surname": surname,
            "answer": answer,
            "score": score,
            "review": review,
            "has_pass": has_pass
        }
        processing_data.append(new_row)

    return processing_data


def upload_to_database(data: list):
    with mariadb.connect(
            user=config["MARIADB_USER"],
            password=config["MARIADB_PASSWORD"],
            host=config["MARIADB_HOST"],
            port=3306,
            database=config["MARIADB_DATABASE"],
            autocommit=False,
    ) as conn:
        cursor = conn.cursor()

        try:
            cursor.executemany(
                """INSERT INTO solution (card, name, surname, answer, score, review, has_pass)
             VALUES (%(card)s, %(name)s, %(surname)s, %(answer)s, %(score)s, %(review)s, %(has_pass)s)""",
                data
            )
            conn.commit()
            print(f"Загружено {len(data)} строк")
        except Exception as e:
            print(f"Ошибка: {e}")


def main():
    # Напишите сценарий на Python для добавления в таблицу записей, содержащих информацию из файла solutions.csv.
    path_csv = "solutions.csv"
    data_csv = read_csv(path_csv)
    processing_data = clean_data(data_csv)
    upload_to_database(processing_data)


if __name__ == '__main__':
    main()
