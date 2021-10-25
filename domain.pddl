(define (domain sokorobotto)
  (:requirements :typing)
  (:types
    shipment
    order
    location
    robot pallette saleitem - object)
  (:predicates
    (free ?x - robot) (contains ?x - pallette ?y - saleitem) (carry ?x - robot ?y - pallette) (includes ?x - shipment ?y - saleitem)
    (at ?x - object ?y - location) (no-robot ?x - location) (no-pallette ?x - location) (unstarted ?x - shipment)
    (connected ?x - location ?y - location) (ships ?x - shipment ?y - order) (orders ?x - order ?y - saleitem)
    (available ?x - location) (packing-location ?x - location))
  (:action pick-up :parameters (?p - pallette ?l - location ?r - robot ?i - saleitem ?o - order ?s - shipment)
    :precondition (and (orders ?o ?i) (unstarted ?s) (at ?r ?l) (at ?p ?l) (contains ?p ?i) (free ?r))
    :effect       (and (carry ?r ?p) (not (free ?r)) (no-pallette ?l)))
  (:action move-rob :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from) (connected ?from ?to) (not (at ?r ?to)) (no-robot ?to))
    :effect       (and (at ?r ?to) (not (at ?r ?from)) (no-robot ?from)))
  (:action move-robpal :parameters (?r - robot ?from - location ?to - location ?pal - pallette)
    :precondition (and (carry ?r ?pal) (at ?r ?from) (at ?pal ?from) (connected ?from ?to) (no-robot ?to) (no-pallette ?to))
    :effect       (and (at ?r ?to) (at ?pal ?to) (not (at ?r ?from)) (not (at ?pal ?from)) (no-pallette ?from) (no-robot ?from)))
  (:action drop-pal :parameters (?r - robot ?l - location ?p - pallette)
    :precondition (and (at ?r ?l) (at ?p ?l) (carry ?r ?p) (packing-location ?l) (available ?l))
    :effect        (and (free ?r) (not (carry ?r ?p))))
  (:action ship :parameters (?s - shipment ?o - order ?i - saleitem ?l - location ?p - pallette ?r - robot)
    :precondition (and (packing-location ?l) (contains ?p ?i) (at ?p ?l) (at ?r ?l))
    :effect       (and (ships ?s ?o) (includes ?s ?i) (available ?l) (not (unstarted ?s)))
    ))