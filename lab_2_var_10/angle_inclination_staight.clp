; Вариант 10
;
(deftemplate angle "An angle template that has point-one, point-two and a resulting angle of a straight line"
    (slot point-one)
    (slot point-two)
    (slot value)
)

(deftemplate straight-line "A straight line that has the coordinates of two points"
    (slot x-one (type NUMBER) (default ?NONE))
    (slot y-one (type NUMBER) (default ?NONE))
    (slot x-two (type NUMBER) (default ?NONE))
    (slot y-two (type NUMBER) (default ?NONE))
)

; Находит угол наклона прямой линии по двум точкам в градусах
(deffunction find-angle (?x-one ?y-one ?x-two ?y-two)
    (bind ?angle NONE)
    (if (= ?x-one ?x-two)
    then
        (return ?angle)
    )
    (bind ?ratio (/ (- ?y-two ?y-one) (- ?x-two ?x-one)))
    (bind ?angle-rad (atan ?ratio)) ; Арктангенс
    (bind ?angle (rad-deg ?angle-rad)) ; Перевод радианы в градусы
    (return ?angle)
)

; Проверяет, если указаны две одинаковые точки
(defrule check-points
    ?straight-line <- (straight-line (x-one ?x-one) (y-one ?y-one) (x-two ?x-two) (y-two ?y-two))
    (test (and (eq ?x-one ?x-two) (eq ?y-one ?y-two)))
    =>
    (retract ?straight-line)
    (printout t "Straight line containt two identical points" crlf)
)

(defrule find-angle-rule
    ?straight-line <- (straight-line (x-one ?x-one) (y-one ?y-one) (x-two ?x-two) (y-two ?y-two))
    =>
    (retract ?straight-line)
    (bind ?angle (find-angle ?x-one ?y-one ?x-two ?y-two))
    (if (eq ?angle NONE)
    then
        (bind ?angle "Infinite slope")
    )
    (bind ?point-one (str-cat "(x1 = " ?x-one "; y1 = " ?y-one ")"))
    (bind ?point-two (str-cat "(x2 = " ?x-two "; y2 = " ?y-two ")"))
    (assert (angle (point-one ?point-one) (point-two ?point-two) (value ?angle)))
)

(deffacts start-facts
    (straight-line (x-one 1) (y-one 1) (x-two 2) (y-two 2))
)
