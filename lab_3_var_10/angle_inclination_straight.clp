; Вариант 10
;
(defclass POINT
    (is-a USER)
    (role concrete)
    (slot x (type NUMBER) (default 0))
    (slot y (type NUMBER) (default 0))
)

; (defmessage-handler POINT get-x-coordinate()
;     (return ?self:x)
; )

; (defmessage-handler POINT get-y-coordinate()
;     (return ?self:y)
; )

(defclass LINE
    (is-a USER)
    (role concrete)
    (slot point-one (type INSTANCE))
    (slot point-two (type INSTANCE))
    (slot angle (default NONE))
)

(defmessage-handler LINE angle-is-defined()
    (return (neq ?self:angle NONE))
)

; Находит угол наклона прямой линии по двум точкам в градусах
(defmessage-handler LINE find-angle()
    (bind ?angle NONE)

    (bind ?point-one ?self:point-one)
    (bind ?point-two ?self:point-two)

    (bind ?x-one (send ?point-one get-x))
    (bind ?y-one (send ?point-one get-y))
    (bind ?x-two (send ?point-two get-x))
    (bind ?y-two (send ?point-two get-y))

    (if (= ?x-one ?x-two)
    then
        (bind ?self:angle "Infinite slope")
    )

    (bind ?ratio (/ (- ?y-two ?y-one) (- ?x-two ?x-one)))
    (bind ?angle-rad (atan ?ratio)) ; Арктангенс
    (bind ?angle (rad-deg ?angle-rad)) ; Перевод радианы в градусы
    (bind ?self:angle ?angle)
)

(deftemplate straight-line "A straight line that has the coordinates of two points"
    (slot x-one (type NUMBER) (default 0))
    (slot y-one (type NUMBER) (default 0))
    (slot x-two (type NUMBER) (default 0))
    (slot y-two (type NUMBER) (default 0))
)

; Проверяет, если указаны две одинаковые точки
(defrule check-points
    ?straight-line <- (straight-line (x-one ?x-one) (y-one ?y-one) (x-two ?x-two) (y-two ?y-two))
    (test (and (eq ?x-one ?x-two) (eq ?y-one ?y-two)))
    =>
    (retract ?straight-line)
    (printout t "Straight line containt two identical points" crlf)
)

(defrule create-line
    ?straight-line <- (straight-line (x-one ?x-one) (y-one ?y-one) (x-two ?x-two) (y-two ?y-two))
    =>
    (retract ?straight-line)
    (make-instance straight-line of LINE 
        (point-one (make-instance point-one of POINT (x ?x-one) (y ?y-one)))
        (point-two (make-instance point-two of POINT (x ?x-two) (y ?y-two)))
    )
)

(defrule find-angle
    ?straight-line <- (object (is-a LINE))
    (test (eq (send ?straight-line angle-is-defined) FALSE))
    =>
    (send ?straight-line find-angle)
)

; (definstances LINE-OBJECTS
    ; (point-1 of POINT)
    ; (point-1 of POINT (x 5) (y 5))
    ; (line-1 of LINE (point-one (point-one of POINT (x 5) (y 5))) (point-two (point-two of POINT (x 8) (y 8))))
; )

(deffacts start-facts
    (straight-line (x-one 1) (y-one 1) (x-two 2) (y-two 2))
)
