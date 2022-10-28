; Вариант 35
;
; Проверка, что введенное значение является числом
(deffunction if-number (?value)
    (return (numberp ?value))
)

; Вычисление кубического корня
(deffunction cubic-root (?value)
    (return (** ?value (/ 1 3)))
)

; Вычисление функции:
; (2**x - 1/((x - 1)**(1/3)))**5
(deffunction function (?value)
    ; Результат вычисления корня 3 степени: (x-1)**(1/3)
    (bind ?value-under-root (- ?value 1))
    ; Вычисляется куб. корень из модуля числа (x-1)
    ; Почему-то CLIPS не хочет вычислять степень из отрицательного числа
    (bind ?denominator (cubic-root (abs ?value-under-root)))
    ; Если результат разницы (x-1) было отрицательное,
    ; то результат куб. корня умножается на -1, чтобы не потерять знак
    (if (< ?value-under-root 0)
    then
        (bind ?denominator (* ?denominator -1))
    )

    (if (= ?denominator 0)
    then
        (printout t "Division by 0, result: ")
        (return NONE)
    )
    ; Результат дроби: 1/( (x-1)**(1/3) )
    (bind ?result-division (/ 1 ?denominator))
    ; Финальный результат функции
    (return (** (- (** 2 ?value) ?result-division) 5))
)

; Функция суммирования
(deffunction function-sum ($?values)
    (bind ?result 0)
    (bind ?length-values (length$ ?values))
    (loop-for-count (?index ?length-values) do
        (bind ?value (nth$ ?index ?values))
        (bind ?is-number (if-number ?value))
        (if ?is-number
        then
            (bind ?result-function (function ?value))
            (if (eq ?result-function NONE)
            then
                (return NONE)
            else 
                (bind ?result (+ ?result ?result-function))
            )
        else
            (printout t "Value is not number, result: ")
            (return NONE)
        )
    )
    (return ?result)
)
