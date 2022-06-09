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
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
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
(assert (forall ((s@$ $Snap) (opt1@0@00 option<any>)) (!
  (implies
    (not (= opt1@0@00 (as None<option<any>>  option<any>)))
    (= (opt_get s@$ opt1@0@00) (option_get<any> opt1@0@00)))
  :pattern ((opt_get s@$ opt1@0@00))
  )))
(assert (forall ((s@$ $Snap) (t@2@00 any)) (!
  (= (any_as%limited s@$ t@2@00) (any_as s@$ t@2@00))
  :pattern ((any_as s@$ t@2@00))
  )))
(assert (forall ((s@$ $Snap) (t@2@00 any)) (!
  (any_as%stateless t@2@00)
  :pattern ((any_as%limited s@$ t@2@00))
  )))
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
(assert (forall ((s@$ $Snap) (opt1@6@00 option<any>) (alt@7@00 any)) (!
  (=
    (opt_or_else s@$ opt1@6@00 alt@7@00)
    (ite
      (= opt1@6@00 (as None<option<any>>  option<any>))
      alt@7@00
      (opt_get $Snap.unit opt1@6@00)))
  :pattern ((opt_or_else s@$ opt1@6@00 alt@7@00))
  )))
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
(assert (forall ((s@$ $Snap) (a2@12@00 array) (i1@13@00 Int)) (!
  (implies
    (and (<= 0 i1@13@00) (< i1@13@00 (alen<Int> a2@12@00)))
    (= (aloc s@$ a2@12@00 i1@13@00) (array_loc<Ref> a2@12@00 i1@13@00)))
  :pattern ((aloc s@$ a2@12@00 i1@13@00))
  )))
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
(assert (forall ((s@$ $Snap) (opt1@17@00 option<array>)) (!
  (implies
    (not (= opt1@17@00 (as None<option<array>>  option<array>)))
    (= (opt_get1 s@$ opt1@17@00) (option_get<array> opt1@17@00)))
  :pattern ((opt_get1 s@$ opt1@17@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- max_flow ----------
(declare-const this@0@07 $Ref)
(declare-const tid@1@07 Int)
(declare-const G@2@07 option<array>)
(declare-const s@3@07 Int)
(declare-const t@4@07 Int)
(declare-const V@5@07 Int)
(declare-const exc@6@07 $Ref)
(declare-const res@7@07 Int)
(declare-const this@8@07 $Ref)
(declare-const tid@9@07 Int)
(declare-const G@10@07 option<array>)
(declare-const s@11@07 Int)
(declare-const t@12@07 Int)
(declare-const V@13@07 Int)
(declare-const exc@14@07 $Ref)
(declare-const res@15@07 Int)
(push) ; 1
(declare-const $t@16@07 $Snap)
(assert (= $t@16@07 ($Snap.combine ($Snap.first $t@16@07) ($Snap.second $t@16@07))))
(assert (= ($Snap.first $t@16@07) $Snap.unit))
; [eval] this != null
(assert (not (= this@8@07 $Ref.null)))
(assert (=
  ($Snap.second $t@16@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@16@07))
    ($Snap.second ($Snap.second $t@16@07)))))
(assert (= ($Snap.first ($Snap.second $t@16@07)) $Snap.unit))
; [eval] G != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= G@10@07 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second $t@16@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@16@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@16@07))) $Snap.unit))
; [eval] alen(opt_get1(G)) == V
; [eval] alen(opt_get1(G))
; [eval] opt_get1(G)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (opt_get1 $Snap.unit G@10@07)) V@13@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@16@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@16@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@16@07))))
  $Snap.unit))
; [eval] 0 <= s
(assert (<= 0 s@11@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))
  $Snap.unit))
; [eval] s <= alen(opt_get1(G)) - 1
; [eval] alen(opt_get1(G)) - 1
; [eval] alen(opt_get1(G))
; [eval] opt_get1(G)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (<= s@11@07 (- (alen<Int> (opt_get1 $Snap.unit G@10@07)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))
  $Snap.unit))
; [eval] 0 <= t
(assert (<= 0 t@12@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))
  $Snap.unit))
; [eval] t <= alen(opt_get1(G)) - 1
; [eval] alen(opt_get1(G)) - 1
; [eval] alen(opt_get1(G))
; [eval] opt_get1(G)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (<= t@12@07 (- (alen<Int> (opt_get1 $Snap.unit G@10@07)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))
  $Snap.unit))
; [eval] s != t
(assert (not (= s@11@07 t@12@07)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))))))
(declare-const i1@17@07 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 0 | 0 <= i1@17@07 | live]
; [else-branch: 0 | !(0 <= i1@17@07) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i1@17@07]
(assert (<= 0 i1@17@07))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i1@17@07)]
(assert (not (<= 0 i1@17@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< i1@17@07 V@13@07) (<= 0 i1@17@07)))
; [eval] aloc(opt_get1(G), i1)
; [eval] opt_get1(G)
(push) ; 3
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
; Joined path conditions
(push) ; 3
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 4
(assert (not (< i1@17@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            58
;  :arith-add-rows       1
;  :arith-assert-diseq   1
;  :arith-assert-lower   7
;  :arith-assert-upper   2
;  :arith-eq-adapter     2
;  :arith-pivots         2
;  :datatype-accessor-ax 10
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.63
;  :mk-bool-var          220
;  :mk-clause            4
;  :num-allocs           91005
;  :num-checks           1
;  :quant-instantiations 5
;  :rlimit-count         70425)
(assert (< i1@17@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(pop) ; 3
; Joined path conditions
(assert (< i1@17@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(pop) ; 2
(declare-fun inv@18@07 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@17@07 Int)) (!
  (< i1@17@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@17@07))
  :qid |option$array$-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((i11@17@07 Int) (i12@17@07 Int)) (!
  (implies
    (and
      (and (< i11@17@07 V@13@07) (<= 0 i11@17@07))
      (and (< i12@17@07 V@13@07) (<= 0 i12@17@07))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i11@17@07)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i12@17@07)))
    (= i11@17@07 i12@17@07))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            88
;  :arith-add-rows       18
;  :arith-assert-diseq   4
;  :arith-assert-lower   16
;  :arith-assert-upper   4
;  :arith-conflicts      2
;  :arith-eq-adapter     3
;  :arith-offset-eqs     1
;  :arith-pivots         10
;  :conflicts            4
;  :datatype-accessor-ax 11
;  :decisions            3
;  :del-clause           17
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.68
;  :mk-bool-var          246
;  :mk-clause            21
;  :num-allocs           91705
;  :num-checks           2
;  :propagations         21
;  :quant-instantiations 16
;  :rlimit-count         71743)
; Definitional axioms for inverse functions
(assert (forall ((i1@17@07 Int)) (!
  (implies
    (and (< i1@17@07 V@13@07) (<= 0 i1@17@07))
    (=
      (inv@18@07 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@17@07))
      i1@17@07))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@17@07))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@18@07 r) V@13@07) (<= 0 (inv@18@07 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) (inv@18@07 r))
      r))
  :pattern ((inv@18@07 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((i1@17@07 Int)) (!
  (implies
    (and (< i1@17@07 V@13@07) (<= 0 i1@17@07))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@17@07)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@17@07))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@19@07 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@18@07 r) V@13@07) (<= 0 (inv@18@07 r)))
    (=
      ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@18@07 r) V@13@07) (<= 0 (inv@18@07 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) r) r))
  :pattern ((inv@18@07 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))))
  $Snap.unit))
; [eval] (forall i1: Int :: { aloc(opt_get1(G), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(G), i1).option$array$ != (None(): option[array]))
(declare-const i1@20@07 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(G), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 1 | 0 <= i1@20@07 | live]
; [else-branch: 1 | !(0 <= i1@20@07) | live]
(push) ; 4
; [then-branch: 1 | 0 <= i1@20@07]
(assert (<= 0 i1@20@07))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 1 | !(0 <= i1@20@07)]
(assert (not (<= 0 i1@20@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 2 | i1@20@07 < V@13@07 && 0 <= i1@20@07 | live]
; [else-branch: 2 | !(i1@20@07 < V@13@07 && 0 <= i1@20@07) | live]
(push) ; 4
; [then-branch: 2 | i1@20@07 < V@13@07 && 0 <= i1@20@07]
(assert (and (< i1@20@07 V@13@07) (<= 0 i1@20@07)))
; [eval] aloc(opt_get1(G), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(G), i1)
; [eval] opt_get1(G)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i1@20@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            94
;  :arith-add-rows       18
;  :arith-assert-diseq   4
;  :arith-assert-lower   18
;  :arith-assert-upper   4
;  :arith-conflicts      2
;  :arith-eq-adapter     3
;  :arith-offset-eqs     1
;  :arith-pivots         10
;  :conflicts            4
;  :datatype-accessor-ax 12
;  :decisions            3
;  :del-clause           17
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.68
;  :mk-bool-var          256
;  :mk-clause            21
;  :num-allocs           92847
;  :num-checks           3
;  :propagations         21
;  :quant-instantiations 16
;  :rlimit-count         74115)
(assert (< i1@20@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(pop) ; 5
; Joined path conditions
(assert (< i1@20@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07)))
(push) ; 5
(assert (not (and
  (<
    (inv@18@07 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07))
    V@13@07)
  (<=
    0
    (inv@18@07 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            99
;  :arith-add-rows       23
;  :arith-assert-diseq   4
;  :arith-assert-lower   19
;  :arith-assert-upper   6
;  :arith-bound-prop     1
;  :arith-conflicts      3
;  :arith-eq-adapter     4
;  :arith-fixed-eqs      1
;  :arith-offset-eqs     1
;  :arith-pivots         12
;  :conflicts            5
;  :datatype-accessor-ax 12
;  :decisions            3
;  :del-clause           17
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.69
;  :mk-bool-var          274
;  :mk-clause            28
;  :num-allocs           93157
;  :num-checks           4
;  :propagations         21
;  :quant-instantiations 26
;  :rlimit-count         74771)
; [eval] (None(): option[array])
(pop) ; 4
(push) ; 4
; [else-branch: 2 | !(i1@20@07 < V@13@07 && 0 <= i1@20@07)]
(assert (not (and (< i1@20@07 V@13@07) (<= 0 i1@20@07))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< i1@20@07 V@13@07) (<= 0 i1@20@07))
  (and
    (< i1@20@07 V@13@07)
    (<= 0 i1@20@07)
    (< i1@20@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07)))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@20@07 Int)) (!
  (implies
    (and (< i1@20@07 V@13@07) (<= 0 i1@20@07))
    (and
      (< i1@20@07 V@13@07)
      (<= 0 i1@20@07)
      (< i1@20@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i1@20@07 Int)) (!
  (implies
    (and (< i1@20@07 V@13@07) (<= 0 i1@20@07))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07))
        (as None<option<array>>  option<array>))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@20@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@16@07)))))))))))
  $Snap.unit))
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(G), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(G), i1).option$array$)) == V)
(declare-const i1@21@07 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(G), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 3 | 0 <= i1@21@07 | live]
; [else-branch: 3 | !(0 <= i1@21@07) | live]
(push) ; 4
; [then-branch: 3 | 0 <= i1@21@07]
(assert (<= 0 i1@21@07))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 3 | !(0 <= i1@21@07)]
(assert (not (<= 0 i1@21@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 4 | i1@21@07 < V@13@07 && 0 <= i1@21@07 | live]
; [else-branch: 4 | !(i1@21@07 < V@13@07 && 0 <= i1@21@07) | live]
(push) ; 4
; [then-branch: 4 | i1@21@07 < V@13@07 && 0 <= i1@21@07]
(assert (and (< i1@21@07 V@13@07) (<= 0 i1@21@07)))
; [eval] alen(opt_get1(aloc(opt_get1(G), i1).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(G), i1).option$array$))
; [eval] opt_get1(aloc(opt_get1(G), i1).option$array$)
; [eval] aloc(opt_get1(G), i1)
; [eval] opt_get1(G)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i1@21@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            105
;  :arith-add-rows       25
;  :arith-assert-diseq   4
;  :arith-assert-lower   21
;  :arith-assert-upper   6
;  :arith-bound-prop     1
;  :arith-conflicts      3
;  :arith-eq-adapter     4
;  :arith-fixed-eqs      1
;  :arith-offset-eqs     1
;  :arith-pivots         15
;  :conflicts            5
;  :datatype-accessor-ax 13
;  :decisions            3
;  :del-clause           24
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.69
;  :mk-bool-var          280
;  :mk-clause            28
;  :num-allocs           93693
;  :num-checks           5
;  :propagations         21
;  :quant-instantiations 26
;  :rlimit-count         75966)
(assert (< i1@21@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(pop) ; 5
; Joined path conditions
(assert (< i1@21@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07)))
(push) ; 5
(assert (not (and
  (<
    (inv@18@07 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
    V@13@07)
  (<=
    0
    (inv@18@07 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            115
;  :arith-add-rows       32
;  :arith-assert-diseq   4
;  :arith-assert-lower   22
;  :arith-assert-upper   8
;  :arith-bound-prop     3
;  :arith-conflicts      4
;  :arith-eq-adapter     5
;  :arith-fixed-eqs      2
;  :arith-offset-eqs     4
;  :arith-pivots         17
;  :conflicts            6
;  :datatype-accessor-ax 13
;  :decisions            3
;  :del-clause           24
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.69
;  :mk-bool-var          299
;  :mk-clause            35
;  :num-allocs           93952
;  :num-checks           6
;  :propagations         24
;  :quant-instantiations 38
;  :rlimit-count         76671)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            115
;  :arith-add-rows       32
;  :arith-assert-diseq   4
;  :arith-assert-lower   22
;  :arith-assert-upper   8
;  :arith-bound-prop     3
;  :arith-conflicts      4
;  :arith-eq-adapter     5
;  :arith-fixed-eqs      2
;  :arith-offset-eqs     4
;  :arith-pivots         17
;  :conflicts            7
;  :datatype-accessor-ax 13
;  :decisions            3
;  :del-clause           24
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.69
;  :mk-bool-var          299
;  :mk-clause            35
;  :num-allocs           94039
;  :num-checks           7
;  :propagations         24
;  :quant-instantiations 38
;  :rlimit-count         76766)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
    (as None<option<array>>  option<array>))))
(pop) ; 4
(push) ; 4
; [else-branch: 4 | !(i1@21@07 < V@13@07 && 0 <= i1@21@07)]
(assert (not (and (< i1@21@07 V@13@07) (<= 0 i1@21@07))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< i1@21@07 V@13@07) (<= 0 i1@21@07))
  (and
    (< i1@21@07 V@13@07)
    (<= 0 i1@21@07)
    (< i1@21@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@21@07 Int)) (!
  (implies
    (and (< i1@21@07 V@13@07) (<= 0 i1@21@07))
    (and
      (< i1@21@07 V@13@07)
      (<= 0 i1@21@07)
      (< i1@21@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i1@21@07 Int)) (!
  (implies
    (and (< i1@21@07 V@13@07) (<= 0 i1@21@07))
    (=
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07))))
      V@13@07))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@21@07)))))
  :qid |prog.l<no position>|)))
(declare-const i1@22@07 Int)
(declare-const j1@23@07 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V && (0 <= j1 && j1 < V)
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 5 | 0 <= i1@22@07 | live]
; [else-branch: 5 | !(0 <= i1@22@07) | live]
(push) ; 4
; [then-branch: 5 | 0 <= i1@22@07]
(assert (<= 0 i1@22@07))
; [eval] i1 < V
(push) ; 5
; [then-branch: 6 | i1@22@07 < V@13@07 | live]
; [else-branch: 6 | !(i1@22@07 < V@13@07) | live]
(push) ; 6
; [then-branch: 6 | i1@22@07 < V@13@07]
(assert (< i1@22@07 V@13@07))
; [eval] 0 <= j1
(push) ; 7
; [then-branch: 7 | 0 <= j1@23@07 | live]
; [else-branch: 7 | !(0 <= j1@23@07) | live]
(push) ; 8
; [then-branch: 7 | 0 <= j1@23@07]
(assert (<= 0 j1@23@07))
; [eval] j1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 7 | !(0 <= j1@23@07)]
(assert (not (<= 0 j1@23@07)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 6 | !(i1@22@07 < V@13@07)]
(assert (not (< i1@22@07 V@13@07)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 5 | !(0 <= i1@22@07)]
(assert (not (<= 0 i1@22@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and
  (and (and (< j1@23@07 V@13@07) (<= 0 j1@23@07)) (< i1@22@07 V@13@07))
  (<= 0 i1@22@07)))
; [eval] aloc(opt_get1(aloc(opt_get1(G), i1).option$array$), j1)
; [eval] opt_get1(aloc(opt_get1(G), i1).option$array$)
; [eval] aloc(opt_get1(G), i1)
; [eval] opt_get1(G)
(push) ; 3
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
; Joined path conditions
(push) ; 3
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 4
(assert (not (< i1@22@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            115
;  :arith-add-rows       34
;  :arith-assert-diseq   4
;  :arith-assert-lower   28
;  :arith-assert-upper   8
;  :arith-bound-prop     3
;  :arith-conflicts      4
;  :arith-eq-adapter     5
;  :arith-fixed-eqs      2
;  :arith-offset-eqs     4
;  :arith-pivots         19
;  :conflicts            7
;  :datatype-accessor-ax 13
;  :decisions            3
;  :del-clause           31
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.70
;  :mk-bool-var          307
;  :mk-clause            35
;  :num-allocs           94703
;  :num-checks           8
;  :propagations         24
;  :quant-instantiations 38
;  :rlimit-count         78018)
(assert (< i1@22@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(pop) ; 3
; Joined path conditions
(assert (< i1@22@07 (alen<Int> (opt_get1 $Snap.unit G@10@07))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07)))
(push) ; 3
(assert (not (and
  (<
    (inv@18@07 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))
    V@13@07)
  (<=
    0
    (inv@18@07 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            119
;  :arith-add-rows       39
;  :arith-assert-diseq   4
;  :arith-assert-lower   29
;  :arith-assert-upper   10
;  :arith-bound-prop     4
;  :arith-conflicts      5
;  :arith-eq-adapter     6
;  :arith-fixed-eqs      3
;  :arith-offset-eqs     4
;  :arith-pivots         21
;  :conflicts            8
;  :datatype-accessor-ax 13
;  :decisions            3
;  :del-clause           31
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.72
;  :mk-bool-var          326
;  :mk-clause            42
;  :num-allocs           94964
;  :num-checks           9
;  :propagations         24
;  :quant-instantiations 50
;  :rlimit-count         78705)
(push) ; 3
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 4
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            119
;  :arith-add-rows       39
;  :arith-assert-diseq   4
;  :arith-assert-lower   29
;  :arith-assert-upper   10
;  :arith-bound-prop     4
;  :arith-conflicts      5
;  :arith-eq-adapter     6
;  :arith-fixed-eqs      3
;  :arith-offset-eqs     4
;  :arith-pivots         21
;  :conflicts            9
;  :datatype-accessor-ax 13
;  :decisions            3
;  :del-clause           31
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.72
;  :mk-bool-var          326
;  :mk-clause            42
;  :num-allocs           95052
;  :num-checks           10
;  :propagations         24
;  :quant-instantiations 50
;  :rlimit-count         78800)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))
    (as None<option<array>>  option<array>))))
(pop) ; 3
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))
    (as None<option<array>>  option<array>))))
(push) ; 3
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 4
(assert (not (<
  j1@23@07
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07)))))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            125
;  :arith-add-rows       44
;  :arith-assert-diseq   4
;  :arith-assert-lower   32
;  :arith-assert-upper   11
;  :arith-bound-prop     4
;  :arith-conflicts      6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      4
;  :arith-offset-eqs     4
;  :arith-pivots         25
;  :conflicts            10
;  :datatype-accessor-ax 13
;  :decisions            3
;  :del-clause           35
;  :max-generation       2
;  :max-memory           3.81
;  :memory               3.73
;  :mk-bool-var          337
;  :mk-clause            46
;  :num-allocs           95271
;  :num-checks           11
;  :propagations         26
;  :quant-instantiations 57
;  :rlimit-count         79303)
(assert (<
  j1@23@07
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))))))
(pop) ; 3
; Joined path conditions
(assert (<
  j1@23@07
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))))))
(pop) ; 2
(declare-fun inv@24@07 ($Ref) Int)
(declare-fun inv@25@07 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@22@07 Int) (j1@23@07 Int)) (!
  (and
    (< i1@22@07 (alen<Int> (opt_get1 $Snap.unit G@10@07)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))
        (as None<option<array>>  option<array>)))
    (<
      j1@23@07
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit G@10@07) i1@22@07))) j1@23@07))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((i11@22@07 Int) (j11@23@07 Int) (i12@22@07 Int) (j12@23@07 Int)) (!
  (implies
    (and
      (and
        (and (and (< j11@23@07 V@13@07) (<= 0 j11@23@07)) (< i11@22@07 V@13@07))
        (<= 0 i11@22@07))
      (and
        (and (and (< j12@23@07 V@13@07) (<= 0 j12@23@07)) (< i12@22@07 V@13@07))
        (<= 0 i12@22@07))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit G@10@07) i11@22@07))) j11@23@07)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@19@07  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit G@10@07) i12@22@07))) j12@23@07)))
    (and (= i11@22@07 i12@22@07) (= j11@23@07 j12@23@07)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-add-rows          91
;  :arith-assert-diseq      6
;  :arith-assert-lower      55
;  :arith-assert-upper      19
;  :arith-bound-prop        8
;  :arith-conflicts         7
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        16
;  :arith-pivots            51
;  :conflicts               11
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   3
;  :datatype-splits         2
;  :decisions               11
;  :del-clause              109
;  :final-checks            3
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              3.89
;  :memory                  3.88
;  :mk-bool-var             445
;  :mk-clause               113
;  :num-allocs              97346
;  :num-checks              12
;  :propagations            63
;  :quant-instantiations    106
;  :rlimit-count            83162
;  :time                    0.00)
(pop) ; 1
