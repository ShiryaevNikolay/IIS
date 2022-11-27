; Вариант 10
; TODO: возможно убрать проверку числа
; Проверка, что введенное значение является числом
(deffunction if-number (?value)
    (return (numberp ?value))
)

; Функция нахождения угла наклона прямой линии по двум точкам
(deffunction find-angle (?x-one ?y-one ?x-two ?y-two)
    (bind ?angle NONE)
    (if (= ?x-one ?x-two)
    then
        (return ?angle)
    )
    (bind ?ratio (/ (- ?y-two ?y-one) (- ?x-two ?x-one)))
    (bind ?angle-rad (atan ?ratio)) ; Арктангенс
    (bind ?angle (rad-deg ?angle-rad))
    (return ?angle)
)

(deftemplate point "A point that has x and y coordinates"
    (slot x-value (type NUMBER) (default ?NONE))
    (slot y-value (type NUMBER) (default ?NONE))
)

(defrule find-angle-rule
    ?point-one <- (point (x-value ?x-one) (y-value ?y-one))
    ?point-two <- (point (x-value ?x-two) (y-value ?y-two))
    (test (not (and (eq ?x-one ?x-two) (eq ?y-one ?y-two))))
    =>
    (retract ?point-one ?point-two)
    (bind ?angle (find-angle ?x-one ?y-one ?x-two ?y-two))
    (if (eq ?angle NONE)
    then
        (printout t "Infinite slope" crlf)
    else
        (printout t "(x1=" ?x-one ";y1=" ?y-one ") and (x2=" ?x-two ";y2=" ?y-two "). The angle is " ?angle " degrees" crlf)
    )
)

(deffacts start-facts
    (point (x-value 0) (y-value 0))
    (point (x-value 2) (y-value 1))
)
