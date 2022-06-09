(get-info :version)
; (:version "4.8.6")
; Started: 2022-05-22 14:39:37
; Silicon.version: 1.1-SNAPSHOT (cd20cf02@(detached))
; Input file: -
; Verifier id: 00
; ------------------------------------------------------------
; Begin preamble
; ////////// Static preamble
; 
; ; /z3config.smt2
(set-option :print-success true) ; Boogie: false
(set-option :global-decls true) ; Boogie: default
(set-option :auto_config false) ; Usually a good idea
(set-option :smt.restart_strategy 0)
(set-option :smt.restart_factor |1.5|)
(set-option :smt.case_split 3)
(set-option :smt.delay_units true)
(set-option :smt.delay_units_threshold 16)
(set-option :nnf.sk_hack true)
(set-option :type_check true)
(set-option :smt.bv.reflect true)
(set-option :smt.mbqi false)
(set-option :smt.qi.eager_threshold 100)
(set-option :smt.qi.cost "(+ weight generation)")
(set-option :smt.qi.max_multi_patterns 1000)
(set-option :smt.phase_selection 0) ; default: 3, Boogie: 0
(set-option :sat.phase caching)
(set-option :sat.random_seed 0)
(set-option :nlsat.randomize true)
(set-option :nlsat.seed 0)
(set-option :nlsat.shuffle_vars false)
(set-option :fp.spacer.order_children 0) ; Not available with Z3 4.5
(set-option :fp.spacer.random_seed 0) ; Not available with Z3 4.5
(set-option :smt.arith.random_initial_value true) ; Boogie: true
(set-option :smt.random_seed 0)
(set-option :sls.random_offset true)
(set-option :sls.random_seed 0)
(set-option :sls.restart_init false)
(set-option :sls.walksat_ucb true)
(set-option :model.v2 true)
; 
; ; /preamble.smt2
(declare-datatypes () ((
    $Snap ($Snap.unit)
    ($Snap.combine ($Snap.first $Snap) ($Snap.second $Snap)))))
(declare-sort $Ref 0)
(declare-const $Ref.null $Ref)
(declare-sort $FPM)
(declare-sort $PPM)
(define-sort $Perm () Real)
(define-const $Perm.Write $Perm 1.0)
(define-const $Perm.No $Perm 0.0)
(define-fun $Perm.isValidVar ((p $Perm)) Bool
	(<= $Perm.No p))
(define-fun $Perm.isReadVar ((p $Perm) (ub $Perm)) Bool
    (and ($Perm.isValidVar p)
         (not (= p $Perm.No))
         (< p $Perm.Write)))
(define-fun $Perm.min ((p1 $Perm) (p2 $Perm)) Real
    (ite (<= p1 p2) p1 p2))
(define-fun $Math.min ((a Int) (b Int)) Int
    (ite (<= a b) a b))
(define-fun $Math.clip ((a Int)) Int
    (ite (< a 0) 0 a))
; ////////// Sorts
(declare-sort Set<option<array>>)
(declare-sort Set<Int>)
(declare-sort Set<$Ref>)
(declare-sort Set<$Snap>)
(declare-sort t_null)
(declare-sort any)
(declare-sort option<any>)
(declare-sort option<array>)
(declare-sort array)
(declare-sort $FVF<option<array>>)
(declare-sort $FVF<Int>)
(declare-sort $FVF<$Ref>)
; ////////// Sort wrappers
; Declaring additional sort wrappers
(declare-fun $SortWrappers.IntTo$Snap (Int) $Snap)
(declare-fun $SortWrappers.$SnapToInt ($Snap) Int)
(assert (forall ((x Int)) (!
    (= x ($SortWrappers.$SnapToInt($SortWrappers.IntTo$Snap x)))
    :pattern (($SortWrappers.IntTo$Snap x))
    :qid |$Snap.$SnapToIntTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.IntTo$Snap($SortWrappers.$SnapToInt x)))
    :pattern (($SortWrappers.$SnapToInt x))
    :qid |$Snap.IntTo$SnapToInt|
    )))
(declare-fun $SortWrappers.BoolTo$Snap (Bool) $Snap)
(declare-fun $SortWrappers.$SnapToBool ($Snap) Bool)
(assert (forall ((x Bool)) (!
    (= x ($SortWrappers.$SnapToBool($SortWrappers.BoolTo$Snap x)))
    :pattern (($SortWrappers.BoolTo$Snap x))
    :qid |$Snap.$SnapToBoolTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.BoolTo$Snap($SortWrappers.$SnapToBool x)))
    :pattern (($SortWrappers.$SnapToBool x))
    :qid |$Snap.BoolTo$SnapToBool|
    )))
(declare-fun $SortWrappers.$RefTo$Snap ($Ref) $Snap)
(declare-fun $SortWrappers.$SnapTo$Ref ($Snap) $Ref)
(assert (forall ((x $Ref)) (!
    (= x ($SortWrappers.$SnapTo$Ref($SortWrappers.$RefTo$Snap x)))
    :pattern (($SortWrappers.$RefTo$Snap x))
    :qid |$Snap.$SnapTo$RefTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$RefTo$Snap($SortWrappers.$SnapTo$Ref x)))
    :pattern (($SortWrappers.$SnapTo$Ref x))
    :qid |$Snap.$RefTo$SnapTo$Ref|
    )))
(declare-fun $SortWrappers.$PermTo$Snap ($Perm) $Snap)
(declare-fun $SortWrappers.$SnapTo$Perm ($Snap) $Perm)
(assert (forall ((x $Perm)) (!
    (= x ($SortWrappers.$SnapTo$Perm($SortWrappers.$PermTo$Snap x)))
    :pattern (($SortWrappers.$PermTo$Snap x))
    :qid |$Snap.$SnapTo$PermTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$PermTo$Snap($SortWrappers.$SnapTo$Perm x)))
    :pattern (($SortWrappers.$SnapTo$Perm x))
    :qid |$Snap.$PermTo$SnapTo$Perm|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Set<option<array>>To$Snap (Set<option<array>>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<option<array>> ($Snap) Set<option<array>>)
(assert (forall ((x Set<option<array>>)) (!
    (= x ($SortWrappers.$SnapToSet<option<array>>($SortWrappers.Set<option<array>>To$Snap x)))
    :pattern (($SortWrappers.Set<option<array>>To$Snap x))
    :qid |$Snap.$SnapToSet<option<array>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<option<array>>To$Snap($SortWrappers.$SnapToSet<option<array>> x)))
    :pattern (($SortWrappers.$SnapToSet<option<array>> x))
    :qid |$Snap.Set<option<array>>To$SnapToSet<option<array>>|
    )))
(declare-fun $SortWrappers.Set<Int>To$Snap (Set<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Int> ($Snap) Set<Int>)
(assert (forall ((x Set<Int>)) (!
    (= x ($SortWrappers.$SnapToSet<Int>($SortWrappers.Set<Int>To$Snap x)))
    :pattern (($SortWrappers.Set<Int>To$Snap x))
    :qid |$Snap.$SnapToSet<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Int>To$Snap($SortWrappers.$SnapToSet<Int> x)))
    :pattern (($SortWrappers.$SnapToSet<Int> x))
    :qid |$Snap.Set<Int>To$SnapToSet<Int>|
    )))
(declare-fun $SortWrappers.Set<$Ref>To$Snap (Set<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Ref> ($Snap) Set<$Ref>)
(assert (forall ((x Set<$Ref>)) (!
    (= x ($SortWrappers.$SnapToSet<$Ref>($SortWrappers.Set<$Ref>To$Snap x)))
    :pattern (($SortWrappers.Set<$Ref>To$Snap x))
    :qid |$Snap.$SnapToSet<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Ref>To$Snap($SortWrappers.$SnapToSet<$Ref> x)))
    :pattern (($SortWrappers.$SnapToSet<$Ref> x))
    :qid |$Snap.Set<$Ref>To$SnapToSet<$Ref>|
    )))
(declare-fun $SortWrappers.Set<$Snap>To$Snap (Set<$Snap>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Snap> ($Snap) Set<$Snap>)
(assert (forall ((x Set<$Snap>)) (!
    (= x ($SortWrappers.$SnapToSet<$Snap>($SortWrappers.Set<$Snap>To$Snap x)))
    :pattern (($SortWrappers.Set<$Snap>To$Snap x))
    :qid |$Snap.$SnapToSet<$Snap>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Snap>To$Snap($SortWrappers.$SnapToSet<$Snap> x)))
    :pattern (($SortWrappers.$SnapToSet<$Snap> x))
    :qid |$Snap.Set<$Snap>To$SnapToSet<$Snap>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.t_nullTo$Snap (t_null) $Snap)
(declare-fun $SortWrappers.$SnapTot_null ($Snap) t_null)
(assert (forall ((x t_null)) (!
    (= x ($SortWrappers.$SnapTot_null($SortWrappers.t_nullTo$Snap x)))
    :pattern (($SortWrappers.t_nullTo$Snap x))
    :qid |$Snap.$SnapTot_nullTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.t_nullTo$Snap($SortWrappers.$SnapTot_null x)))
    :pattern (($SortWrappers.$SnapTot_null x))
    :qid |$Snap.t_nullTo$SnapTot_null|
    )))
(declare-fun $SortWrappers.anyTo$Snap (any) $Snap)
(declare-fun $SortWrappers.$SnapToany ($Snap) any)
(assert (forall ((x any)) (!
    (= x ($SortWrappers.$SnapToany($SortWrappers.anyTo$Snap x)))
    :pattern (($SortWrappers.anyTo$Snap x))
    :qid |$Snap.$SnapToanyTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.anyTo$Snap($SortWrappers.$SnapToany x)))
    :pattern (($SortWrappers.$SnapToany x))
    :qid |$Snap.anyTo$SnapToany|
    )))
(declare-fun $SortWrappers.option<any>To$Snap (option<any>) $Snap)
(declare-fun $SortWrappers.$SnapTooption<any> ($Snap) option<any>)
(assert (forall ((x option<any>)) (!
    (= x ($SortWrappers.$SnapTooption<any>($SortWrappers.option<any>To$Snap x)))
    :pattern (($SortWrappers.option<any>To$Snap x))
    :qid |$Snap.$SnapTooption<any>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.option<any>To$Snap($SortWrappers.$SnapTooption<any> x)))
    :pattern (($SortWrappers.$SnapTooption<any> x))
    :qid |$Snap.option<any>To$SnapTooption<any>|
    )))
(declare-fun $SortWrappers.option<array>To$Snap (option<array>) $Snap)
(declare-fun $SortWrappers.$SnapTooption<array> ($Snap) option<array>)
(assert (forall ((x option<array>)) (!
    (= x ($SortWrappers.$SnapTooption<array>($SortWrappers.option<array>To$Snap x)))
    :pattern (($SortWrappers.option<array>To$Snap x))
    :qid |$Snap.$SnapTooption<array>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.option<array>To$Snap($SortWrappers.$SnapTooption<array> x)))
    :pattern (($SortWrappers.$SnapTooption<array> x))
    :qid |$Snap.option<array>To$SnapTooption<array>|
    )))
(declare-fun $SortWrappers.arrayTo$Snap (array) $Snap)
(declare-fun $SortWrappers.$SnapToarray ($Snap) array)
(assert (forall ((x array)) (!
    (= x ($SortWrappers.$SnapToarray($SortWrappers.arrayTo$Snap x)))
    :pattern (($SortWrappers.arrayTo$Snap x))
    :qid |$Snap.$SnapToarrayTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.arrayTo$Snap($SortWrappers.$SnapToarray x)))
    :pattern (($SortWrappers.$SnapToarray x))
    :qid |$Snap.arrayTo$SnapToarray|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.$FVF<option<array>>To$Snap ($FVF<option<array>>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<option<array>> ($Snap) $FVF<option<array>>)
(assert (forall ((x $FVF<option<array>>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<option<array>>($SortWrappers.$FVF<option<array>>To$Snap x)))
    :pattern (($SortWrappers.$FVF<option<array>>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<option<array>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<option<array>>To$Snap($SortWrappers.$SnapTo$FVF<option<array>> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<option<array>> x))
    :qid |$Snap.$FVF<option<array>>To$SnapTo$FVF<option<array>>|
    )))
(declare-fun $SortWrappers.$FVF<Int>To$Snap ($FVF<Int>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Int> ($Snap) $FVF<Int>)
(assert (forall ((x $FVF<Int>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Int>($SortWrappers.$FVF<Int>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Int>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Int>To$Snap($SortWrappers.$SnapTo$FVF<Int> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Int> x))
    :qid |$Snap.$FVF<Int>To$SnapTo$FVF<Int>|
    )))
(declare-fun $SortWrappers.$FVF<$Ref>To$Snap ($FVF<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<$Ref> ($Snap) $FVF<$Ref>)
(assert (forall ((x $FVF<$Ref>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<$Ref>($SortWrappers.$FVF<$Ref>To$Snap x)))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<$Ref>To$Snap($SortWrappers.$SnapTo$FVF<$Ref> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<$Ref> x))
    :qid |$Snap.$FVF<$Ref>To$SnapTo$FVF<$Ref>|
    )))
; ////////// Symbols
(declare-fun Set_in (option<array> Set<option<array>>) Bool)
(declare-fun Set_card (Set<option<array>>) Int)
(declare-const Set_empty Set<option<array>>)
(declare-fun Set_singleton (option<array>) Set<option<array>>)
(declare-fun Set_unionone (Set<option<array>> option<array>) Set<option<array>>)
(declare-fun Set_union (Set<option<array>> Set<option<array>>) Set<option<array>>)
(declare-fun Set_disjoint (Set<option<array>> Set<option<array>>) Bool)
(declare-fun Set_difference (Set<option<array>> Set<option<array>>) Set<option<array>>)
(declare-fun Set_intersection (Set<option<array>> Set<option<array>>) Set<option<array>>)
(declare-fun Set_subset (Set<option<array>> Set<option<array>>) Bool)
(declare-fun Set_equal (Set<option<array>> Set<option<array>>) Bool)
(declare-fun Set_in (Int Set<Int>) Bool)
(declare-fun Set_card (Set<Int>) Int)
(declare-const Set_empty Set<Int>)
(declare-fun Set_singleton (Int) Set<Int>)
(declare-fun Set_unionone (Set<Int> Int) Set<Int>)
(declare-fun Set_union (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_disjoint (Set<Int> Set<Int>) Bool)
(declare-fun Set_difference (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_intersection (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_subset (Set<Int> Set<Int>) Bool)
(declare-fun Set_equal (Set<Int> Set<Int>) Bool)
(declare-fun Set_in ($Ref Set<$Ref>) Bool)
(declare-fun Set_card (Set<$Ref>) Int)
(declare-const Set_empty Set<$Ref>)
(declare-fun Set_singleton ($Ref) Set<$Ref>)
(declare-fun Set_unionone (Set<$Ref> $Ref) Set<$Ref>)
(declare-fun Set_union (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_disjoint (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_difference (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_intersection (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_subset (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_equal (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_in ($Snap Set<$Snap>) Bool)
(declare-fun Set_card (Set<$Snap>) Int)
(declare-const Set_empty Set<$Snap>)
(declare-fun Set_singleton ($Snap) Set<$Snap>)
(declare-fun Set_unionone (Set<$Snap> $Snap) Set<$Snap>)
(declare-fun Set_union (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_disjoint (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_difference (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_intersection (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_subset (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_equal (Set<$Snap> Set<$Snap>) Bool)
(declare-fun array_loc<Ref> (array Int) $Ref)
(declare-fun alen<Int> (array) Int)
(declare-fun loc_inv_1<array> ($Ref) array)
(declare-fun loc_inv_2<Int> ($Ref) Int)
(declare-const None<option<array>> option<array>)
(declare-fun some<option<array>> (array) option<array>)
(declare-fun option_get<array> (option<array>) array)
(declare-const v_null<t_null> t_null)
(declare-const None<option<any>> option<any>)
(declare-fun some<option<any>> (any) option<any>)
(declare-fun option_get<any> (option<any>) any)
; /field_value_functions_declarations.smt2 [option$array$: option[array]]
(declare-fun $FVF.domain_option$array$ ($FVF<option<array>>) Set<$Ref>)
(declare-fun $FVF.lookup_option$array$ ($FVF<option<array>> $Ref) option<array>)
(declare-fun $FVF.after_option$array$ ($FVF<option<array>> $FVF<option<array>>) Bool)
(declare-fun $FVF.loc_option$array$ (option<array> $Ref) Bool)
(declare-fun $FVF.perm_option$array$ ($FPM $Ref) $Perm)
(declare-const $fvfTOP_option$array$ $FVF<option<array>>)
; /field_value_functions_declarations.smt2 [int: Int]
(declare-fun $FVF.domain_int ($FVF<Int>) Set<$Ref>)
(declare-fun $FVF.lookup_int ($FVF<Int> $Ref) Int)
(declare-fun $FVF.after_int ($FVF<Int> $FVF<Int>) Bool)
(declare-fun $FVF.loc_int (Int $Ref) Bool)
(declare-fun $FVF.perm_int ($FPM $Ref) $Perm)
(declare-const $fvfTOP_int $FVF<Int>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun opt_get ($Snap option<any>) any)
(declare-fun opt_get%limited ($Snap option<any>) any)
(declare-fun opt_get%stateless (option<any>) Bool)
(declare-fun any_as ($Snap any) any)
(declare-fun any_as%limited ($Snap any) any)
(declare-fun any_as%stateless (any) Bool)
(declare-fun type ($Snap $Ref) Int)
(declare-fun type%limited ($Snap $Ref) Int)
(declare-fun type%stateless ($Ref) Bool)
(declare-fun opt_or_else ($Snap option<any> any) any)
(declare-fun opt_or_else%limited ($Snap option<any> any) any)
(declare-fun opt_or_else%stateless (option<any> any) Bool)
(declare-fun subtype ($Snap Int Int) Bool)
(declare-fun subtype%limited ($Snap Int Int) Bool)
(declare-fun subtype%stateless (Int Int) Bool)
(declare-fun aloc ($Snap array Int) $Ref)
(declare-fun aloc%limited ($Snap array Int) $Ref)
(declare-fun aloc%stateless (array Int) Bool)
(declare-fun as_any ($Snap any) any)
(declare-fun as_any%limited ($Snap any) any)
(declare-fun as_any%stateless (any) Bool)
(declare-fun opt_get1 ($Snap option<array>) array)
(declare-fun opt_get1%limited ($Snap option<array>) array)
(declare-fun opt_get1%stateless (option<array>) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun lock_inv_FordFulkerson%trigger ($Snap $Ref) Bool)
(declare-fun lock_held_FordFulkerson%trigger ($Snap $Ref) Bool)
(declare-fun lock_inv_Object%trigger ($Snap $Ref) Bool)
(declare-fun lock_held_Object%trigger ($Snap $Ref) Bool)
; ////////// Uniqueness assumptions from domains
; ////////// Axioms
(assert (forall ((s Set<option<array>>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[option[array]]_prog.card_non_negative|)))
(assert (forall ((e option<array>)) (!
  (not (Set_in e (as Set_empty  Set<option<array>>)))
  :pattern ((Set_in e (as Set_empty  Set<option<array>>)))
  :qid |$Set[option[array]]_prog.in_empty_set|)))
(assert (forall ((s Set<option<array>>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<option<array>>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e option<array>)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[option[array]]_prog.empty_set_cardinality|)))
(assert (forall ((e option<array>)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[option[array]]_prog.in_singleton_set|)))
(assert (forall ((e1 option<array>) (e2 option<array>)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[option[array]]_prog.in_singleton_set_equality|)))
(assert (forall ((e option<array>)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[option[array]]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<option<array>>) (e option<array>)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[option[array]]_prog.in_unionone_same|)))
(assert (forall ((s Set<option<array>>) (e1 option<array>) (e2 option<array>)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[option[array]]_prog.in_unionone_other|)))
(assert (forall ((s Set<option<array>>) (e1 option<array>) (e2 option<array>)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[option[array]]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<option<array>>) (e option<array>)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[option[array]]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<option<array>>) (e option<array>)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[option[array]]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>) (e option<array>)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[option[array]]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>) (e option<array>)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[option[array]]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>) (e option<array>)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[option[array]]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>) (e option<array>)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[option[array]]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[option[array]]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[option[array]]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[option[array]]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[option[array]]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[option[array]]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>) (e option<array>)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[option[array]]_prog.in_difference|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>) (e option<array>)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[option[array]]_prog.not_in_difference|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e option<array>)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[option[array]]_prog.subset_definition|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e option<array>)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[option[array]]_prog.equality_definition|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[option[array]]_prog.native_equality|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e option<array>)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[option[array]]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<option<array>>) (s2 Set<option<array>>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[option[array]]_prog.cardinality_difference|)))
(assert (forall ((s Set<Int>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.card_non_negative|)))
(assert (forall ((e Int)) (!
  (not (Set_in e (as Set_empty  Set<Int>)))
  :pattern ((Set_in e (as Set_empty  Set<Int>)))
  :qid |$Set[Int]_prog.in_empty_set|)))
(assert (forall ((s Set<Int>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Int>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Int)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.empty_set_cardinality|)))
(assert (forall ((e Int)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Int]_prog.in_singleton_set|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Int]_prog.in_singleton_set_equality|)))
(assert (forall ((e Int)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Int]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Int]_prog.in_unionone_same|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Int]_prog.in_unionone_other|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Int]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Int]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Int]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Int]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Int]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Int)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Int]_prog.subset_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Int)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.equality_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.native_equality|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Int)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Int]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.cardinality_difference|)))
(assert (forall ((s Set<$Ref>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.card_non_negative|)))
(assert (forall ((e $Ref)) (!
  (not (Set_in e (as Set_empty  Set<$Ref>)))
  :pattern ((Set_in e (as Set_empty  Set<$Ref>)))
  :qid |$Set[Ref]_prog.in_empty_set|)))
(assert (forall ((s Set<$Ref>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Ref>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Ref)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.empty_set_cardinality|)))
(assert (forall ((e $Ref)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Ref]_prog.in_singleton_set|)))
(assert (forall ((e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Ref]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Ref)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Ref]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Ref]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Ref]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Ref]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Ref]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Ref]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Ref)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Ref]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Ref)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.native_equality|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Ref)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Ref]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_difference|)))
(assert (forall ((s Set<$Snap>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.card_non_negative|)))
(assert (forall ((e $Snap)) (!
  (not (Set_in e (as Set_empty  Set<$Snap>)))
  :pattern ((Set_in e (as Set_empty  Set<$Snap>)))
  :qid |$Set[Snap]_prog.in_empty_set|)))
(assert (forall ((s Set<$Snap>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Snap>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Snap)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.empty_set_cardinality|)))
(assert (forall ((e $Snap)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Snap]_prog.in_singleton_set|)))
(assert (forall ((e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Snap]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Snap)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Snap]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Snap]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Snap]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Snap]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Snap]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Snap]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Snap)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Snap]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Snap)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.native_equality|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Snap)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Snap]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_difference|)))
(assert (forall ((a2 array)) (!
  (forall ((i1 Int)) (!
    (and
      (= (loc_inv_1<array> (array_loc<Ref> a2 i1)) a2)
      (= (loc_inv_2<Int> (array_loc<Ref> a2 i1)) i1))
    :pattern ((loc_inv_1<array> (array_loc<Ref> a2 i1)))
    :pattern ((loc_inv_2<Int> (array_loc<Ref> a2 i1)))
    ))
  
  )))
(assert (forall ((a2 array)) (!
  (>= (alen<Int> a2) 0)
  :pattern ((alen<Int> a2))
  )))
(assert (forall ((x1 array)) (!
  (not (= (as None<option<array>>  option<array>) (some<option<array>> x1)))
  :pattern ((some<option<array>> x1))
  )))
(assert (forall ((x1 array)) (!
  (= (option_get<array> (some<option<array>> x1)) x1)
  :pattern ((option_get<array> (some<option<array>> x1)))
  )))
(assert (forall ((opt1 option<array>)) (!
  (= (some<option<array>> (option_get<array> opt1)) opt1)
  :pattern ((some<option<array>> (option_get<array> opt1)))
  )))
(assert (forall ((v t_null)) (!
  (= (as v_null<t_null>  t_null) v)
  
  )))
(assert (forall ((x1 any)) (!
  (not (= (as None<option<any>>  option<any>) (some<option<any>> x1)))
  :pattern ((some<option<any>> x1))
  )))
(assert (forall ((x1 any)) (!
  (= (option_get<any> (some<option<any>> x1)) x1)
  :pattern ((option_get<any> (some<option<any>> x1)))
  )))
(assert (forall ((opt1 option<any>)) (!
  (= (some<option<any>> (option_get<any> opt1)) opt1)
  :pattern ((some<option<any>> (option_get<any> opt1)))
  )))
; /field_value_functions_axioms.smt2 [option$array$: option[array]]
(assert (forall ((vs $FVF<option<array>>) (ws $FVF<option<array>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_option$array$ vs) ($FVF.domain_option$array$ ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_option$array$ vs))
            (= ($FVF.lookup_option$array$ vs x) ($FVF.lookup_option$array$ ws x)))
          :pattern (($FVF.lookup_option$array$ vs x) ($FVF.lookup_option$array$ ws x))
          :qid |qp.$FVF<option<array>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<option<array>>To$Snap vs)
              ($SortWrappers.$FVF<option<array>>To$Snap ws)
              )
    :qid |qp.$FVF<option<array>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_option$array$ pm r))
    :pattern ($FVF.perm_option$array$ pm r))))
(assert (forall ((r $Ref) (f option<array>)) (!
    (= ($FVF.loc_option$array$ f r) true)
    :pattern ($FVF.loc_option$array$ f r))))
; /field_value_functions_axioms.smt2 [int: Int]
(assert (forall ((vs $FVF<Int>) (ws $FVF<Int>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_int vs) ($FVF.domain_int ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_int vs))
            (= ($FVF.lookup_int vs x) ($FVF.lookup_int ws x)))
          :pattern (($FVF.lookup_int vs x) ($FVF.lookup_int ws x))
          :qid |qp.$FVF<Int>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Int>To$Snap vs)
              ($SortWrappers.$FVF<Int>To$Snap ws)
              )
    :qid |qp.$FVF<Int>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_int pm r))
    :pattern ($FVF.perm_int pm r))))
(assert (forall ((r $Ref) (f Int)) (!
    (= ($FVF.loc_int f r) true)
    :pattern ($FVF.loc_int f r))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ---------- FUNCTION opt_get----------
(declare-fun opt1@0@00 () option<any>)
(declare-fun result@1@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(assert (not (= opt1@0@00 (as None<option<any>>  option<any>))))
(declare-const $t@19@00 $Snap)
(assert (= $t@19@00 $Snap.unit))
; [eval] (some(result): option[any]) == opt1
; [eval] (some(result): option[any])
(assert (= (some<option<any>> result@1@00) opt1@0@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@0@00 option<any>)) (!
  (= (opt_get%limited s@$ opt1@0@00) (opt_get s@$ opt1@0@00))
  :pattern ((opt_get s@$ opt1@0@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@0@00 option<any>)) (!
  (opt_get%stateless opt1@0@00)
  :pattern ((opt_get%limited s@$ opt1@0@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@0@00 option<any>)) (!
  (let ((result@1@00 (opt_get%limited s@$ opt1@0@00))) (implies
    (not (= opt1@0@00 (as None<option<any>>  option<any>)))
    (= (some<option<any>> result@1@00) opt1@0@00)))
  :pattern ((opt_get%limited s@$ opt1@0@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ $Snap.unit))
(assert (not (= opt1@0@00 (as None<option<any>>  option<any>))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (option_get(opt1): any)
(assert (= result@1@00 (option_get<any> opt1@0@00)))
; [eval] (some(result): option[any]) == opt1
; [eval] (some(result): option[any])
(set-option :timeout 0)
(push) ; 2
(assert (not (= (some<option<any>> result@1@00) opt1@0@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             4
;  :conflicts             1
;  :datatype-accessor-ax  1
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            3.81
;  :memory                3.52
;  :mk-bool-var           165
;  :num-allocs            87539
;  :num-checks            2
;  :quant-instantiations  2
;  :rlimit-count          65379)
(assert (= (some<option<any>> result@1@00) opt1@0@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@0@00 option<any>)) (!
  (implies
    (not (= opt1@0@00 (as None<option<any>>  option<any>)))
    (= (opt_get s@$ opt1@0@00) (option_get<any> opt1@0@00)))
  :pattern ((opt_get s@$ opt1@0@00))
  )))
; ---------- FUNCTION any_as----------
(declare-fun t@2@00 () any)
(declare-fun result@3@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(pop) ; 1
(assert (forall ((s@$ $Snap) (t@2@00 any)) (!
  (= (any_as%limited s@$ t@2@00) (any_as s@$ t@2@00))
  :pattern ((any_as s@$ t@2@00))
  )))
(assert (forall ((s@$ $Snap) (t@2@00 any)) (!
  (any_as%stateless t@2@00)
  :pattern ((any_as%limited s@$ t@2@00))
  )))
; ---------- FUNCTION type----------
(declare-fun type1@4@00 () $Ref)
(declare-fun result@5@00 () Int)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@20@00 $Snap)
(assert (= $t@20@00 ($Snap.combine ($Snap.first $t@20@00) ($Snap.second $t@20@00))))
(assert (= ($Snap.first $t@20@00) $Snap.unit))
; [eval] 0 <= result
(assert (<= 0 result@5@00))
(assert (=
  ($Snap.second $t@20@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@20@00))
    ($Snap.second ($Snap.second $t@20@00)))))
(assert (= ($Snap.first ($Snap.second $t@20@00)) $Snap.unit))
; [eval] result < 2 + 1
; [eval] 2 + 1
(assert (< result@5@00 3))
(assert (=
  ($Snap.second ($Snap.second $t@20@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@20@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@20@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@20@00))) $Snap.unit))
; [eval] type1 == null ==> result == 0
; [eval] type1 == null
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= type1@4@00 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25
;  :arith-assert-lower      1
;  :arith-assert-upper      1
;  :conflicts               1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   3
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            3
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.54
;  :mk-bool-var             178
;  :num-allocs              88790
;  :num-checks              3
;  :quant-instantiations    2
;  :rlimit-count            66462)
(push) ; 3
(assert (not (= type1@4@00 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27
;  :arith-assert-lower      1
;  :arith-assert-upper      1
;  :conflicts               1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   5
;  :datatype-splits         2
;  :decisions               2
;  :final-checks            5
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.54
;  :mk-bool-var             180
;  :num-allocs              89148
;  :num-checks              4
;  :quant-instantiations    2
;  :rlimit-count            66733)
; [then-branch: 0 | type1@4@00 == Null | live]
; [else-branch: 0 | type1@4@00 != Null | live]
(push) ; 3
; [then-branch: 0 | type1@4@00 == Null]
(assert (= type1@4@00 $Ref.null))
; [eval] result == 0
(pop) ; 3
(push) ; 3
; [else-branch: 0 | type1@4@00 != Null]
(assert (not (= type1@4@00 $Ref.null)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (= type1@4@00 $Ref.null) (= result@5@00 0)))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@20@00))) $Snap.unit))
; [eval] type1 != null ==> result != 0
; [eval] type1 != null
(push) ; 2
(push) ; 3
(assert (not (= type1@4@00 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   6
;  :datatype-splits         2
;  :decisions               3
;  :final-checks            6
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.56
;  :mk-bool-var             184
;  :mk-clause               3
;  :num-allocs              89615
;  :num-checks              5
;  :propagations            1
;  :quant-instantiations    2
;  :rlimit-count            67149)
(push) ; 3
(assert (not (not (= type1@4@00 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               30
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   7
;  :datatype-splits         2
;  :decisions               3
;  :final-checks            7
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.56
;  :mk-bool-var             184
;  :mk-clause               3
;  :num-allocs              89975
;  :num-checks              6
;  :propagations            3
;  :quant-instantiations    2
;  :rlimit-count            67388)
; [then-branch: 1 | type1@4@00 != Null | live]
; [else-branch: 1 | type1@4@00 == Null | live]
(push) ; 3
; [then-branch: 1 | type1@4@00 != Null]
(assert (not (= type1@4@00 $Ref.null)))
; [eval] result != 0
(pop) ; 3
(push) ; 3
; [else-branch: 1 | type1@4@00 == Null]
(assert (= type1@4@00 $Ref.null))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (not (= type1@4@00 $Ref.null)) (not (= result@5@00 0))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (type1@4@00 $Ref)) (!
  (= (type%limited s@$ type1@4@00) (type s@$ type1@4@00))
  :pattern ((type s@$ type1@4@00))
  )))
(assert (forall ((s@$ $Snap) (type1@4@00 $Ref)) (!
  (type%stateless type1@4@00)
  :pattern ((type%limited s@$ type1@4@00))
  )))
(assert (forall ((s@$ $Snap) (type1@4@00 $Ref)) (!
  (let ((result@5@00 (type%limited s@$ type1@4@00))) (and
    (<= 0 result@5@00)
    (< result@5@00 3)
    (implies (= type1@4@00 $Ref.null) (= result@5@00 0))
    (implies (not (= type1@4@00 $Ref.null)) (not (= result@5@00 0)))))
  :pattern ((type%limited s@$ type1@4@00))
  )))
; ---------- FUNCTION opt_or_else----------
(declare-fun opt1@6@00 () option<any>)
(declare-fun alt@7@00 () any)
(declare-fun result@8@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@21@00 $Snap)
(assert (= $t@21@00 ($Snap.combine ($Snap.first $t@21@00) ($Snap.second $t@21@00))))
(assert (= ($Snap.first $t@21@00) $Snap.unit))
; [eval] opt1 == (None(): option[any]) ==> result == alt
; [eval] opt1 == (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(push) ; 3
(assert (not (not (= opt1@6@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   9
;  :datatype-splits         3
;  :decisions               4
;  :del-clause              3
;  :final-checks            9
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.56
;  :mk-bool-var             191
;  :mk-clause               3
;  :num-allocs              90829
;  :num-checks              7
;  :propagations            3
;  :quant-instantiations    2
;  :rlimit-count            68283)
(push) ; 3
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   11
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              3
;  :final-checks            11
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.56
;  :mk-bool-var             193
;  :mk-clause               3
;  :num-allocs              91160
;  :num-checks              8
;  :propagations            3
;  :quant-instantiations    2
;  :rlimit-count            68551)
; [then-branch: 2 | opt1@6@00 == None[option[any]] | live]
; [else-branch: 2 | opt1@6@00 != None[option[any]] | live]
(push) ; 3
; [then-branch: 2 | opt1@6@00 == None[option[any]]]
(assert (= opt1@6@00 (as None<option<any>>  option<any>)))
; [eval] result == alt
(pop) ; 3
(push) ; 3
; [else-branch: 2 | opt1@6@00 != None[option[any]]]
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (= opt1@6@00 (as None<option<any>>  option<any>))
  (= result@8@00 alt@7@00)))
(assert (= ($Snap.second $t@21@00) $Snap.unit))
; [eval] opt1 != (None(): option[any]) ==> result == opt_get(opt1)
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(push) ; 3
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               42
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              3
;  :final-checks            12
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.56
;  :mk-bool-var             196
;  :mk-clause               4
;  :num-allocs              91565
;  :num-checks              9
;  :propagations            3
;  :quant-instantiations    2
;  :rlimit-count            68930)
(push) ; 3
(assert (not (not (= opt1@6@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               44
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   13
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              3
;  :final-checks            13
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.56
;  :mk-bool-var             196
;  :mk-clause               4
;  :num-allocs              91911
;  :num-checks              10
;  :propagations            4
;  :quant-instantiations    2
;  :rlimit-count            69163)
; [then-branch: 3 | opt1@6@00 != None[option[any]] | live]
; [else-branch: 3 | opt1@6@00 == None[option[any]] | live]
(push) ; 3
; [then-branch: 3 | opt1@6@00 != None[option[any]]]
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
; [eval] result == opt_get(opt1)
; [eval] opt_get(opt1)
(push) ; 4
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 3 | opt1@6@00 == None[option[any]]]
(assert (= opt1@6@00 (as None<option<any>>  option<any>)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (not (= opt1@6@00 (as None<option<any>>  option<any>)))
  (= result@8@00 (opt_get $Snap.unit opt1@6@00))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@6@00 option<any>) (alt@7@00 any)) (!
  (=
    (opt_or_else%limited s@$ opt1@6@00 alt@7@00)
    (opt_or_else s@$ opt1@6@00 alt@7@00))
  :pattern ((opt_or_else s@$ opt1@6@00 alt@7@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@6@00 option<any>) (alt@7@00 any)) (!
  (opt_or_else%stateless opt1@6@00 alt@7@00)
  :pattern ((opt_or_else%limited s@$ opt1@6@00 alt@7@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@6@00 option<any>) (alt@7@00 any)) (!
  (let ((result@8@00 (opt_or_else%limited s@$ opt1@6@00 alt@7@00))) (and
    (implies
      (= opt1@6@00 (as None<option<any>>  option<any>))
      (= result@8@00 alt@7@00))
    (implies
      (not (= opt1@6@00 (as None<option<any>>  option<any>)))
      (= result@8@00 (opt_get $Snap.unit opt1@6@00)))))
  :pattern ((opt_or_else%limited s@$ opt1@6@00 alt@7@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (opt1 == (None(): option[any]) ? alt : opt_get(opt1))
; [eval] opt1 == (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= opt1@6@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   13
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            15
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.57
;  :mk-bool-var             200
;  :mk-clause               4
;  :num-allocs              92882
;  :num-checks              12
;  :propagations            4
;  :quant-instantiations    2
;  :rlimit-count            70095)
(push) ; 3
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               45
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   13
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            16
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.57
;  :mk-bool-var             201
;  :mk-clause               4
;  :num-allocs              93192
;  :num-checks              13
;  :propagations            4
;  :quant-instantiations    2
;  :rlimit-count            70331)
; [then-branch: 4 | opt1@6@00 == None[option[any]] | live]
; [else-branch: 4 | opt1@6@00 != None[option[any]] | live]
(push) ; 3
; [then-branch: 4 | opt1@6@00 == None[option[any]]]
(assert (= opt1@6@00 (as None<option<any>>  option<any>)))
(pop) ; 3
(push) ; 3
; [else-branch: 4 | opt1@6@00 != None[option[any]]]
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
; [eval] opt_get(opt1)
(push) ; 4
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(pop) ; 4
; Joined path conditions
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (=
  result@8@00
  (ite
    (= opt1@6@00 (as None<option<any>>  option<any>))
    alt@7@00
    (opt_get $Snap.unit opt1@6@00))))
; [eval] opt1 == (None(): option[any]) ==> result == alt
; [eval] opt1 == (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(push) ; 3
(assert (not (not (= opt1@6@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   14
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            17
;  :max-generation          1
;  :max-memory              3.81
;  :memory                  3.57
;  :mk-bool-var             206
;  :mk-clause               6
;  :num-allocs              93679
;  :num-checks              14
;  :propagations            5
;  :quant-instantiations    2
;  :rlimit-count            70717)
(push) ; 3
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               52
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   15
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.58
;  :mk-bool-var             210
;  :mk-clause               6
;  :num-allocs              94102
;  :num-checks              15
;  :propagations            6
;  :quant-instantiations    6
;  :rlimit-count            71040)
; [then-branch: 5 | opt1@6@00 == None[option[any]] | live]
; [else-branch: 5 | opt1@6@00 != None[option[any]] | live]
(push) ; 3
; [then-branch: 5 | opt1@6@00 == None[option[any]]]
(assert (= opt1@6@00 (as None<option<any>>  option<any>)))
; [eval] result == alt
(pop) ; 3
(push) ; 3
; [else-branch: 5 | opt1@6@00 != None[option[any]]]
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (implies
  (= opt1@6@00 (as None<option<any>>  option<any>))
  (= result@8@00 alt@7@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               55
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               2
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   15
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            18
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.57
;  :mk-bool-var             211
;  :mk-clause               6
;  :num-allocs              94184
;  :num-checks              16
;  :propagations            7
;  :quant-instantiations    6
;  :rlimit-count            71146)
(assert (implies
  (= opt1@6@00 (as None<option<any>>  option<any>))
  (= result@8@00 alt@7@00)))
; [eval] opt1 != (None(): option[any]) ==> result == opt_get(opt1)
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               60
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               2
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   16
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            19
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.58
;  :mk-bool-var             216
;  :mk-clause               7
;  :num-allocs              94632
;  :num-checks              17
;  :propagations            8
;  :quant-instantiations    10
;  :rlimit-count            71533)
(push) ; 3
(assert (not (not (= opt1@6@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               63
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               2
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   17
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.58
;  :mk-bool-var             216
;  :mk-clause               7
;  :num-allocs              94959
;  :num-checks              18
;  :propagations            10
;  :quant-instantiations    10
;  :rlimit-count            71769)
; [then-branch: 6 | opt1@6@00 != None[option[any]] | live]
; [else-branch: 6 | opt1@6@00 == None[option[any]] | live]
(push) ; 3
; [then-branch: 6 | opt1@6@00 != None[option[any]]]
(assert (not (= opt1@6@00 (as None<option<any>>  option<any>))))
; [eval] result == opt_get(opt1)
; [eval] opt_get(opt1)
(push) ; 4
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 6 | opt1@6@00 == None[option[any]]]
(assert (= opt1@6@00 (as None<option<any>>  option<any>)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (implies
  (not (= opt1@6@00 (as None<option<any>>  option<any>)))
  (= result@8@00 (opt_get $Snap.unit opt1@6@00)))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               69
;  :arith-assert-diseq      1
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :conflicts               3
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   17
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              4
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.57
;  :mk-bool-var             221
;  :mk-clause               7
;  :num-allocs              95105
;  :num-checks              19
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            72015)
(assert (implies
  (not (= opt1@6@00 (as None<option<any>>  option<any>)))
  (= result@8@00 (opt_get $Snap.unit opt1@6@00))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@6@00 option<any>) (alt@7@00 any)) (!
  (=
    (opt_or_else s@$ opt1@6@00 alt@7@00)
    (ite
      (= opt1@6@00 (as None<option<any>>  option<any>))
      alt@7@00
      (opt_get $Snap.unit opt1@6@00)))
  :pattern ((opt_or_else s@$ opt1@6@00 alt@7@00))
  )))
; ---------- FUNCTION subtype----------
(declare-fun subtype1@9@00 () Int)
(declare-fun subtype2@10@00 () Int)
(declare-fun result@11@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 <= subtype1
(assert (<= 0 subtype1@9@00))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] subtype1 < 2 + 1
; [eval] 2 + 1
(assert (< subtype1@9@00 3))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] 0 <= subtype2
(assert (<= 0 subtype2@10@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] subtype2 <= 2
(assert (<= subtype2@10@00 2))
(pop) ; 1
(assert (forall ((s@$ $Snap) (subtype1@9@00 Int) (subtype2@10@00 Int)) (!
  (=
    (subtype%limited s@$ subtype1@9@00 subtype2@10@00)
    (subtype s@$ subtype1@9@00 subtype2@10@00))
  :pattern ((subtype s@$ subtype1@9@00 subtype2@10@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@9@00 Int) (subtype2@10@00 Int)) (!
  (subtype%stateless subtype1@9@00 subtype2@10@00)
  :pattern ((subtype%limited s@$ subtype1@9@00 subtype2@10@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (<= 0 subtype1@9@00))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (< subtype1@9@00 3))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (<= 0 subtype2@10@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (<= subtype2@10@00 2))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (subtype1 == 1 ==> subtype2 == 1 || subtype2 == 2) && (subtype1 == 2 ==> subtype2 == 2)
; [eval] subtype1 == 1 ==> subtype2 == 1 || subtype2 == 2
; [eval] subtype1 == 1
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= subtype1@9@00 1))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               89
;  :arith-assert-diseq      1
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        2
;  :conflicts               3
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   19
;  :datatype-splits         4
;  :decisions               5
;  :del-clause              10
;  :final-checks            22
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.58
;  :mk-bool-var             238
;  :mk-clause               10
;  :num-allocs              96447
;  :num-checks              21
;  :propagations            14
;  :quant-instantiations    14
;  :rlimit-count            73448)
(push) ; 3
(assert (not (= subtype1@9@00 1)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               89
;  :arith-assert-diseq      2
;  :arith-assert-lower      7
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :conflicts               3
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   20
;  :datatype-splits         4
;  :decisions               6
;  :del-clause              14
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.58
;  :mk-bool-var             241
;  :mk-clause               14
;  :num-allocs              96802
;  :num-checks              22
;  :propagations            15
;  :quant-instantiations    14
;  :rlimit-count            73720)
; [then-branch: 7 | subtype1@9@00 == 1 | live]
; [else-branch: 7 | subtype1@9@00 != 1 | live]
(push) ; 3
; [then-branch: 7 | subtype1@9@00 == 1]
(assert (= subtype1@9@00 1))
; [eval] subtype2 == 1 || subtype2 == 2
; [eval] subtype2 == 1
(push) ; 4
; [then-branch: 8 | subtype2@10@00 == 1 | live]
; [else-branch: 8 | subtype2@10@00 != 1 | live]
(push) ; 5
; [then-branch: 8 | subtype2@10@00 == 1]
(assert (= subtype2@10@00 1))
(pop) ; 5
(push) ; 5
; [else-branch: 8 | subtype2@10@00 != 1]
(assert (not (= subtype2@10@00 1)))
; [eval] subtype2 == 2
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 7 | subtype1@9@00 != 1]
(assert (not (= subtype1@9@00 1)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(push) ; 2
; [then-branch: 9 | subtype1@9@00 == 1 ==> subtype2@10@00 == 1 || subtype2@10@00 == 2 | live]
; [else-branch: 9 | !(subtype1@9@00 == 1 ==> subtype2@10@00 == 1 || subtype2@10@00 == 2) | live]
(push) ; 3
; [then-branch: 9 | subtype1@9@00 == 1 ==> subtype2@10@00 == 1 || subtype2@10@00 == 2]
(assert (implies (= subtype1@9@00 1) (or (= subtype2@10@00 1) (= subtype2@10@00 2))))
; [eval] subtype1 == 2 ==> subtype2 == 2
; [eval] subtype1 == 2
(push) ; 4
(push) ; 5
(assert (not (not (= subtype1@9@00 2))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               93
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      9
;  :arith-eq-adapter        8
;  :conflicts               3
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   21
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              20
;  :final-checks            24
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.59
;  :mk-bool-var             255
;  :mk-clause               34
;  :num-allocs              97440
;  :num-checks              23
;  :propagations            23
;  :quant-instantiations    14
;  :rlimit-count            74204)
(push) ; 5
(assert (not (= subtype1@9@00 2)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               94
;  :arith-assert-diseq      7
;  :arith-assert-lower      14
;  :arith-assert-upper      15
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :conflicts               4
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   22
;  :datatype-splits         4
;  :decisions               12
;  :del-clause              25
;  :final-checks            25
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.59
;  :mk-bool-var             258
;  :mk-clause               39
;  :num-allocs              97851
;  :num-checks              24
;  :propagations            29
;  :quant-instantiations    14
;  :rlimit-count            74532)
; [then-branch: 10 | subtype1@9@00 == 2 | live]
; [else-branch: 10 | subtype1@9@00 != 2 | live]
(push) ; 5
; [then-branch: 10 | subtype1@9@00 == 2]
(assert (= subtype1@9@00 2))
; [eval] subtype2 == 2
(pop) ; 5
(push) ; 5
; [else-branch: 10 | subtype1@9@00 != 2]
(assert (not (= subtype1@9@00 2)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 9 | !(subtype1@9@00 == 1 ==> subtype2@10@00 == 1 || subtype2@10@00 == 2)]
(assert (not
  (implies (= subtype1@9@00 1) (or (= subtype2@10@00 1) (= subtype2@10@00 2)))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (and
    (implies (= subtype1@9@00 1) (or (= subtype2@10@00 1) (= subtype2@10@00 2)))
    (= subtype1@9@00 1))
  (or (= subtype2@10@00 1) (= subtype2@10@00 2))))
; Joined path conditions
(assert (=
  result@11@00
  (and
    (implies (= subtype1@9@00 2) (= subtype2@10@00 2))
    (implies (= subtype1@9@00 1) (or (= subtype2@10@00 1) (= subtype2@10@00 2))))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (subtype1@9@00 Int) (subtype2@10@00 Int)) (!
  (implies
    (and
      (<= 0 subtype1@9@00)
      (< subtype1@9@00 3)
      (<= 0 subtype2@10@00)
      (<= subtype2@10@00 2))
    (=
      (subtype s@$ subtype1@9@00 subtype2@10@00)
      (and
        (implies
          (= subtype1@9@00 1)
          (or (= subtype2@10@00 1) (= subtype2@10@00 2)))
        (implies (= subtype1@9@00 2) (= subtype2@10@00 2)))))
  :pattern ((subtype s@$ subtype1@9@00 subtype2@10@00))
  )))
; ---------- FUNCTION aloc----------
(declare-fun a2@12@00 () array)
(declare-fun i1@13@00 () Int)
(declare-fun result@14@00 () $Ref)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@13@00))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(assert (< i1@13@00 (alen<Int> a2@12@00)))
(declare-const $t@22@00 $Snap)
(assert (= $t@22@00 ($Snap.combine ($Snap.first $t@22@00) ($Snap.second $t@22@00))))
(assert (= ($Snap.first $t@22@00) $Snap.unit))
; [eval] loc_inv_1(result) == a2
; [eval] loc_inv_1(result)
(assert (= (loc_inv_1<array> result@14@00) a2@12@00))
(assert (= ($Snap.second $t@22@00) $Snap.unit))
; [eval] loc_inv_2(result) == i1
; [eval] loc_inv_2(result)
(assert (= (loc_inv_2<Int> result@14@00) i1@13@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (a2@12@00 array) (i1@13@00 Int)) (!
  (= (aloc%limited s@$ a2@12@00 i1@13@00) (aloc s@$ a2@12@00 i1@13@00))
  :pattern ((aloc s@$ a2@12@00 i1@13@00))
  )))
(assert (forall ((s@$ $Snap) (a2@12@00 array) (i1@13@00 Int)) (!
  (aloc%stateless a2@12@00 i1@13@00)
  :pattern ((aloc%limited s@$ a2@12@00 i1@13@00))
  )))
(assert (forall ((s@$ $Snap) (a2@12@00 array) (i1@13@00 Int)) (!
  (let ((result@14@00 (aloc%limited s@$ a2@12@00 i1@13@00))) (implies
    (and (<= 0 i1@13@00) (< i1@13@00 (alen<Int> a2@12@00)))
    (and
      (= (loc_inv_1<array> result@14@00) a2@12@00)
      (= (loc_inv_2<Int> result@14@00) i1@13@00))))
  :pattern ((aloc%limited s@$ a2@12@00 i1@13@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (<= 0 i1@13@00))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (< i1@13@00 (alen<Int> a2@12@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] array_loc(a2, i1)
(assert (= result@14@00 (array_loc<Ref> a2@12@00 i1@13@00)))
; [eval] loc_inv_1(result) == a2
; [eval] loc_inv_1(result)
(set-option :timeout 0)
(push) ; 2
(assert (not (= (loc_inv_1<array> result@14@00) a2@12@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               105
;  :arith-assert-diseq      7
;  :arith-assert-lower      16
;  :arith-assert-upper      16
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :conflicts               5
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   23
;  :datatype-splits         4
;  :decisions               12
;  :del-clause              39
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.62
;  :mk-bool-var             273
;  :mk-clause               42
;  :num-allocs              99137
;  :num-checks              26
;  :propagations            31
;  :quant-instantiations    16
;  :rlimit-count            76286)
(assert (= (loc_inv_1<array> result@14@00) a2@12@00))
; [eval] loc_inv_2(result) == i1
; [eval] loc_inv_2(result)
(push) ; 2
(assert (not (= (loc_inv_2<Int> result@14@00) i1@13@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               108
;  :arith-assert-diseq      7
;  :arith-assert-lower      16
;  :arith-assert-upper      16
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :conflicts               6
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   23
;  :datatype-splits         4
;  :decisions               12
;  :del-clause              39
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.62
;  :mk-bool-var             275
;  :mk-clause               42
;  :num-allocs              99273
;  :num-checks              27
;  :propagations            31
;  :quant-instantiations    16
;  :rlimit-count            76419)
(assert (= (loc_inv_2<Int> result@14@00) i1@13@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (a2@12@00 array) (i1@13@00 Int)) (!
  (implies
    (and (<= 0 i1@13@00) (< i1@13@00 (alen<Int> a2@12@00)))
    (= (aloc s@$ a2@12@00 i1@13@00) (array_loc<Ref> a2@12@00 i1@13@00)))
  :pattern ((aloc s@$ a2@12@00 i1@13@00))
  )))
; ---------- FUNCTION as_any----------
(declare-fun t@15@00 () any)
(declare-fun result@16@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@23@00 $Snap)
(assert (= $t@23@00 $Snap.unit))
; [eval] any_as(result) == t
; [eval] any_as(result)
(push) ; 2
(pop) ; 2
; Joined path conditions
(assert (= (any_as $Snap.unit result@16@00) t@15@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (t@15@00 any)) (!
  (= (as_any%limited s@$ t@15@00) (as_any s@$ t@15@00))
  :pattern ((as_any s@$ t@15@00))
  )))
(assert (forall ((s@$ $Snap) (t@15@00 any)) (!
  (as_any%stateless t@15@00)
  :pattern ((as_any%limited s@$ t@15@00))
  )))
(assert (forall ((s@$ $Snap) (t@15@00 any)) (!
  (let ((result@16@00 (as_any%limited s@$ t@15@00))) (=
    (any_as $Snap.unit result@16@00)
    t@15@00))
  :pattern ((as_any%limited s@$ t@15@00))
  )))
; ---------- FUNCTION opt_get1----------
(declare-fun opt1@17@00 () option<array>)
(declare-fun result@18@00 () array)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= opt1@17@00 (as None<option<array>>  option<array>))))
(declare-const $t@24@00 $Snap)
(assert (= $t@24@00 $Snap.unit))
; [eval] (some(result): option[array]) == opt1
; [eval] (some(result): option[array])
(assert (= (some<option<array>> result@18@00) opt1@17@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@17@00 option<array>)) (!
  (= (opt_get1%limited s@$ opt1@17@00) (opt_get1 s@$ opt1@17@00))
  :pattern ((opt_get1 s@$ opt1@17@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@17@00 option<array>)) (!
  (opt_get1%stateless opt1@17@00)
  :pattern ((opt_get1%limited s@$ opt1@17@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@17@00 option<array>)) (!
  (let ((result@18@00 (opt_get1%limited s@$ opt1@17@00))) (implies
    (not (= opt1@17@00 (as None<option<array>>  option<array>)))
    (= (some<option<array>> result@18@00) opt1@17@00)))
  :pattern ((opt_get1%limited s@$ opt1@17@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ $Snap.unit))
(assert (not (= opt1@17@00 (as None<option<array>>  option<array>))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (option_get(opt1): array)
(assert (= result@18@00 (option_get<array> opt1@17@00)))
; [eval] (some(result): option[array]) == opt1
; [eval] (some(result): option[array])
(set-option :timeout 0)
(push) ; 2
(assert (not (= (some<option<array>> result@18@00) opt1@17@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               113
;  :arith-assert-diseq      7
;  :arith-assert-lower      16
;  :arith-assert-upper      16
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :conflicts               7
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   24
;  :datatype-splits         4
;  :decisions               12
;  :del-clause              42
;  :final-checks            27
;  :max-generation          2
;  :max-memory              3.81
;  :memory                  3.62
;  :mk-bool-var             289
;  :mk-clause               42
;  :num-allocs              100764
;  :num-checks              29
;  :propagations            31
;  :quant-instantiations    18
;  :rlimit-count            77854)
(assert (= (some<option<array>> result@18@00) opt1@17@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@17@00 option<array>)) (!
  (implies
    (not (= opt1@17@00 (as None<option<array>>  option<array>)))
    (= (opt_get1 s@$ opt1@17@00) (option_get<array> opt1@17@00)))
  :pattern ((opt_get1 s@$ opt1@17@00))
  )))
; ---------- lock_inv_FordFulkerson ----------
(declare-const this@25@00 $Ref)
(push) ; 1
(declare-const $t@26@00 $Snap)
(assert (= $t@26@00 $Snap.unit))
(pop) ; 1
; ---------- lock_held_FordFulkerson ----------
(declare-const this@27@00 $Ref)
; ---------- lock_inv_Object ----------
(declare-const this@28@00 $Ref)
(push) ; 1
(declare-const $t@29@00 $Snap)
(assert (= $t@29@00 $Snap.unit))
(pop) ; 1
; ---------- lock_held_Object ----------
(declare-const this@30@00 $Ref)
