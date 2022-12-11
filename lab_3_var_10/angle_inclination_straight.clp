; Вариант 10
;
(defclass STRAIGHT-LINE (is-a USER)
    (role concrete)
    (slot x-one (type NUMBER) (default ?NONE))
    (slot y-one (type NUMBER) (default ?NONE))
    (slot x-two (type NUMBER) (default ?NONE))
    (slot y-two (type NUMBER) (default ?NONE))
    (slot angle (default NONE))
)

(defmessage-handler STRAIGHT-LINE find-angle()
    (bind ?angle NONE)
    (if (= ?self:x-one ?self:x-two)
    then
        (bind ?angle "Infinite slope")
    else
        (bind ?ratio (/ (- ?self:y-two ?self:y-one) (- ?self:x-two ?self:x-one)))
        (bind ?angle-rad (atan ?ratio)) ; Арктангенс
        (bind ?angle (rad-deg ?angle-rad)) ; Перевод радианы в градусы
    )
    (bind ?self:angle ?angle)
)

(defrule check-points
    ?straight-line <- (object (is-a STRAIGHT-LINE))
    (test 
        (and
            (eq (send ?straight-line get-x-one) (send ?straight-line get-x-two))
            (eq (send ?straight-line get-y-one) (send ?straight-line get-y-two))
        )
    )
    =>
    (send ?straight-line delete)
    (printout t "Straight line containt two identical points" crlf)
)

(defrule find-angle-rule
    ?straight-line <- (object (is-a STRAIGHT-LINE))
    (test
        (eq (send ?straight-line get-angle) NONE)
    )
    =>
    (send ?straight-line find-angle)
)

; (make-instance straight-line of STRAIGHT-LINE (x-one 1) (y-one 4) (x-two 1) (y-two 10))