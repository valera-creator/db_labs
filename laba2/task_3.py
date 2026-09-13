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


def get_conn():
    conn = mariadb.connect(
        user=config["MARIADB_USER"],
        password=config["MARIADB_PASSWORD"],
        host=config["MARIADB_HOST"],
        port=3306,
        database=config["MARIADB_DATABASE"],
        autocommit=False
    )
    return conn


def task_1():
    """Вывести на экран фамилии студентов, которые пока не получили зачёт за задание, и данные ими ответы."""
    conn = get_conn()
    cursor = conn.cursor()
    cursor.execute("""SELECT surname, answer FROM solution
                        WHERE has_pass != 'T' OR has_pass IS NULL""")
    data = cursor.fetchall()
    cursor.close()
    conn.close()

    for elem in data:
        print(f'Фамилия: {elem[0]}, Ответ: {elem[1] if elem[1] is not None else "<Нет ответа>"}')


def task_2(card_data, answer_text):
    """Добавление ответа на задание студентом с заданным номером студенческого билета."""
    conn = get_conn()
    cursor = conn.cursor()
    cursor.execute("UPDATE solution SET answer = %s WHERE card = %s", [answer_text, card_data])
    conn.commit()

    cursor.execute("""SELECT surname, answer FROM solution WHERE card = %s""", [card_data])
    student = cursor.fetchone()
    cursor.close()
    conn.close()

    if student is None:
        print(f"Нет студента с номером {card_data}")
    else:
        print(f'Фамилия студента: {student[0]}, Ответ: {student[1]}')


def task_3(card_data, score_data, review_data):
    """Выставление оценки студенту с заданным номером студенческого билета и добавление комментария."""
    conn = get_conn()
    cursor = conn.cursor()

    if 0 <= score_data <= 5:
        cursor.execute("""UPDATE solution SET score = %s, review = %s WHERE card = %s""",
                       [score_data, review_data, card_data])
        conn.commit()
        cursor.execute("""SELECT surname, answer, score, review FROM solution WHERE card = %s""", [card_data])

        student = cursor.fetchone()
        if student is None:
            print(f"Нет студента с номером {card_data}")
        else:
            print(f'Фамилия студента: {student[0]}, Ответ: {student[1]}, "score: {student[2]}, review: {student[3]}')

    else:
        print(f"Некорректное значение score: {score_data}")

    cursor.close()
    conn.close()


def task_4(pass_threshold):
    """Изменение порога для успешного выполнения задания (например, с 3 баллов на 2) и показ студентов, у которых
       после этого появится или пропадёт зачёт."""
    pass


def main():
    #     Удаление информации о студентах, не получивших зачёт.

    task_1()
    print()
    task_2(762016, "Текст ответа")
    task_2(762030, "Текст ответа")
    print()
    task_3(762016, 3.4, "коммент")
    task_3(762016, 5.4, "коммент")
    print()

    task_4(4)

if __name__ == '__main__':
    main()
