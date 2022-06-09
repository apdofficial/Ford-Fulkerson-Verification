(get-info :version)
; (:version "4.8.6")
; Started: 2022-06-09 19:28:09
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
(declare-sort Seq<Int>)
(declare-sort Set<option<array>>)
(declare-sort Set<Bool>)
(declare-sort Set<Int>)
(declare-sort Set<$Ref>)
(declare-sort Set<$Snap>)
(declare-sort t_null)
(declare-sort any)
(declare-sort void)
(declare-sort option<any>)
(declare-sort option<array>)
(declare-sort array)
(declare-sort $FVF<Int>)
(declare-sort $FVF<option<array>>)
(declare-sort $FVF<Bool>)
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
(declare-fun $SortWrappers.Seq<Int>To$Snap (Seq<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSeq<Int> ($Snap) Seq<Int>)
(assert (forall ((x Seq<Int>)) (!
    (= x ($SortWrappers.$SnapToSeq<Int>($SortWrappers.Seq<Int>To$Snap x)))
    :pattern (($SortWrappers.Seq<Int>To$Snap x))
    :qid |$Snap.$SnapToSeq<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Seq<Int>To$Snap($SortWrappers.$SnapToSeq<Int> x)))
    :pattern (($SortWrappers.$SnapToSeq<Int> x))
    :qid |$Snap.Seq<Int>To$SnapToSeq<Int>|
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
(declare-fun $SortWrappers.Set<Bool>To$Snap (Set<Bool>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Bool> ($Snap) Set<Bool>)
(assert (forall ((x Set<Bool>)) (!
    (= x ($SortWrappers.$SnapToSet<Bool>($SortWrappers.Set<Bool>To$Snap x)))
    :pattern (($SortWrappers.Set<Bool>To$Snap x))
    :qid |$Snap.$SnapToSet<Bool>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Bool>To$Snap($SortWrappers.$SnapToSet<Bool> x)))
    :pattern (($SortWrappers.$SnapToSet<Bool> x))
    :qid |$Snap.Set<Bool>To$SnapToSet<Bool>|
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
(declare-fun $SortWrappers.voidTo$Snap (void) $Snap)
(declare-fun $SortWrappers.$SnapTovoid ($Snap) void)
(assert (forall ((x void)) (!
    (= x ($SortWrappers.$SnapTovoid($SortWrappers.voidTo$Snap x)))
    :pattern (($SortWrappers.voidTo$Snap x))
    :qid |$Snap.$SnapTovoidTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.voidTo$Snap($SortWrappers.$SnapTovoid x)))
    :pattern (($SortWrappers.$SnapTovoid x))
    :qid |$Snap.voidTo$SnapTovoid|
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
(declare-fun $SortWrappers.$FVF<Bool>To$Snap ($FVF<Bool>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Bool> ($Snap) $FVF<Bool>)
(assert (forall ((x $FVF<Bool>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Bool>($SortWrappers.$FVF<Bool>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Bool>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Bool>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Bool>To$Snap($SortWrappers.$SnapTo$FVF<Bool> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Bool> x))
    :qid |$Snap.$FVF<Bool>To$SnapTo$FVF<Bool>|
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
(declare-fun Set_in (Bool Set<Bool>) Bool)
(declare-fun Set_card (Set<Bool>) Int)
(declare-const Set_empty Set<Bool>)
(declare-fun Set_singleton (Bool) Set<Bool>)
(declare-fun Set_unionone (Set<Bool> Bool) Set<Bool>)
(declare-fun Set_union (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_disjoint (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_difference (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_intersection (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_subset (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_equal (Set<Bool> Set<Bool>) Bool)
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
(declare-fun Seq_length (Seq<Int>) Int)
(declare-const Seq_empty Seq<Int>)
(declare-fun Seq_singleton (Int) Seq<Int>)
(declare-fun Seq_build (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_index (Seq<Int> Int) Int)
(declare-fun Seq_append (Seq<Int> Seq<Int>) Seq<Int>)
(declare-fun Seq_update (Seq<Int> Int Int) Seq<Int>)
(declare-fun Seq_contains (Seq<Int> Int) Bool)
(declare-fun Seq_take (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_drop (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_equal (Seq<Int> Seq<Int>) Bool)
(declare-fun Seq_sameuntil (Seq<Int> Seq<Int> Int) Bool)
(declare-fun Seq_range (Int Int) Seq<Int>)
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
(declare-const unit<void> void)
; /field_value_functions_declarations.smt2 [int: Int]
(declare-fun $FVF.domain_int ($FVF<Int>) Set<$Ref>)
(declare-fun $FVF.lookup_int ($FVF<Int> $Ref) Int)
(declare-fun $FVF.after_int ($FVF<Int> $FVF<Int>) Bool)
(declare-fun $FVF.loc_int (Int $Ref) Bool)
(declare-fun $FVF.perm_int ($FPM $Ref) $Perm)
(declare-const $fvfTOP_int $FVF<Int>)
; /field_value_functions_declarations.smt2 [option$array$: option[array]]
(declare-fun $FVF.domain_option$array$ ($FVF<option<array>>) Set<$Ref>)
(declare-fun $FVF.lookup_option$array$ ($FVF<option<array>> $Ref) option<array>)
(declare-fun $FVF.after_option$array$ ($FVF<option<array>> $FVF<option<array>>) Bool)
(declare-fun $FVF.loc_option$array$ (option<array> $Ref) Bool)
(declare-fun $FVF.perm_option$array$ ($FPM $Ref) $Perm)
(declare-const $fvfTOP_option$array$ $FVF<option<array>>)
; /field_value_functions_declarations.smt2 [bool: Bool]
(declare-fun $FVF.domain_bool ($FVF<Bool>) Set<$Ref>)
(declare-fun $FVF.lookup_bool ($FVF<Bool> $Ref) Bool)
(declare-fun $FVF.after_bool ($FVF<Bool> $FVF<Bool>) Bool)
(declare-fun $FVF.loc_bool (Bool $Ref) Bool)
(declare-fun $FVF.perm_bool ($FPM $Ref) $Perm)
(declare-const $fvfTOP_bool $FVF<Bool>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun aloc ($Snap array Int) $Ref)
(declare-fun aloc%limited ($Snap array Int) $Ref)
(declare-fun aloc%stateless (array Int) Bool)
(declare-fun opt_get1 ($Snap option<array>) array)
(declare-fun opt_get1%limited ($Snap option<array>) array)
(declare-fun opt_get1%stateless (option<array>) Bool)
(declare-fun any_as ($Snap any) any)
(declare-fun any_as%limited ($Snap any) any)
(declare-fun any_as%stateless (any) Bool)
(declare-fun opt_get ($Snap option<any>) any)
(declare-fun opt_get%limited ($Snap option<any>) any)
(declare-fun opt_get%stateless (option<any>) Bool)
(declare-fun lemma_skew_symetry ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_skew_symetry%limited ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_skew_symetry%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun FlowNetwork ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun FlowNetwork%limited ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun FlowNetwork%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun ExPath ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun ExPath%limited ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun ExPath%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun value ($Snap $Ref option<array> Int Int Int) Int)
(declare-fun value%limited ($Snap $Ref option<array> Int Int Int) Int)
(declare-fun value%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun valid_graph_vertices ($Snap $Ref option<array> Int) Bool)
(declare-fun valid_graph_vertices%limited ($Snap $Ref option<array> Int) Bool)
(declare-fun valid_graph_vertices%stateless ($Ref option<array> Int) Bool)
(declare-fun scale ($Snap $Perm) $Perm)
(declare-fun scale%limited ($Snap $Perm) $Perm)
(declare-fun scale%stateless ($Perm) Bool)
(declare-fun as_any ($Snap any) any)
(declare-fun as_any%limited ($Snap any) any)
(declare-fun as_any%stateless (any) Bool)
(declare-fun ResidualNetwork ($Snap $Ref option<array> Int) Bool)
(declare-fun ResidualNetwork%limited ($Snap $Ref option<array> Int) Bool)
(declare-fun ResidualNetwork%stateless ($Ref option<array> Int) Bool)
(declare-fun type ($Snap $Ref) Int)
(declare-fun type%limited ($Snap $Ref) Int)
(declare-fun type%stateless ($Ref) Bool)
(declare-fun lemma_max_flow_min_cut ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_max_flow_min_cut%limited ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_max_flow_min_cut%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun lemma_capacity_constrain ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_capacity_constrain%limited ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_capacity_constrain%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun opt_or_else ($Snap option<any> any) any)
(declare-fun opt_or_else%limited ($Snap option<any> any) any)
(declare-fun opt_or_else%stateless (option<any> any) Bool)
(declare-fun valid_graph_vertices1 ($Snap $Ref Seq<Int> Int) Bool)
(declare-fun valid_graph_vertices1%limited ($Snap $Ref Seq<Int> Int) Bool)
(declare-fun valid_graph_vertices1%stateless ($Ref Seq<Int> Int) Bool)
(declare-fun flow ($Snap $Ref option<array> Int Int Int) Int)
(declare-fun flow%limited ($Snap $Ref option<array> Int Int Int) Int)
(declare-fun flow%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun lemma_flow_conservation ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_flow_conservation%limited ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun lemma_flow_conservation%stateless ($Ref option<array> Int Int Int) Bool)
(declare-fun subtype ($Snap Int Int) Bool)
(declare-fun subtype%limited ($Snap Int Int) Bool)
(declare-fun subtype%stateless (Int Int) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun lock_inv_FordFulkerson%trigger ($Snap $Ref) Bool)
(declare-fun lock_held_FordFulkerson%trigger ($Snap $Ref) Bool)
(declare-fun lock_inv_Object%trigger ($Snap $Ref) Bool)
(declare-fun lock_held_Object%trigger ($Snap $Ref) Bool)
; ////////// Uniqueness assumptions from domains
; ////////// Axioms
(assert (forall ((s Seq<Int>)) (!
  (<= 0 (Seq_length s))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.seq_length_non_negative|)))
(assert (= (Seq_length (as Seq_empty  Seq<Int>)) 0))
(assert (forall ((s Seq<Int>)) (!
  (implies (= (Seq_length s) 0) (= s (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.only_empty_seq_length_zero|)))
(assert (forall ((e Int)) (!
  (= (Seq_length (Seq_singleton e)) 1)
  :pattern ((Seq_length (Seq_singleton e)))
  :qid |$Seq[Int]_prog.length_singleton_seq|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (= (Seq_length (Seq_build s e)) (+ 1 (Seq_length s)))
  :pattern ((Seq_length (Seq_build s e)))
  :qid |$Seq[Int]_prog.length_seq_build_inc_by_one|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (ite
    (= i (Seq_length s))
    (= (Seq_index (Seq_build s e) i) e)
    (= (Seq_index (Seq_build s e) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_build s e) i))
  :qid |$Seq[Int]_prog.seq_index_over_build|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (= (Seq_length (Seq_append s1 s2)) (+ (Seq_length s1) (Seq_length s2))))
  :pattern ((Seq_length (Seq_append s1 s2)))
  :qid |$Seq[Int]_prog.seq_length_over_append|)))
(assert (forall ((e Int)) (!
  (= (Seq_index (Seq_singleton e) 0) e)
  :pattern ((Seq_index (Seq_singleton e) 0))
  :qid |$Seq[Int]_prog.seq_index_over_singleton|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_singleton e1) e2) (= e1 e2))
  :pattern ((Seq_contains (Seq_singleton e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_singleton|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append (as Seq_empty  Seq<Int>) s) s)
  :pattern ((Seq_append (as Seq_empty  Seq<Int>) s))
  :qid |$Seq[Int]_prog.seq_append_empty_left|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append s (as Seq_empty  Seq<Int>)) s)
  :pattern ((Seq_append s (as Seq_empty  Seq<Int>)))
  :qid |$Seq[Int]_prog.seq_append_empty_right|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (i Int)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (ite
      (< i (Seq_length s1))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s1 i))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s2 (- i (Seq_length s1))))))
  :pattern ((Seq_index (Seq_append s1 s2) i))
  :pattern ((Seq_index s1 i) (Seq_append s1 s2))
  :qid |$Seq[Int]_prog.seq_index_over_append|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (implies
    (and (<= 0 i) (< i (Seq_length s)))
    (= (Seq_length (Seq_update s i e)) (Seq_length s)))
  :pattern ((Seq_length (Seq_update s i e)))
  :qid |$Seq[Int]_prog.seq_length_invariant_over_update|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (j Int)) (!
  (ite
    (implies (and (<= 0 i) (< i (Seq_length s))) (= i j))
    (= (Seq_index (Seq_update s i e) j) e)
    (= (Seq_index (Seq_update s i e) j) (Seq_index s j)))
  :pattern ((Seq_index (Seq_update s i e) j))
  :qid |$Seq[Int]_prog.seq_index_over_update|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (=
    (Seq_contains s e)
    (exists ((i Int)) (!
      (and (<= 0 i) (and (< i (Seq_length s)) (= (Seq_index s i) e)))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains s e))
  :qid |$Seq[Int]_prog.seq_element_contains_index_exists|)))
(assert (forall ((e Int)) (!
  (not (Seq_contains (as Seq_empty  Seq<Int>) e))
  :pattern ((Seq_contains (as Seq_empty  Seq<Int>) e))
  :qid |$Seq[Int]_prog.empty_seq_contains_nothing|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (e Int)) (!
  (=
    (Seq_contains (Seq_append s1 s2) e)
    (or (Seq_contains s1 e) (Seq_contains s2 e)))
  :pattern ((Seq_contains (Seq_append s1 s2) e))
  :qid |$Seq[Int]_prog.seq_contains_over_append|)))
(assert (forall ((s Seq<Int>) (e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_build s e1) e2) (or (= e1 e2) (Seq_contains s e2)))
  :pattern ((Seq_contains (Seq_build s e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_build|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_take s n) (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_take s n))
  :qid |$Seq[Int]_prog.seq_take_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_take s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (< i n) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_take s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_take_index_exists|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_drop s n) s))
  :pattern ((Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_drop_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_drop s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (<= n i) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_drop s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_drop_index_exists|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (=
    (Seq_equal s1 s2)
    (and
      (= (Seq_length s1) (Seq_length s2))
      (forall ((i Int)) (!
        (implies
          (and (<= 0 i) (< i (Seq_length s1)))
          (= (Seq_index s1 i) (Seq_index s2 i)))
        :pattern ((Seq_index s1 i))
        :pattern ((Seq_index s2 i))
        ))))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.extensional_seq_equality|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies (Seq_equal s1 s2) (= s1 s2))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.seq_equality_identity|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (n Int)) (!
  (=
    (Seq_sameuntil s1 s2 n)
    (forall ((i Int)) (!
      (implies (and (<= 0 i) (< i n)) (= (Seq_index s1 i) (Seq_index s2 i)))
      :pattern ((Seq_index s1 i))
      :pattern ((Seq_index s2 i))
      )))
  :pattern ((Seq_sameuntil s1 s2 n))
  :qid |$Seq[Int]_prog.extensional_seq_equality_prefix|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_take s n)) n)
      (= (Seq_length (Seq_take s n)) (Seq_length s))))
  :pattern ((Seq_length (Seq_take s n)))
  :qid |$Seq[Int]_prog.seq_length_over_take|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< i (Seq_length s))))
    (= (Seq_index (Seq_take s n) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_take s n) i))
  :pattern ((Seq_index s i) (Seq_take s n))
  :qid |$Seq[Int]_prog.seq_index_over_take|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_drop s n)) (- (Seq_length s) n))
      (= (Seq_length (Seq_drop s n)) 0)))
  :pattern ((Seq_length (Seq_drop s n)))
  :qid |$Seq[Int]_prog.seq_length_over_drop|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= 0 i) (< i (- (Seq_length s) n))))
    (= (Seq_index (Seq_drop s n) i) (Seq_index s (+ i n))))
  :pattern ((Seq_index (Seq_drop s n) i))
  :qid |$Seq[Int]_prog.seq_index_over_drop_1|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_index (Seq_drop s n) (- i n)) (Seq_index s i)))
  :pattern ((Seq_index s i) (Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_index_over_drop_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_take (Seq_update s i e) n) (Seq_update (Seq_take s n) i e)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= n i) (< i (Seq_length s)))
    (= (Seq_take (Seq_update s i e) n) (Seq_take s n)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_update (Seq_drop s n) (- i n) e)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_drop s n)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_2|)))
(assert (forall ((s Seq<Int>) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (<= n (Seq_length s)))
    (= (Seq_drop (Seq_build s e) n) (Seq_build (Seq_drop s n) e)))
  :pattern ((Seq_drop (Seq_build s e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_build|)))
(assert (forall ((min_ Int) (max Int)) (!
  (ite
    (< min_ max)
    (= (Seq_length (Seq_range min_ max)) (- max min_))
    (= (Seq_length (Seq_range min_ max)) 0))
  :pattern ((Seq_length (Seq_range min_ max)))
  :qid |$Seq[Int]_prog.ranged_seq_length|)))
(assert (forall ((min_ Int) (max Int) (i Int)) (!
  (implies
    (and (<= 0 i) (< i (- max min_)))
    (= (Seq_index (Seq_range min_ max) i) (+ min_ i)))
  :pattern ((Seq_index (Seq_range min_ max) i))
  :qid |$Seq[Int]_prog.ranged_seq_index|)))
(assert (forall ((min_ Int) (max Int) (e Int)) (!
  (= (Seq_contains (Seq_range min_ max) e) (and (<= min_ e) (< e max)))
  :pattern ((Seq_contains (Seq_range min_ max) e))
  :qid |$Seq[Int]_prog.ranged_seq_contains|)))
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
(assert (forall ((s Set<Bool>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.card_non_negative|)))
(assert (forall ((e Bool)) (!
  (not (Set_in e (as Set_empty  Set<Bool>)))
  :pattern ((Set_in e (as Set_empty  Set<Bool>)))
  :qid |$Set[Bool]_prog.in_empty_set|)))
(assert (forall ((s Set<Bool>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Bool>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Bool)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.empty_set_cardinality|)))
(assert (forall ((e Bool)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Bool]_prog.in_singleton_set|)))
(assert (forall ((e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Bool]_prog.in_singleton_set_equality|)))
(assert (forall ((e Bool)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Bool]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Bool]_prog.in_unionone_same|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Bool]_prog.in_unionone_other|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Bool]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Bool]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Bool]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Bool]_prog.in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Bool)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Bool]_prog.subset_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Bool)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.equality_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.native_equality|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Bool)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Bool]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
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
  :qid |$Set[Bool]_prog.cardinality_difference|)))
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
(assert (forall ((v void)) (!
  (= (as unit<void>  void) v)
  
  )))
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
; /field_value_functions_axioms.smt2 [bool: Bool]
(assert (forall ((vs $FVF<Bool>) (ws $FVF<Bool>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_bool vs) ($FVF.domain_bool ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_bool vs))
            (= ($FVF.lookup_bool vs x) ($FVF.lookup_bool ws x)))
          :pattern (($FVF.lookup_bool vs x) ($FVF.lookup_bool ws x))
          :qid |qp.$FVF<Bool>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Bool>To$Snap vs)
              ($SortWrappers.$FVF<Bool>To$Snap ws)
              )
    :qid |qp.$FVF<Bool>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_bool pm r))
    :pattern ($FVF.perm_bool pm r))))
(assert (forall ((r $Ref) (f Bool)) (!
    (= ($FVF.loc_bool f r) true)
    :pattern ($FVF.loc_bool f r))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
(declare-fun $k@85@00 () $Perm)
(declare-fun inv@86@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun sm@87@00 ($Snap $Ref option<array> Int) $FVF<Int>)
(assert (forall ((s@$ $Snap) (a2@0@00 array) (i1@1@00 Int)) (!
  (= (aloc%limited s@$ a2@0@00 i1@1@00) (aloc s@$ a2@0@00 i1@1@00))
  :pattern ((aloc s@$ a2@0@00 i1@1@00))
  )))
(assert (forall ((s@$ $Snap) (a2@0@00 array) (i1@1@00 Int)) (!
  (aloc%stateless a2@0@00 i1@1@00)
  :pattern ((aloc%limited s@$ a2@0@00 i1@1@00))
  )))
(assert (forall ((s@$ $Snap) (a2@0@00 array) (i1@1@00 Int)) (!
  (let ((result@2@00 (aloc%limited s@$ a2@0@00 i1@1@00))) (implies
    (and (<= 0 i1@1@00) (< i1@1@00 (alen<Int> a2@0@00)))
    (and
      (= (loc_inv_1<array> result@2@00) a2@0@00)
      (= (loc_inv_2<Int> result@2@00) i1@1@00))))
  :pattern ((aloc%limited s@$ a2@0@00 i1@1@00))
  )))
(assert (forall ((s@$ $Snap) (a2@0@00 array) (i1@1@00 Int)) (!
  (implies
    (and (<= 0 i1@1@00) (< i1@1@00 (alen<Int> a2@0@00)))
    (= (aloc s@$ a2@0@00 i1@1@00) (array_loc<Ref> a2@0@00 i1@1@00)))
  :pattern ((aloc s@$ a2@0@00 i1@1@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@3@00 option<array>)) (!
  (= (opt_get1%limited s@$ opt1@3@00) (opt_get1 s@$ opt1@3@00))
  :pattern ((opt_get1 s@$ opt1@3@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@3@00 option<array>)) (!
  (opt_get1%stateless opt1@3@00)
  :pattern ((opt_get1%limited s@$ opt1@3@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@3@00 option<array>)) (!
  (let ((result@4@00 (opt_get1%limited s@$ opt1@3@00))) (implies
    (not (= opt1@3@00 (as None<option<array>>  option<array>)))
    (= (some<option<array>> result@4@00) opt1@3@00)))
  :pattern ((opt_get1%limited s@$ opt1@3@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@3@00 option<array>)) (!
  (implies
    (not (= opt1@3@00 (as None<option<array>>  option<array>)))
    (= (opt_get1 s@$ opt1@3@00) (option_get<array> opt1@3@00)))
  :pattern ((opt_get1 s@$ opt1@3@00))
  )))
(assert (forall ((s@$ $Snap) (t@5@00 any)) (!
  (= (any_as%limited s@$ t@5@00) (any_as s@$ t@5@00))
  :pattern ((any_as s@$ t@5@00))
  )))
(assert (forall ((s@$ $Snap) (t@5@00 any)) (!
  (any_as%stateless t@5@00)
  :pattern ((any_as%limited s@$ t@5@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@7@00 option<any>)) (!
  (= (opt_get%limited s@$ opt1@7@00) (opt_get s@$ opt1@7@00))
  :pattern ((opt_get s@$ opt1@7@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@7@00 option<any>)) (!
  (opt_get%stateless opt1@7@00)
  :pattern ((opt_get%limited s@$ opt1@7@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@7@00 option<any>)) (!
  (let ((result@8@00 (opt_get%limited s@$ opt1@7@00))) (implies
    (not (= opt1@7@00 (as None<option<any>>  option<any>)))
    (= (some<option<any>> result@8@00) opt1@7@00)))
  :pattern ((opt_get%limited s@$ opt1@7@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@7@00 option<any>)) (!
  (implies
    (not (= opt1@7@00 (as None<option<any>>  option<any>)))
    (= (opt_get s@$ opt1@7@00) (option_get<any> opt1@7@00)))
  :pattern ((opt_get s@$ opt1@7@00))
  )))
(assert (forall ((s@$ $Snap) (this@9@00 $Ref) (G@10@00 option<array>) (V@11@00 Int) (s@12@00 Int) (t@13@00 Int)) (!
  (=
    (lemma_skew_symetry%limited s@$ this@9@00 G@10@00 V@11@00 s@12@00 t@13@00)
    (lemma_skew_symetry s@$ this@9@00 G@10@00 V@11@00 s@12@00 t@13@00))
  :pattern ((lemma_skew_symetry s@$ this@9@00 G@10@00 V@11@00 s@12@00 t@13@00))
  )))
(assert (forall ((s@$ $Snap) (this@9@00 $Ref) (G@10@00 option<array>) (V@11@00 Int) (s@12@00 Int) (t@13@00 Int)) (!
  (lemma_skew_symetry%stateless this@9@00 G@10@00 V@11@00 s@12@00 t@13@00)
  :pattern ((lemma_skew_symetry%limited s@$ this@9@00 G@10@00 V@11@00 s@12@00 t@13@00))
  )))
(assert (forall ((s@$ $Snap) (this@9@00 $Ref) (G@10@00 option<array>) (V@11@00 Int) (s@12@00 Int) (t@13@00 Int)) (!
  (implies
    (not (= this@9@00 $Ref.null))
    (= (lemma_skew_symetry s@$ this@9@00 G@10@00 V@11@00 s@12@00 t@13@00) false))
  :pattern ((lemma_skew_symetry s@$ this@9@00 G@10@00 V@11@00 s@12@00 t@13@00))
  )))
(assert (forall ((s@$ $Snap) (this@15@00 $Ref) (G@16@00 option<array>) (V@17@00 Int) (s@18@00 Int) (t@19@00 Int)) (!
  (=
    (FlowNetwork%limited s@$ this@15@00 G@16@00 V@17@00 s@18@00 t@19@00)
    (FlowNetwork s@$ this@15@00 G@16@00 V@17@00 s@18@00 t@19@00))
  :pattern ((FlowNetwork s@$ this@15@00 G@16@00 V@17@00 s@18@00 t@19@00))
  )))
(assert (forall ((s@$ $Snap) (this@15@00 $Ref) (G@16@00 option<array>) (V@17@00 Int) (s@18@00 Int) (t@19@00 Int)) (!
  (FlowNetwork%stateless this@15@00 G@16@00 V@17@00 s@18@00 t@19@00)
  :pattern ((FlowNetwork%limited s@$ this@15@00 G@16@00 V@17@00 s@18@00 t@19@00))
  )))
(assert (forall ((s@$ $Snap) (this@15@00 $Ref) (G@16@00 option<array>) (V@17@00 Int) (s@18@00 Int) (t@19@00 Int)) (!
  (implies
    (not (= this@15@00 $Ref.null))
    (=
      (FlowNetwork s@$ this@15@00 G@16@00 V@17@00 s@18@00 t@19@00)
      (and (and (< 0 V@17@00) (= s@18@00 0)) (not (= s@18@00 t@19@00)))))
  :pattern ((FlowNetwork s@$ this@15@00 G@16@00 V@17@00 s@18@00 t@19@00))
  )))
(assert (forall ((s@$ $Snap) (this@21@00 $Ref) (G@22@00 option<array>) (V@23@00 Int) (s@24@00 Int) (t@25@00 Int)) (!
  (=
    (ExPath%limited s@$ this@21@00 G@22@00 V@23@00 s@24@00 t@25@00)
    (ExPath s@$ this@21@00 G@22@00 V@23@00 s@24@00 t@25@00))
  :pattern ((ExPath s@$ this@21@00 G@22@00 V@23@00 s@24@00 t@25@00))
  )))
(assert (forall ((s@$ $Snap) (this@21@00 $Ref) (G@22@00 option<array>) (V@23@00 Int) (s@24@00 Int) (t@25@00 Int)) (!
  (ExPath%stateless this@21@00 G@22@00 V@23@00 s@24@00 t@25@00)
  :pattern ((ExPath%limited s@$ this@21@00 G@22@00 V@23@00 s@24@00 t@25@00))
  )))
(assert (forall ((s@$ $Snap) (this@21@00 $Ref) (G@22@00 option<array>) (V@23@00 Int) (s@24@00 Int) (t@25@00 Int)) (!
  (implies
    (not (= this@21@00 $Ref.null))
    (= (ExPath s@$ this@21@00 G@22@00 V@23@00 s@24@00 t@25@00) false))
  :pattern ((ExPath s@$ this@21@00 G@22@00 V@23@00 s@24@00 t@25@00))
  )))
(assert (forall ((s@$ $Snap) (this@27@00 $Ref) (G@28@00 option<array>) (V@29@00 Int) (s@30@00 Int) (t@31@00 Int)) (!
  (=
    (value%limited s@$ this@27@00 G@28@00 V@29@00 s@30@00 t@31@00)
    (value s@$ this@27@00 G@28@00 V@29@00 s@30@00 t@31@00))
  :pattern ((value s@$ this@27@00 G@28@00 V@29@00 s@30@00 t@31@00))
  )))
(assert (forall ((s@$ $Snap) (this@27@00 $Ref) (G@28@00 option<array>) (V@29@00 Int) (s@30@00 Int) (t@31@00 Int)) (!
  (value%stateless this@27@00 G@28@00 V@29@00 s@30@00 t@31@00)
  :pattern ((value%limited s@$ this@27@00 G@28@00 V@29@00 s@30@00 t@31@00))
  )))
(assert (forall ((s@$ $Snap) (this@27@00 $Ref) (G@28@00 option<array>) (V@29@00 Int) (s@30@00 Int) (t@31@00 Int)) (!
  (implies
    (not (= this@27@00 $Ref.null))
    (= (value s@$ this@27@00 G@28@00 V@29@00 s@30@00 t@31@00) 0))
  :pattern ((value s@$ this@27@00 G@28@00 V@29@00 s@30@00 t@31@00))
  )))
(assert (forall ((s@$ $Snap) (this@33@00 $Ref) (p@34@00 option<array>) (V@35@00 Int)) (!
  (=
    (valid_graph_vertices%limited s@$ this@33@00 p@34@00 V@35@00)
    (valid_graph_vertices s@$ this@33@00 p@34@00 V@35@00))
  :pattern ((valid_graph_vertices s@$ this@33@00 p@34@00 V@35@00))
  )))
(assert (forall ((s@$ $Snap) (this@33@00 $Ref) (p@34@00 option<array>) (V@35@00 Int)) (!
  (valid_graph_vertices%stateless this@33@00 p@34@00 V@35@00)
  :pattern ((valid_graph_vertices%limited s@$ this@33@00 p@34@00 V@35@00))
  )))
(assert (forall ((s@$ $Snap) (this@33@00 $Ref) (p@34@00 option<array>) (V@35@00 Int)) (!
  (and
    (forall ((i1@84@00 Int)) (!
      (implies
        (and (and (< i1@84@00 V@35@00) (<= 0 i1@84@00)) (< $Perm.No $k@85@00))
        (=
          (inv@86@00 s@$ this@33@00 p@34@00 V@35@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@34@00) i1@84@00))
          i1@84@00))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@34@00) i1@84@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (< (inv@86@00 s@$ this@33@00 p@34@00 V@35@00 r) V@35@00)
            (<= 0 (inv@86@00 s@$ this@33@00 p@34@00 V@35@00 r)))
          (< $Perm.No $k@85@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@34@00) (inv@86@00 s@$ this@33@00 p@34@00 V@35@00 r))
          r))
      :pattern ((inv@86@00 s@$ this@33@00 p@34@00 V@35@00 r))
      :qid |int-fctOfInv|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (< (inv@86@00 s@$ this@33@00 p@34@00 V@35@00 r) V@35@00)
            (<= 0 (inv@86@00 s@$ this@33@00 p@34@00 V@35@00 r)))
          (< $Perm.No $k@85@00)
          false)
        (=
          ($FVF.lookup_int (sm@87@00 s@$ this@33@00 p@34@00 V@35@00) r)
          ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r)))
      :pattern (($FVF.lookup_int (sm@87@00 s@$ this@33@00 p@34@00 V@35@00) r))
      :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r))
      :qid |qp.fvfValDef0|))
    (forall ((r $Ref)) (!
      ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r) r)
      :pattern (($FVF.lookup_int (sm@87@00 s@$ this@33@00 p@34@00 V@35@00) r))
      :qid |qp.fvfResTrgDef1|))
    ($Perm.isReadVar $k@85@00 $Perm.Write)
    (implies
      (and
        (not (= this@33@00 $Ref.null))
        (not (= p@34@00 (as None<option<array>>  option<array>)))
        (= (alen<Int> (opt_get1 $Snap.unit p@34@00)) V@35@00))
      (=
        (valid_graph_vertices s@$ this@33@00 p@34@00 V@35@00)
        (and
          (forall ((unknown_ Int)) (!
            (implies
              (and
                (<= 0 unknown_)
                (< unknown_ (alen<Int> (opt_get1 $Snap.unit p@34@00))))
              (<=
                0
                ($FVF.lookup_int (sm@87@00 s@$ this@33@00 p@34@00 V@35@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit p@34@00) unknown_))))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@34@00) unknown_))
            ))
          (forall ((unknown_ Int)) (!
            (implies
              (and
                (<= 0 unknown_)
                (< unknown_ (alen<Int> (opt_get1 $Snap.unit p@34@00))))
              (<
                ($FVF.lookup_int (sm@87@00 s@$ this@33@00 p@34@00 V@35@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit p@34@00) unknown_))
                V@35@00))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@34@00) unknown_))
            ))))))
  :pattern ((valid_graph_vertices s@$ this@33@00 p@34@00 V@35@00))
  )))
(assert (forall ((s@$ $Snap) (amount@37@00 $Perm)) (!
  (= (scale%limited s@$ amount@37@00) (scale s@$ amount@37@00))
  :pattern ((scale s@$ amount@37@00))
  )))
(assert (forall ((s@$ $Snap) (amount@37@00 $Perm)) (!
  (scale%stateless amount@37@00)
  :pattern ((scale%limited s@$ amount@37@00))
  )))
(assert (forall ((s@$ $Snap) (amount@37@00 $Perm)) (!
  (implies (>= amount@37@00 $Perm.No) (= (scale s@$ amount@37@00) amount@37@00))
  :pattern ((scale s@$ amount@37@00))
  )))
(assert (forall ((s@$ $Snap) (t@39@00 any)) (!
  (= (as_any%limited s@$ t@39@00) (as_any s@$ t@39@00))
  :pattern ((as_any s@$ t@39@00))
  )))
(assert (forall ((s@$ $Snap) (t@39@00 any)) (!
  (as_any%stateless t@39@00)
  :pattern ((as_any%limited s@$ t@39@00))
  )))
(assert (forall ((s@$ $Snap) (t@39@00 any)) (!
  (let ((result@40@00 (as_any%limited s@$ t@39@00))) (=
    (any_as $Snap.unit result@40@00)
    t@39@00))
  :pattern ((as_any%limited s@$ t@39@00))
  )))
(assert (forall ((s@$ $Snap) (this@41@00 $Ref) (G@42@00 option<array>) (V@43@00 Int)) (!
  (=
    (ResidualNetwork%limited s@$ this@41@00 G@42@00 V@43@00)
    (ResidualNetwork s@$ this@41@00 G@42@00 V@43@00))
  :pattern ((ResidualNetwork s@$ this@41@00 G@42@00 V@43@00))
  )))
(assert (forall ((s@$ $Snap) (this@41@00 $Ref) (G@42@00 option<array>) (V@43@00 Int)) (!
  (ResidualNetwork%stateless this@41@00 G@42@00 V@43@00)
  :pattern ((ResidualNetwork%limited s@$ this@41@00 G@42@00 V@43@00))
  )))
(assert (forall ((s@$ $Snap) (this@41@00 $Ref) (G@42@00 option<array>) (V@43@00 Int)) (!
  (implies
    (not (= this@41@00 $Ref.null))
    (= (ResidualNetwork s@$ this@41@00 G@42@00 V@43@00) false))
  :pattern ((ResidualNetwork s@$ this@41@00 G@42@00 V@43@00))
  )))
(assert (forall ((s@$ $Snap) (type1@45@00 $Ref)) (!
  (= (type%limited s@$ type1@45@00) (type s@$ type1@45@00))
  :pattern ((type s@$ type1@45@00))
  )))
(assert (forall ((s@$ $Snap) (type1@45@00 $Ref)) (!
  (type%stateless type1@45@00)
  :pattern ((type%limited s@$ type1@45@00))
  )))
(assert (forall ((s@$ $Snap) (type1@45@00 $Ref)) (!
  (let ((result@46@00 (type%limited s@$ type1@45@00))) (and
    (<= 0 result@46@00)
    (< result@46@00 3)
    (implies (= type1@45@00 $Ref.null) (= result@46@00 0))
    (implies (not (= type1@45@00 $Ref.null)) (not (= result@46@00 0)))))
  :pattern ((type%limited s@$ type1@45@00))
  )))
(assert (forall ((s@$ $Snap) (this@47@00 $Ref) (G@48@00 option<array>) (V@49@00 Int) (s@50@00 Int) (t@51@00 Int)) (!
  (=
    (lemma_max_flow_min_cut%limited s@$ this@47@00 G@48@00 V@49@00 s@50@00 t@51@00)
    (lemma_max_flow_min_cut s@$ this@47@00 G@48@00 V@49@00 s@50@00 t@51@00))
  :pattern ((lemma_max_flow_min_cut s@$ this@47@00 G@48@00 V@49@00 s@50@00 t@51@00))
  )))
(assert (forall ((s@$ $Snap) (this@47@00 $Ref) (G@48@00 option<array>) (V@49@00 Int) (s@50@00 Int) (t@51@00 Int)) (!
  (lemma_max_flow_min_cut%stateless this@47@00 G@48@00 V@49@00 s@50@00 t@51@00)
  :pattern ((lemma_max_flow_min_cut%limited s@$ this@47@00 G@48@00 V@49@00 s@50@00 t@51@00))
  )))
(assert (forall ((s@$ $Snap) (this@47@00 $Ref) (G@48@00 option<array>) (V@49@00 Int) (s@50@00 Int) (t@51@00 Int)) (!
  (implies
    (not (= this@47@00 $Ref.null))
    (=
      (lemma_max_flow_min_cut s@$ this@47@00 G@48@00 V@49@00 s@50@00 t@51@00)
      false))
  :pattern ((lemma_max_flow_min_cut s@$ this@47@00 G@48@00 V@49@00 s@50@00 t@51@00))
  )))
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 option<array>) (V@55@00 Int) (s@56@00 Int) (t@57@00 Int)) (!
  (=
    (lemma_capacity_constrain%limited s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00)
    (lemma_capacity_constrain s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  :pattern ((lemma_capacity_constrain s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  )))
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 option<array>) (V@55@00 Int) (s@56@00 Int) (t@57@00 Int)) (!
  (lemma_capacity_constrain%stateless this@53@00 G@54@00 V@55@00 s@56@00 t@57@00)
  :pattern ((lemma_capacity_constrain%limited s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  )))
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 option<array>) (V@55@00 Int) (s@56@00 Int) (t@57@00 Int)) (!
  (implies
    (not (= this@53@00 $Ref.null))
    (=
      (lemma_capacity_constrain s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00)
      false))
  :pattern ((lemma_capacity_constrain s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@59@00 option<any>) (alt@60@00 any)) (!
  (=
    (opt_or_else%limited s@$ opt1@59@00 alt@60@00)
    (opt_or_else s@$ opt1@59@00 alt@60@00))
  :pattern ((opt_or_else s@$ opt1@59@00 alt@60@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@59@00 option<any>) (alt@60@00 any)) (!
  (opt_or_else%stateless opt1@59@00 alt@60@00)
  :pattern ((opt_or_else%limited s@$ opt1@59@00 alt@60@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@59@00 option<any>) (alt@60@00 any)) (!
  (let ((result@61@00 (opt_or_else%limited s@$ opt1@59@00 alt@60@00))) (and
    (implies
      (= opt1@59@00 (as None<option<any>>  option<any>))
      (= result@61@00 alt@60@00))
    (implies
      (not (= opt1@59@00 (as None<option<any>>  option<any>)))
      (= result@61@00 (opt_get $Snap.unit opt1@59@00)))))
  :pattern ((opt_or_else%limited s@$ opt1@59@00 alt@60@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@59@00 option<any>) (alt@60@00 any)) (!
  (=
    (opt_or_else s@$ opt1@59@00 alt@60@00)
    (ite
      (= opt1@59@00 (as None<option<any>>  option<any>))
      alt@60@00
      (opt_get $Snap.unit opt1@59@00)))
  :pattern ((opt_or_else s@$ opt1@59@00 alt@60@00))
  )))
(assert (forall ((s@$ $Snap) (this@62@00 $Ref) (p@63@00 Seq<Int>) (V@64@00 Int)) (!
  (=
    (valid_graph_vertices1%limited s@$ this@62@00 p@63@00 V@64@00)
    (valid_graph_vertices1 s@$ this@62@00 p@63@00 V@64@00))
  :pattern ((valid_graph_vertices1 s@$ this@62@00 p@63@00 V@64@00))
  )))
(assert (forall ((s@$ $Snap) (this@62@00 $Ref) (p@63@00 Seq<Int>) (V@64@00 Int)) (!
  (valid_graph_vertices1%stateless this@62@00 p@63@00 V@64@00)
  :pattern ((valid_graph_vertices1%limited s@$ this@62@00 p@63@00 V@64@00))
  )))
(assert (forall ((s@$ $Snap) (this@62@00 $Ref) (p@63@00 Seq<Int>) (V@64@00 Int)) (!
  (implies
    (not (= this@62@00 $Ref.null))
    (=
      (valid_graph_vertices1 s@$ this@62@00 p@63@00 V@64@00)
      (and
        (forall ((unknown_ Int)) (!
          (implies
            (and (<= 0 unknown_) (< unknown_ (Seq_length p@63@00)))
            (<= 0 (Seq_index p@63@00 unknown_)))
          :pattern ((Seq_index p@63@00 unknown_))
          ))
        (forall ((unknown_ Int)) (!
          (implies
            (and (<= 0 unknown_) (< unknown_ (Seq_length p@63@00)))
            (< (Seq_index p@63@00 unknown_) V@64@00))
          :pattern ((Seq_index p@63@00 unknown_))
          )))))
  :pattern ((valid_graph_vertices1 s@$ this@62@00 p@63@00 V@64@00))
  )))
(assert (forall ((s@$ $Snap) (this@66@00 $Ref) (G@67@00 option<array>) (V@68@00 Int) (s@69@00 Int) (t@70@00 Int)) (!
  (=
    (flow%limited s@$ this@66@00 G@67@00 V@68@00 s@69@00 t@70@00)
    (flow s@$ this@66@00 G@67@00 V@68@00 s@69@00 t@70@00))
  :pattern ((flow s@$ this@66@00 G@67@00 V@68@00 s@69@00 t@70@00))
  )))
(assert (forall ((s@$ $Snap) (this@66@00 $Ref) (G@67@00 option<array>) (V@68@00 Int) (s@69@00 Int) (t@70@00 Int)) (!
  (flow%stateless this@66@00 G@67@00 V@68@00 s@69@00 t@70@00)
  :pattern ((flow%limited s@$ this@66@00 G@67@00 V@68@00 s@69@00 t@70@00))
  )))
(assert (forall ((s@$ $Snap) (this@66@00 $Ref) (G@67@00 option<array>) (V@68@00 Int) (s@69@00 Int) (t@70@00 Int)) (!
  (implies
    (not (= this@66@00 $Ref.null))
    (= (flow s@$ this@66@00 G@67@00 V@68@00 s@69@00 t@70@00) 0))
  :pattern ((flow s@$ this@66@00 G@67@00 V@68@00 s@69@00 t@70@00))
  )))
(assert (forall ((s@$ $Snap) (this@72@00 $Ref) (G@73@00 option<array>) (V@74@00 Int) (s@75@00 Int) (t@76@00 Int)) (!
  (=
    (lemma_flow_conservation%limited s@$ this@72@00 G@73@00 V@74@00 s@75@00 t@76@00)
    (lemma_flow_conservation s@$ this@72@00 G@73@00 V@74@00 s@75@00 t@76@00))
  :pattern ((lemma_flow_conservation s@$ this@72@00 G@73@00 V@74@00 s@75@00 t@76@00))
  )))
(assert (forall ((s@$ $Snap) (this@72@00 $Ref) (G@73@00 option<array>) (V@74@00 Int) (s@75@00 Int) (t@76@00 Int)) (!
  (lemma_flow_conservation%stateless this@72@00 G@73@00 V@74@00 s@75@00 t@76@00)
  :pattern ((lemma_flow_conservation%limited s@$ this@72@00 G@73@00 V@74@00 s@75@00 t@76@00))
  )))
(assert (forall ((s@$ $Snap) (this@72@00 $Ref) (G@73@00 option<array>) (V@74@00 Int) (s@75@00 Int) (t@76@00 Int)) (!
  (implies
    (not (= this@72@00 $Ref.null))
    (=
      (lemma_flow_conservation s@$ this@72@00 G@73@00 V@74@00 s@75@00 t@76@00)
      false))
  :pattern ((lemma_flow_conservation s@$ this@72@00 G@73@00 V@74@00 s@75@00 t@76@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@78@00 Int) (subtype2@79@00 Int)) (!
  (=
    (subtype%limited s@$ subtype1@78@00 subtype2@79@00)
    (subtype s@$ subtype1@78@00 subtype2@79@00))
  :pattern ((subtype s@$ subtype1@78@00 subtype2@79@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@78@00 Int) (subtype2@79@00 Int)) (!
  (subtype%stateless subtype1@78@00 subtype2@79@00)
  :pattern ((subtype%limited s@$ subtype1@78@00 subtype2@79@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@78@00 Int) (subtype2@79@00 Int)) (!
  (implies
    (and
      (<= 0 subtype1@78@00)
      (< subtype1@78@00 3)
      (<= 0 subtype2@79@00)
      (<= subtype2@79@00 2))
    (=
      (subtype s@$ subtype1@78@00 subtype2@79@00)
      (and
        (implies (= subtype1@78@00 1) (= subtype2@79@00 1))
        (implies (= subtype1@78@00 2) (= subtype2@79@00 2)))))
  :pattern ((subtype s@$ subtype1@78@00 subtype2@79@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- check_unknown1 ----------
(declare-const V@0@02 Int)
(declare-const target@1@02 option<array>)
(declare-const source@2@02 option<array>)
(declare-const i1@3@02 Int)
(declare-const j@4@02 Int)
(declare-const exc@5@02 $Ref)
(declare-const res@6@02 void)
(declare-const V@7@02 Int)
(declare-const target@8@02 option<array>)
(declare-const source@9@02 option<array>)
(declare-const i1@10@02 Int)
(declare-const j@11@02 Int)
(declare-const exc@12@02 $Ref)
(declare-const res@13@02 void)
(push) ; 1
(declare-const $t@14@02 $Snap)
(assert (= $t@14@02 ($Snap.combine ($Snap.first $t@14@02) ($Snap.second $t@14@02))))
(assert (= ($Snap.first $t@14@02) $Snap.unit))
; [eval] 0 < V ==> source != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9
;  :arith-assert-lower      2
;  :arith-assert-upper      1
;  :arith-eq-adapter        1
;  :datatype-accessor-ax    2
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            2
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  3.90
;  :mk-bool-var             302
;  :num-allocs              121757
;  :num-checks              1
;  :quant-instantiations    1
;  :rlimit-count            120240)
(push) ; 3
(assert (not (< 0 V@7@02)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :datatype-accessor-ax    2
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  3.90
;  :mk-bool-var             304
;  :num-allocs              122110
;  :num-checks              2
;  :quant-instantiations    1
;  :rlimit-count            120627)
; [then-branch: 0 | 0 < V@7@02 | live]
; [else-branch: 0 | !(0 < V@7@02) | live]
(push) ; 3
; [then-branch: 0 | 0 < V@7@02]
(assert (< 0 V@7@02))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(0 < V@7@02)]
(assert (not (< 0 V@7@02)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (not (= source@9@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@14@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@14@02))
    ($Snap.second ($Snap.second $t@14@02)))))
(assert (= ($Snap.first ($Snap.second $t@14@02)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(source)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19
;  :arith-assert-lower      3
;  :arith-assert-upper      2
;  :arith-eq-adapter        1
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  3.92
;  :mk-bool-var             309
;  :mk-clause               1
;  :num-allocs              122630
;  :num-checks              3
;  :propagations            1
;  :quant-instantiations    1
;  :rlimit-count            121285)
(push) ; 3
(assert (not (< 0 V@7@02)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        1
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  3.92
;  :mk-bool-var             310
;  :mk-clause               1
;  :num-allocs              122977
;  :num-checks              4
;  :propagations            1
;  :quant-instantiations    1
;  :rlimit-count            121676)
; [then-branch: 1 | 0 < V@7@02 | live]
; [else-branch: 1 | !(0 < V@7@02) | live]
(push) ; 3
; [then-branch: 1 | 0 < V@7@02]
(assert (< 0 V@7@02))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@9@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21
;  :arith-assert-lower      4
;  :arith-assert-upper      3
;  :arith-eq-adapter        1
;  :conflicts               1
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          1
;  :max-memory              4.14
;  :memory                  3.92
;  :mk-bool-var             310
;  :mk-clause               1
;  :num-allocs              123119
;  :num-checks              5
;  :propagations            2
;  :quant-instantiations    1
;  :rlimit-count            121784)
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(0 < V@7@02)]
(assert (not (< 0 V@7@02)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (and
    (< 0 V@7@02)
    (not (= source@9@02 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies (< 0 V@7@02) (= (alen<Int> (opt_get1 $Snap.unit source@9@02)) V@7@02)))
(assert (=
  ($Snap.second ($Snap.second $t@14@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@14@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 2
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               36
;  :arith-assert-lower      7
;  :arith-assert-upper      4
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               1
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   10
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              1
;  :final-checks            10
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.95
;  :mk-bool-var             323
;  :mk-clause               7
;  :num-allocs              123860
;  :num-checks              6
;  :propagations            5
;  :quant-instantiations    6
;  :rlimit-count            122630)
(push) ; 2
(assert (not (< 0 V@7@02)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               40
;  :arith-assert-lower      7
;  :arith-assert-upper      5
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               1
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              1
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.95
;  :mk-bool-var             325
;  :mk-clause               7
;  :num-allocs              124219
;  :num-checks              7
;  :propagations            6
;  :quant-instantiations    6
;  :rlimit-count            123037)
; [then-branch: 2 | 0 < V@7@02 | live]
; [else-branch: 2 | !(0 < V@7@02) | live]
(push) ; 2
; [then-branch: 2 | 0 < V@7@02]
(assert (< 0 V@7@02))
(declare-const i2@15@02 Int)
(push) ; 3
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 4
; [then-branch: 3 | 0 <= i2@15@02 | live]
; [else-branch: 3 | !(0 <= i2@15@02) | live]
(push) ; 5
; [then-branch: 3 | 0 <= i2@15@02]
(assert (<= 0 i2@15@02))
; [eval] i2 < V
(pop) ; 5
(push) ; 5
; [else-branch: 3 | !(0 <= i2@15@02)]
(assert (not (<= 0 i2@15@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i2@15@02 V@7@02) (<= 0 i2@15@02)))
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@9@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46
;  :arith-assert-lower      12
;  :arith-assert-upper      6
;  :arith-eq-adapter        3
;  :arith-fixed-eqs         2
;  :arith-pivots            4
;  :conflicts               2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              1
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.95
;  :mk-bool-var             335
;  :mk-clause               7
;  :num-allocs              124474
;  :num-checks              8
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            123393)
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i2@15@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               46
;  :arith-add-rows          2
;  :arith-assert-lower      12
;  :arith-assert-upper      7
;  :arith-conflicts         1
;  :arith-eq-adapter        3
;  :arith-fixed-eqs         2
;  :arith-pivots            4
;  :conflicts               3
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              1
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.94
;  :mk-bool-var             336
;  :mk-clause               7
;  :num-allocs              124644
;  :num-checks              9
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            123556)
(assert (< i2@15@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 4
; Joined path conditions
(assert (< i2@15@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 4
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 5
(assert (not (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-add-rows          4
;  :arith-assert-lower      15
;  :arith-assert-upper      8
;  :arith-conflicts         2
;  :arith-eq-adapter        3
;  :arith-fixed-eqs         2
;  :arith-max-min           3
;  :arith-offset-eqs        1
;  :arith-pivots            4
;  :conflicts               4
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   12
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              1
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.95
;  :mk-bool-var             338
;  :mk-clause               7
;  :num-allocs              124839
;  :num-checks              10
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            123802)
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(pop) ; 4
; Joined path conditions
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(declare-const $k@16@02 $Perm)
(assert ($Perm.isReadVar $k@16@02 $Perm.Write))
(pop) ; 3
(declare-fun inv@17@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@16@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@15@02 Int)) (!
  (and
    (not (= source@9@02 (as None<option<array>>  option<array>)))
    (< i2@15@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@15@02))
  :qid |option$array$-aux|)))
(push) ; 3
(assert (not (forall ((i2@15@02 Int)) (!
  (implies
    (and (< i2@15@02 V@7@02) (<= 0 i2@15@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               57
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      29
;  :arith-assert-upper      15
;  :arith-conflicts         4
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         2
;  :arith-max-min           19
;  :arith-nonlinear-bounds  2
;  :arith-offset-eqs        2
;  :arith-pivots            7
;  :conflicts               6
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               11
;  :del-clause              9
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.97
;  :mk-bool-var             356
;  :mk-clause               17
;  :num-allocs              125622
;  :num-checks              11
;  :propagations            14
;  :quant-instantiations    14
;  :rlimit-count            124846)
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i21@15@02 Int) (i22@15@02 Int)) (!
  (implies
    (and
      (and
        (and (< i21@15@02 V@7@02) (<= 0 i21@15@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@16@02)))
      (and
        (and (< i22@15@02 V@7@02) (<= 0 i22@15@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@16@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i21@15@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i22@15@02)))
    (= i21@15@02 i22@15@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               77
;  :arith-add-rows          8
;  :arith-assert-diseq      4
;  :arith-assert-lower      34
;  :arith-assert-upper      20
;  :arith-conflicts         4
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         2
;  :arith-max-min           19
;  :arith-nonlinear-bounds  2
;  :arith-offset-eqs        4
;  :arith-pivots            11
;  :conflicts               7
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   14
;  :datatype-splits         10
;  :decisions               11
;  :del-clause              38
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.99
;  :mk-bool-var             394
;  :mk-clause               46
;  :num-allocs              126172
;  :num-checks              12
;  :propagations            30
;  :quant-instantiations    29
;  :rlimit-count            125808)
; Definitional axioms for inverse functions
(assert (forall ((i2@15@02 Int)) (!
  (implies
    (and
      (and (< i2@15@02 V@7@02) (<= 0 i2@15@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02)))
    (=
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@15@02))
      i2@15@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@15@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) (inv@17@02 r))
      r))
  :pattern ((inv@17@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@15@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@15@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@15@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@15@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@15@02 Int)) (!
  (implies
    (and
      (and (< i2@15@02 V@7@02) (<= 0 i2@15@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@15@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@15@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@18@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) r) r))
  :pattern ((inv@17@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@14@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               91
;  :arith-add-rows          8
;  :arith-assert-diseq      4
;  :arith-assert-lower      50
;  :arith-assert-upper      28
;  :arith-conflicts         5
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :arith-grobner           4
;  :arith-max-min           44
;  :arith-nonlinear-bounds  3
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        5
;  :arith-pivots            12
;  :conflicts               8
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   18
;  :datatype-splits         12
;  :decisions               14
;  :del-clause              38
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             412
;  :mk-clause               51
;  :num-allocs              128052
;  :num-checks              13
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            129154)
; [then-branch: 4 | 0 < V@7@02 | live]
; [else-branch: 4 | !(0 < V@7@02) | dead]
(push) ; 4
; [then-branch: 4 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
(declare-const i2@19@02 Int)
(push) ; 5
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 6
; [then-branch: 5 | 0 <= i2@19@02 | live]
; [else-branch: 5 | !(0 <= i2@19@02) | live]
(push) ; 7
; [then-branch: 5 | 0 <= i2@19@02]
(assert (<= 0 i2@19@02))
; [eval] i2 < V
(pop) ; 7
(push) ; 7
; [else-branch: 5 | !(0 <= i2@19@02)]
(assert (not (<= 0 i2@19@02)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 6 | i2@19@02 < V@7@02 && 0 <= i2@19@02 | live]
; [else-branch: 6 | !(i2@19@02 < V@7@02 && 0 <= i2@19@02) | live]
(push) ; 7
; [then-branch: 6 | i2@19@02 < V@7@02 && 0 <= i2@19@02]
(assert (and (< i2@19@02 V@7@02) (<= 0 i2@19@02)))
; [eval] aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= source@9@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               91
;  :arith-add-rows          8
;  :arith-assert-diseq      4
;  :arith-assert-lower      51
;  :arith-assert-upper      29
;  :arith-conflicts         5
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :arith-grobner           4
;  :arith-max-min           44
;  :arith-nonlinear-bounds  3
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        5
;  :arith-pivots            13
;  :conflicts               9
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   18
;  :datatype-splits         12
;  :decisions               14
;  :del-clause              38
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             414
;  :mk-clause               51
;  :num-allocs              128274
;  :num-checks              14
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            129366)
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i2@19@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               91
;  :arith-add-rows          10
;  :arith-assert-diseq      4
;  :arith-assert-lower      52
;  :arith-assert-upper      29
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :arith-grobner           4
;  :arith-max-min           44
;  :arith-nonlinear-bounds  3
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        5
;  :arith-pivots            13
;  :conflicts               10
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   18
;  :datatype-splits         12
;  :decisions               14
;  :del-clause              38
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             415
;  :mk-clause               51
;  :num-allocs              128424
;  :num-checks              15
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            129521)
(assert (< i2@19@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 8
; Joined path conditions
(assert (< i2@19@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))
      V@7@02)
    (<=
      0
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02))
  false)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               109
;  :arith-add-rows          20
;  :arith-assert-diseq      4
;  :arith-assert-lower      60
;  :arith-assert-upper      36
;  :arith-bound-prop        1
;  :arith-conflicts         8
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           4
;  :arith-max-min           51
;  :arith-nonlinear-bounds  4
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-pivots            16
;  :conflicts               13
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   18
;  :datatype-splits         12
;  :decisions               16
;  :del-clause              41
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             439
;  :mk-clause               65
;  :num-allocs              128828
;  :num-checks              16
;  :propagations            43
;  :quant-instantiations    43
;  :rlimit-count            130506)
; [eval] (None(): option[array])
(pop) ; 7
(push) ; 7
; [else-branch: 6 | !(i2@19@02 < V@7@02 && 0 <= i2@19@02)]
(assert (not (and (< i2@19@02 V@7@02) (<= 0 i2@19@02))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i2@19@02 V@7@02) (<= 0 i2@19@02))
  (and
    (< i2@19@02 V@7@02)
    (<= 0 i2@19@02)
    (not (= source@9@02 (as None<option<array>>  option<array>)))
    (< i2@19@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02)))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@19@02 Int)) (!
  (implies
    (and (< i2@19@02 V@7@02) (<= 0 i2@19@02))
    (and
      (< i2@19@02 V@7@02)
      (<= 0 i2@19@02)
      (not (= source@9@02 (as None<option<array>>  option<array>)))
      (< i2@19@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@19@02 Int)) (!
    (implies
      (and (< i2@19@02 V@7@02) (<= 0 i2@19@02))
      (and
        (< i2@19@02 V@7@02)
        (<= 0 i2@19@02)
        (not (= source@9@02 (as None<option<array>>  option<array>)))
        (< i2@19@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@19@02 Int)) (!
    (implies
      (and (< i2@19@02 V@7@02) (<= 0 i2@19@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@19@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               122
;  :arith-add-rows          20
;  :arith-assert-diseq      4
;  :arith-assert-lower      75
;  :arith-assert-upper      44
;  :arith-bound-prop        1
;  :arith-conflicts         9
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        10
;  :arith-pivots            17
;  :conflicts               14
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               19
;  :del-clause              52
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             445
;  :mk-clause               65
;  :num-allocs              129955
;  :num-checks              17
;  :propagations            46
;  :quant-instantiations    43
;  :rlimit-count            132401)
; [then-branch: 7 | 0 < V@7@02 | live]
; [else-branch: 7 | !(0 < V@7@02) | dead]
(push) ; 4
; [then-branch: 7 | 0 < V@7@02]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
(declare-const i2@20@02 Int)
(push) ; 5
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 6
; [then-branch: 8 | 0 <= i2@20@02 | live]
; [else-branch: 8 | !(0 <= i2@20@02) | live]
(push) ; 7
; [then-branch: 8 | 0 <= i2@20@02]
(assert (<= 0 i2@20@02))
; [eval] i2 < V
(pop) ; 7
(push) ; 7
; [else-branch: 8 | !(0 <= i2@20@02)]
(assert (not (<= 0 i2@20@02)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 9 | i2@20@02 < V@7@02 && 0 <= i2@20@02 | live]
; [else-branch: 9 | !(i2@20@02 < V@7@02 && 0 <= i2@20@02) | live]
(push) ; 7
; [then-branch: 9 | i2@20@02 < V@7@02 && 0 <= i2@20@02]
(assert (and (< i2@20@02 V@7@02) (<= 0 i2@20@02)))
; [eval] alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(source), i2).option$array$))
; [eval] opt_get1(aloc(opt_get1(source), i2).option$array$)
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= source@9@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               122
;  :arith-add-rows          20
;  :arith-assert-diseq      4
;  :arith-assert-lower      77
;  :arith-assert-upper      44
;  :arith-bound-prop        1
;  :arith-conflicts         9
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        10
;  :arith-pivots            17
;  :conflicts               15
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               19
;  :del-clause              52
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             447
;  :mk-clause               65
;  :num-allocs              130109
;  :num-checks              18
;  :propagations            46
;  :quant-instantiations    43
;  :rlimit-count            132617)
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i2@20@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               122
;  :arith-add-rows          23
;  :arith-assert-diseq      4
;  :arith-assert-lower      77
;  :arith-assert-upper      45
;  :arith-bound-prop        1
;  :arith-conflicts         10
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        10
;  :arith-pivots            19
;  :conflicts               16
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               19
;  :del-clause              52
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             448
;  :mk-clause               65
;  :num-allocs              130253
;  :num-checks              19
;  :propagations            46
;  :quant-instantiations    43
;  :rlimit-count            132811)
(assert (< i2@20@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 8
; Joined path conditions
(assert (< i2@20@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
      V@7@02)
    (<=
      0
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02))
  false)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               147
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      86
;  :arith-assert-upper      52
;  :arith-bound-prop        2
;  :arith-conflicts         12
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-grobner           8
;  :arith-max-min           84
;  :arith-nonlinear-bounds  6
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        15
;  :arith-pivots            22
;  :conflicts               18
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               23
;  :del-clause              57
;  :final-checks            30
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             477
;  :mk-clause               81
;  :num-allocs              130607
;  :num-checks              20
;  :propagations            58
;  :quant-instantiations    56
;  :rlimit-count            133880)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 9
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               147
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      86
;  :arith-assert-upper      52
;  :arith-bound-prop        2
;  :arith-conflicts         12
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-grobner           8
;  :arith-max-min           84
;  :arith-nonlinear-bounds  6
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        15
;  :arith-pivots            22
;  :conflicts               19
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               23
;  :del-clause              57
;  :final-checks            30
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             477
;  :mk-clause               81
;  :num-allocs              130697
;  :num-checks              21
;  :propagations            58
;  :quant-instantiations    56
;  :rlimit-count            133975)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
    (as None<option<array>>  option<array>))))
(pop) ; 7
(push) ; 7
; [else-branch: 9 | !(i2@20@02 < V@7@02 && 0 <= i2@20@02)]
(assert (not (and (< i2@20@02 V@7@02) (<= 0 i2@20@02))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i2@20@02 V@7@02) (<= 0 i2@20@02))
  (and
    (< i2@20@02 V@7@02)
    (<= 0 i2@20@02)
    (not (= source@9@02 (as None<option<array>>  option<array>)))
    (< i2@20@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@20@02 Int)) (!
  (implies
    (and (< i2@20@02 V@7@02) (<= 0 i2@20@02))
    (and
      (< i2@20@02 V@7@02)
      (<= 0 i2@20@02)
      (not (= source@9@02 (as None<option<array>>  option<array>)))
      (< i2@20@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@20@02 Int)) (!
    (implies
      (and (< i2@20@02 V@7@02) (<= 0 i2@20@02))
      (and
        (< i2@20@02 V@7@02)
        (<= 0 i2@20@02)
        (not (= source@9@02 (as None<option<array>>  option<array>)))
        (< i2@20@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@20@02 Int)) (!
    (implies
      (and (< i2@20@02 V@7@02) (<= 0 i2@20@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@20@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      101
;  :arith-assert-upper      60
;  :arith-bound-prop        2
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        16
;  :arith-pivots            23
;  :conflicts               20
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               26
;  :del-clause              68
;  :final-checks            35
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             483
;  :mk-clause               81
;  :num-allocs              131835
;  :num-checks              22
;  :propagations            61
;  :quant-instantiations    56
;  :rlimit-count            135974)
; [then-branch: 10 | 0 < V@7@02 | live]
; [else-branch: 10 | !(0 < V@7@02) | dead]
(push) ; 4
; [then-branch: 10 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
(declare-const i2@21@02 Int)
(push) ; 5
; [eval] (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3)
(declare-const i3@22@02 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 11 | 0 <= i2@21@02 | live]
; [else-branch: 11 | !(0 <= i2@21@02) | live]
(push) ; 8
; [then-branch: 11 | 0 <= i2@21@02]
(assert (<= 0 i2@21@02))
; [eval] i2 < V
(push) ; 9
; [then-branch: 12 | i2@21@02 < V@7@02 | live]
; [else-branch: 12 | !(i2@21@02 < V@7@02) | live]
(push) ; 10
; [then-branch: 12 | i2@21@02 < V@7@02]
(assert (< i2@21@02 V@7@02))
; [eval] 0 <= i3
(push) ; 11
; [then-branch: 13 | 0 <= i3@22@02 | live]
; [else-branch: 13 | !(0 <= i3@22@02) | live]
(push) ; 12
; [then-branch: 13 | 0 <= i3@22@02]
(assert (<= 0 i3@22@02))
; [eval] i3 < V
(push) ; 13
; [then-branch: 14 | i3@22@02 < V@7@02 | live]
; [else-branch: 14 | !(i3@22@02 < V@7@02) | live]
(push) ; 14
; [then-branch: 14 | i3@22@02 < V@7@02]
(assert (< i3@22@02 V@7@02))
; [eval] aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 15
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 16
(assert (not (not (= source@9@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      105
;  :arith-assert-upper      60
;  :arith-bound-prop        2
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        16
;  :arith-pivots            24
;  :conflicts               21
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               26
;  :del-clause              68
;  :final-checks            35
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             487
;  :mk-clause               81
;  :num-allocs              132219
;  :num-checks              23
;  :propagations            61
;  :quant-instantiations    56
;  :rlimit-count            136339)
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 15
; Joined path conditions
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(push) ; 15
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 16
(assert (not (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-add-rows          32
;  :arith-assert-diseq      4
;  :arith-assert-lower      105
;  :arith-assert-upper      61
;  :arith-bound-prop        2
;  :arith-conflicts         14
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        16
;  :arith-pivots            24
;  :conflicts               22
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               26
;  :del-clause              68
;  :final-checks            35
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.04
;  :mk-bool-var             488
;  :mk-clause               81
;  :num-allocs              132364
;  :num-checks              24
;  :propagations            61
;  :quant-instantiations    56
;  :rlimit-count            136494)
(assert (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 15
; Joined path conditions
(assert (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
      V@7@02)
    (<=
      0
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02))
  false)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               177
;  :arith-add-rows          41
;  :arith-assert-diseq      4
;  :arith-assert-lower      114
;  :arith-assert-upper      67
;  :arith-bound-prop        3
;  :arith-conflicts         16
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         11
;  :arith-grobner           12
;  :arith-max-min           117
;  :arith-nonlinear-bounds  8
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        20
;  :arith-pivots            27
;  :conflicts               24
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               27
;  :del-clause              71
;  :final-checks            36
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.06
;  :mk-bool-var             512
;  :mk-clause               95
;  :num-allocs              132705
;  :num-checks              25
;  :propagations            72
;  :quant-instantiations    69
;  :rlimit-count            137512)
; [eval] aloc(opt_get1(source), i3)
; [eval] opt_get1(source)
(push) ; 15
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 15
; Joined path conditions
(push) ; 15
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 16
(assert (not (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               177
;  :arith-add-rows          44
;  :arith-assert-diseq      4
;  :arith-assert-lower      114
;  :arith-assert-upper      68
;  :arith-bound-prop        3
;  :arith-conflicts         17
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         11
;  :arith-grobner           12
;  :arith-max-min           117
;  :arith-nonlinear-bounds  8
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        20
;  :arith-pivots            29
;  :conflicts               25
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               27
;  :del-clause              71
;  :final-checks            36
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.06
;  :mk-bool-var             513
;  :mk-clause               95
;  :num-allocs              132790
;  :num-checks              26
;  :propagations            72
;  :quant-instantiations    69
;  :rlimit-count            137661)
(assert (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 15
; Joined path conditions
(assert (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))
      V@7@02)
    (<=
      0
      (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02))
  false)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               191
;  :arith-add-rows          52
;  :arith-assert-diseq      4
;  :arith-assert-lower      122
;  :arith-assert-upper      74
;  :arith-bound-prop        4
;  :arith-conflicts         19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         15
;  :arith-grobner           12
;  :arith-max-min           124
;  :arith-nonlinear-bounds  9
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        20
;  :arith-pivots            32
;  :conflicts               27
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               28
;  :del-clause              75
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.10
;  :mk-bool-var             538
;  :mk-clause               108
;  :num-allocs              133170
;  :num-checks              27
;  :propagations            81
;  :quant-instantiations    81
;  :rlimit-count            138672)
(pop) ; 14
(push) ; 14
; [else-branch: 14 | !(i3@22@02 < V@7@02)]
(assert (not (< i3@22@02 V@7@02)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i3@22@02 V@7@02)
  (and
    (< i3@22@02 V@7@02)
    (not (= source@9@02 (as None<option<array>>  option<array>)))
    (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
    (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 13 | !(0 <= i3@22@02)]
(assert (not (<= 0 i3@22@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i3@22@02)
  (and
    (<= 0 i3@22@02)
    (implies
      (< i3@22@02 V@7@02)
      (and
        (< i3@22@02 V@7@02)
        (not (= source@9@02 (as None<option<array>>  option<array>)))
        (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
        (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))))))
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 12 | !(i2@21@02 < V@7@02)]
(assert (not (< i2@21@02 V@7@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (< i2@21@02 V@7@02)
  (and
    (< i2@21@02 V@7@02)
    (implies
      (<= 0 i3@22@02)
      (and
        (<= 0 i3@22@02)
        (implies
          (< i3@22@02 V@7@02)
          (and
            (< i3@22@02 V@7@02)
            (not (= source@9@02 (as None<option<array>>  option<array>)))
            (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
            (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))))))))
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= i2@21@02)]
(assert (not (<= 0 i2@21@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (<= 0 i2@21@02)
  (and
    (<= 0 i2@21@02)
    (implies
      (< i2@21@02 V@7@02)
      (and
        (< i2@21@02 V@7@02)
        (implies
          (<= 0 i3@22@02)
          (and
            (<= 0 i3@22@02)
            (implies
              (< i3@22@02 V@7@02)
              (and
                (< i3@22@02 V@7@02)
                (not (= source@9@02 (as None<option<array>>  option<array>)))
                (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))))))))))
; Joined path conditions
(push) ; 7
; [then-branch: 15 | Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i2@21@02)) == Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i3@22@02)) && i3@22@02 < V@7@02 && 0 <= i3@22@02 && i2@21@02 < V@7@02 && 0 <= i2@21@02 | live]
; [else-branch: 15 | !(Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i2@21@02)) == Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i3@22@02)) && i3@22@02 < V@7@02 && 0 <= i3@22@02 && i2@21@02 < V@7@02 && 0 <= i2@21@02) | live]
(push) ; 8
; [then-branch: 15 | Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i2@21@02)) == Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i3@22@02)) && i3@22@02 < V@7@02 && 0 <= i3@22@02 && i2@21@02 < V@7@02 && 0 <= i2@21@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
          ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
        (< i3@22@02 V@7@02))
      (<= 0 i3@22@02))
    (< i2@21@02 V@7@02))
  (<= 0 i2@21@02)))
; [eval] i2 == i3
(pop) ; 8
(push) ; 8
; [else-branch: 15 | !(Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i2@21@02)) == Lookup(option$array$,sm@18@02,aloc((_, _), opt_get1(_, source@9@02), i3@22@02)) && i3@22@02 < V@7@02 && 0 <= i3@22@02 && i2@21@02 < V@7@02 && 0 <= i2@21@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
            ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
          (< i3@22@02 V@7@02))
        (<= 0 i3@22@02))
      (< i2@21@02 V@7@02))
    (<= 0 i2@21@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
            ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
          (< i3@22@02 V@7@02))
        (<= 0 i3@22@02))
      (< i2@21@02 V@7@02))
    (<= 0 i2@21@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
      ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
    (< i3@22@02 V@7@02)
    (<= 0 i3@22@02)
    (< i2@21@02 V@7@02)
    (<= 0 i2@21@02))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@22@02 Int)) (!
  (and
    (implies
      (<= 0 i2@21@02)
      (and
        (<= 0 i2@21@02)
        (implies
          (< i2@21@02 V@7@02)
          (and
            (< i2@21@02 V@7@02)
            (implies
              (<= 0 i3@22@02)
              (and
                (<= 0 i3@22@02)
                (implies
                  (< i3@22@02 V@7@02)
                  (and
                    (< i3@22@02 V@7@02)
                    (not (= source@9@02 (as None<option<array>>  option<array>)))
                    (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                    (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
              (< i3@22@02 V@7@02))
            (<= 0 i3@22@02))
          (< i2@21@02 V@7@02))
        (<= 0 i2@21@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
          ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
        (< i3@22@02 V@7@02)
        (<= 0 i3@22@02)
        (< i2@21@02 V@7@02)
        (<= 0 i2@21@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@21@02 Int)) (!
  (forall ((i3@22@02 Int)) (!
    (and
      (implies
        (<= 0 i2@21@02)
        (and
          (<= 0 i2@21@02)
          (implies
            (< i2@21@02 V@7@02)
            (and
              (< i2@21@02 V@7@02)
              (implies
                (<= 0 i3@22@02)
                (and
                  (<= 0 i3@22@02)
                  (implies
                    (< i3@22@02 V@7@02)
                    (and
                      (< i3@22@02 V@7@02)
                      (not
                        (= source@9@02 (as None<option<array>>  option<array>)))
                      (< i2@21@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                      (< i3@22@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                  ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
                (< i3@22@02 V@7@02))
              (<= 0 i3@22@02))
            (< i2@21@02 V@7@02))
          (<= 0 i2@21@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
            ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
          (< i3@22@02 V@7@02)
          (<= 0 i3@22@02)
          (< i2@21@02 V@7@02)
          (<= 0 i2@21@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@21@02 Int)) (!
    (forall ((i3@22@02 Int)) (!
      (and
        (implies
          (<= 0 i2@21@02)
          (and
            (<= 0 i2@21@02)
            (implies
              (< i2@21@02 V@7@02)
              (and
                (< i2@21@02 V@7@02)
                (implies
                  (<= 0 i3@22@02)
                  (and
                    (<= 0 i3@22@02)
                    (implies
                      (< i3@22@02 V@7@02)
                      (and
                        (< i3@22@02 V@7@02)
                        (not
                          (= source@9@02 (as None<option<array>>  option<array>)))
                        (<
                          i2@21@02
                          (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                        (<
                          i3@22@02
                          (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                    ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
                  (< i3@22@02 V@7@02))
                (<= 0 i3@22@02))
              (< i2@21@02 V@7@02))
            (<= 0 i2@21@02))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
              ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
            (< i3@22@02 V@7@02)
            (<= 0 i3@22@02)
            (< i2@21@02 V@7@02)
            (<= 0 i2@21@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@21@02 Int)) (!
    (forall ((i3@22@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
                  ($FVF.lookup_option$array$ (as sm@18@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02)))
                (< i3@22@02 V@7@02))
              (<= 0 i3@22@02))
            (< i2@21@02 V@7@02))
          (<= 0 i2@21@02))
        (= i2@21@02 i3@22@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@22@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@21@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               204
;  :arith-add-rows          54
;  :arith-assert-diseq      4
;  :arith-assert-lower      137
;  :arith-assert-upper      82
;  :arith-bound-prop        4
;  :arith-conflicts         20
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         15
;  :arith-grobner           16
;  :arith-max-min           150
;  :arith-nonlinear-bounds  10
;  :arith-nonlinear-horner  12
;  :arith-offset-eqs        21
;  :arith-pivots            34
;  :conflicts               28
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   32
;  :datatype-splits         20
;  :decisions               31
;  :del-clause              120
;  :final-checks            42
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             559
;  :mk-clause               133
;  :num-allocs              134915
;  :num-checks              28
;  :propagations            84
;  :quant-instantiations    81
;  :rlimit-count            142344)
; [then-branch: 16 | 0 < V@7@02 | live]
; [else-branch: 16 | !(0 < V@7@02) | dead]
(push) ; 4
; [then-branch: 16 | 0 < V@7@02]
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (not (= target@8@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               217
;  :arith-add-rows          54
;  :arith-assert-diseq      4
;  :arith-assert-lower      152
;  :arith-assert-upper      90
;  :arith-bound-prop        4
;  :arith-conflicts         21
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         15
;  :arith-grobner           20
;  :arith-max-min           176
;  :arith-nonlinear-bounds  11
;  :arith-nonlinear-horner  15
;  :arith-offset-eqs        22
;  :arith-pivots            34
;  :conflicts               29
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   36
;  :datatype-splits         22
;  :decisions               34
;  :del-clause              120
;  :final-checks            47
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             564
;  :mk-clause               133
;  :num-allocs              135658
;  :num-checks              29
;  :propagations            87
;  :quant-instantiations    81
;  :rlimit-count            143419)
; [then-branch: 17 | 0 < V@7@02 | live]
; [else-branch: 17 | !(0 < V@7@02) | dead]
(push) ; 4
; [then-branch: 17 | 0 < V@7@02]
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@8@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               217
;  :arith-add-rows          54
;  :arith-assert-diseq      4
;  :arith-assert-lower      152
;  :arith-assert-upper      90
;  :arith-bound-prop        4
;  :arith-conflicts         21
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         15
;  :arith-grobner           20
;  :arith-max-min           176
;  :arith-nonlinear-bounds  11
;  :arith-nonlinear-horner  15
;  :arith-offset-eqs        22
;  :arith-pivots            34
;  :conflicts               29
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   36
;  :datatype-splits         22
;  :decisions               34
;  :del-clause              120
;  :final-checks            47
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             564
;  :mk-clause               133
;  :num-allocs              135683
;  :num-checks              30
;  :propagations            87
;  :quant-instantiations    81
;  :rlimit-count            143440)
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (< 0 V@7@02) (= (alen<Int> (opt_get1 $Snap.unit target@8@02)) V@7@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               237
;  :arith-add-rows          54
;  :arith-assert-diseq      4
;  :arith-assert-lower      169
;  :arith-assert-upper      99
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        23
;  :arith-pivots            35
;  :conflicts               30
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               38
;  :del-clause              120
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             577
;  :mk-clause               133
;  :num-allocs              136558
;  :num-checks              31
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            144848)
; [then-branch: 18 | 0 < V@7@02 | live]
; [else-branch: 18 | !(0 < V@7@02) | dead]
(push) ; 3
; [then-branch: 18 | 0 < V@7@02]
(declare-const i2@23@02 Int)
(push) ; 4
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 5
; [then-branch: 19 | 0 <= i2@23@02 | live]
; [else-branch: 19 | !(0 <= i2@23@02) | live]
(push) ; 6
; [then-branch: 19 | 0 <= i2@23@02]
(assert (<= 0 i2@23@02))
; [eval] i2 < V
(pop) ; 6
(push) ; 6
; [else-branch: 19 | !(0 <= i2@23@02)]
(assert (not (<= 0 i2@23@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< i2@23@02 V@7@02) (<= 0 i2@23@02)))
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@8@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               237
;  :arith-add-rows          54
;  :arith-assert-diseq      4
;  :arith-assert-lower      171
;  :arith-assert-upper      99
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        23
;  :arith-pivots            35
;  :conflicts               30
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               38
;  :del-clause              120
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             579
;  :mk-clause               133
;  :num-allocs              136658
;  :num-checks              32
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            145019)
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i2@23@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               237
;  :arith-add-rows          54
;  :arith-assert-diseq      4
;  :arith-assert-lower      171
;  :arith-assert-upper      99
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        23
;  :arith-pivots            35
;  :conflicts               30
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               38
;  :del-clause              120
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             579
;  :mk-clause               133
;  :num-allocs              136679
;  :num-checks              33
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            145050)
(assert (< i2@23@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 5
; Joined path conditions
(assert (< i2@23@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 5
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 6
(assert (not (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               237
;  :arith-add-rows          54
;  :arith-assert-diseq      4
;  :arith-assert-lower      175
;  :arith-assert-upper      102
;  :arith-bound-prop        4
;  :arith-conflicts         23
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           211
;  :arith-nonlinear-bounds  13
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        23
;  :arith-pivots            35
;  :conflicts               31
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               38
;  :del-clause              120
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             579
;  :mk-clause               133
;  :num-allocs              136853
;  :num-checks              34
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            145215)
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(pop) ; 5
; Joined path conditions
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(declare-const $k@24@02 $Perm)
(assert ($Perm.isReadVar $k@24@02 $Perm.Write))
(pop) ; 4
(declare-fun inv@25@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@24@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@23@02 Int)) (!
  (and
    (not (= target@8@02 (as None<option<array>>  option<array>)))
    (< i2@23@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@23@02))
  :qid |option$array$-aux|)))
(push) ; 4
(assert (not (forall ((i2@23@02 Int)) (!
  (implies
    (and (< i2@23@02 V@7@02) (<= 0 i2@23@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               246
;  :arith-add-rows          54
;  :arith-assert-diseq      6
;  :arith-assert-lower      193
;  :arith-assert-upper      112
;  :arith-bound-prop        4
;  :arith-conflicts         25
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           234
;  :arith-nonlinear-bounds  16
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        24
;  :arith-pivots            37
;  :conflicts               33
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   42
;  :datatype-splits         28
;  :decisions               42
;  :del-clause              123
;  :final-checks            56
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             592
;  :mk-clause               138
;  :num-allocs              137525
;  :num-checks              35
;  :propagations            95
;  :quant-instantiations    86
;  :rlimit-count            146191)
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((i21@23@02 Int) (i22@23@02 Int)) (!
  (implies
    (and
      (and
        (and (< i21@23@02 V@7@02) (<= 0 i21@23@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@24@02)))
      (and
        (and (< i22@23@02 V@7@02) (<= 0 i22@23@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@24@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i21@23@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i22@23@02)))
    (= i21@23@02 i22@23@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               261
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      200
;  :arith-assert-upper      113
;  :arith-bound-prop        6
;  :arith-conflicts         25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           234
;  :arith-nonlinear-bounds  16
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        27
;  :arith-pivots            41
;  :conflicts               34
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   42
;  :datatype-splits         28
;  :decisions               42
;  :del-clause              141
;  :final-checks            56
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.13
;  :mk-bool-var             617
;  :mk-clause               156
;  :num-allocs              137930
;  :num-checks              36
;  :propagations            105
;  :quant-instantiations    96
;  :rlimit-count            147059)
; Definitional axioms for inverse functions
(assert (forall ((i2@23@02 Int)) (!
  (implies
    (and
      (and (< i2@23@02 V@7@02) (<= 0 i2@23@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02)))
    (=
      (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@23@02))
      i2@23@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@23@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) (inv@25@02 r))
      r))
  :pattern ((inv@25@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@23@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@23@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@23@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@23@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@23@02 Int)) (!
  (implies
    (and
      (and (< i2@23@02 V@7@02) (<= 0 i2@23@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@23@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@23@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@26@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r))
  :qid |qp.fvfValDef2|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r))
  :qid |qp.fvfValDef3|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef4|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) r) r))
  :pattern ((inv@25@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      223
;  :arith-assert-upper      127
;  :arith-bound-prop        6
;  :arith-conflicts         26
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           271
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        28
;  :arith-pivots            41
;  :conflicts               35
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   46
;  :datatype-splits         31
;  :decisions               46
;  :del-clause              141
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.14
;  :mk-bool-var             631
;  :mk-clause               156
;  :num-allocs              140075
;  :num-checks              37
;  :propagations            108
;  :quant-instantiations    96
;  :rlimit-count            151639)
; [then-branch: 20 | 0 < V@7@02 | live]
; [else-branch: 20 | !(0 < V@7@02) | dead]
(push) ; 5
; [then-branch: 20 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
(declare-const i2@27@02 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 21 | 0 <= i2@27@02 | live]
; [else-branch: 21 | !(0 <= i2@27@02) | live]
(push) ; 8
; [then-branch: 21 | 0 <= i2@27@02]
(assert (<= 0 i2@27@02))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 21 | !(0 <= i2@27@02)]
(assert (not (<= 0 i2@27@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 22 | i2@27@02 < V@7@02 && 0 <= i2@27@02 | live]
; [else-branch: 22 | !(i2@27@02 < V@7@02 && 0 <= i2@27@02) | live]
(push) ; 8
; [then-branch: 22 | i2@27@02 < V@7@02 && 0 <= i2@27@02]
(assert (and (< i2@27@02 V@7@02) (<= 0 i2@27@02)))
; [eval] aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@8@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      225
;  :arith-assert-upper      127
;  :arith-bound-prop        6
;  :arith-conflicts         26
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           271
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        28
;  :arith-pivots            42
;  :conflicts               35
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   46
;  :datatype-splits         31
;  :decisions               46
;  :del-clause              141
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.14
;  :mk-bool-var             633
;  :mk-clause               156
;  :num-allocs              140175
;  :num-checks              38
;  :propagations            108
;  :quant-instantiations    96
;  :rlimit-count            151824)
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i2@27@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      225
;  :arith-assert-upper      127
;  :arith-bound-prop        6
;  :arith-conflicts         26
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           271
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        28
;  :arith-pivots            42
;  :conflicts               35
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   46
;  :datatype-splits         31
;  :decisions               46
;  :del-clause              141
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.14
;  :mk-bool-var             633
;  :mk-clause               156
;  :num-allocs              140196
;  :num-checks              39
;  :propagations            108
;  :quant-instantiations    96
;  :rlimit-count            151855)
(assert (< i2@27@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 9
; Joined path conditions
(assert (< i2@27@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               345
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      262
;  :arith-assert-upper      154
;  :arith-bound-prop        8
;  :arith-conflicts         32
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         26
;  :arith-grobner           30
;  :arith-max-min           291
;  :arith-nonlinear-bounds  22
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        34
;  :arith-pivots            60
;  :conflicts               45
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 35
;  :datatype-occurs-check   48
;  :datatype-splits         34
;  :decisions               73
;  :del-clause              230
;  :final-checks            64
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             772
;  :mk-clause               268
;  :num-allocs              141110
;  :num-checks              40
;  :propagations            178
;  :quant-instantiations    125
;  :rlimit-count            154509
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 8
(push) ; 8
; [else-branch: 22 | !(i2@27@02 < V@7@02 && 0 <= i2@27@02)]
(assert (not (and (< i2@27@02 V@7@02) (<= 0 i2@27@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i2@27@02 V@7@02) (<= 0 i2@27@02))
  (and
    (< i2@27@02 V@7@02)
    (<= 0 i2@27@02)
    (not (= target@8@02 (as None<option<array>>  option<array>)))
    (< i2@27@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@27@02 Int)) (!
  (implies
    (and (< i2@27@02 V@7@02) (<= 0 i2@27@02))
    (and
      (< i2@27@02 V@7@02)
      (<= 0 i2@27@02)
      (not (= target@8@02 (as None<option<array>>  option<array>)))
      (< i2@27@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@27@02 Int)) (!
    (implies
      (and (< i2@27@02 V@7@02) (<= 0 i2@27@02))
      (and
        (< i2@27@02 V@7@02)
        (<= 0 i2@27@02)
        (not (= target@8@02 (as None<option<array>>  option<array>)))
        (< i2@27@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@27@02 Int)) (!
    (implies
      (and (< i2@27@02 V@7@02) (<= 0 i2@27@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@27@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               361
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      284
;  :arith-assert-upper      168
;  :arith-bound-prop        8
;  :arith-conflicts         33
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         26
;  :arith-grobner           35
;  :arith-max-min           329
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        35
;  :arith-pivots            61
;  :conflicts               46
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 38
;  :datatype-occurs-check   52
;  :datatype-splits         37
;  :decisions               77
;  :del-clause              253
;  :final-checks            69
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.22
;  :memory                  4.21
;  :mk-bool-var             779
;  :mk-clause               268
;  :num-allocs              142361
;  :num-checks              41
;  :propagations            181
;  :quant-instantiations    125
;  :rlimit-count            156662)
; [then-branch: 23 | 0 < V@7@02 | live]
; [else-branch: 23 | !(0 < V@7@02) | dead]
(push) ; 5
; [then-branch: 23 | 0 < V@7@02]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
(declare-const i2@28@02 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 24 | 0 <= i2@28@02 | live]
; [else-branch: 24 | !(0 <= i2@28@02) | live]
(push) ; 8
; [then-branch: 24 | 0 <= i2@28@02]
(assert (<= 0 i2@28@02))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(0 <= i2@28@02)]
(assert (not (<= 0 i2@28@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 25 | i2@28@02 < V@7@02 && 0 <= i2@28@02 | live]
; [else-branch: 25 | !(i2@28@02 < V@7@02 && 0 <= i2@28@02) | live]
(push) ; 8
; [then-branch: 25 | i2@28@02 < V@7@02 && 0 <= i2@28@02]
(assert (and (< i2@28@02 V@7@02) (<= 0 i2@28@02)))
; [eval] alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(target), i2).option$array$))
; [eval] opt_get1(aloc(opt_get1(target), i2).option$array$)
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@8@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               361
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      286
;  :arith-assert-upper      168
;  :arith-bound-prop        8
;  :arith-conflicts         33
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         26
;  :arith-grobner           35
;  :arith-max-min           329
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        35
;  :arith-pivots            62
;  :conflicts               46
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 38
;  :datatype-occurs-check   52
;  :datatype-splits         37
;  :decisions               77
;  :del-clause              253
;  :final-checks            69
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.22
;  :memory                  4.21
;  :mk-bool-var             781
;  :mk-clause               268
;  :num-allocs              142461
;  :num-checks              42
;  :propagations            181
;  :quant-instantiations    125
;  :rlimit-count            156847)
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i2@28@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               361
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      286
;  :arith-assert-upper      168
;  :arith-bound-prop        8
;  :arith-conflicts         33
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         26
;  :arith-grobner           35
;  :arith-max-min           329
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        35
;  :arith-pivots            62
;  :conflicts               46
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 38
;  :datatype-occurs-check   52
;  :datatype-splits         37
;  :decisions               77
;  :del-clause              253
;  :final-checks            69
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.22
;  :memory                  4.21
;  :mk-bool-var             781
;  :mk-clause               268
;  :num-allocs              142482
;  :num-checks              43
;  :propagations            181
;  :quant-instantiations    125
;  :rlimit-count            156878)
(assert (< i2@28@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 9
; Joined path conditions
(assert (< i2@28@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          107
;  :arith-assert-diseq      11
;  :arith-assert-lower      324
;  :arith-assert-upper      194
;  :arith-bound-prop        11
;  :arith-conflicts         38
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         36
;  :arith-grobner           35
;  :arith-max-min           349
;  :arith-nonlinear-bounds  28
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        42
;  :arith-pivots            79
;  :conflicts               56
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   54
;  :datatype-splits         40
;  :decisions               105
;  :del-clause              351
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.24
;  :memory                  4.23
;  :mk-bool-var             936
;  :mk-clause               389
;  :num-allocs              143258
;  :num-checks              44
;  :propagations            244
;  :quant-instantiations    156
;  :rlimit-count            159439
;  :time                    0.00)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-add-rows          107
;  :arith-assert-diseq      11
;  :arith-assert-lower      324
;  :arith-assert-upper      194
;  :arith-bound-prop        11
;  :arith-conflicts         38
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         36
;  :arith-grobner           35
;  :arith-max-min           349
;  :arith-nonlinear-bounds  28
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        42
;  :arith-pivots            79
;  :conflicts               57
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   54
;  :datatype-splits         40
;  :decisions               105
;  :del-clause              351
;  :final-checks            72
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.24
;  :memory                  4.23
;  :mk-bool-var             936
;  :mk-clause               389
;  :num-allocs              143348
;  :num-checks              45
;  :propagations            244
;  :quant-instantiations    156
;  :rlimit-count            159534)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
    (as None<option<array>>  option<array>))))
(pop) ; 8
(push) ; 8
; [else-branch: 25 | !(i2@28@02 < V@7@02 && 0 <= i2@28@02)]
(assert (not (and (< i2@28@02 V@7@02) (<= 0 i2@28@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i2@28@02 V@7@02) (<= 0 i2@28@02))
  (and
    (< i2@28@02 V@7@02)
    (<= 0 i2@28@02)
    (not (= target@8@02 (as None<option<array>>  option<array>)))
    (< i2@28@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@28@02 Int)) (!
  (implies
    (and (< i2@28@02 V@7@02) (<= 0 i2@28@02))
    (and
      (< i2@28@02 V@7@02)
      (<= 0 i2@28@02)
      (not (= target@8@02 (as None<option<array>>  option<array>)))
      (< i2@28@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@28@02 Int)) (!
    (implies
      (and (< i2@28@02 V@7@02) (<= 0 i2@28@02))
      (and
        (< i2@28@02 V@7@02)
        (<= 0 i2@28@02)
        (not (= target@8@02 (as None<option<array>>  option<array>)))
        (< i2@28@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@28@02 Int)) (!
    (implies
      (and (< i2@28@02 V@7@02) (<= 0 i2@28@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@28@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-add-rows          107
;  :arith-assert-diseq      11
;  :arith-assert-lower      346
;  :arith-assert-upper      208
;  :arith-bound-prop        11
;  :arith-conflicts         39
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         36
;  :arith-grobner           40
;  :arith-max-min           387
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        43
;  :arith-pivots            80
;  :conflicts               58
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   58
;  :datatype-splits         43
;  :decisions               109
;  :del-clause              374
;  :final-checks            77
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             943
;  :mk-clause               389
;  :num-allocs              144624
;  :num-checks              46
;  :propagations            247
;  :quant-instantiations    156
;  :rlimit-count            161791)
; [then-branch: 26 | 0 < V@7@02 | live]
; [else-branch: 26 | !(0 < V@7@02) | dead]
(push) ; 5
; [then-branch: 26 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
(declare-const i2@29@02 Int)
(push) ; 6
; [eval] (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3)
(declare-const i3@30@02 Int)
(push) ; 7
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] 0 <= i2
(push) ; 8
; [then-branch: 27 | 0 <= i2@29@02 | live]
; [else-branch: 27 | !(0 <= i2@29@02) | live]
(push) ; 9
; [then-branch: 27 | 0 <= i2@29@02]
(assert (<= 0 i2@29@02))
; [eval] i2 < V
(push) ; 10
; [then-branch: 28 | i2@29@02 < V@7@02 | live]
; [else-branch: 28 | !(i2@29@02 < V@7@02) | live]
(push) ; 11
; [then-branch: 28 | i2@29@02 < V@7@02]
(assert (< i2@29@02 V@7@02))
; [eval] 0 <= i3
(push) ; 12
; [then-branch: 29 | 0 <= i3@30@02 | live]
; [else-branch: 29 | !(0 <= i3@30@02) | live]
(push) ; 13
; [then-branch: 29 | 0 <= i3@30@02]
(assert (<= 0 i3@30@02))
; [eval] i3 < V
(push) ; 14
; [then-branch: 30 | i3@30@02 < V@7@02 | live]
; [else-branch: 30 | !(i3@30@02 < V@7@02) | live]
(push) ; 15
; [then-branch: 30 | i3@30@02 < V@7@02]
(assert (< i3@30@02 V@7@02))
; [eval] aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 16
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 17
(assert (not (not (= target@8@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-add-rows          107
;  :arith-assert-diseq      11
;  :arith-assert-lower      350
;  :arith-assert-upper      208
;  :arith-bound-prop        11
;  :arith-conflicts         39
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         36
;  :arith-grobner           40
;  :arith-max-min           387
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        43
;  :arith-pivots            80
;  :conflicts               58
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   58
;  :datatype-splits         43
;  :decisions               109
;  :del-clause              374
;  :final-checks            77
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             947
;  :mk-clause               389
;  :num-allocs              144901
;  :num-checks              47
;  :propagations            247
;  :quant-instantiations    156
;  :rlimit-count            162116)
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 16
; Joined path conditions
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(push) ; 16
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 17
(assert (not (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-add-rows          107
;  :arith-assert-diseq      11
;  :arith-assert-lower      350
;  :arith-assert-upper      208
;  :arith-bound-prop        11
;  :arith-conflicts         39
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         36
;  :arith-grobner           40
;  :arith-max-min           387
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        43
;  :arith-pivots            80
;  :conflicts               58
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   58
;  :datatype-splits         43
;  :decisions               109
;  :del-clause              374
;  :final-checks            77
;  :interface-eqs           1
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             947
;  :mk-clause               389
;  :num-allocs              144922
;  :num-checks              48
;  :propagations            247
;  :quant-instantiations    156
;  :rlimit-count            162147)
(assert (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 16
; Joined path conditions
(assert (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               554
;  :arith-add-rows          127
;  :arith-assert-diseq      13
;  :arith-assert-lower      387
;  :arith-assert-upper      237
;  :arith-bound-prop        14
;  :arith-conflicts         45
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         46
;  :arith-grobner           40
;  :arith-max-min           407
;  :arith-nonlinear-bounds  34
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        58
;  :arith-pivots            100
;  :conflicts               70
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   63
;  :datatype-splits         51
;  :decisions               144
;  :del-clause              476
;  :final-checks            84
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             1112
;  :mk-clause               514
;  :num-allocs              145718
;  :num-checks              49
;  :propagations            324
;  :quant-instantiations    189
;  :rlimit-count            164939
;  :time                    0.00)
; [eval] aloc(opt_get1(target), i3)
; [eval] opt_get1(target)
(push) ; 16
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 16
; Joined path conditions
(push) ; 16
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 17
(assert (not (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               554
;  :arith-add-rows          127
;  :arith-assert-diseq      13
;  :arith-assert-lower      387
;  :arith-assert-upper      237
;  :arith-bound-prop        14
;  :arith-conflicts         45
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         46
;  :arith-grobner           40
;  :arith-max-min           407
;  :arith-nonlinear-bounds  34
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        58
;  :arith-pivots            100
;  :conflicts               70
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   63
;  :datatype-splits         51
;  :decisions               144
;  :del-clause              476
;  :final-checks            84
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.25
;  :mk-bool-var             1112
;  :mk-clause               514
;  :num-allocs              145745
;  :num-checks              50
;  :propagations            324
;  :quant-instantiations    189
;  :rlimit-count            164969)
(assert (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 16
; Joined path conditions
(assert (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               750
;  :arith-add-rows          152
;  :arith-assert-diseq      14
;  :arith-assert-lower      425
;  :arith-assert-upper      273
;  :arith-bound-prop        23
;  :arith-conflicts         51
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         60
;  :arith-grobner           40
;  :arith-max-min           427
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        82
;  :arith-pivots            122
;  :conflicts               84
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   70
;  :datatype-splits         61
;  :decisions               184
;  :del-clause              584
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.30
;  :memory                  4.30
;  :mk-bool-var             1289
;  :mk-clause               635
;  :num-allocs              146613
;  :num-checks              51
;  :propagations            407
;  :quant-instantiations    223
;  :rlimit-count            168047
;  :time                    0.00)
(pop) ; 15
(push) ; 15
; [else-branch: 30 | !(i3@30@02 < V@7@02)]
(assert (not (< i3@30@02 V@7@02)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (< i3@30@02 V@7@02)
  (and
    (< i3@30@02 V@7@02)
    (not (= target@8@02 (as None<option<array>>  option<array>)))
    (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
    (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 29 | !(0 <= i3@30@02)]
(assert (not (<= 0 i3@30@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (<= 0 i3@30@02)
  (and
    (<= 0 i3@30@02)
    (implies
      (< i3@30@02 V@7@02)
      (and
        (< i3@30@02 V@7@02)
        (not (= target@8@02 (as None<option<array>>  option<array>)))
        (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
        (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 28 | !(i2@29@02 < V@7@02)]
(assert (not (< i2@29@02 V@7@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (< i2@29@02 V@7@02)
  (and
    (< i2@29@02 V@7@02)
    (implies
      (<= 0 i3@30@02)
      (and
        (<= 0 i3@30@02)
        (implies
          (< i3@30@02 V@7@02)
          (and
            (< i3@30@02 V@7@02)
            (not (= target@8@02 (as None<option<array>>  option<array>)))
            (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
            (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))))))))
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 27 | !(0 <= i2@29@02)]
(assert (not (<= 0 i2@29@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (<= 0 i2@29@02)
  (and
    (<= 0 i2@29@02)
    (implies
      (< i2@29@02 V@7@02)
      (and
        (< i2@29@02 V@7@02)
        (implies
          (<= 0 i3@30@02)
          (and
            (<= 0 i3@30@02)
            (implies
              (< i3@30@02 V@7@02)
              (and
                (< i3@30@02 V@7@02)
                (not (= target@8@02 (as None<option<array>>  option<array>)))
                (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))))))))))
; Joined path conditions
(push) ; 8
; [then-branch: 31 | Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i2@29@02)) == Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i3@30@02)) && i3@30@02 < V@7@02 && 0 <= i3@30@02 && i2@29@02 < V@7@02 && 0 <= i2@29@02 | live]
; [else-branch: 31 | !(Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i2@29@02)) == Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i3@30@02)) && i3@30@02 < V@7@02 && 0 <= i3@30@02 && i2@29@02 < V@7@02 && 0 <= i2@29@02) | live]
(push) ; 9
; [then-branch: 31 | Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i2@29@02)) == Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i3@30@02)) && i3@30@02 < V@7@02 && 0 <= i3@30@02 && i2@29@02 < V@7@02 && 0 <= i2@29@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
          ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
        (< i3@30@02 V@7@02))
      (<= 0 i3@30@02))
    (< i2@29@02 V@7@02))
  (<= 0 i2@29@02)))
; [eval] i2 == i3
(pop) ; 9
(push) ; 9
; [else-branch: 31 | !(Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i2@29@02)) == Lookup(option$array$,sm@26@02,aloc((_, _), opt_get1(_, target@8@02), i3@30@02)) && i3@30@02 < V@7@02 && 0 <= i3@30@02 && i2@29@02 < V@7@02 && 0 <= i2@29@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
            ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
          (< i3@30@02 V@7@02))
        (<= 0 i3@30@02))
      (< i2@29@02 V@7@02))
    (<= 0 i2@29@02))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
            ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
          (< i3@30@02 V@7@02))
        (<= 0 i3@30@02))
      (< i2@29@02 V@7@02))
    (<= 0 i2@29@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
      ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
    (< i3@30@02 V@7@02)
    (<= 0 i3@30@02)
    (< i2@29@02 V@7@02)
    (<= 0 i2@29@02))))
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@30@02 Int)) (!
  (and
    (implies
      (<= 0 i2@29@02)
      (and
        (<= 0 i2@29@02)
        (implies
          (< i2@29@02 V@7@02)
          (and
            (< i2@29@02 V@7@02)
            (implies
              (<= 0 i3@30@02)
              (and
                (<= 0 i3@30@02)
                (implies
                  (< i3@30@02 V@7@02)
                  (and
                    (< i3@30@02 V@7@02)
                    (not (= target@8@02 (as None<option<array>>  option<array>)))
                    (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                    (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
              (< i3@30@02 V@7@02))
            (<= 0 i3@30@02))
          (< i2@29@02 V@7@02))
        (<= 0 i2@29@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
          ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
        (< i3@30@02 V@7@02)
        (<= 0 i3@30@02)
        (< i2@29@02 V@7@02)
        (<= 0 i2@29@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@29@02 Int)) (!
  (forall ((i3@30@02 Int)) (!
    (and
      (implies
        (<= 0 i2@29@02)
        (and
          (<= 0 i2@29@02)
          (implies
            (< i2@29@02 V@7@02)
            (and
              (< i2@29@02 V@7@02)
              (implies
                (<= 0 i3@30@02)
                (and
                  (<= 0 i3@30@02)
                  (implies
                    (< i3@30@02 V@7@02)
                    (and
                      (< i3@30@02 V@7@02)
                      (not
                        (= target@8@02 (as None<option<array>>  option<array>)))
                      (< i2@29@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                      (< i3@30@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                  ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
                (< i3@30@02 V@7@02))
              (<= 0 i3@30@02))
            (< i2@29@02 V@7@02))
          (<= 0 i2@29@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
            ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
          (< i3@30@02 V@7@02)
          (<= 0 i3@30@02)
          (< i2@29@02 V@7@02)
          (<= 0 i2@29@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@29@02 Int)) (!
    (forall ((i3@30@02 Int)) (!
      (and
        (implies
          (<= 0 i2@29@02)
          (and
            (<= 0 i2@29@02)
            (implies
              (< i2@29@02 V@7@02)
              (and
                (< i2@29@02 V@7@02)
                (implies
                  (<= 0 i3@30@02)
                  (and
                    (<= 0 i3@30@02)
                    (implies
                      (< i3@30@02 V@7@02)
                      (and
                        (< i3@30@02 V@7@02)
                        (not
                          (= target@8@02 (as None<option<array>>  option<array>)))
                        (<
                          i2@29@02
                          (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                        (<
                          i3@30@02
                          (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
                  (< i3@30@02 V@7@02))
                (<= 0 i3@30@02))
              (< i2@29@02 V@7@02))
            (<= 0 i2@29@02))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
              ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
            (< i3@30@02 V@7@02)
            (<= 0 i3@30@02)
            (< i2@29@02 V@7@02)
            (<= 0 i2@29@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@29@02 Int)) (!
    (forall ((i3@30@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
                  ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02)))
                (< i3@30@02 V@7@02))
              (<= 0 i3@30@02))
            (< i2@29@02 V@7@02))
          (<= 0 i2@29@02))
        (= i2@29@02 i3@30@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@30@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@29@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
  $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@10@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
  $Snap.unit))
; [eval] i1 < V
(assert (< i1@10@02 V@7@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
  $Snap.unit))
; [eval] 0 <= j
(assert (<= 0 j@11@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
  $Snap.unit))
; [eval] j < V
(assert (< j@11@02 V@7@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))))
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not (= target@8@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               779
;  :arith-add-rows          152
;  :arith-assert-diseq      14
;  :arith-assert-lower      429
;  :arith-assert-upper      273
;  :arith-bound-prop        23
;  :arith-conflicts         51
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         60
;  :arith-grobner           40
;  :arith-max-min           427
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        82
;  :arith-pivots            125
;  :conflicts               84
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   70
;  :datatype-splits         61
;  :decisions               184
;  :del-clause              644
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.31
;  :memory                  4.30
;  :mk-bool-var             1317
;  :mk-clause               659
;  :num-allocs              147867
;  :num-checks              52
;  :propagations            407
;  :quant-instantiations    223
;  :rlimit-count            171383)
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               779
;  :arith-add-rows          152
;  :arith-assert-diseq      14
;  :arith-assert-lower      429
;  :arith-assert-upper      273
;  :arith-bound-prop        23
;  :arith-conflicts         51
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         60
;  :arith-grobner           40
;  :arith-max-min           427
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        82
;  :arith-pivots            125
;  :conflicts               84
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   70
;  :datatype-splits         61
;  :decisions               184
;  :del-clause              644
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.31
;  :memory                  4.30
;  :mk-bool-var             1317
;  :mk-clause               659
;  :num-allocs              147888
;  :num-checks              53
;  :propagations            407
;  :quant-instantiations    223
;  :rlimit-count            171414)
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 4
; Joined path conditions
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))
(push) ; 4
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               884
;  :arith-add-rows          178
;  :arith-assert-diseq      16
;  :arith-assert-lower      470
;  :arith-assert-upper      303
;  :arith-bound-prop        25
;  :arith-conflicts         57
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         70
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        94
;  :arith-pivots            142
;  :conflicts               98
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   75
;  :datatype-splits         71
;  :decisions               223
;  :del-clause              761
;  :final-checks            101
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.35
;  :memory                  4.34
;  :mk-bool-var             1503
;  :mk-clause               799
;  :num-allocs              148703
;  :num-checks              54
;  :propagations            486
;  :quant-instantiations    261
;  :rlimit-count            174642
;  :time                    0.00)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               884
;  :arith-add-rows          178
;  :arith-assert-diseq      16
;  :arith-assert-lower      470
;  :arith-assert-upper      303
;  :arith-bound-prop        25
;  :arith-conflicts         57
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         70
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        94
;  :arith-pivots            142
;  :conflicts               99
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   75
;  :datatype-splits         71
;  :decisions               223
;  :del-clause              761
;  :final-checks            101
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.35
;  :memory                  4.34
;  :mk-bool-var             1503
;  :mk-clause               799
;  :num-allocs              148794
;  :num-checks              55
;  :propagations            486
;  :quant-instantiations    261
;  :rlimit-count            174737)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               888
;  :arith-add-rows          180
;  :arith-assert-diseq      16
;  :arith-assert-lower      472
;  :arith-assert-upper      303
;  :arith-bound-prop        27
;  :arith-conflicts         57
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         70
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        94
;  :arith-pivots            144
;  :conflicts               100
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   75
;  :datatype-splits         71
;  :decisions               223
;  :del-clause              767
;  :final-checks            101
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.35
;  :memory                  4.34
;  :mk-bool-var             1514
;  :mk-clause               805
;  :num-allocs              148992
;  :num-checks              56
;  :propagations            486
;  :quant-instantiations    268
;  :rlimit-count            175152)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
    $Ref.null)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not (= source@9@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               903
;  :arith-add-rows          182
;  :arith-assert-diseq      16
;  :arith-assert-lower      474
;  :arith-assert-upper      305
;  :arith-bound-prop        27
;  :arith-conflicts         57
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         71
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        94
;  :arith-pivots            145
;  :conflicts               101
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   75
;  :datatype-splits         71
;  :decisions               223
;  :del-clause              767
;  :final-checks            101
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.35
;  :memory                  4.34
;  :mk-bool-var             1535
;  :mk-clause               815
;  :num-allocs              149220
;  :num-checks              57
;  :propagations            492
;  :quant-instantiations    280
;  :rlimit-count            175681)
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               903
;  :arith-add-rows          187
;  :arith-assert-diseq      16
;  :arith-assert-lower      474
;  :arith-assert-upper      306
;  :arith-bound-prop        27
;  :arith-conflicts         58
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         71
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        94
;  :arith-pivots            147
;  :conflicts               102
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   75
;  :datatype-splits         71
;  :decisions               223
;  :del-clause              767
;  :final-checks            101
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.35
;  :memory                  4.34
;  :mk-bool-var             1536
;  :mk-clause               815
;  :num-allocs              149366
;  :num-checks              58
;  :propagations            492
;  :quant-instantiations    280
;  :rlimit-count            175908)
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 4
; Joined path conditions
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(declare-const sm@31@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r))
  :qid |qp.fvfValDef5|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r))
  :qid |qp.fvfValDef6|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef7|)))
(declare-const pm@32@02 $FPM)
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_option$array$ (as pm@32@02  $FPM) r)
    (+
      (ite
        (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02)
        $Perm.No)
      (ite
        (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02)
        $Perm.No)))
  :pattern (($FVF.perm_option$array$ (as pm@32@02  $FPM) r))
  :qid |qp.resPrmSumDef8|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r) r))
  :pattern (($FVF.perm_option$array$ (as pm@32@02  $FPM) r))
  :qid |qp.resTrgDef9|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))
(push) ; 4
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@32@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1044
;  :arith-add-rows          223
;  :arith-assert-diseq      16
;  :arith-assert-lower      512
;  :arith-assert-upper      338
;  :arith-bound-prop        32
;  :arith-conflicts         64
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         85
;  :arith-grobner           40
;  :arith-max-min           468
;  :arith-nonlinear-bounds  46
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        121
;  :arith-pivots            167
;  :conflicts               112
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 87
;  :datatype-occurs-check   80
;  :datatype-splits         81
;  :decisions               268
;  :del-clause              908
;  :final-checks            108
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.44
;  :memory                  4.43
;  :minimized-lits          1
;  :mk-bool-var             1740
;  :mk-clause               976
;  :num-allocs              151094
;  :num-checks              59
;  :propagations            589
;  :quant-instantiations    328
;  :rlimit-count            181890
;  :time                    0.00)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1098
;  :arith-add-rows          234
;  :arith-assert-diseq      16
;  :arith-assert-lower      520
;  :arith-assert-upper      350
;  :arith-bound-prop        34
;  :arith-conflicts         67
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         89
;  :arith-grobner           40
;  :arith-max-min           477
;  :arith-nonlinear-bounds  48
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        127
;  :arith-pivots            171
;  :conflicts               119
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 92
;  :datatype-occurs-check   82
;  :datatype-splits         85
;  :decisions               288
;  :del-clause              969
;  :final-checks            111
;  :interface-eqs           12
;  :max-generation          3
;  :max-memory              4.44
;  :memory                  4.43
;  :minimized-lits          1
;  :mk-bool-var             1815
;  :mk-clause               1037
;  :num-allocs              151330
;  :num-checks              60
;  :propagations            614
;  :quant-instantiations    339
;  :rlimit-count            182954)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1180
;  :arith-add-rows          248
;  :arith-assert-diseq      16
;  :arith-assert-lower      534
;  :arith-assert-upper      364
;  :arith-bound-prop        37
;  :arith-conflicts         71
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         95
;  :arith-grobner           40
;  :arith-max-min           486
;  :arith-nonlinear-bounds  50
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        138
;  :arith-pivots            177
;  :conflicts               126
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 97
;  :datatype-occurs-check   84
;  :datatype-splits         89
;  :decisions               309
;  :del-clause              1032
;  :final-checks            114
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.44
;  :memory                  4.43
;  :minimized-lits          1
;  :mk-bool-var             1908
;  :mk-clause               1100
;  :num-allocs              151692
;  :num-checks              61
;  :propagations            650
;  :quant-instantiations    359
;  :rlimit-count            184518
;  :time                    0.00)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1318
;  :arith-add-rows          297
;  :arith-assert-diseq      16
;  :arith-assert-lower      576
;  :arith-assert-upper      404
;  :arith-bound-prop        41
;  :arith-conflicts         77
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         103
;  :arith-grobner           56
;  :arith-max-min           542
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  44
;  :arith-offset-eqs        156
;  :arith-pivots            193
;  :conflicts               134
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   94
;  :datatype-splits         103
;  :decisions               354
;  :del-clause              1141
;  :final-checks            126
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.52
;  :memory                  4.49
;  :minimized-lits          1
;  :mk-bool-var             2052
;  :mk-clause               1209
;  :num-allocs              154516
;  :num-checks              62
;  :propagations            711
;  :quant-instantiations    393
;  :rlimit-count            194412
;  :time                    0.00)
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02)
    $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 4
(declare-const $t@33@02 $Snap)
(assert (= $t@33@02 ($Snap.combine ($Snap.first $t@33@02) ($Snap.second $t@33@02))))
(assert (= ($Snap.first $t@33@02) $Snap.unit))
; [eval] exc == null
(assert (= exc@12@02 $Ref.null))
(assert (=
  ($Snap.second $t@33@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@33@02))
    ($Snap.second ($Snap.second $t@33@02)))))
(assert (= ($Snap.first ($Snap.second $t@33@02)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 32 | exc@12@02 == Null | live]
; [else-branch: 32 | exc@12@02 != Null | live]
(push) ; 6
; [then-branch: 32 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 32 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1487
;  :arith-add-rows          357
;  :arith-assert-diseq      16
;  :arith-assert-lower      634
;  :arith-assert-upper      458
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         111
;  :arith-grobner           85
;  :arith-max-min           634
;  :arith-nonlinear-bounds  61
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        169
;  :arith-pivots            204
;  :conflicts               141
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   110
;  :datatype-splits         124
;  :decisions               412
;  :del-clause              1308
;  :final-checks            145
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.53
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             2219
;  :mk-clause               1339
;  :num-allocs              159005
;  :num-checks              64
;  :propagations            785
;  :quant-instantiations    427
;  :rlimit-count            208502
;  :time                    0.00)
(push) ; 6
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1487
;  :arith-add-rows          357
;  :arith-assert-diseq      16
;  :arith-assert-lower      634
;  :arith-assert-upper      458
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         111
;  :arith-grobner           85
;  :arith-max-min           634
;  :arith-nonlinear-bounds  61
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        169
;  :arith-pivots            204
;  :conflicts               141
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   110
;  :datatype-splits         124
;  :decisions               412
;  :del-clause              1308
;  :final-checks            145
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.53
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             2219
;  :mk-clause               1339
;  :num-allocs              159023
;  :num-checks              65
;  :propagations            785
;  :quant-instantiations    427
;  :rlimit-count            208519)
; [then-branch: 33 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 33 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 6
; [then-branch: 33 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (not (= source@9@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@33@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@33@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@33@02))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 34 | exc@12@02 == Null | live]
; [else-branch: 34 | exc@12@02 != Null | live]
(push) ; 6
; [then-branch: 34 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 34 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1517
;  :arith-add-rows          357
;  :arith-assert-diseq      16
;  :arith-assert-lower      652
;  :arith-assert-upper      474
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         111
;  :arith-grobner           99
;  :arith-max-min           670
;  :arith-nonlinear-bounds  62
;  :arith-nonlinear-horner  78
;  :arith-offset-eqs        169
;  :arith-pivots            204
;  :conflicts               141
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 141
;  :datatype-occurs-check   116
;  :datatype-splits         131
;  :decisions               426
;  :del-clause              1328
;  :final-checks            152
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             2245
;  :mk-clause               1359
;  :num-allocs              161153
;  :num-checks              66
;  :propagations            796
;  :quant-instantiations    432
;  :rlimit-count            214213
;  :time                    0.00)
(push) ; 6
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1517
;  :arith-add-rows          357
;  :arith-assert-diseq      16
;  :arith-assert-lower      652
;  :arith-assert-upper      474
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         111
;  :arith-grobner           99
;  :arith-max-min           670
;  :arith-nonlinear-bounds  62
;  :arith-nonlinear-horner  78
;  :arith-offset-eqs        169
;  :arith-pivots            204
;  :conflicts               141
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 141
;  :datatype-occurs-check   116
;  :datatype-splits         131
;  :decisions               426
;  :del-clause              1328
;  :final-checks            152
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             2245
;  :mk-clause               1359
;  :num-allocs              161171
;  :num-checks              67
;  :propagations            796
;  :quant-instantiations    432
;  :rlimit-count            214230)
; [then-branch: 35 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 35 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 6
; [then-branch: 35 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
; Joined path conditions
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit source@9@02)) V@7@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@33@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 36 | exc@12@02 == Null | live]
; [else-branch: 36 | exc@12@02 != Null | live]
(push) ; 6
; [then-branch: 36 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 36 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1549
;  :arith-add-rows          357
;  :arith-assert-diseq      16
;  :arith-assert-lower      670
;  :arith-assert-upper      490
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         111
;  :arith-grobner           113
;  :arith-max-min           706
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  89
;  :arith-offset-eqs        169
;  :arith-pivots            204
;  :conflicts               141
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 149
;  :datatype-occurs-check   122
;  :datatype-splits         139
;  :decisions               441
;  :del-clause              1348
;  :final-checks            159
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.51
;  :minimized-lits          1
;  :mk-bool-var             2271
;  :mk-clause               1379
;  :num-allocs              163320
;  :num-checks              68
;  :propagations            807
;  :quant-instantiations    437
;  :rlimit-count            219962
;  :time                    0.00)
(push) ; 5
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1549
;  :arith-add-rows          357
;  :arith-assert-diseq      16
;  :arith-assert-lower      670
;  :arith-assert-upper      490
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         111
;  :arith-grobner           113
;  :arith-max-min           706
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  89
;  :arith-offset-eqs        169
;  :arith-pivots            204
;  :conflicts               141
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 149
;  :datatype-occurs-check   122
;  :datatype-splits         139
;  :decisions               441
;  :del-clause              1348
;  :final-checks            159
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.51
;  :minimized-lits          1
;  :mk-bool-var             2271
;  :mk-clause               1379
;  :num-allocs              163338
;  :num-checks              69
;  :propagations            807
;  :quant-instantiations    437
;  :rlimit-count            219979)
; [then-branch: 37 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 37 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 5
; [then-branch: 37 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
(declare-const i2@34@02 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 38 | 0 <= i2@34@02 | live]
; [else-branch: 38 | !(0 <= i2@34@02) | live]
(push) ; 8
; [then-branch: 38 | 0 <= i2@34@02]
(assert (<= 0 i2@34@02))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 38 | !(0 <= i2@34@02)]
(assert (not (<= 0 i2@34@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< i2@34@02 V@7@02) (<= 0 i2@34@02)))
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
; Joined path conditions
(push) ; 7
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 8
(assert (not (< i2@34@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1549
;  :arith-add-rows          358
;  :arith-assert-diseq      16
;  :arith-assert-lower      672
;  :arith-assert-upper      490
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         111
;  :arith-grobner           113
;  :arith-max-min           706
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  89
;  :arith-offset-eqs        169
;  :arith-pivots            205
;  :conflicts               141
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 149
;  :datatype-occurs-check   122
;  :datatype-splits         139
;  :decisions               441
;  :del-clause              1348
;  :final-checks            159
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.51
;  :minimized-lits          1
;  :mk-bool-var             2273
;  :mk-clause               1379
;  :num-allocs              163443
;  :num-checks              70
;  :propagations            807
;  :quant-instantiations    437
;  :rlimit-count            220180)
(assert (< i2@34@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 7
; Joined path conditions
(assert (< i2@34@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 7
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 8
(assert (not (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1549
;  :arith-add-rows          358
;  :arith-assert-diseq      16
;  :arith-assert-lower      672
;  :arith-assert-upper      490
;  :arith-bound-prop        46
;  :arith-conflicts         82
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         111
;  :arith-grobner           113
;  :arith-max-min           706
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  89
;  :arith-offset-eqs        169
;  :arith-pivots            205
;  :conflicts               142
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 149
;  :datatype-occurs-check   122
;  :datatype-splits         139
;  :decisions               441
;  :del-clause              1348
;  :final-checks            159
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.51
;  :minimized-lits          1
;  :mk-bool-var             2273
;  :mk-clause               1379
;  :num-allocs              163587
;  :num-checks              71
;  :propagations            807
;  :quant-instantiations    437
;  :rlimit-count            220292)
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(pop) ; 7
; Joined path conditions
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(declare-const $k@35@02 $Perm)
(assert ($Perm.isReadVar $k@35@02 $Perm.Write))
(pop) ; 6
(declare-fun inv@36@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@35@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@34@02 Int)) (!
  (and
    (< i2@34@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@34@02))
  :qid |option$array$-aux|)))
(push) ; 6
(assert (not (forall ((i2@34@02 Int)) (!
  (implies
    (and (< i2@34@02 V@7@02) (<= 0 i2@34@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1549
;  :arith-add-rows          359
;  :arith-assert-diseq      18
;  :arith-assert-lower      686
;  :arith-assert-upper      499
;  :arith-bound-prop        46
;  :arith-conflicts         83
;  :arith-eq-adapter        151
;  :arith-fixed-eqs         111
;  :arith-grobner           113
;  :arith-max-min           721
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  89
;  :arith-offset-eqs        169
;  :arith-pivots            208
;  :conflicts               143
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 149
;  :datatype-occurs-check   122
;  :datatype-splits         139
;  :decisions               447
;  :del-clause              1367
;  :final-checks            160
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.50
;  :minimized-lits          1
;  :mk-bool-var             2298
;  :mk-clause               1400
;  :num-allocs              164261
;  :num-checks              72
;  :propagations            817
;  :quant-instantiations    443
;  :rlimit-count            221511)
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((i21@34@02 Int) (i22@34@02 Int)) (!
  (implies
    (and
      (and
        (and (< i21@34@02 V@7@02) (<= 0 i21@34@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@35@02)))
      (and
        (and (< i22@34@02 V@7@02) (<= 0 i22@34@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@35@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i21@34@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i22@34@02)))
    (= i21@34@02 i22@34@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1558
;  :arith-add-rows          365
;  :arith-assert-diseq      19
;  :arith-assert-lower      691
;  :arith-assert-upper      499
;  :arith-bound-prop        46
;  :arith-conflicts         83
;  :arith-eq-adapter        152
;  :arith-fixed-eqs         111
;  :arith-grobner           113
;  :arith-max-min           721
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  89
;  :arith-offset-eqs        169
;  :arith-pivots            210
;  :conflicts               144
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 149
;  :datatype-occurs-check   122
;  :datatype-splits         139
;  :decisions               447
;  :del-clause              1377
;  :final-checks            160
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.51
;  :minimized-lits          1
;  :mk-bool-var             2321
;  :mk-clause               1410
;  :num-allocs              164675
;  :num-checks              73
;  :propagations            821
;  :quant-instantiations    454
;  :rlimit-count            222330)
; Definitional axioms for inverse functions
(assert (forall ((i2@34@02 Int)) (!
  (implies
    (and
      (and (< i2@34@02 V@7@02) (<= 0 i2@34@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02)))
    (=
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@34@02))
      i2@34@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@34@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@36@02 r) V@7@02) (<= 0 (inv@36@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) (inv@36@02 r))
      r))
  :pattern ((inv@36@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@34@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@34@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@34@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@34@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@34@02 Int)) (!
  (implies
    (and
      (and (< i2@34@02 V@7@02) (<= 0 i2@34@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@34@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@34@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@37@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@36@02 r) V@7@02) (<= 0 (inv@36@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r))
  :qid |qp.fvfValDef10|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef11|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@36@02 r) V@7@02) (<= 0 (inv@36@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) r) r))
  :pattern ((inv@36@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 39 | exc@12@02 == Null | live]
; [else-branch: 39 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 39 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 39 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1661
;  :arith-add-rows          385
;  :arith-assert-diseq      19
;  :arith-assert-lower      729
;  :arith-assert-upper      531
;  :arith-bound-prop        47
;  :arith-conflicts         85
;  :arith-eq-adapter        155
;  :arith-fixed-eqs         113
;  :arith-grobner           128
;  :arith-max-min           784
;  :arith-nonlinear-bounds  69
;  :arith-nonlinear-horner  101
;  :arith-offset-eqs        178
;  :arith-pivots            215
;  :conflicts               148
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 165
;  :datatype-occurs-check   133
;  :datatype-splits         151
;  :decisions               488
;  :del-clause              1484
;  :final-checks            169
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.63
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             2464
;  :mk-clause               1518
;  :num-allocs              168428
;  :num-checks              74
;  :propagations            859
;  :quant-instantiations    476
;  :rlimit-count            232877
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1661
;  :arith-add-rows          385
;  :arith-assert-diseq      19
;  :arith-assert-lower      729
;  :arith-assert-upper      531
;  :arith-bound-prop        47
;  :arith-conflicts         85
;  :arith-eq-adapter        155
;  :arith-fixed-eqs         113
;  :arith-grobner           128
;  :arith-max-min           784
;  :arith-nonlinear-bounds  69
;  :arith-nonlinear-horner  101
;  :arith-offset-eqs        178
;  :arith-pivots            215
;  :conflicts               148
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 165
;  :datatype-occurs-check   133
;  :datatype-splits         151
;  :decisions               488
;  :del-clause              1484
;  :final-checks            169
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.63
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             2464
;  :mk-clause               1518
;  :num-allocs              168446
;  :num-checks              75
;  :propagations            859
;  :quant-instantiations    476
;  :rlimit-count            232894)
; [then-branch: 40 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 40 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 7
; [then-branch: 40 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
(declare-const i2@38@02 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 41 | 0 <= i2@38@02 | live]
; [else-branch: 41 | !(0 <= i2@38@02) | live]
(push) ; 10
; [then-branch: 41 | 0 <= i2@38@02]
(assert (<= 0 i2@38@02))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 41 | !(0 <= i2@38@02)]
(assert (not (<= 0 i2@38@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 42 | i2@38@02 < V@7@02 && 0 <= i2@38@02 | live]
; [else-branch: 42 | !(i2@38@02 < V@7@02 && 0 <= i2@38@02) | live]
(push) ; 10
; [then-branch: 42 | i2@38@02 < V@7@02 && 0 <= i2@38@02]
(assert (and (< i2@38@02 V@7@02) (<= 0 i2@38@02)))
; [eval] aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 12
(assert (not (< i2@38@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1661
;  :arith-add-rows          386
;  :arith-assert-diseq      19
;  :arith-assert-lower      731
;  :arith-assert-upper      531
;  :arith-bound-prop        47
;  :arith-conflicts         85
;  :arith-eq-adapter        155
;  :arith-fixed-eqs         113
;  :arith-grobner           128
;  :arith-max-min           784
;  :arith-nonlinear-bounds  69
;  :arith-nonlinear-horner  101
;  :arith-offset-eqs        178
;  :arith-pivots            215
;  :conflicts               148
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 165
;  :datatype-occurs-check   133
;  :datatype-splits         151
;  :decisions               488
;  :del-clause              1484
;  :final-checks            169
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.63
;  :memory                  4.59
;  :minimized-lits          1
;  :mk-bool-var             2466
;  :mk-clause               1518
;  :num-allocs              168545
;  :num-checks              76
;  :propagations            859
;  :quant-instantiations    476
;  :rlimit-count            233099)
(assert (< i2@38@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 11
; Joined path conditions
(assert (< i2@38@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))
      V@7@02)
    (<=
      0
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1700
;  :arith-add-rows          524
;  :arith-assert-diseq      23
;  :arith-assert-lower      745
;  :arith-assert-upper      547
;  :arith-bound-prop        55
;  :arith-conflicts         87
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         117
;  :arith-grobner           128
;  :arith-max-min           799
;  :arith-nonlinear-bounds  71
;  :arith-nonlinear-horner  101
;  :arith-offset-eqs        187
;  :arith-pivots            228
;  :conflicts               157
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 165
;  :datatype-occurs-check   133
;  :datatype-splits         151
;  :decisions               508
;  :del-clause              1583
;  :final-checks            170
;  :interface-eqs           27
;  :max-generation          6
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          1
;  :mk-bool-var             2670
;  :mk-clause               1672
;  :num-allocs              169611
;  :num-checks              77
;  :propagations            907
;  :quant-instantiations    524
;  :rlimit-count            238133
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 10
(push) ; 10
; [else-branch: 42 | !(i2@38@02 < V@7@02 && 0 <= i2@38@02)]
(assert (not (and (< i2@38@02 V@7@02) (<= 0 i2@38@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@38@02 V@7@02) (<= 0 i2@38@02))
  (and
    (< i2@38@02 V@7@02)
    (<= 0 i2@38@02)
    (< i2@38@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@38@02 Int)) (!
  (implies
    (and (< i2@38@02 V@7@02) (<= 0 i2@38@02))
    (and
      (< i2@38@02 V@7@02)
      (<= 0 i2@38@02)
      (< i2@38@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (and
    (< 0 V@7@02)
    (= exc@12@02 $Ref.null)
    (forall ((i2@38@02 Int)) (!
      (implies
        (and (< i2@38@02 V@7@02) (<= 0 i2@38@02))
        (and
          (< i2@38@02 V@7@02)
          (<= 0 i2@38@02)
          (< i2@38@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (forall ((i2@38@02 Int)) (!
    (implies
      (and (< i2@38@02 V@7@02) (<= 0 i2@38@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@38@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 43 | exc@12@02 == Null | live]
; [else-branch: 43 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 43 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 43 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1830
;  :arith-add-rows          578
;  :arith-assert-diseq      23
;  :arith-assert-lower      783
;  :arith-assert-upper      579
;  :arith-bound-prop        56
;  :arith-conflicts         89
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         120
;  :arith-grobner           143
;  :arith-max-min           862
;  :arith-nonlinear-bounds  75
;  :arith-nonlinear-horner  113
;  :arith-offset-eqs        198
;  :arith-pivots            237
;  :conflicts               161
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   147
;  :datatype-splits         169
;  :decisions               554
;  :del-clause              1731
;  :final-checks            181
;  :interface-eqs           30
;  :max-generation          6
;  :max-memory              4.69
;  :memory                  4.65
;  :minimized-lits          1
;  :mk-bool-var             2814
;  :mk-clause               1784
;  :num-allocs              172458
;  :num-checks              78
;  :propagations            949
;  :quant-instantiations    546
;  :rlimit-count            247316
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1830
;  :arith-add-rows          578
;  :arith-assert-diseq      23
;  :arith-assert-lower      783
;  :arith-assert-upper      579
;  :arith-bound-prop        56
;  :arith-conflicts         89
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         120
;  :arith-grobner           143
;  :arith-max-min           862
;  :arith-nonlinear-bounds  75
;  :arith-nonlinear-horner  113
;  :arith-offset-eqs        198
;  :arith-pivots            237
;  :conflicts               161
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   147
;  :datatype-splits         169
;  :decisions               554
;  :del-clause              1731
;  :final-checks            181
;  :interface-eqs           30
;  :max-generation          6
;  :max-memory              4.69
;  :memory                  4.65
;  :minimized-lits          1
;  :mk-bool-var             2814
;  :mk-clause               1784
;  :num-allocs              172476
;  :num-checks              79
;  :propagations            949
;  :quant-instantiations    546
;  :rlimit-count            247333)
; [then-branch: 44 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 44 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 7
; [then-branch: 44 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
(declare-const i2@39@02 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 45 | 0 <= i2@39@02 | live]
; [else-branch: 45 | !(0 <= i2@39@02) | live]
(push) ; 10
; [then-branch: 45 | 0 <= i2@39@02]
(assert (<= 0 i2@39@02))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 45 | !(0 <= i2@39@02)]
(assert (not (<= 0 i2@39@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 46 | i2@39@02 < V@7@02 && 0 <= i2@39@02 | live]
; [else-branch: 46 | !(i2@39@02 < V@7@02 && 0 <= i2@39@02) | live]
(push) ; 10
; [then-branch: 46 | i2@39@02 < V@7@02 && 0 <= i2@39@02]
(assert (and (< i2@39@02 V@7@02) (<= 0 i2@39@02)))
; [eval] alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(source), i2).option$array$))
; [eval] opt_get1(aloc(opt_get1(source), i2).option$array$)
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 12
(assert (not (< i2@39@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1830
;  :arith-add-rows          578
;  :arith-assert-diseq      23
;  :arith-assert-lower      785
;  :arith-assert-upper      579
;  :arith-bound-prop        56
;  :arith-conflicts         89
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         120
;  :arith-grobner           143
;  :arith-max-min           862
;  :arith-nonlinear-bounds  75
;  :arith-nonlinear-horner  113
;  :arith-offset-eqs        198
;  :arith-pivots            237
;  :conflicts               161
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   147
;  :datatype-splits         169
;  :decisions               554
;  :del-clause              1731
;  :final-checks            181
;  :interface-eqs           30
;  :max-generation          6
;  :max-memory              4.69
;  :memory                  4.65
;  :minimized-lits          1
;  :mk-bool-var             2816
;  :mk-clause               1784
;  :num-allocs              172575
;  :num-checks              80
;  :propagations            949
;  :quant-instantiations    546
;  :rlimit-count            247537)
(assert (< i2@39@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 11
; Joined path conditions
(assert (< i2@39@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
      V@7@02)
    (<=
      0
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1907
;  :arith-add-rows          719
;  :arith-assert-diseq      25
;  :arith-assert-lower      799
;  :arith-assert-upper      594
;  :arith-bound-prop        63
;  :arith-conflicts         91
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         124
;  :arith-grobner           143
;  :arith-max-min           877
;  :arith-nonlinear-bounds  77
;  :arith-nonlinear-horner  113
;  :arith-offset-eqs        206
;  :arith-pivots            249
;  :conflicts               170
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   150
;  :datatype-splits         175
;  :decisions               581
;  :del-clause              1803
;  :final-checks            184
;  :interface-eqs           31
;  :max-generation          6
;  :max-memory              4.70
;  :memory                  4.70
;  :minimized-lits          1
;  :mk-bool-var             2996
;  :mk-clause               1895
;  :num-allocs              173414
;  :num-checks              81
;  :propagations            992
;  :quant-instantiations    589
;  :rlimit-count            252545
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 12
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1907
;  :arith-add-rows          719
;  :arith-assert-diseq      25
;  :arith-assert-lower      799
;  :arith-assert-upper      594
;  :arith-bound-prop        63
;  :arith-conflicts         91
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         124
;  :arith-grobner           143
;  :arith-max-min           877
;  :arith-nonlinear-bounds  77
;  :arith-nonlinear-horner  113
;  :arith-offset-eqs        206
;  :arith-pivots            249
;  :conflicts               171
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 196
;  :datatype-occurs-check   150
;  :datatype-splits         175
;  :decisions               581
;  :del-clause              1803
;  :final-checks            184
;  :interface-eqs           31
;  :max-generation          6
;  :max-memory              4.70
;  :memory                  4.70
;  :minimized-lits          1
;  :mk-bool-var             2996
;  :mk-clause               1895
;  :num-allocs              173505
;  :num-checks              82
;  :propagations            992
;  :quant-instantiations    589
;  :rlimit-count            252640)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
    (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
    (as None<option<array>>  option<array>))))
(pop) ; 10
(push) ; 10
; [else-branch: 46 | !(i2@39@02 < V@7@02 && 0 <= i2@39@02)]
(assert (not (and (< i2@39@02 V@7@02) (<= 0 i2@39@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@39@02 V@7@02) (<= 0 i2@39@02))
  (and
    (< i2@39@02 V@7@02)
    (<= 0 i2@39@02)
    (< i2@39@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@39@02 Int)) (!
  (implies
    (and (< i2@39@02 V@7@02) (<= 0 i2@39@02))
    (and
      (< i2@39@02 V@7@02)
      (<= 0 i2@39@02)
      (< i2@39@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (and
    (< 0 V@7@02)
    (= exc@12@02 $Ref.null)
    (forall ((i2@39@02 Int)) (!
      (implies
        (and (< i2@39@02 V@7@02) (<= 0 i2@39@02))
        (and
          (< i2@39@02 V@7@02)
          (<= 0 i2@39@02)
          (< i2@39@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (forall ((i2@39@02 Int)) (!
    (implies
      (and (< i2@39@02 V@7@02) (<= 0 i2@39@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@39@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 47 | exc@12@02 == Null | live]
; [else-branch: 47 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 47 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 47 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2048
;  :arith-add-rows          750
;  :arith-assert-diseq      25
;  :arith-assert-lower      831
;  :arith-assert-upper      620
;  :arith-bound-prop        64
;  :arith-conflicts         93
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         127
;  :arith-grobner           155
;  :arith-max-min           925
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  124
;  :arith-offset-eqs        229
;  :arith-pivots            258
;  :conflicts               175
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   164
;  :datatype-splits         193
;  :decisions               627
;  :del-clause              1935
;  :final-checks            195
;  :interface-eqs           34
;  :max-generation          6
;  :max-memory              4.75
;  :memory                  4.71
;  :minimized-lits          1
;  :mk-bool-var             3112
;  :mk-clause               1988
;  :num-allocs              177074
;  :num-checks              83
;  :propagations            1033
;  :quant-instantiations    602
;  :rlimit-count            261670
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2048
;  :arith-add-rows          750
;  :arith-assert-diseq      25
;  :arith-assert-lower      831
;  :arith-assert-upper      620
;  :arith-bound-prop        64
;  :arith-conflicts         93
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         127
;  :arith-grobner           155
;  :arith-max-min           925
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  124
;  :arith-offset-eqs        229
;  :arith-pivots            258
;  :conflicts               175
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   164
;  :datatype-splits         193
;  :decisions               627
;  :del-clause              1935
;  :final-checks            195
;  :interface-eqs           34
;  :max-generation          6
;  :max-memory              4.75
;  :memory                  4.71
;  :minimized-lits          1
;  :mk-bool-var             3112
;  :mk-clause               1988
;  :num-allocs              177092
;  :num-checks              84
;  :propagations            1033
;  :quant-instantiations    602
;  :rlimit-count            261687)
; [then-branch: 48 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 48 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 7
; [then-branch: 48 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
(declare-const i2@40@02 Int)
(push) ; 8
; [eval] (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3)
(declare-const i3@41@02 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 49 | 0 <= i2@40@02 | live]
; [else-branch: 49 | !(0 <= i2@40@02) | live]
(push) ; 11
; [then-branch: 49 | 0 <= i2@40@02]
(assert (<= 0 i2@40@02))
; [eval] i2 < V
(push) ; 12
; [then-branch: 50 | i2@40@02 < V@7@02 | live]
; [else-branch: 50 | !(i2@40@02 < V@7@02) | live]
(push) ; 13
; [then-branch: 50 | i2@40@02 < V@7@02]
(assert (< i2@40@02 V@7@02))
; [eval] 0 <= i3
(push) ; 14
; [then-branch: 51 | 0 <= i3@41@02 | live]
; [else-branch: 51 | !(0 <= i3@41@02) | live]
(push) ; 15
; [then-branch: 51 | 0 <= i3@41@02]
(assert (<= 0 i3@41@02))
; [eval] i3 < V
(push) ; 16
; [then-branch: 52 | i3@41@02 < V@7@02 | live]
; [else-branch: 52 | !(i3@41@02 < V@7@02) | live]
(push) ; 17
; [then-branch: 52 | i3@41@02 < V@7@02]
(assert (< i3@41@02 V@7@02))
; [eval] aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 18
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 18
; Joined path conditions
(push) ; 18
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 19
(assert (not (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2048
;  :arith-add-rows          750
;  :arith-assert-diseq      25
;  :arith-assert-lower      835
;  :arith-assert-upper      620
;  :arith-bound-prop        64
;  :arith-conflicts         93
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         127
;  :arith-grobner           155
;  :arith-max-min           925
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  124
;  :arith-offset-eqs        229
;  :arith-pivots            258
;  :conflicts               175
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   164
;  :datatype-splits         193
;  :decisions               627
;  :del-clause              1935
;  :final-checks            195
;  :interface-eqs           34
;  :max-generation          6
;  :max-memory              4.75
;  :memory                  4.71
;  :minimized-lits          1
;  :mk-bool-var             3116
;  :mk-clause               1988
;  :num-allocs              177374
;  :num-checks              85
;  :propagations            1033
;  :quant-instantiations    602
;  :rlimit-count            262035)
(assert (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 18
; Joined path conditions
(assert (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
      V@7@02)
    (<=
      0
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2082
;  :arith-add-rows          846
;  :arith-assert-diseq      27
;  :arith-assert-lower      851
;  :arith-assert-upper      634
;  :arith-bound-prop        71
;  :arith-conflicts         95
;  :arith-eq-adapter        183
;  :arith-fixed-eqs         131
;  :arith-grobner           155
;  :arith-max-min           940
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  124
;  :arith-offset-eqs        238
;  :arith-pivots            269
;  :conflicts               183
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   164
;  :datatype-splits         193
;  :decisions               646
;  :del-clause              2004
;  :final-checks            196
;  :interface-eqs           34
;  :max-generation          6
;  :max-memory              4.75
;  :memory                  4.73
;  :minimized-lits          1
;  :mk-bool-var             3266
;  :mk-clause               2096
;  :num-allocs              178134
;  :num-checks              86
;  :propagations            1075
;  :quant-instantiations    645
;  :rlimit-count            266119
;  :time                    0.00)
; [eval] aloc(opt_get1(source), i3)
; [eval] opt_get1(source)
(push) ; 18
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 18
; Joined path conditions
(push) ; 18
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 19
(assert (not (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2082
;  :arith-add-rows          846
;  :arith-assert-diseq      27
;  :arith-assert-lower      851
;  :arith-assert-upper      634
;  :arith-bound-prop        71
;  :arith-conflicts         95
;  :arith-eq-adapter        183
;  :arith-fixed-eqs         131
;  :arith-grobner           155
;  :arith-max-min           940
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  124
;  :arith-offset-eqs        238
;  :arith-pivots            269
;  :conflicts               183
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   164
;  :datatype-splits         193
;  :decisions               646
;  :del-clause              2004
;  :final-checks            196
;  :interface-eqs           34
;  :max-generation          6
;  :max-memory              4.75
;  :memory                  4.73
;  :minimized-lits          1
;  :mk-bool-var             3266
;  :mk-clause               2096
;  :num-allocs              178161
;  :num-checks              87
;  :propagations            1075
;  :quant-instantiations    645
;  :rlimit-count            266149)
(assert (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 18
; Joined path conditions
(assert (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))
      V@7@02)
    (<=
      0
      (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2131
;  :arith-add-rows          1015
;  :arith-assert-diseq      35
;  :arith-assert-lower      877
;  :arith-assert-upper      653
;  :arith-bound-prop        81
;  :arith-conflicts         100
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         136
;  :arith-grobner           155
;  :arith-max-min           955
;  :arith-nonlinear-bounds  85
;  :arith-nonlinear-horner  124
;  :arith-offset-eqs        245
;  :arith-pivots            286
;  :conflicts               194
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   164
;  :datatype-splits         193
;  :decisions               683
;  :del-clause              2160
;  :final-checks            197
;  :interface-eqs           34
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.94
;  :minimized-lits          1
;  :mk-bool-var             3533
;  :mk-clause               2311
;  :num-allocs              179377
;  :num-checks              88
;  :propagations            1155
;  :quant-instantiations    709
;  :rlimit-count            272583
;  :time                    0.00)
(pop) ; 17
(push) ; 17
; [else-branch: 52 | !(i3@41@02 < V@7@02)]
(assert (not (< i3@41@02 V@7@02)))
(pop) ; 17
(pop) ; 16
; Joined path conditions
(assert (implies
  (< i3@41@02 V@7@02)
  (and
    (< i3@41@02 V@7@02)
    (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
    (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))))
; Joined path conditions
(pop) ; 15
(push) ; 15
; [else-branch: 51 | !(0 <= i3@41@02)]
(assert (not (<= 0 i3@41@02)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (<= 0 i3@41@02)
  (and
    (<= 0 i3@41@02)
    (implies
      (< i3@41@02 V@7@02)
      (and
        (< i3@41@02 V@7@02)
        (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
        (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 50 | !(i2@40@02 < V@7@02)]
(assert (not (< i2@40@02 V@7@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (< i2@40@02 V@7@02)
  (and
    (< i2@40@02 V@7@02)
    (implies
      (<= 0 i3@41@02)
      (and
        (<= 0 i3@41@02)
        (implies
          (< i3@41@02 V@7@02)
          (and
            (< i3@41@02 V@7@02)
            (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
            (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 49 | !(0 <= i2@40@02)]
(assert (not (<= 0 i2@40@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (<= 0 i2@40@02)
  (and
    (<= 0 i2@40@02)
    (implies
      (< i2@40@02 V@7@02)
      (and
        (< i2@40@02 V@7@02)
        (implies
          (<= 0 i3@41@02)
          (and
            (<= 0 i3@41@02)
            (implies
              (< i3@41@02 V@7@02)
              (and
                (< i3@41@02 V@7@02)
                (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))))))))))
; Joined path conditions
(push) ; 10
; [then-branch: 53 | Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i2@40@02)) == Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i3@41@02)) && i3@41@02 < V@7@02 && 0 <= i3@41@02 && i2@40@02 < V@7@02 && 0 <= i2@40@02 | live]
; [else-branch: 53 | !(Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i2@40@02)) == Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i3@41@02)) && i3@41@02 < V@7@02 && 0 <= i3@41@02 && i2@40@02 < V@7@02 && 0 <= i2@40@02) | live]
(push) ; 11
; [then-branch: 53 | Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i2@40@02)) == Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i3@41@02)) && i3@41@02 < V@7@02 && 0 <= i3@41@02 && i2@40@02 < V@7@02 && 0 <= i2@40@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
          ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
        (< i3@41@02 V@7@02))
      (<= 0 i3@41@02))
    (< i2@40@02 V@7@02))
  (<= 0 i2@40@02)))
; [eval] i2 == i3
(pop) ; 11
(push) ; 11
; [else-branch: 53 | !(Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i2@40@02)) == Lookup(option$array$,sm@37@02,aloc((_, _), opt_get1(_, source@9@02), i3@41@02)) && i3@41@02 < V@7@02 && 0 <= i3@41@02 && i2@40@02 < V@7@02 && 0 <= i2@40@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
            ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
          (< i3@41@02 V@7@02))
        (<= 0 i3@41@02))
      (< i2@40@02 V@7@02))
    (<= 0 i2@40@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
            ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
          (< i3@41@02 V@7@02))
        (<= 0 i3@41@02))
      (< i2@40@02 V@7@02))
    (<= 0 i2@40@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
      ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
    (< i3@41@02 V@7@02)
    (<= 0 i3@41@02)
    (< i2@40@02 V@7@02)
    (<= 0 i2@40@02))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@41@02 Int)) (!
  (and
    (implies
      (<= 0 i2@40@02)
      (and
        (<= 0 i2@40@02)
        (implies
          (< i2@40@02 V@7@02)
          (and
            (< i2@40@02 V@7@02)
            (implies
              (<= 0 i3@41@02)
              (and
                (<= 0 i3@41@02)
                (implies
                  (< i3@41@02 V@7@02)
                  (and
                    (< i3@41@02 V@7@02)
                    (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                    (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
              (< i3@41@02 V@7@02))
            (<= 0 i3@41@02))
          (< i2@40@02 V@7@02))
        (<= 0 i2@40@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
          ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
        (< i3@41@02 V@7@02)
        (<= 0 i3@41@02)
        (< i2@40@02 V@7@02)
        (<= 0 i2@40@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@40@02 Int)) (!
  (forall ((i3@41@02 Int)) (!
    (and
      (implies
        (<= 0 i2@40@02)
        (and
          (<= 0 i2@40@02)
          (implies
            (< i2@40@02 V@7@02)
            (and
              (< i2@40@02 V@7@02)
              (implies
                (<= 0 i3@41@02)
                (and
                  (<= 0 i3@41@02)
                  (implies
                    (< i3@41@02 V@7@02)
                    (and
                      (< i3@41@02 V@7@02)
                      (< i2@40@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                      (< i3@41@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                  ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
                (< i3@41@02 V@7@02))
              (<= 0 i3@41@02))
            (< i2@40@02 V@7@02))
          (<= 0 i2@40@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
            ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
          (< i3@41@02 V@7@02)
          (<= 0 i3@41@02)
          (< i2@40@02 V@7@02)
          (<= 0 i2@40@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (and
    (< 0 V@7@02)
    (= exc@12@02 $Ref.null)
    (forall ((i2@40@02 Int)) (!
      (forall ((i3@41@02 Int)) (!
        (and
          (implies
            (<= 0 i2@40@02)
            (and
              (<= 0 i2@40@02)
              (implies
                (< i2@40@02 V@7@02)
                (and
                  (< i2@40@02 V@7@02)
                  (implies
                    (<= 0 i3@41@02)
                    (and
                      (<= 0 i3@41@02)
                      (implies
                        (< i3@41@02 V@7@02)
                        (and
                          (< i3@41@02 V@7@02)
                          (<
                            i2@40@02
                            (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                          (<
                            i3@41@02
                            (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                      ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
                    (< i3@41@02 V@7@02))
                  (<= 0 i3@41@02))
                (< i2@40@02 V@7@02))
              (<= 0 i2@40@02))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
              (< i3@41@02 V@7@02)
              (<= 0 i3@41@02)
              (< i2@40@02 V@7@02)
              (<= 0 i2@40@02))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (forall ((i2@40@02 Int)) (!
    (forall ((i3@41@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
                  ($FVF.lookup_option$array$ (as sm@37@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02)))
                (< i3@41@02 V@7@02))
              (<= 0 i3@41@02))
            (< i2@40@02 V@7@02))
          (<= 0 i2@40@02))
        (= i2@40@02 i3@41@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@41@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@40@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 54 | exc@12@02 == Null | live]
; [else-branch: 54 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 54 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 54 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2265
;  :arith-add-rows          1061
;  :arith-assert-diseq      35
;  :arith-assert-lower      909
;  :arith-assert-upper      679
;  :arith-bound-prop        82
;  :arith-conflicts         102
;  :arith-eq-adapter        193
;  :arith-fixed-eqs         139
;  :arith-grobner           167
;  :arith-max-min           1003
;  :arith-nonlinear-bounds  89
;  :arith-nonlinear-horner  135
;  :arith-offset-eqs        268
;  :arith-pivots            297
;  :conflicts               198
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 240
;  :datatype-occurs-check   178
;  :datatype-splits         211
;  :decisions               729
;  :del-clause              2375
;  :final-checks            208
;  :interface-eqs           37
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3671
;  :mk-clause               2428
;  :num-allocs              183605
;  :num-checks              89
;  :propagations            1196
;  :quant-instantiations    725
;  :rlimit-count            283810
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2265
;  :arith-add-rows          1061
;  :arith-assert-diseq      35
;  :arith-assert-lower      909
;  :arith-assert-upper      679
;  :arith-bound-prop        82
;  :arith-conflicts         102
;  :arith-eq-adapter        193
;  :arith-fixed-eqs         139
;  :arith-grobner           167
;  :arith-max-min           1003
;  :arith-nonlinear-bounds  89
;  :arith-nonlinear-horner  135
;  :arith-offset-eqs        268
;  :arith-pivots            297
;  :conflicts               198
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 240
;  :datatype-occurs-check   178
;  :datatype-splits         211
;  :decisions               729
;  :del-clause              2375
;  :final-checks            208
;  :interface-eqs           37
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3671
;  :mk-clause               2428
;  :num-allocs              183623
;  :num-checks              90
;  :propagations            1196
;  :quant-instantiations    725
;  :rlimit-count            283827)
; [then-branch: 55 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 55 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 7
; [then-branch: 55 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (not (= target@8@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 56 | exc@12@02 == Null | live]
; [else-branch: 56 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 56 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 56 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(push) ; 7
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2412
;  :arith-add-rows          1086
;  :arith-assert-diseq      35
;  :arith-assert-lower      946
;  :arith-assert-upper      712
;  :arith-bound-prop        83
;  :arith-conflicts         104
;  :arith-eq-adapter        198
;  :arith-fixed-eqs         141
;  :arith-grobner           182
;  :arith-max-min           1066
;  :arith-nonlinear-bounds  93
;  :arith-nonlinear-horner  147
;  :arith-offset-eqs        283
;  :arith-pivots            301
;  :conflicts               202
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   198
;  :datatype-splits         233
;  :decisions               779
;  :del-clause              2468
;  :final-checks            220
;  :interface-eqs           41
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3790
;  :mk-clause               2521
;  :num-allocs              186093
;  :num-checks              91
;  :propagations            1238
;  :quant-instantiations    738
;  :rlimit-count            291765
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2412
;  :arith-add-rows          1086
;  :arith-assert-diseq      35
;  :arith-assert-lower      946
;  :arith-assert-upper      712
;  :arith-bound-prop        83
;  :arith-conflicts         104
;  :arith-eq-adapter        198
;  :arith-fixed-eqs         141
;  :arith-grobner           182
;  :arith-max-min           1066
;  :arith-nonlinear-bounds  93
;  :arith-nonlinear-horner  147
;  :arith-offset-eqs        283
;  :arith-pivots            301
;  :conflicts               202
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 266
;  :datatype-occurs-check   198
;  :datatype-splits         233
;  :decisions               779
;  :del-clause              2468
;  :final-checks            220
;  :interface-eqs           41
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3790
;  :mk-clause               2521
;  :num-allocs              186111
;  :num-checks              92
;  :propagations            1238
;  :quant-instantiations    738
;  :rlimit-count            291782)
; [then-branch: 57 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 57 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 7
; [then-branch: 57 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 8
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit target@8@02)) V@7@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 58 | exc@12@02 == Null | live]
; [else-branch: 58 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 58 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 58 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2523
;  :arith-add-rows          1120
;  :arith-assert-diseq      35
;  :arith-assert-lower      983
;  :arith-assert-upper      743
;  :arith-bound-prop        84
;  :arith-conflicts         106
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         143
;  :arith-grobner           197
;  :arith-max-min           1129
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  159
;  :arith-offset-eqs        296
;  :arith-pivots            306
;  :conflicts               206
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 283
;  :datatype-occurs-check   209
;  :datatype-splits         246
;  :decisions               821
;  :del-clause              2557
;  :final-checks            229
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3895
;  :mk-clause               2610
;  :num-allocs              188514
;  :num-checks              93
;  :propagations            1275
;  :quant-instantiations    751
;  :rlimit-count            299750
;  :time                    0.00)
(push) ; 6
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2523
;  :arith-add-rows          1120
;  :arith-assert-diseq      35
;  :arith-assert-lower      983
;  :arith-assert-upper      743
;  :arith-bound-prop        84
;  :arith-conflicts         106
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         143
;  :arith-grobner           197
;  :arith-max-min           1129
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  159
;  :arith-offset-eqs        296
;  :arith-pivots            306
;  :conflicts               206
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 283
;  :datatype-occurs-check   209
;  :datatype-splits         246
;  :decisions               821
;  :del-clause              2557
;  :final-checks            229
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3895
;  :mk-clause               2610
;  :num-allocs              188532
;  :num-checks              94
;  :propagations            1275
;  :quant-instantiations    751
;  :rlimit-count            299767)
; [then-branch: 59 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 59 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 6
; [then-branch: 59 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
(declare-const i2@42@02 Int)
(push) ; 7
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 8
; [then-branch: 60 | 0 <= i2@42@02 | live]
; [else-branch: 60 | !(0 <= i2@42@02) | live]
(push) ; 9
; [then-branch: 60 | 0 <= i2@42@02]
(assert (<= 0 i2@42@02))
; [eval] i2 < V
(pop) ; 9
(push) ; 9
; [else-branch: 60 | !(0 <= i2@42@02)]
(assert (not (<= 0 i2@42@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< i2@42@02 V@7@02) (<= 0 i2@42@02)))
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 8
; Joined path conditions
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 9
(assert (not (< i2@42@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2523
;  :arith-add-rows          1120
;  :arith-assert-diseq      35
;  :arith-assert-lower      985
;  :arith-assert-upper      743
;  :arith-bound-prop        84
;  :arith-conflicts         106
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         143
;  :arith-grobner           197
;  :arith-max-min           1129
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  159
;  :arith-offset-eqs        296
;  :arith-pivots            307
;  :conflicts               206
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 283
;  :datatype-occurs-check   209
;  :datatype-splits         246
;  :decisions               821
;  :del-clause              2557
;  :final-checks            229
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3897
;  :mk-clause               2610
;  :num-allocs              188637
;  :num-checks              95
;  :propagations            1275
;  :quant-instantiations    751
;  :rlimit-count            299965)
(assert (< i2@42@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 8
; Joined path conditions
(assert (< i2@42@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 8
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 9
(assert (not (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2523
;  :arith-add-rows          1120
;  :arith-assert-diseq      35
;  :arith-assert-lower      985
;  :arith-assert-upper      743
;  :arith-bound-prop        84
;  :arith-conflicts         106
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         143
;  :arith-grobner           197
;  :arith-max-min           1129
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  159
;  :arith-offset-eqs        296
;  :arith-pivots            307
;  :conflicts               207
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 283
;  :datatype-occurs-check   209
;  :datatype-splits         246
;  :decisions               821
;  :del-clause              2557
;  :final-checks            229
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.95
;  :minimized-lits          1
;  :mk-bool-var             3897
;  :mk-clause               2610
;  :num-allocs              188781
;  :num-checks              96
;  :propagations            1275
;  :quant-instantiations    751
;  :rlimit-count            300077)
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(pop) ; 8
; Joined path conditions
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(declare-const $k@43@02 $Perm)
(assert ($Perm.isReadVar $k@43@02 $Perm.Write))
(pop) ; 7
(declare-fun inv@44@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@43@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@42@02 Int)) (!
  (and
    (< i2@42@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@42@02))
  :qid |option$array$-aux|)))
(push) ; 7
(assert (not (forall ((i2@42@02 Int)) (!
  (implies
    (and (< i2@42@02 V@7@02) (<= 0 i2@42@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2588
;  :arith-add-rows          1152
;  :arith-assert-diseq      37
;  :arith-assert-lower      1015
;  :arith-assert-upper      764
;  :arith-bound-prop        85
;  :arith-conflicts         109
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         145
;  :arith-grobner           197
;  :arith-max-min           1166
;  :arith-nonlinear-bounds  103
;  :arith-nonlinear-horner  159
;  :arith-offset-eqs        305
;  :arith-pivots            312
;  :conflicts               211
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 293
;  :datatype-occurs-check   212
;  :datatype-splits         253
;  :decisions               855
;  :del-clause              2644
;  :final-checks            232
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.94
;  :minimized-lits          1
;  :mk-bool-var             3993
;  :mk-clause               2699
;  :num-allocs              189607
;  :num-checks              97
;  :propagations            1312
;  :quant-instantiations    765
;  :rlimit-count            302903)
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((i21@42@02 Int) (i22@42@02 Int)) (!
  (implies
    (and
      (and
        (and (< i21@42@02 V@7@02) (<= 0 i21@42@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@43@02)))
      (and
        (and (< i22@42@02 V@7@02) (<= 0 i22@42@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@43@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i21@42@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i22@42@02)))
    (= i21@42@02 i22@42@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2595
;  :arith-add-rows          1156
;  :arith-assert-diseq      38
;  :arith-assert-lower      1020
;  :arith-assert-upper      764
;  :arith-bound-prop        85
;  :arith-conflicts         109
;  :arith-eq-adapter        205
;  :arith-fixed-eqs         145
;  :arith-grobner           197
;  :arith-max-min           1166
;  :arith-nonlinear-bounds  103
;  :arith-nonlinear-horner  159
;  :arith-offset-eqs        305
;  :arith-pivots            314
;  :conflicts               212
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 293
;  :datatype-occurs-check   212
;  :datatype-splits         253
;  :decisions               855
;  :del-clause              2650
;  :final-checks            232
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.05
;  :memory                  4.98
;  :minimized-lits          1
;  :mk-bool-var             4014
;  :mk-clause               2705
;  :num-allocs              189996
;  :num-checks              98
;  :propagations            1312
;  :quant-instantiations    776
;  :rlimit-count            303698)
; Definitional axioms for inverse functions
(assert (forall ((i2@42@02 Int)) (!
  (implies
    (and
      (and (< i2@42@02 V@7@02) (<= 0 i2@42@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02)))
    (=
      (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@42@02))
      i2@42@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@42@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@44@02 r) V@7@02) (<= 0 (inv@44@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) (inv@44@02 r))
      r))
  :pattern ((inv@44@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@42@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@43@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@42@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@42@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@43@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@42@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@42@02 Int)) (!
  (implies
    (and
      (and (< i2@42@02 V@7@02) (<= 0 i2@42@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@42@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@42@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@45@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@44@02 r) V@7@02) (<= 0 (inv@44@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@36@02 r) V@7@02) (<= 0 (inv@36@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r))
  :qid |qp.fvfValDef13|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef14|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@44@02 r) V@7@02) (<= 0 (inv@44@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) r) r))
  :pattern ((inv@44@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 61 | exc@12@02 == Null | live]
; [else-branch: 61 | exc@12@02 != Null | live]
(push) ; 8
; [then-branch: 61 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 61 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2870
;  :arith-add-rows          1262
;  :arith-assert-diseq      38
;  :arith-assert-lower      1074
;  :arith-assert-upper      812
;  :arith-bound-prop        89
;  :arith-conflicts         114
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         152
;  :arith-gcd-tests         1
;  :arith-grobner           210
;  :arith-ineq-splits       1
;  :arith-max-min           1244
;  :arith-nonlinear-bounds  112
;  :arith-nonlinear-horner  171
;  :arith-offset-eqs        333
;  :arith-patches           1
;  :arith-pivots            331
;  :conflicts               222
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 328
;  :datatype-occurs-check   230
;  :datatype-splits         279
;  :decisions               964
;  :del-clause              2934
;  :final-checks            246
;  :interface-eqs           46
;  :max-generation          6
;  :max-memory              5.09
;  :memory                  5.05
;  :minimized-lits          1
;  :mk-bool-var             4366
;  :mk-clause               2991
;  :num-allocs              195691
;  :num-checks              99
;  :propagations            1427
;  :quant-instantiations    831
;  :rlimit-count            321046
;  :time                    0.01)
(push) ; 8
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2870
;  :arith-add-rows          1262
;  :arith-assert-diseq      38
;  :arith-assert-lower      1074
;  :arith-assert-upper      812
;  :arith-bound-prop        89
;  :arith-conflicts         114
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         152
;  :arith-gcd-tests         1
;  :arith-grobner           210
;  :arith-ineq-splits       1
;  :arith-max-min           1244
;  :arith-nonlinear-bounds  112
;  :arith-nonlinear-horner  171
;  :arith-offset-eqs        333
;  :arith-patches           1
;  :arith-pivots            331
;  :conflicts               222
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 328
;  :datatype-occurs-check   230
;  :datatype-splits         279
;  :decisions               964
;  :del-clause              2934
;  :final-checks            246
;  :interface-eqs           46
;  :max-generation          6
;  :max-memory              5.09
;  :memory                  5.05
;  :minimized-lits          1
;  :mk-bool-var             4366
;  :mk-clause               2991
;  :num-allocs              195709
;  :num-checks              100
;  :propagations            1427
;  :quant-instantiations    831
;  :rlimit-count            321063)
; [then-branch: 62 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 62 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 8
; [then-branch: 62 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
(declare-const i2@46@02 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 63 | 0 <= i2@46@02 | live]
; [else-branch: 63 | !(0 <= i2@46@02) | live]
(push) ; 11
; [then-branch: 63 | 0 <= i2@46@02]
(assert (<= 0 i2@46@02))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 63 | !(0 <= i2@46@02)]
(assert (not (<= 0 i2@46@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 64 | i2@46@02 < V@7@02 && 0 <= i2@46@02 | live]
; [else-branch: 64 | !(i2@46@02 < V@7@02 && 0 <= i2@46@02) | live]
(push) ; 11
; [then-branch: 64 | i2@46@02 < V@7@02 && 0 <= i2@46@02]
(assert (and (< i2@46@02 V@7@02) (<= 0 i2@46@02)))
; [eval] aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 12
; Joined path conditions
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 13
(assert (not (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2870
;  :arith-add-rows          1262
;  :arith-assert-diseq      38
;  :arith-assert-lower      1076
;  :arith-assert-upper      812
;  :arith-bound-prop        89
;  :arith-conflicts         114
;  :arith-eq-adapter        210
;  :arith-fixed-eqs         152
;  :arith-gcd-tests         1
;  :arith-grobner           210
;  :arith-ineq-splits       1
;  :arith-max-min           1244
;  :arith-nonlinear-bounds  112
;  :arith-nonlinear-horner  171
;  :arith-offset-eqs        333
;  :arith-patches           1
;  :arith-pivots            331
;  :conflicts               222
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 328
;  :datatype-occurs-check   230
;  :datatype-splits         279
;  :decisions               964
;  :del-clause              2934
;  :final-checks            246
;  :interface-eqs           46
;  :max-generation          6
;  :max-memory              5.09
;  :memory                  5.05
;  :minimized-lits          1
;  :mk-bool-var             4368
;  :mk-clause               2991
;  :num-allocs              195808
;  :num-checks              101
;  :propagations            1427
;  :quant-instantiations    831
;  :rlimit-count            321267)
(assert (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 12
; Joined path conditions
(assert (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))
          V@7@02)
        (<=
          0
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@43@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))
          V@7@02)
        (<=
          0
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3154
;  :arith-add-rows          1394
;  :arith-assert-diseq      47
;  :arith-assert-lower      1129
;  :arith-assert-upper      853
;  :arith-bound-prop        101
;  :arith-conflicts         119
;  :arith-eq-adapter        227
;  :arith-fixed-eqs         164
;  :arith-gcd-tests         1
;  :arith-grobner           210
;  :arith-ineq-splits       1
;  :arith-max-min           1280
;  :arith-nonlinear-bounds  118
;  :arith-nonlinear-horner  171
;  :arith-offset-eqs        351
;  :arith-patches           1
;  :arith-pivots            353
;  :conflicts               242
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 356
;  :datatype-occurs-check   238
;  :datatype-splits         299
;  :decisions               1060
;  :del-clause              3182
;  :final-checks            253
;  :interface-eqs           48
;  :max-generation          6
;  :max-memory              5.09
;  :memory                  5.07
;  :minimized-lits          2
;  :mk-bool-var             4945
;  :mk-clause               3308
;  :num-allocs              197449
;  :num-checks              102
;  :propagations            1579
;  :quant-instantiations    909
;  :rlimit-count            328607
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 11
(push) ; 11
; [else-branch: 64 | !(i2@46@02 < V@7@02 && 0 <= i2@46@02)]
(assert (not (and (< i2@46@02 V@7@02) (<= 0 i2@46@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@46@02 V@7@02) (<= 0 i2@46@02))
  (and
    (< i2@46@02 V@7@02)
    (<= 0 i2@46@02)
    (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02)))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@46@02 Int)) (!
  (implies
    (and (< i2@46@02 V@7@02) (<= 0 i2@46@02))
    (and
      (< i2@46@02 V@7@02)
      (<= 0 i2@46@02)
      (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (and
    (< 0 V@7@02)
    (= exc@12@02 $Ref.null)
    (forall ((i2@46@02 Int)) (!
      (implies
        (and (< i2@46@02 V@7@02) (<= 0 i2@46@02))
        (and
          (< i2@46@02 V@7@02)
          (<= 0 i2@46@02)
          (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (forall ((i2@46@02 Int)) (!
    (implies
      (and (< i2@46@02 V@7@02) (<= 0 i2@46@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@46@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 65 | exc@12@02 == Null | live]
; [else-branch: 65 | exc@12@02 != Null | live]
(push) ; 8
; [then-branch: 65 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 65 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3553
;  :arith-add-rows          1481
;  :arith-assert-diseq      47
;  :arith-assert-lower      1189
;  :arith-assert-upper      911
;  :arith-bound-prop        105
;  :arith-conflicts         123
;  :arith-eq-adapter        236
;  :arith-fixed-eqs         171
;  :arith-gcd-tests         1
;  :arith-grobner           226
;  :arith-ineq-splits       1
;  :arith-max-min           1376
;  :arith-nonlinear-bounds  127
;  :arith-nonlinear-horner  184
;  :arith-offset-eqs        374
;  :arith-patches           1
;  :arith-pivots            373
;  :conflicts               253
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 414
;  :datatype-occurs-check   273
;  :datatype-splits         346
;  :decisions               1181
;  :del-clause              3511
;  :final-checks            272
;  :interface-eqs           55
;  :max-generation          6
;  :max-memory              5.14
;  :memory                  5.09
;  :minimized-lits          2
;  :mk-bool-var             5315
;  :mk-clause               3600
;  :num-allocs              201628
;  :num-checks              103
;  :propagations            1697
;  :quant-instantiations    960
;  :rlimit-count            343420
;  :time                    0.01)
(push) ; 8
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3553
;  :arith-add-rows          1481
;  :arith-assert-diseq      47
;  :arith-assert-lower      1189
;  :arith-assert-upper      911
;  :arith-bound-prop        105
;  :arith-conflicts         123
;  :arith-eq-adapter        236
;  :arith-fixed-eqs         171
;  :arith-gcd-tests         1
;  :arith-grobner           226
;  :arith-ineq-splits       1
;  :arith-max-min           1376
;  :arith-nonlinear-bounds  127
;  :arith-nonlinear-horner  184
;  :arith-offset-eqs        374
;  :arith-patches           1
;  :arith-pivots            373
;  :conflicts               253
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 414
;  :datatype-occurs-check   273
;  :datatype-splits         346
;  :decisions               1181
;  :del-clause              3511
;  :final-checks            272
;  :interface-eqs           55
;  :max-generation          6
;  :max-memory              5.14
;  :memory                  5.09
;  :minimized-lits          2
;  :mk-bool-var             5315
;  :mk-clause               3600
;  :num-allocs              201646
;  :num-checks              104
;  :propagations            1697
;  :quant-instantiations    960
;  :rlimit-count            343437)
; [then-branch: 66 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 66 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 8
; [then-branch: 66 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
(declare-const i2@47@02 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 67 | 0 <= i2@47@02 | live]
; [else-branch: 67 | !(0 <= i2@47@02) | live]
(push) ; 11
; [then-branch: 67 | 0 <= i2@47@02]
(assert (<= 0 i2@47@02))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 67 | !(0 <= i2@47@02)]
(assert (not (<= 0 i2@47@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 68 | i2@47@02 < V@7@02 && 0 <= i2@47@02 | live]
; [else-branch: 68 | !(i2@47@02 < V@7@02 && 0 <= i2@47@02) | live]
(push) ; 11
; [then-branch: 68 | i2@47@02 < V@7@02 && 0 <= i2@47@02]
(assert (and (< i2@47@02 V@7@02) (<= 0 i2@47@02)))
; [eval] alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(target), i2).option$array$))
; [eval] opt_get1(aloc(opt_get1(target), i2).option$array$)
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 12
; Joined path conditions
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 13
(assert (not (< i2@47@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3553
;  :arith-add-rows          1481
;  :arith-assert-diseq      47
;  :arith-assert-lower      1191
;  :arith-assert-upper      911
;  :arith-bound-prop        105
;  :arith-conflicts         123
;  :arith-eq-adapter        236
;  :arith-fixed-eqs         171
;  :arith-gcd-tests         1
;  :arith-grobner           226
;  :arith-ineq-splits       1
;  :arith-max-min           1376
;  :arith-nonlinear-bounds  127
;  :arith-nonlinear-horner  184
;  :arith-offset-eqs        374
;  :arith-patches           1
;  :arith-pivots            373
;  :conflicts               253
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 414
;  :datatype-occurs-check   273
;  :datatype-splits         346
;  :decisions               1181
;  :del-clause              3511
;  :final-checks            272
;  :interface-eqs           55
;  :max-generation          6
;  :max-memory              5.14
;  :memory                  5.09
;  :minimized-lits          2
;  :mk-bool-var             5317
;  :mk-clause               3600
;  :num-allocs              201745
;  :num-checks              105
;  :propagations            1697
;  :quant-instantiations    960
;  :rlimit-count            343641)
(assert (< i2@47@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 12
; Joined path conditions
(assert (< i2@47@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
          V@7@02)
        (<=
          0
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@43@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
          V@7@02)
        (<=
          0
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3889
;  :arith-add-rows          1717
;  :arith-assert-diseq      59
;  :arith-assert-lower      1251
;  :arith-assert-upper      963
;  :arith-bound-prop        118
;  :arith-conflicts         130
;  :arith-eq-adapter        257
;  :arith-fixed-eqs         185
;  :arith-gcd-tests         1
;  :arith-grobner           226
;  :arith-ineq-splits       1
;  :arith-max-min           1412
;  :arith-nonlinear-bounds  133
;  :arith-nonlinear-horner  184
;  :arith-offset-eqs        404
;  :arith-patches           1
;  :arith-pivots            403
;  :conflicts               277
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 447
;  :datatype-occurs-check   283
;  :datatype-splits         370
;  :decisions               1300
;  :del-clause              3873
;  :final-checks            281
;  :interface-eqs           58
;  :max-generation          6
;  :max-memory              5.14
;  :memory                  5.11
;  :minimized-lits          2
;  :mk-bool-var             6075
;  :mk-clause               4007
;  :num-allocs              203596
;  :num-checks              106
;  :propagations            1899
;  :quant-instantiations    1054
;  :rlimit-count            353591
;  :time                    0.00)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 13
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3889
;  :arith-add-rows          1717
;  :arith-assert-diseq      59
;  :arith-assert-lower      1251
;  :arith-assert-upper      963
;  :arith-bound-prop        118
;  :arith-conflicts         130
;  :arith-eq-adapter        257
;  :arith-fixed-eqs         185
;  :arith-gcd-tests         1
;  :arith-grobner           226
;  :arith-ineq-splits       1
;  :arith-max-min           1412
;  :arith-nonlinear-bounds  133
;  :arith-nonlinear-horner  184
;  :arith-offset-eqs        404
;  :arith-patches           1
;  :arith-pivots            403
;  :conflicts               278
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 447
;  :datatype-occurs-check   283
;  :datatype-splits         370
;  :decisions               1300
;  :del-clause              3873
;  :final-checks            281
;  :interface-eqs           58
;  :max-generation          6
;  :max-memory              5.14
;  :memory                  5.11
;  :minimized-lits          2
;  :mk-bool-var             6075
;  :mk-clause               4007
;  :num-allocs              203686
;  :num-checks              107
;  :propagations            1899
;  :quant-instantiations    1054
;  :rlimit-count            353686)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
    (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
    (as None<option<array>>  option<array>))))
(pop) ; 11
(push) ; 11
; [else-branch: 68 | !(i2@47@02 < V@7@02 && 0 <= i2@47@02)]
(assert (not (and (< i2@47@02 V@7@02) (<= 0 i2@47@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@47@02 V@7@02) (<= 0 i2@47@02))
  (and
    (< i2@47@02 V@7@02)
    (<= 0 i2@47@02)
    (< i2@47@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@47@02 Int)) (!
  (implies
    (and (< i2@47@02 V@7@02) (<= 0 i2@47@02))
    (and
      (< i2@47@02 V@7@02)
      (<= 0 i2@47@02)
      (< i2@47@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (and
    (< 0 V@7@02)
    (= exc@12@02 $Ref.null)
    (forall ((i2@47@02 Int)) (!
      (implies
        (and (< i2@47@02 V@7@02) (<= 0 i2@47@02))
        (and
          (< i2@47@02 V@7@02)
          (<= 0 i2@47@02)
          (< i2@47@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (forall ((i2@47@02 Int)) (!
    (implies
      (and (< i2@47@02 V@7@02) (<= 0 i2@47@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@47@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 69 | exc@12@02 == Null | live]
; [else-branch: 69 | exc@12@02 != Null | live]
(push) ; 8
; [then-branch: 69 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 69 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4290
;  :arith-add-rows          1813
;  :arith-assert-diseq      59
;  :arith-assert-lower      1315
;  :arith-assert-upper      1023
;  :arith-bound-prop        121
;  :arith-conflicts         136
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         194
;  :arith-gcd-tests         2
;  :arith-grobner           243
;  :arith-ineq-splits       2
;  :arith-max-min           1509
;  :arith-nonlinear-bounds  142
;  :arith-nonlinear-horner  198
;  :arith-offset-eqs        429
;  :arith-patches           2
;  :arith-pivots            424
;  :conflicts               291
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   320
;  :datatype-splits         417
;  :decisions               1423
;  :del-clause              4180
;  :final-checks            301
;  :interface-eqs           65
;  :max-generation          6
;  :max-memory              5.17
;  :memory                  5.13
;  :minimized-lits          2
;  :mk-bool-var             6404
;  :mk-clause               4269
;  :num-allocs              207727
;  :num-checks              108
;  :propagations            2015
;  :quant-instantiations    1092
;  :rlimit-count            369090
;  :time                    0.01)
(push) ; 8
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4290
;  :arith-add-rows          1813
;  :arith-assert-diseq      59
;  :arith-assert-lower      1315
;  :arith-assert-upper      1023
;  :arith-bound-prop        121
;  :arith-conflicts         136
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         194
;  :arith-gcd-tests         2
;  :arith-grobner           243
;  :arith-ineq-splits       2
;  :arith-max-min           1509
;  :arith-nonlinear-bounds  142
;  :arith-nonlinear-horner  198
;  :arith-offset-eqs        429
;  :arith-patches           2
;  :arith-pivots            424
;  :conflicts               291
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   320
;  :datatype-splits         417
;  :decisions               1423
;  :del-clause              4180
;  :final-checks            301
;  :interface-eqs           65
;  :max-generation          6
;  :max-memory              5.17
;  :memory                  5.13
;  :minimized-lits          2
;  :mk-bool-var             6404
;  :mk-clause               4269
;  :num-allocs              207745
;  :num-checks              109
;  :propagations            2015
;  :quant-instantiations    1092
;  :rlimit-count            369107)
; [then-branch: 70 | 0 < V@7@02 && exc@12@02 == Null | live]
; [else-branch: 70 | !(0 < V@7@02 && exc@12@02 == Null) | dead]
(push) ; 8
; [then-branch: 70 | 0 < V@7@02 && exc@12@02 == Null]
(assert (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
(declare-const i2@48@02 Int)
(push) ; 9
; [eval] (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3)
(declare-const i3@49@02 Int)
(push) ; 10
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] 0 <= i2
(push) ; 11
; [then-branch: 71 | 0 <= i2@48@02 | live]
; [else-branch: 71 | !(0 <= i2@48@02) | live]
(push) ; 12
; [then-branch: 71 | 0 <= i2@48@02]
(assert (<= 0 i2@48@02))
; [eval] i2 < V
(push) ; 13
; [then-branch: 72 | i2@48@02 < V@7@02 | live]
; [else-branch: 72 | !(i2@48@02 < V@7@02) | live]
(push) ; 14
; [then-branch: 72 | i2@48@02 < V@7@02]
(assert (< i2@48@02 V@7@02))
; [eval] 0 <= i3
(push) ; 15
; [then-branch: 73 | 0 <= i3@49@02 | live]
; [else-branch: 73 | !(0 <= i3@49@02) | live]
(push) ; 16
; [then-branch: 73 | 0 <= i3@49@02]
(assert (<= 0 i3@49@02))
; [eval] i3 < V
(push) ; 17
; [then-branch: 74 | i3@49@02 < V@7@02 | live]
; [else-branch: 74 | !(i3@49@02 < V@7@02) | live]
(push) ; 18
; [then-branch: 74 | i3@49@02 < V@7@02]
(assert (< i3@49@02 V@7@02))
; [eval] aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 19
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 19
; Joined path conditions
(push) ; 19
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 20
(assert (not (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4290
;  :arith-add-rows          1813
;  :arith-assert-diseq      59
;  :arith-assert-lower      1319
;  :arith-assert-upper      1023
;  :arith-bound-prop        121
;  :arith-conflicts         136
;  :arith-eq-adapter        266
;  :arith-fixed-eqs         194
;  :arith-gcd-tests         2
;  :arith-grobner           243
;  :arith-ineq-splits       2
;  :arith-max-min           1509
;  :arith-nonlinear-bounds  142
;  :arith-nonlinear-horner  198
;  :arith-offset-eqs        429
;  :arith-patches           2
;  :arith-pivots            426
;  :conflicts               291
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   320
;  :datatype-splits         417
;  :decisions               1423
;  :del-clause              4180
;  :final-checks            301
;  :interface-eqs           65
;  :max-generation          6
;  :max-memory              5.17
;  :memory                  5.13
;  :minimized-lits          2
;  :mk-bool-var             6408
;  :mk-clause               4269
;  :num-allocs              208021
;  :num-checks              110
;  :propagations            2015
;  :quant-instantiations    1092
;  :rlimit-count            369465)
(assert (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 19
; Joined path conditions
(assert (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
          V@7@02)
        (<=
          0
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@43@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
          V@7@02)
        (<=
          0
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4453
;  :arith-add-rows          1975
;  :arith-assert-diseq      64
;  :arith-assert-lower      1369
;  :arith-assert-upper      1067
;  :arith-bound-prop        134
;  :arith-conflicts         142
;  :arith-eq-adapter        281
;  :arith-fixed-eqs         206
;  :arith-gcd-tests         2
;  :arith-grobner           243
;  :arith-ineq-splits       2
;  :arith-max-min           1545
;  :arith-nonlinear-bounds  148
;  :arith-nonlinear-horner  198
;  :arith-offset-eqs        447
;  :arith-patches           2
;  :arith-pivots            451
;  :conflicts               310
;  :datatype-accessor-ax    143
;  :datatype-constructor-ax 518
;  :datatype-occurs-check   323
;  :datatype-splits         424
;  :decisions               1520
;  :del-clause              4567
;  :final-checks            304
;  :interface-eqs           65
;  :max-generation          6
;  :max-memory              5.17
;  :memory                  5.14
;  :minimized-lits          3
;  :mk-bool-var             6941
;  :mk-clause               4701
;  :num-allocs              209275
;  :num-checks              111
;  :propagations            2180
;  :quant-instantiations    1187
;  :rlimit-count            377714
;  :time                    0.00)
; [eval] aloc(opt_get1(target), i3)
; [eval] opt_get1(target)
(push) ; 19
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 19
; Joined path conditions
(push) ; 19
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 20
(assert (not (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4453
;  :arith-add-rows          1975
;  :arith-assert-diseq      64
;  :arith-assert-lower      1369
;  :arith-assert-upper      1067
;  :arith-bound-prop        134
;  :arith-conflicts         142
;  :arith-eq-adapter        281
;  :arith-fixed-eqs         206
;  :arith-gcd-tests         2
;  :arith-grobner           243
;  :arith-ineq-splits       2
;  :arith-max-min           1545
;  :arith-nonlinear-bounds  148
;  :arith-nonlinear-horner  198
;  :arith-offset-eqs        447
;  :arith-patches           2
;  :arith-pivots            451
;  :conflicts               310
;  :datatype-accessor-ax    143
;  :datatype-constructor-ax 518
;  :datatype-occurs-check   323
;  :datatype-splits         424
;  :decisions               1520
;  :del-clause              4567
;  :final-checks            304
;  :interface-eqs           65
;  :max-generation          6
;  :max-memory              5.17
;  :memory                  5.14
;  :minimized-lits          3
;  :mk-bool-var             6941
;  :mk-clause               4701
;  :num-allocs              209302
;  :num-checks              112
;  :propagations            2180
;  :quant-instantiations    1187
;  :rlimit-count            377744)
(assert (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 19
; Joined path conditions
(assert (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))
          V@7@02)
        (<=
          0
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@43@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))
          V@7@02)
        (<=
          0
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4771
;  :arith-add-rows          2338
;  :arith-assert-diseq      92
;  :arith-assert-lower      1448
;  :arith-assert-upper      1131
;  :arith-bound-prop        149
;  :arith-conflicts         152
;  :arith-eq-adapter        303
;  :arith-fixed-eqs         220
;  :arith-gcd-tests         2
;  :arith-grobner           243
;  :arith-ineq-splits       2
;  :arith-max-min           1581
;  :arith-nonlinear-bounds  154
;  :arith-nonlinear-horner  198
;  :arith-offset-eqs        491
;  :arith-patches           2
;  :arith-pivots            487
;  :conflicts               337
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 544
;  :datatype-occurs-check   330
;  :datatype-splits         441
;  :decisions               1666
;  :del-clause              5026
;  :final-checks            311
;  :interface-eqs           67
;  :max-generation          6
;  :max-memory              5.24
;  :memory                  5.24
;  :minimized-lits          3
;  :mk-bool-var             7837
;  :mk-clause               5225
;  :num-allocs              211534
;  :num-checks              113
;  :propagations            2420
;  :quant-instantiations    1312
;  :rlimit-count            391182
;  :time                    0.00)
(pop) ; 18
(push) ; 18
; [else-branch: 74 | !(i3@49@02 < V@7@02)]
(assert (not (< i3@49@02 V@7@02)))
(pop) ; 18
(pop) ; 17
; Joined path conditions
(assert (implies
  (< i3@49@02 V@7@02)
  (and
    (< i3@49@02 V@7@02)
    (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
    (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))))
; Joined path conditions
(pop) ; 16
(push) ; 16
; [else-branch: 73 | !(0 <= i3@49@02)]
(assert (not (<= 0 i3@49@02)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (implies
  (<= 0 i3@49@02)
  (and
    (<= 0 i3@49@02)
    (implies
      (< i3@49@02 V@7@02)
      (and
        (< i3@49@02 V@7@02)
        (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
        (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))))))
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 72 | !(i2@48@02 < V@7@02)]
(assert (not (< i2@48@02 V@7@02)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i2@48@02 V@7@02)
  (and
    (< i2@48@02 V@7@02)
    (implies
      (<= 0 i3@49@02)
      (and
        (<= 0 i3@49@02)
        (implies
          (< i3@49@02 V@7@02)
          (and
            (< i3@49@02 V@7@02)
            (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
            (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))))))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 71 | !(0 <= i2@48@02)]
(assert (not (<= 0 i2@48@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i2@48@02)
  (and
    (<= 0 i2@48@02)
    (implies
      (< i2@48@02 V@7@02)
      (and
        (< i2@48@02 V@7@02)
        (implies
          (<= 0 i3@49@02)
          (and
            (<= 0 i3@49@02)
            (implies
              (< i3@49@02 V@7@02)
              (and
                (< i3@49@02 V@7@02)
                (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))))))))))
; Joined path conditions
(push) ; 11
; [then-branch: 75 | Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i2@48@02)) == Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i3@49@02)) && i3@49@02 < V@7@02 && 0 <= i3@49@02 && i2@48@02 < V@7@02 && 0 <= i2@48@02 | live]
; [else-branch: 75 | !(Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i2@48@02)) == Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i3@49@02)) && i3@49@02 < V@7@02 && 0 <= i3@49@02 && i2@48@02 < V@7@02 && 0 <= i2@48@02) | live]
(push) ; 12
; [then-branch: 75 | Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i2@48@02)) == Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i3@49@02)) && i3@49@02 < V@7@02 && 0 <= i3@49@02 && i2@48@02 < V@7@02 && 0 <= i2@48@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
          ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
        (< i3@49@02 V@7@02))
      (<= 0 i3@49@02))
    (< i2@48@02 V@7@02))
  (<= 0 i2@48@02)))
; [eval] i2 == i3
(pop) ; 12
(push) ; 12
; [else-branch: 75 | !(Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i2@48@02)) == Lookup(option$array$,sm@45@02,aloc((_, _), opt_get1(_, target@8@02), i3@49@02)) && i3@49@02 < V@7@02 && 0 <= i3@49@02 && i2@48@02 < V@7@02 && 0 <= i2@48@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
            ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
          (< i3@49@02 V@7@02))
        (<= 0 i3@49@02))
      (< i2@48@02 V@7@02))
    (<= 0 i2@48@02))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
            ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
          (< i3@49@02 V@7@02))
        (<= 0 i3@49@02))
      (< i2@48@02 V@7@02))
    (<= 0 i2@48@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
      ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
    (< i3@49@02 V@7@02)
    (<= 0 i3@49@02)
    (< i2@48@02 V@7@02)
    (<= 0 i2@48@02))))
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@49@02 Int)) (!
  (and
    (implies
      (<= 0 i2@48@02)
      (and
        (<= 0 i2@48@02)
        (implies
          (< i2@48@02 V@7@02)
          (and
            (< i2@48@02 V@7@02)
            (implies
              (<= 0 i3@49@02)
              (and
                (<= 0 i3@49@02)
                (implies
                  (< i3@49@02 V@7@02)
                  (and
                    (< i3@49@02 V@7@02)
                    (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                    (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
              (< i3@49@02 V@7@02))
            (<= 0 i3@49@02))
          (< i2@48@02 V@7@02))
        (<= 0 i2@48@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
          ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
        (< i3@49@02 V@7@02)
        (<= 0 i3@49@02)
        (< i2@48@02 V@7@02)
        (<= 0 i2@48@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@48@02 Int)) (!
  (forall ((i3@49@02 Int)) (!
    (and
      (implies
        (<= 0 i2@48@02)
        (and
          (<= 0 i2@48@02)
          (implies
            (< i2@48@02 V@7@02)
            (and
              (< i2@48@02 V@7@02)
              (implies
                (<= 0 i3@49@02)
                (and
                  (<= 0 i3@49@02)
                  (implies
                    (< i3@49@02 V@7@02)
                    (and
                      (< i3@49@02 V@7@02)
                      (< i2@48@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                      (< i3@49@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                  ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
                (< i3@49@02 V@7@02))
              (<= 0 i3@49@02))
            (< i2@48@02 V@7@02))
          (<= 0 i2@48@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
            ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
          (< i3@49@02 V@7@02)
          (<= 0 i3@49@02)
          (< i2@48@02 V@7@02)
          (<= 0 i2@48@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (and
    (< 0 V@7@02)
    (= exc@12@02 $Ref.null)
    (forall ((i2@48@02 Int)) (!
      (forall ((i3@49@02 Int)) (!
        (and
          (implies
            (<= 0 i2@48@02)
            (and
              (<= 0 i2@48@02)
              (implies
                (< i2@48@02 V@7@02)
                (and
                  (< i2@48@02 V@7@02)
                  (implies
                    (<= 0 i3@49@02)
                    (and
                      (<= 0 i3@49@02)
                      (implies
                        (< i3@49@02 V@7@02)
                        (and
                          (< i3@49@02 V@7@02)
                          (<
                            i2@48@02
                            (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                          (<
                            i3@49@02
                            (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                      ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
                    (< i3@49@02 V@7@02))
                  (<= 0 i3@49@02))
                (< i2@48@02 V@7@02))
              (<= 0 i2@48@02))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
              (< i3@49@02 V@7@02)
              (<= 0 i3@49@02)
              (< i2@48@02 V@7@02)
              (<= 0 i2@48@02))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@02) (= exc@12@02 $Ref.null))
  (forall ((i2@48@02 Int)) (!
    (forall ((i3@49@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
                  ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02)))
                (< i3@49@02 V@7@02))
              (<= 0 i3@49@02))
            (< i2@48@02 V@7@02))
          (<= 0 i2@48@02))
        (= i2@48@02 i3@49@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@49@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@48@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5175
;  :arith-add-rows          2403
;  :arith-assert-diseq      92
;  :arith-assert-lower      1512
;  :arith-assert-upper      1190
;  :arith-bound-prop        152
;  :arith-conflicts         157
;  :arith-eq-adapter        312
;  :arith-fixed-eqs         228
;  :arith-gcd-tests         2
;  :arith-grobner           260
;  :arith-ineq-splits       2
;  :arith-max-min           1677
;  :arith-nonlinear-bounds  163
;  :arith-nonlinear-horner  212
;  :arith-offset-eqs        516
;  :arith-patches           2
;  :arith-pivots            508
;  :conflicts               349
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 602
;  :datatype-occurs-check   365
;  :datatype-splits         488
;  :decisions               1788
;  :del-clause              5422
;  :final-checks            330
;  :interface-eqs           74
;  :max-generation          6
;  :max-memory              5.29
;  :memory                  5.25
;  :minimized-lits          3
;  :mk-bool-var             8186
;  :mk-clause               5511
;  :num-allocs              216074
;  :num-checks              114
;  :propagations            2536
;  :quant-instantiations    1353
;  :rlimit-count            407707
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@02 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5175
;  :arith-add-rows          2403
;  :arith-assert-diseq      92
;  :arith-assert-lower      1512
;  :arith-assert-upper      1190
;  :arith-bound-prop        152
;  :arith-conflicts         157
;  :arith-eq-adapter        312
;  :arith-fixed-eqs         228
;  :arith-gcd-tests         2
;  :arith-grobner           260
;  :arith-ineq-splits       2
;  :arith-max-min           1677
;  :arith-nonlinear-bounds  163
;  :arith-nonlinear-horner  212
;  :arith-offset-eqs        516
;  :arith-patches           2
;  :arith-pivots            508
;  :conflicts               349
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 602
;  :datatype-occurs-check   365
;  :datatype-splits         488
;  :decisions               1788
;  :del-clause              5422
;  :final-checks            330
;  :interface-eqs           74
;  :max-generation          6
;  :max-memory              5.29
;  :memory                  5.25
;  :minimized-lits          3
;  :mk-bool-var             8186
;  :mk-clause               5511
;  :num-allocs              216092
;  :num-checks              115
;  :propagations            2536
;  :quant-instantiations    1353
;  :rlimit-count            407718)
; [then-branch: 76 | exc@12@02 == Null | live]
; [else-branch: 76 | exc@12@02 != Null | dead]
(push) ; 8
; [then-branch: 76 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 <= i1
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@02 $Ref.null) (<= 0 i1@10@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5564
;  :arith-add-rows          2443
;  :arith-assert-diseq      92
;  :arith-assert-lower      1564
;  :arith-assert-upper      1239
;  :arith-bound-prop        156
;  :arith-conflicts         161
;  :arith-eq-adapter        320
;  :arith-fixed-eqs         233
;  :arith-gcd-tests         2
;  :arith-grobner           277
;  :arith-ineq-splits       2
;  :arith-max-min           1754
;  :arith-nonlinear-bounds  172
;  :arith-nonlinear-horner  226
;  :arith-offset-eqs        548
;  :arith-patches           2
;  :arith-pivots            515
;  :conflicts               359
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 663
;  :datatype-occurs-check   404
;  :datatype-splits         539
;  :decisions               1911
;  :del-clause              5675
;  :final-checks            348
;  :interface-eqs           80
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.25
;  :minimized-lits          3
;  :mk-bool-var             8490
;  :mk-clause               5764
;  :num-allocs              221348
;  :num-checks              116
;  :propagations            2651
;  :quant-instantiations    1391
;  :rlimit-count            423274
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@02 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5564
;  :arith-add-rows          2443
;  :arith-assert-diseq      92
;  :arith-assert-lower      1564
;  :arith-assert-upper      1239
;  :arith-bound-prop        156
;  :arith-conflicts         161
;  :arith-eq-adapter        320
;  :arith-fixed-eqs         233
;  :arith-gcd-tests         2
;  :arith-grobner           277
;  :arith-ineq-splits       2
;  :arith-max-min           1754
;  :arith-nonlinear-bounds  172
;  :arith-nonlinear-horner  226
;  :arith-offset-eqs        548
;  :arith-patches           2
;  :arith-pivots            515
;  :conflicts               359
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 663
;  :datatype-occurs-check   404
;  :datatype-splits         539
;  :decisions               1911
;  :del-clause              5675
;  :final-checks            348
;  :interface-eqs           80
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.25
;  :minimized-lits          3
;  :mk-bool-var             8490
;  :mk-clause               5764
;  :num-allocs              221366
;  :num-checks              117
;  :propagations            2651
;  :quant-instantiations    1391
;  :rlimit-count            423285)
; [then-branch: 77 | exc@12@02 == Null | live]
; [else-branch: 77 | exc@12@02 != Null | dead]
(push) ; 8
; [then-branch: 77 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] i1 < V
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@02 $Ref.null) (< i1@10@02 V@7@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= j
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5954
;  :arith-add-rows          2483
;  :arith-assert-diseq      92
;  :arith-assert-lower      1616
;  :arith-assert-upper      1288
;  :arith-bound-prop        160
;  :arith-conflicts         165
;  :arith-eq-adapter        328
;  :arith-fixed-eqs         238
;  :arith-gcd-tests         2
;  :arith-grobner           294
;  :arith-ineq-splits       2
;  :arith-max-min           1831
;  :arith-nonlinear-bounds  181
;  :arith-nonlinear-horner  240
;  :arith-offset-eqs        578
;  :arith-patches           2
;  :arith-pivots            522
;  :conflicts               369
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 724
;  :datatype-occurs-check   443
;  :datatype-splits         590
;  :decisions               2034
;  :del-clause              5928
;  :final-checks            366
;  :interface-eqs           86
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          3
;  :mk-bool-var             8794
;  :mk-clause               6017
;  :num-allocs              226625
;  :num-checks              118
;  :propagations            2766
;  :quant-instantiations    1429
;  :rlimit-count            438900
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@02 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5954
;  :arith-add-rows          2483
;  :arith-assert-diseq      92
;  :arith-assert-lower      1616
;  :arith-assert-upper      1288
;  :arith-bound-prop        160
;  :arith-conflicts         165
;  :arith-eq-adapter        328
;  :arith-fixed-eqs         238
;  :arith-gcd-tests         2
;  :arith-grobner           294
;  :arith-ineq-splits       2
;  :arith-max-min           1831
;  :arith-nonlinear-bounds  181
;  :arith-nonlinear-horner  240
;  :arith-offset-eqs        578
;  :arith-patches           2
;  :arith-pivots            522
;  :conflicts               369
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 724
;  :datatype-occurs-check   443
;  :datatype-splits         590
;  :decisions               2034
;  :del-clause              5928
;  :final-checks            366
;  :interface-eqs           86
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          3
;  :mk-bool-var             8794
;  :mk-clause               6017
;  :num-allocs              226643
;  :num-checks              119
;  :propagations            2766
;  :quant-instantiations    1429
;  :rlimit-count            438911)
; [then-branch: 78 | exc@12@02 == Null | live]
; [else-branch: 78 | exc@12@02 != Null | dead]
(push) ; 8
; [then-branch: 78 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] 0 <= j
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@02 $Ref.null) (<= 0 j@11@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> j < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6349
;  :arith-add-rows          2523
;  :arith-assert-diseq      92
;  :arith-assert-lower      1668
;  :arith-assert-upper      1337
;  :arith-bound-prop        164
;  :arith-conflicts         169
;  :arith-eq-adapter        336
;  :arith-fixed-eqs         243
;  :arith-gcd-tests         2
;  :arith-grobner           309
;  :arith-ineq-splits       2
;  :arith-max-min           1908
;  :arith-nonlinear-bounds  190
;  :arith-nonlinear-horner  253
;  :arith-offset-eqs        610
;  :arith-patches           2
;  :arith-pivots            531
;  :conflicts               379
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 785
;  :datatype-occurs-check   482
;  :datatype-splits         641
;  :decisions               2157
;  :del-clause              6181
;  :final-checks            384
;  :interface-eqs           92
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          3
;  :mk-bool-var             9098
;  :mk-clause               6270
;  :num-allocs              231323
;  :num-checks              120
;  :propagations            2881
;  :quant-instantiations    1467
;  :rlimit-count            452626
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@02 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6349
;  :arith-add-rows          2523
;  :arith-assert-diseq      92
;  :arith-assert-lower      1668
;  :arith-assert-upper      1337
;  :arith-bound-prop        164
;  :arith-conflicts         169
;  :arith-eq-adapter        336
;  :arith-fixed-eqs         243
;  :arith-gcd-tests         2
;  :arith-grobner           309
;  :arith-ineq-splits       2
;  :arith-max-min           1908
;  :arith-nonlinear-bounds  190
;  :arith-nonlinear-horner  253
;  :arith-offset-eqs        610
;  :arith-patches           2
;  :arith-pivots            531
;  :conflicts               379
;  :datatype-accessor-ax    219
;  :datatype-constructor-ax 785
;  :datatype-occurs-check   482
;  :datatype-splits         641
;  :decisions               2157
;  :del-clause              6181
;  :final-checks            384
;  :interface-eqs           92
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          3
;  :mk-bool-var             9098
;  :mk-clause               6270
;  :num-allocs              231341
;  :num-checks              121
;  :propagations            2881
;  :quant-instantiations    1467
;  :rlimit-count            452637)
; [then-branch: 79 | exc@12@02 == Null | live]
; [else-branch: 79 | exc@12@02 != Null | dead]
(push) ; 8
; [then-branch: 79 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] j < V
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@02 $Ref.null) (< j@11@02 V@7@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02)))))))))))))))))))))
; [eval] exc == null
(push) ; 7
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6756
;  :arith-add-rows          2563
;  :arith-assert-diseq      92
;  :arith-assert-lower      1720
;  :arith-assert-upper      1386
;  :arith-bound-prop        168
;  :arith-conflicts         173
;  :arith-eq-adapter        344
;  :arith-fixed-eqs         248
;  :arith-gcd-tests         2
;  :arith-grobner           326
;  :arith-ineq-splits       2
;  :arith-max-min           1985
;  :arith-nonlinear-bounds  199
;  :arith-nonlinear-horner  267
;  :arith-offset-eqs        640
;  :arith-patches           2
;  :arith-pivots            538
;  :conflicts               389
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   521
;  :datatype-splits         695
;  :decisions               2283
;  :del-clause              6434
;  :final-checks            402
;  :interface-eqs           98
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          3
;  :mk-bool-var             9404
;  :mk-clause               6523
;  :num-allocs              236469
;  :num-checks              122
;  :propagations            2996
;  :quant-instantiations    1505
;  :rlimit-count            468075
;  :time                    0.01)
(push) ; 7
(assert (not (= exc@12@02 $Ref.null)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6756
;  :arith-add-rows          2563
;  :arith-assert-diseq      92
;  :arith-assert-lower      1720
;  :arith-assert-upper      1386
;  :arith-bound-prop        168
;  :arith-conflicts         173
;  :arith-eq-adapter        344
;  :arith-fixed-eqs         248
;  :arith-gcd-tests         2
;  :arith-grobner           326
;  :arith-ineq-splits       2
;  :arith-max-min           1985
;  :arith-nonlinear-bounds  199
;  :arith-nonlinear-horner  267
;  :arith-offset-eqs        640
;  :arith-patches           2
;  :arith-pivots            538
;  :conflicts               389
;  :datatype-accessor-ax    237
;  :datatype-constructor-ax 849
;  :datatype-occurs-check   521
;  :datatype-splits         695
;  :decisions               2283
;  :del-clause              6434
;  :final-checks            402
;  :interface-eqs           98
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          3
;  :mk-bool-var             9404
;  :mk-clause               6523
;  :num-allocs              236487
;  :num-checks              123
;  :propagations            2996
;  :quant-instantiations    1505
;  :rlimit-count            468086)
; [then-branch: 80 | exc@12@02 == Null | live]
; [else-branch: 80 | exc@12@02 != Null | dead]
(push) ; 7
; [then-branch: 80 | exc@12@02 == Null]
(assert (= exc@12@02 $Ref.null))
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 8
; Joined path conditions
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 8
; Joined path conditions
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@44@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@43@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@35@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7099
;  :arith-add-rows          2644
;  :arith-assert-diseq      93
;  :arith-assert-lower      1764
;  :arith-assert-upper      1426
;  :arith-bound-prop        171
;  :arith-conflicts         179
;  :arith-eq-adapter        366
;  :arith-fixed-eqs         258
;  :arith-gcd-tests         2
;  :arith-grobner           326
;  :arith-ineq-splits       2
;  :arith-max-min           2021
;  :arith-nonlinear-bounds  205
;  :arith-nonlinear-horner  267
;  :arith-offset-eqs        658
;  :arith-patches           2
;  :arith-pivots            554
;  :conflicts               409
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 893
;  :datatype-occurs-check   539
;  :datatype-splits         729
;  :decisions               2379
;  :del-clause              6686
;  :final-checks            413
;  :interface-eqs           102
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.25
;  :minimized-lits          3
;  :mk-bool-var             9873
;  :mk-clause               6775
;  :num-allocs              237654
;  :num-checks              124
;  :propagations            3108
;  :quant-instantiations    1538
;  :rlimit-count            473003
;  :time                    0.00)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 9
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7099
;  :arith-add-rows          2644
;  :arith-assert-diseq      93
;  :arith-assert-lower      1764
;  :arith-assert-upper      1426
;  :arith-bound-prop        171
;  :arith-conflicts         179
;  :arith-eq-adapter        366
;  :arith-fixed-eqs         258
;  :arith-gcd-tests         2
;  :arith-grobner           326
;  :arith-ineq-splits       2
;  :arith-max-min           2021
;  :arith-nonlinear-bounds  205
;  :arith-nonlinear-horner  267
;  :arith-offset-eqs        658
;  :arith-patches           2
;  :arith-pivots            554
;  :conflicts               410
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 893
;  :datatype-occurs-check   539
;  :datatype-splits         729
;  :decisions               2379
;  :del-clause              6686
;  :final-checks            413
;  :interface-eqs           102
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.25
;  :minimized-lits          3
;  :mk-bool-var             9873
;  :mk-clause               6775
;  :num-allocs              237744
;  :num-checks              125
;  :propagations            3108
;  :quant-instantiations    1538
;  :rlimit-count            473094)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7105
;  :arith-add-rows          2655
;  :arith-assert-diseq      93
;  :arith-assert-lower      1767
;  :arith-assert-upper      1427
;  :arith-bound-prop        171
;  :arith-conflicts         180
;  :arith-eq-adapter        367
;  :arith-fixed-eqs         259
;  :arith-gcd-tests         2
;  :arith-grobner           326
;  :arith-ineq-splits       2
;  :arith-max-min           2021
;  :arith-nonlinear-bounds  205
;  :arith-nonlinear-horner  267
;  :arith-offset-eqs        658
;  :arith-patches           2
;  :arith-pivots            558
;  :conflicts               411
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 893
;  :datatype-occurs-check   539
;  :datatype-splits         729
;  :decisions               2379
;  :del-clause              6690
;  :final-checks            413
;  :interface-eqs           102
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.25
;  :minimized-lits          3
;  :mk-bool-var             9884
;  :mk-clause               6779
;  :num-allocs              237943
;  :num-checks              126
;  :propagations            3110
;  :quant-instantiations    1545
;  :rlimit-count            473693)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(pop) ; 8
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
    $Ref.null)))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7521
;  :arith-add-rows          2697
;  :arith-assert-diseq      93
;  :arith-assert-lower      1821
;  :arith-assert-upper      1478
;  :arith-bound-prop        175
;  :arith-conflicts         184
;  :arith-eq-adapter        376
;  :arith-fixed-eqs         265
;  :arith-gcd-tests         2
;  :arith-grobner           343
;  :arith-ineq-splits       2
;  :arith-max-min           2098
;  :arith-nonlinear-bounds  214
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        687
;  :arith-patches           2
;  :arith-pivots            568
;  :conflicts               421
;  :datatype-accessor-ax    265
;  :datatype-constructor-ax 957
;  :datatype-occurs-check   578
;  :datatype-splits         783
;  :decisions               2505
;  :del-clause              6943
;  :final-checks            431
;  :interface-eqs           108
;  :max-generation          6
;  :max-memory              5.32
;  :memory                  5.28
;  :minimized-lits          3
;  :mk-bool-var             10210
;  :mk-clause               7042
;  :num-allocs              244062
;  :num-checks              127
;  :propagations            3231
;  :quant-instantiations    1595
;  :rlimit-count            491506
;  :time                    0.01)
; [then-branch: 81 | exc@12@02 == Null | live]
; [else-branch: 81 | exc@12@02 != Null | dead]
(push) ; 8
; [then-branch: 81 | exc@12@02 == Null]
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 9
; Joined path conditions
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 9
; Joined path conditions
(declare-const sm@50@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@36@02 r) V@7@02) (<= 0 (inv@36@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r))
  :qid |qp.fvfValDef15|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@44@02 r) V@7@02) (<= 0 (inv@44@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))) r))
  :qid |qp.fvfValDef16|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef17|)))
(declare-const pm@51@02 $FPM)
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_option$array$ (as pm@51@02  $FPM) r)
    (+
      (ite
        (and (< (inv@36@02 r) V@7@02) (<= 0 (inv@36@02 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@35@02)
        $Perm.No)
      (ite
        (and (< (inv@44@02 r) V@7@02) (<= 0 (inv@44@02 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@43@02)
        $Perm.No)))
  :pattern (($FVF.perm_option$array$ (as pm@51@02  $FPM) r))
  :qid |qp.resPrmSumDef18|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@02))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@02))))))))))) r) r))
  :pattern (($FVF.perm_option$array$ (as pm@51@02  $FPM) r))
  :qid |qp.resTrgDef19|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))
(set-option :timeout 0)
(push) ; 9
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@51@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7732
;  :arith-add-rows          2737
;  :arith-assert-diseq      94
;  :arith-assert-lower      1849
;  :arith-assert-upper      1503
;  :arith-bound-prop        177
;  :arith-conflicts         188
;  :arith-eq-adapter        393
;  :arith-fixed-eqs         275
;  :arith-gcd-tests         2
;  :arith-grobner           343
;  :arith-ineq-splits       2
;  :arith-max-min           2115
;  :arith-nonlinear-bounds  217
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        703
;  :arith-patches           2
;  :arith-pivots            577
;  :conflicts               436
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 979
;  :datatype-occurs-check   583
;  :datatype-splits         797
;  :decisions               2582
;  :del-clause              7256
;  :final-checks            436
;  :interface-eqs           110
;  :max-generation          6
;  :max-memory              5.32
;  :memory                  5.27
;  :minimized-lits          3
;  :mk-bool-var             10649
;  :mk-clause               7362
;  :num-allocs              245654
;  :num-checks              128
;  :propagations            3337
;  :quant-instantiations    1643
;  :rlimit-count            497956
;  :time                    0.00)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7916
;  :arith-add-rows          2760
;  :arith-assert-diseq      94
;  :arith-assert-lower      1861
;  :arith-assert-upper      1518
;  :arith-bound-prop        178
;  :arith-conflicts         190
;  :arith-eq-adapter        402
;  :arith-fixed-eqs         278
;  :arith-gcd-tests         2
;  :arith-grobner           343
;  :arith-ineq-splits       2
;  :arith-max-min           2132
;  :arith-nonlinear-bounds  220
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        716
;  :arith-patches           2
;  :arith-pivots            580
;  :conflicts               449
;  :datatype-accessor-ax    275
;  :datatype-constructor-ax 1001
;  :datatype-occurs-check   588
;  :datatype-splits         811
;  :decisions               2631
;  :del-clause              7387
;  :final-checks            441
;  :interface-eqs           112
;  :max-generation          6
;  :max-memory              5.32
;  :memory                  5.27
;  :minimized-lits          3
;  :mk-bool-var             10909
;  :mk-clause               7493
;  :num-allocs              246167
;  :num-checks              129
;  :propagations            3382
;  :quant-instantiations    1658
;  :rlimit-count            500335
;  :time                    0.00)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8119
;  :arith-add-rows          2802
;  :arith-assert-diseq      94
;  :arith-assert-lower      1879
;  :arith-assert-upper      1535
;  :arith-bound-prop        179
;  :arith-conflicts         193
;  :arith-eq-adapter        408
;  :arith-fixed-eqs         283
;  :arith-gcd-tests         2
;  :arith-grobner           343
;  :arith-ineq-splits       2
;  :arith-max-min           2149
;  :arith-nonlinear-bounds  223
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        727
;  :arith-patches           2
;  :arith-pivots            587
;  :conflicts               462
;  :datatype-accessor-ax    280
;  :datatype-constructor-ax 1023
;  :datatype-occurs-check   593
;  :datatype-splits         825
;  :decisions               2680
;  :del-clause              7501
;  :final-checks            446
;  :interface-eqs           114
;  :max-generation          6
;  :max-memory              5.32
;  :memory                  5.27
;  :minimized-lits          3
;  :mk-bool-var             11185
;  :mk-clause               7607
;  :num-allocs              246812
;  :num-checks              130
;  :propagations            3432
;  :quant-instantiations    1682
;  :rlimit-count            503373
;  :time                    0.00)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(pop) ; 9
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@45@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8545
;  :arith-add-rows          2895
;  :arith-assert-diseq      94
;  :arith-assert-lower      1934
;  :arith-assert-upper      1587
;  :arith-bound-prop        182
;  :arith-conflicts         198
;  :arith-eq-adapter        417
;  :arith-fixed-eqs         289
;  :arith-gcd-tests         2
;  :arith-grobner           362
;  :arith-ineq-splits       2
;  :arith-max-min           2226
;  :arith-nonlinear-bounds  232
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        756
;  :arith-patches           2
;  :arith-pivots            598
;  :conflicts               473
;  :datatype-accessor-ax    297
;  :datatype-constructor-ax 1087
;  :datatype-occurs-check   632
;  :datatype-splits         879
;  :decisions               2807
;  :del-clause              7758
;  :final-checks            464
;  :interface-eqs           120
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.30
;  :minimized-lits          3
;  :mk-bool-var             11505
;  :mk-clause               7864
;  :num-allocs              253855
;  :num-checks              131
;  :propagations            3552
;  :quant-instantiations    1730
;  :rlimit-count            525722
;  :time                    0.01)
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02)
    $Ref.null)))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(push) ; 4
; [exec]
; var return: void
(declare-const return@52@02 void)
; [exec]
; exc := null
; [exec]
; aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int := aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8555
;  :arith-add-rows          2903
;  :arith-assert-diseq      95
;  :arith-assert-lower      1941
;  :arith-assert-upper      1594
;  :arith-bound-prop        182
;  :arith-conflicts         200
;  :arith-eq-adapter        422
;  :arith-fixed-eqs         291
;  :arith-gcd-tests         2
;  :arith-grobner           362
;  :arith-ineq-splits       2
;  :arith-max-min           2226
;  :arith-nonlinear-bounds  232
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        756
;  :arith-patches           2
;  :arith-pivots            610
;  :conflicts               476
;  :datatype-accessor-ax    297
;  :datatype-constructor-ax 1087
;  :datatype-occurs-check   632
;  :datatype-splits         879
;  :decisions               2809
;  :del-clause              7841
;  :final-checks            464
;  :interface-eqs           120
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.27
;  :minimized-lits          3
;  :mk-bool-var             11524
;  :mk-clause               7872
;  :num-allocs              254076
;  :num-checks              132
;  :propagations            3565
;  :quant-instantiations    1733
;  :rlimit-count            526429)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 5
; Joined path conditions
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 5
; Joined path conditions
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))
(push) ; 5
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8598
;  :arith-add-rows          2905
;  :arith-assert-diseq      96
;  :arith-assert-lower      1955
;  :arith-assert-upper      1608
;  :arith-bound-prop        182
;  :arith-conflicts         202
;  :arith-eq-adapter        429
;  :arith-fixed-eqs         296
;  :arith-gcd-tests         2
;  :arith-grobner           362
;  :arith-ineq-splits       2
;  :arith-max-min           2237
;  :arith-nonlinear-bounds  234
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        770
;  :arith-patches           2
;  :arith-pivots            616
;  :conflicts               483
;  :datatype-accessor-ax    298
;  :datatype-constructor-ax 1093
;  :datatype-occurs-check   635
;  :datatype-splits         885
;  :decisions               2823
;  :del-clause              7870
;  :final-checks            469
;  :interface-eqs           122
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          3
;  :mk-bool-var             11569
;  :mk-clause               7901
;  :num-allocs              254442
;  :num-checks              133
;  :propagations            3587
;  :quant-instantiations    1739
;  :rlimit-count            527587)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8599
;  :arith-add-rows          2905
;  :arith-assert-diseq      96
;  :arith-assert-lower      1955
;  :arith-assert-upper      1608
;  :arith-bound-prop        182
;  :arith-conflicts         202
;  :arith-eq-adapter        429
;  :arith-fixed-eqs         296
;  :arith-gcd-tests         2
;  :arith-grobner           362
;  :arith-ineq-splits       2
;  :arith-max-min           2237
;  :arith-nonlinear-bounds  234
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        770
;  :arith-patches           2
;  :arith-pivots            616
;  :conflicts               484
;  :datatype-accessor-ax    298
;  :datatype-constructor-ax 1093
;  :datatype-occurs-check   635
;  :datatype-splits         885
;  :decisions               2823
;  :del-clause              7870
;  :final-checks            469
;  :interface-eqs           122
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          3
;  :mk-bool-var             11570
;  :mk-clause               7901
;  :num-allocs              254533
;  :num-checks              134
;  :propagations            3587
;  :quant-instantiations    1739
;  :rlimit-count            527680)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8603
;  :arith-add-rows          2915
;  :arith-assert-diseq      96
;  :arith-assert-lower      1957
;  :arith-assert-upper      1609
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        430
;  :arith-fixed-eqs         297
;  :arith-gcd-tests         2
;  :arith-grobner           362
;  :arith-ineq-splits       2
;  :arith-max-min           2237
;  :arith-nonlinear-bounds  234
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        770
;  :arith-patches           2
;  :arith-pivots            620
;  :conflicts               485
;  :datatype-accessor-ax    298
;  :datatype-constructor-ax 1093
;  :datatype-occurs-check   635
;  :datatype-splits         885
;  :decisions               2823
;  :del-clause              7871
;  :final-checks            469
;  :interface-eqs           122
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          3
;  :mk-bool-var             11575
;  :mk-clause               7902
;  :num-allocs              254700
;  :num-checks              135
;  :propagations            3587
;  :quant-instantiations    1739
;  :rlimit-count            528150)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(pop) ; 5
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8608
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1958
;  :arith-assert-upper      1611
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        431
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           362
;  :arith-ineq-splits       2
;  :arith-max-min           2237
;  :arith-nonlinear-bounds  234
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        770
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    298
;  :datatype-constructor-ax 1093
;  :datatype-occurs-check   635
;  :datatype-splits         885
;  :decisions               2823
;  :del-clause              7871
;  :final-checks            469
;  :interface-eqs           122
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          3
;  :mk-bool-var             11580
;  :mk-clause               7902
;  :num-allocs              254887
;  :num-checks              136
;  :propagations            3587
;  :quant-instantiations    1739
;  :rlimit-count            528534)
(declare-const int@53@02 Int)
(assert (=
  int@53@02
  ($SortWrappers.$SnapToInt ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))))
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8641
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1972
;  :arith-assert-upper      1623
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        433
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        782
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    299
;  :datatype-constructor-ax 1099
;  :datatype-occurs-check   640
;  :datatype-splits         891
;  :decisions               2836
;  :del-clause              7891
;  :final-checks            476
;  :interface-eqs           124
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11606
;  :mk-clause               7922
;  :num-allocs              258112
;  :num-checks              137
;  :propagations            3598
;  :quant-instantiations    1745
;  :rlimit-count            536358
;  :time                    0.00)
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 82 | True | live]
; [else-branch: 82 | False | live]
(push) ; 6
; [then-branch: 82 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 82 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8672
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1972
;  :arith-assert-upper      1627
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        435
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        794
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 1105
;  :datatype-occurs-check   644
;  :datatype-splits         897
;  :decisions               2849
;  :del-clause              7911
;  :final-checks            481
;  :interface-eqs           126
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11629
;  :mk-clause               7942
;  :num-allocs              259063
;  :num-checks              138
;  :propagations            3609
;  :quant-instantiations    1750
;  :rlimit-count            537243
;  :time                    0.00)
(push) ; 6
(assert (not (< 0 V@7@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8672
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1972
;  :arith-assert-upper      1627
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        435
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        794
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 1105
;  :datatype-occurs-check   644
;  :datatype-splits         897
;  :decisions               2849
;  :del-clause              7911
;  :final-checks            481
;  :interface-eqs           126
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11629
;  :mk-clause               7942
;  :num-allocs              259081
;  :num-checks              139
;  :propagations            3609
;  :quant-instantiations    1750
;  :rlimit-count            537256)
; [then-branch: 83 | 0 < V@7@02 | live]
; [else-branch: 83 | !(0 < V@7@02) | dead]
(push) ; 6
; [then-branch: 83 | 0 < V@7@02]
(assert (< 0 V@7@02))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 84 | True | live]
; [else-branch: 84 | False | live]
(push) ; 6
; [then-branch: 84 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 84 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8703
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1972
;  :arith-assert-upper      1631
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        437
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        806
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    301
;  :datatype-constructor-ax 1111
;  :datatype-occurs-check   648
;  :datatype-splits         903
;  :decisions               2862
;  :del-clause              7931
;  :final-checks            486
;  :interface-eqs           128
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11652
;  :mk-clause               7962
;  :num-allocs              260027
;  :num-checks              140
;  :propagations            3620
;  :quant-instantiations    1755
;  :rlimit-count            538151
;  :time                    0.00)
(push) ; 6
(assert (not (< 0 V@7@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8703
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1972
;  :arith-assert-upper      1631
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        437
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        806
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    301
;  :datatype-constructor-ax 1111
;  :datatype-occurs-check   648
;  :datatype-splits         903
;  :decisions               2862
;  :del-clause              7931
;  :final-checks            486
;  :interface-eqs           128
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11652
;  :mk-clause               7962
;  :num-allocs              260045
;  :num-checks              141
;  :propagations            3620
;  :quant-instantiations    1755
;  :rlimit-count            538164)
; [then-branch: 85 | 0 < V@7@02 | live]
; [else-branch: 85 | !(0 < V@7@02) | dead]
(push) ; 6
; [then-branch: 85 | 0 < V@7@02]
(assert (< 0 V@7@02))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
; Joined path conditions
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 86 | True | live]
; [else-branch: 86 | False | live]
(push) ; 6
; [then-branch: 86 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 86 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8734
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1972
;  :arith-assert-upper      1635
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        818
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    302
;  :datatype-constructor-ax 1117
;  :datatype-occurs-check   652
;  :datatype-splits         909
;  :decisions               2875
;  :del-clause              7951
;  :final-checks            491
;  :interface-eqs           130
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11675
;  :mk-clause               7982
;  :num-allocs              260991
;  :num-checks              142
;  :propagations            3631
;  :quant-instantiations    1760
;  :rlimit-count            539059
;  :time                    0.00)
(push) ; 5
(assert (not (< 0 V@7@02)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8734
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1972
;  :arith-assert-upper      1635
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        818
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               486
;  :datatype-accessor-ax    302
;  :datatype-constructor-ax 1117
;  :datatype-occurs-check   652
;  :datatype-splits         909
;  :decisions               2875
;  :del-clause              7951
;  :final-checks            491
;  :interface-eqs           130
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11675
;  :mk-clause               7982
;  :num-allocs              261009
;  :num-checks              143
;  :propagations            3631
;  :quant-instantiations    1760
;  :rlimit-count            539072)
; [then-branch: 87 | 0 < V@7@02 | live]
; [else-branch: 87 | !(0 < V@7@02) | dead]
(push) ; 5
; [then-branch: 87 | 0 < V@7@02]
(assert (< 0 V@7@02))
(declare-const i2@54@02 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 88 | 0 <= i2@54@02 | live]
; [else-branch: 88 | !(0 <= i2@54@02) | live]
(push) ; 8
; [then-branch: 88 | 0 <= i2@54@02]
(assert (<= 0 i2@54@02))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 88 | !(0 <= i2@54@02)]
(assert (not (<= 0 i2@54@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< i2@54@02 V@7@02) (<= 0 i2@54@02)))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 7
; [eval] amount >= 0 * write
; [eval] 0 * write
(set-option :timeout 0)
(push) ; 8
(assert (not (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8734
;  :arith-add-rows          2917
;  :arith-assert-diseq      96
;  :arith-assert-lower      1974
;  :arith-assert-upper      1635
;  :arith-bound-prop        182
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        818
;  :arith-patches           2
;  :arith-pivots            621
;  :conflicts               487
;  :datatype-accessor-ax    302
;  :datatype-constructor-ax 1117
;  :datatype-occurs-check   652
;  :datatype-splits         909
;  :decisions               2875
;  :del-clause              7951
;  :final-checks            491
;  :interface-eqs           130
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.32
;  :minimized-lits          3
;  :mk-bool-var             11677
;  :mk-clause               7982
;  :num-allocs              261182
;  :num-checks              144
;  :propagations            3631
;  :quant-instantiations    1760
;  :rlimit-count            539315)
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(pop) ; 7
; Joined path conditions
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(declare-const $k@55@02 $Perm)
(assert ($Perm.isReadVar $k@55@02 $Perm.Write))
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
; Joined path conditions
(push) ; 7
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 8
(assert (not (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8734
;  :arith-add-rows          2920
;  :arith-assert-diseq      97
;  :arith-assert-lower      1976
;  :arith-assert-upper      1637
;  :arith-bound-prop        182
;  :arith-conflicts         204
;  :arith-eq-adapter        440
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2262
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        818
;  :arith-patches           2
;  :arith-pivots            623
;  :conflicts               488
;  :datatype-accessor-ax    302
;  :datatype-constructor-ax 1117
;  :datatype-occurs-check   652
;  :datatype-splits         909
;  :decisions               2875
;  :del-clause              7951
;  :final-checks            491
;  :interface-eqs           130
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          3
;  :mk-bool-var             11682
;  :mk-clause               7984
;  :num-allocs              261435
;  :num-checks              145
;  :propagations            3632
;  :quant-instantiations    1760
;  :rlimit-count            539680)
(assert (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 7
; Joined path conditions
(assert (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 6
(declare-fun inv@56@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@55@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@54@02 Int)) (!
  (and
    (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)
    (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@54@02))
  :qid |option$array$-aux|)))
(push) ; 6
(assert (not (forall ((i2@54@02 Int)) (!
  (implies
    (and (< i2@54@02 V@7@02) (<= 0 i2@54@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@55@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@55@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8765
;  :arith-add-rows          2920
;  :arith-assert-diseq      99
;  :arith-assert-lower      1990
;  :arith-assert-upper      1649
;  :arith-bound-prop        182
;  :arith-conflicts         205
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2278
;  :arith-nonlinear-bounds  237
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        830
;  :arith-patches           2
;  :arith-pivots            623
;  :conflicts               489
;  :datatype-accessor-ax    303
;  :datatype-constructor-ax 1123
;  :datatype-occurs-check   655
;  :datatype-splits         915
;  :decisions               2888
;  :del-clause              7975
;  :final-checks            496
;  :interface-eqs           132
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          3
;  :mk-bool-var             11716
;  :mk-clause               8008
;  :num-allocs              262067
;  :num-checks              146
;  :propagations            3645
;  :quant-instantiations    1766
;  :rlimit-count            540990)
(declare-const sm@57@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r))
  :qid |qp.fvfValDef20|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r))
  :qid |qp.fvfValDef21|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef22|)))
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((i21@54@02 Int) (i22@54@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< i21@54@02 V@7@02) (<= 0 i21@54@02))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i21@54@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i21@54@02)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@55@02)))
      (and
        (and
          (and (< i22@54@02 V@7@02) (<= 0 i22@54@02))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i22@54@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i22@54@02)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@55@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i21@54@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i22@54@02)))
    (= i21@54@02 i22@54@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8780
;  :arith-add-rows          2922
;  :arith-assert-diseq      100
;  :arith-assert-lower      1995
;  :arith-assert-upper      1649
;  :arith-bound-prop        182
;  :arith-conflicts         205
;  :arith-eq-adapter        445
;  :arith-fixed-eqs         298
;  :arith-gcd-tests         2
;  :arith-grobner           375
;  :arith-ineq-splits       2
;  :arith-max-min           2278
;  :arith-nonlinear-bounds  237
;  :arith-nonlinear-horner  311
;  :arith-offset-eqs        830
;  :arith-patches           2
;  :arith-pivots            623
;  :conflicts               490
;  :datatype-accessor-ax    303
;  :datatype-constructor-ax 1123
;  :datatype-occurs-check   655
;  :datatype-splits         915
;  :decisions               2888
;  :del-clause              7994
;  :final-checks            496
;  :interface-eqs           132
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          3
;  :mk-bool-var             11757
;  :mk-clause               8029
;  :num-allocs              263042
;  :num-checks              147
;  :propagations            3651
;  :quant-instantiations    1784
;  :rlimit-count            543529)
; Definitional axioms for inverse functions
(assert (forall ((i2@54@02 Int)) (!
  (implies
    (and
      (and (< i2@54@02 V@7@02) (<= 0 i2@54@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@55@02)))
    (=
      (inv@56@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@54@02))
      i2@54@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@54@02))
  :qid |option$array$-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@56@02 r) V@7@02) (<= 0 (inv@56@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@55@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) (inv@56@02 r))
      r))
  :pattern ((inv@56@02 r))
  :qid |option$array$-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@56@02 r) V@7@02) (<= 0 (inv@56@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) r) r))
  :pattern ((inv@56@02 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@58@02 ((r $Ref)) $Perm
  (ite
    (and (< (inv@56@02 r) V@7@02) (<= 0 (inv@56@02 r)))
    ($Perm.min
      (ite
        (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02)
        $Perm.No)
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@55@02))
    $Perm.No))
(define-fun pTaken@59@02 ((r $Ref)) $Perm
  (ite
    (and (< (inv@56@02 r) V@7@02) (<= 0 (inv@56@02 r)))
    ($Perm.min
      (ite
        (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02)
        $Perm.No)
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@55@02)
        (pTaken@58@02 r)))
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Constrain original permissions scale(_, V@7@02 * V@7@02 * W) * $k@55@02
(assert (forall ((r $Ref)) (!
  (implies
    (not
      (=
        (ite
          (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@16@02)
          $Perm.No)
        $Perm.No))
    (ite
      (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
      (<
        (ite
          (and (< (inv@56@02 r) V@7@02) (<= 0 (inv@56@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@55@02)
          $Perm.No)
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@16@02))
      (<
        (ite
          (and (< (inv@56@02 r) V@7@02) (<= 0 (inv@56@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@55@02)
          $Perm.No)
        $Perm.No)))
  :pattern ((inv@17@02 r))
  :pattern ((inv@56@02 r))
  :qid |qp.srp23|)))
; Intermediate check if already taken enough permissions
(set-option :timeout 500)
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@56@02 r) V@7@02) (<= 0 (inv@56@02 r)))
    (=
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@55@02)
        (pTaken@58@02 r))
      $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8946
;  :arith-add-rows          2982
;  :arith-assert-diseq      118
;  :arith-assert-lower      2057
;  :arith-assert-upper      1689
;  :arith-bound-prop        186
;  :arith-conflicts         210
;  :arith-eq-adapter        479
;  :arith-fixed-eqs         308
;  :arith-gcd-tests         2
;  :arith-grobner           388
;  :arith-ineq-splits       2
;  :arith-max-min           2325
;  :arith-nonlinear-bounds  241
;  :arith-nonlinear-horner  323
;  :arith-offset-eqs        857
;  :arith-patches           2
;  :arith-pivots            648
;  :conflicts               502
;  :datatype-accessor-ax    305
;  :datatype-constructor-ax 1135
;  :datatype-occurs-check   664
;  :datatype-splits         927
;  :decisions               2926
;  :del-clause              8166
;  :final-checks            508
;  :interface-eqs           136
;  :max-generation          6
;  :max-memory              5.36
;  :memory                  5.32
;  :minimized-lits          5
;  :mk-bool-var             11985
;  :mk-clause               8209
;  :num-allocs              268084
;  :num-checks              149
;  :propagations            3767
;  :quant-instantiations    1830
;  :rlimit-count            556842
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 89 | True | live]
; [else-branch: 89 | False | live]
(push) ; 7
; [then-branch: 89 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 89 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8991
;  :arith-add-rows          2990
;  :arith-assert-diseq      124
;  :arith-assert-lower      2088
;  :arith-assert-upper      1711
;  :arith-bound-prop        187
;  :arith-conflicts         210
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         309
;  :arith-gcd-tests         2
;  :arith-grobner           418
;  :arith-ineq-splits       2
;  :arith-max-min           2373
;  :arith-nonlinear-bounds  244
;  :arith-nonlinear-horner  353
;  :arith-offset-eqs        871
;  :arith-patches           2
;  :arith-pivots            655
;  :conflicts               504
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 1141
;  :datatype-occurs-check   669
;  :datatype-splits         933
;  :decisions               2946
;  :del-clause              8217
;  :final-checks            515
;  :interface-eqs           138
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.33
;  :minimized-lits          6
;  :mk-bool-var             12042
;  :mk-clause               8260
;  :num-allocs              274543
;  :num-checks              150
;  :propagations            3788
;  :quant-instantiations    1839
;  :rlimit-count            577640
;  :time                    0.01)
; [then-branch: 90 | 0 < V@7@02 | live]
; [else-branch: 90 | !(0 < V@7@02) | dead]
(push) ; 7
; [then-branch: 90 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
(declare-const i2@60@02 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 91 | 0 <= i2@60@02 | live]
; [else-branch: 91 | !(0 <= i2@60@02) | live]
(push) ; 10
; [then-branch: 91 | 0 <= i2@60@02]
(assert (<= 0 i2@60@02))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 91 | !(0 <= i2@60@02)]
(assert (not (<= 0 i2@60@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 92 | i2@60@02 < V@7@02 && 0 <= i2@60@02 | live]
; [else-branch: 92 | !(i2@60@02 < V@7@02 && 0 <= i2@60@02) | live]
(push) ; 10
; [then-branch: 92 | i2@60@02 < V@7@02 && 0 <= i2@60@02]
(assert (and (< i2@60@02 V@7@02) (<= 0 i2@60@02)))
; [eval] aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 12
(assert (not (< i2@60@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8991
;  :arith-add-rows          2992
;  :arith-assert-diseq      124
;  :arith-assert-lower      2090
;  :arith-assert-upper      1712
;  :arith-bound-prop        187
;  :arith-conflicts         211
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         309
;  :arith-gcd-tests         2
;  :arith-grobner           418
;  :arith-ineq-splits       2
;  :arith-max-min           2373
;  :arith-nonlinear-bounds  244
;  :arith-nonlinear-horner  353
;  :arith-offset-eqs        871
;  :arith-patches           2
;  :arith-pivots            656
;  :conflicts               505
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 1141
;  :datatype-occurs-check   669
;  :datatype-splits         933
;  :decisions               2946
;  :del-clause              8217
;  :final-checks            515
;  :interface-eqs           138
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.32
;  :minimized-lits          6
;  :mk-bool-var             12045
;  :mk-clause               8260
;  :num-allocs              274699
;  :num-checks              151
;  :propagations            3788
;  :quant-instantiations    1839
;  :rlimit-count            577919)
(assert (< i2@60@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 11
; Joined path conditions
(assert (< i2@60@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9061
;  :arith-add-rows          3044
;  :arith-assert-diseq      134
;  :arith-assert-lower      2121
;  :arith-assert-upper      1729
;  :arith-bound-prop        193
;  :arith-conflicts         214
;  :arith-eq-adapter        506
;  :arith-fixed-eqs         316
;  :arith-gcd-tests         2
;  :arith-grobner           418
;  :arith-ineq-splits       2
;  :arith-max-min           2373
;  :arith-nonlinear-bounds  244
;  :arith-nonlinear-horner  353
;  :arith-offset-eqs        877
;  :arith-patches           2
;  :arith-pivots            670
;  :conflicts               518
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 1141
;  :datatype-occurs-check   669
;  :datatype-splits         933
;  :decisions               2962
;  :del-clause              8293
;  :final-checks            515
;  :interface-eqs           138
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.32
;  :minimized-lits          7
;  :mk-bool-var             12230
;  :mk-clause               8392
;  :num-allocs              275511
;  :num-checks              152
;  :propagations            3851
;  :quant-instantiations    1880
;  :rlimit-count            581393
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 10
(push) ; 10
; [else-branch: 92 | !(i2@60@02 < V@7@02 && 0 <= i2@60@02)]
(assert (not (and (< i2@60@02 V@7@02) (<= 0 i2@60@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@60@02 V@7@02) (<= 0 i2@60@02))
  (and
    (< i2@60@02 V@7@02)
    (<= 0 i2@60@02)
    (< i2@60@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@60@02 Int)) (!
  (implies
    (and (< i2@60@02 V@7@02) (<= 0 i2@60@02))
    (and
      (< i2@60@02 V@7@02)
      (<= 0 i2@60@02)
      (< i2@60@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@60@02 Int)) (!
    (implies
      (and (< i2@60@02 V@7@02) (<= 0 i2@60@02))
      (and
        (< i2@60@02 V@7@02)
        (<= 0 i2@60@02)
        (< i2@60@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (< 0 V@7@02)
  (forall ((i2@60@02 Int)) (!
    (implies
      (and (< i2@60@02 V@7@02) (<= 0 i2@60@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9101
;  :arith-add-rows          3060
;  :arith-assert-diseq      140
;  :arith-assert-lower      2134
;  :arith-assert-upper      1736
;  :arith-bound-prop        195
;  :arith-conflicts         215
;  :arith-eq-adapter        514
;  :arith-fixed-eqs         319
;  :arith-gcd-tests         2
;  :arith-grobner           418
;  :arith-ineq-splits       2
;  :arith-max-min           2373
;  :arith-nonlinear-bounds  244
;  :arith-nonlinear-horner  353
;  :arith-offset-eqs        877
;  :arith-patches           2
;  :arith-pivots            681
;  :conflicts               528
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 1141
;  :datatype-occurs-check   669
;  :datatype-splits         933
;  :decisions               2975
;  :del-clause              8464
;  :final-checks            515
;  :interface-eqs           138
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.32
;  :minimized-lits          8
;  :mk-bool-var             12364
;  :mk-clause               8509
;  :num-allocs              276354
;  :num-checks              153
;  :propagations            3896
;  :quant-instantiations    1921
;  :rlimit-count            584481
;  :time                    0.00)
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@60@02 Int)) (!
    (implies
      (and (< i2@60@02 V@7@02) (<= 0 i2@60@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@60@02))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 93 | True | live]
; [else-branch: 93 | False | live]
(push) ; 7
; [then-branch: 93 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 93 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9146
;  :arith-add-rows          3068
;  :arith-assert-diseq      146
;  :arith-assert-lower      2165
;  :arith-assert-upper      1759
;  :arith-bound-prop        196
;  :arith-conflicts         215
;  :arith-eq-adapter        521
;  :arith-fixed-eqs         320
;  :arith-gcd-tests         2
;  :arith-grobner           448
;  :arith-ineq-splits       2
;  :arith-max-min           2421
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  383
;  :arith-offset-eqs        891
;  :arith-patches           2
;  :arith-pivots            687
;  :conflicts               530
;  :datatype-accessor-ax    307
;  :datatype-constructor-ax 1147
;  :datatype-occurs-check   674
;  :datatype-splits         939
;  :decisions               2995
;  :del-clause              8515
;  :final-checks            522
;  :interface-eqs           140
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.33
;  :minimized-lits          9
;  :mk-bool-var             12422
;  :mk-clause               8560
;  :num-allocs              282990
;  :num-checks              154
;  :propagations            3917
;  :quant-instantiations    1930
;  :rlimit-count            605586
;  :time                    0.01)
; [then-branch: 94 | 0 < V@7@02 | live]
; [else-branch: 94 | !(0 < V@7@02) | dead]
(push) ; 7
; [then-branch: 94 | 0 < V@7@02]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
(declare-const i2@61@02 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 95 | 0 <= i2@61@02 | live]
; [else-branch: 95 | !(0 <= i2@61@02) | live]
(push) ; 10
; [then-branch: 95 | 0 <= i2@61@02]
(assert (<= 0 i2@61@02))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 95 | !(0 <= i2@61@02)]
(assert (not (<= 0 i2@61@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 96 | i2@61@02 < V@7@02 && 0 <= i2@61@02 | live]
; [else-branch: 96 | !(i2@61@02 < V@7@02 && 0 <= i2@61@02) | live]
(push) ; 10
; [then-branch: 96 | i2@61@02 < V@7@02 && 0 <= i2@61@02]
(assert (and (< i2@61@02 V@7@02) (<= 0 i2@61@02)))
; [eval] alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(source), i2).option$array$))
; [eval] opt_get1(aloc(opt_get1(source), i2).option$array$)
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 12
(assert (not (< i2@61@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9146
;  :arith-add-rows          3070
;  :arith-assert-diseq      146
;  :arith-assert-lower      2167
;  :arith-assert-upper      1760
;  :arith-bound-prop        196
;  :arith-conflicts         216
;  :arith-eq-adapter        521
;  :arith-fixed-eqs         320
;  :arith-gcd-tests         2
;  :arith-grobner           448
;  :arith-ineq-splits       2
;  :arith-max-min           2421
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  383
;  :arith-offset-eqs        891
;  :arith-patches           2
;  :arith-pivots            688
;  :conflicts               531
;  :datatype-accessor-ax    307
;  :datatype-constructor-ax 1147
;  :datatype-occurs-check   674
;  :datatype-splits         939
;  :decisions               2995
;  :del-clause              8515
;  :final-checks            522
;  :interface-eqs           140
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.32
;  :minimized-lits          9
;  :mk-bool-var             12425
;  :mk-clause               8560
;  :num-allocs              283146
;  :num-checks              155
;  :propagations            3917
;  :quant-instantiations    1930
;  :rlimit-count            605865)
(assert (< i2@61@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 11
; Joined path conditions
(assert (< i2@61@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9223
;  :arith-add-rows          3160
;  :arith-assert-diseq      159
;  :arith-assert-lower      2198
;  :arith-assert-upper      1773
;  :arith-bound-prop        202
;  :arith-conflicts         219
;  :arith-eq-adapter        539
;  :arith-fixed-eqs         326
;  :arith-gcd-tests         2
;  :arith-grobner           448
;  :arith-ineq-splits       2
;  :arith-max-min           2421
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  383
;  :arith-offset-eqs        905
;  :arith-patches           2
;  :arith-pivots            704
;  :conflicts               545
;  :datatype-accessor-ax    307
;  :datatype-constructor-ax 1147
;  :datatype-occurs-check   674
;  :datatype-splits         939
;  :decisions               3016
;  :del-clause              8589
;  :final-checks            522
;  :interface-eqs           140
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.32
;  :minimized-lits          10
;  :mk-bool-var             12609
;  :mk-clause               8690
;  :num-allocs              283999
;  :num-checks              156
;  :propagations            3979
;  :quant-instantiations    1971
;  :rlimit-count            610093
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 12
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9223
;  :arith-add-rows          3160
;  :arith-assert-diseq      159
;  :arith-assert-lower      2198
;  :arith-assert-upper      1773
;  :arith-bound-prop        202
;  :arith-conflicts         219
;  :arith-eq-adapter        539
;  :arith-fixed-eqs         326
;  :arith-gcd-tests         2
;  :arith-grobner           448
;  :arith-ineq-splits       2
;  :arith-max-min           2421
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  383
;  :arith-offset-eqs        905
;  :arith-patches           2
;  :arith-pivots            704
;  :conflicts               546
;  :datatype-accessor-ax    307
;  :datatype-constructor-ax 1147
;  :datatype-occurs-check   674
;  :datatype-splits         939
;  :decisions               3016
;  :del-clause              8589
;  :final-checks            522
;  :interface-eqs           140
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.32
;  :minimized-lits          10
;  :mk-bool-var             12609
;  :mk-clause               8690
;  :num-allocs              284089
;  :num-checks              157
;  :propagations            3979
;  :quant-instantiations    1971
;  :rlimit-count            610188)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
    (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
    (as None<option<array>>  option<array>))))
(pop) ; 10
(push) ; 10
; [else-branch: 96 | !(i2@61@02 < V@7@02 && 0 <= i2@61@02)]
(assert (not (and (< i2@61@02 V@7@02) (<= 0 i2@61@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@61@02 V@7@02) (<= 0 i2@61@02))
  (and
    (< i2@61@02 V@7@02)
    (<= 0 i2@61@02)
    (< i2@61@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@61@02 Int)) (!
  (implies
    (and (< i2@61@02 V@7@02) (<= 0 i2@61@02))
    (and
      (< i2@61@02 V@7@02)
      (<= 0 i2@61@02)
      (< i2@61@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@61@02 Int)) (!
    (implies
      (and (< i2@61@02 V@7@02) (<= 0 i2@61@02))
      (and
        (< i2@61@02 V@7@02)
        (<= 0 i2@61@02)
        (< i2@61@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)))))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (< 0 V@7@02)
  (forall ((i2@61@02 Int)) (!
    (implies
      (and (< i2@61@02 V@7@02) (<= 0 i2@61@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)))))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9281
;  :arith-add-rows          3204
;  :arith-assert-diseq      167
;  :arith-assert-lower      2213
;  :arith-assert-upper      1780
;  :arith-bound-prop        205
;  :arith-conflicts         220
;  :arith-eq-adapter        548
;  :arith-fixed-eqs         329
;  :arith-gcd-tests         2
;  :arith-grobner           448
;  :arith-ineq-splits       2
;  :arith-max-min           2421
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  383
;  :arith-offset-eqs        914
;  :arith-patches           2
;  :arith-pivots            713
;  :conflicts               556
;  :datatype-accessor-ax    307
;  :datatype-constructor-ax 1147
;  :datatype-occurs-check   674
;  :datatype-splits         939
;  :decisions               3029
;  :del-clause              8767
;  :final-checks            522
;  :interface-eqs           140
;  :max-generation          6
;  :max-memory              5.37
;  :memory                  5.33
;  :minimized-lits          11
;  :mk-bool-var             12755
;  :mk-clause               8814
;  :num-allocs              285002
;  :num-checks              158
;  :propagations            4027
;  :quant-instantiations    2019
;  :rlimit-count            614000
;  :time                    0.00)
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@61@02 Int)) (!
    (implies
      (and (< i2@61@02 V@7@02) (<= 0 i2@61@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@61@02)))))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 97 | True | live]
; [else-branch: 97 | False | live]
(push) ; 7
; [then-branch: 97 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 97 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9315
;  :arith-add-rows          3215
;  :arith-assert-diseq      173
;  :arith-assert-lower      2244
;  :arith-assert-upper      1802
;  :arith-bound-prop        206
;  :arith-conflicts         220
;  :arith-eq-adapter        554
;  :arith-fixed-eqs         330
;  :arith-gcd-tests         2
;  :arith-grobner           484
;  :arith-ineq-splits       2
;  :arith-max-min           2469
;  :arith-nonlinear-bounds  248
;  :arith-nonlinear-horner  417
;  :arith-offset-eqs        918
;  :arith-patches           2
;  :arith-pivots            720
;  :conflicts               558
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1153
;  :datatype-occurs-check   678
;  :datatype-splits         945
;  :decisions               3048
;  :del-clause              8816
;  :final-checks            528
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.38
;  :memory                  5.34
;  :minimized-lits          12
;  :mk-bool-var             12812
;  :mk-clause               8863
;  :num-allocs              291529
;  :num-checks              159
;  :propagations            4047
;  :quant-instantiations    2028
;  :rlimit-count            639367
;  :time                    0.01)
; [then-branch: 98 | 0 < V@7@02 | live]
; [else-branch: 98 | !(0 < V@7@02) | dead]
(push) ; 7
; [then-branch: 98 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
(declare-const i2@62@02 Int)
(push) ; 8
; [eval] (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3)
(declare-const i3@63@02 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 99 | 0 <= i2@62@02 | live]
; [else-branch: 99 | !(0 <= i2@62@02) | live]
(push) ; 11
; [then-branch: 99 | 0 <= i2@62@02]
(assert (<= 0 i2@62@02))
; [eval] i2 < V
(push) ; 12
; [then-branch: 100 | i2@62@02 < V@7@02 | live]
; [else-branch: 100 | !(i2@62@02 < V@7@02) | live]
(push) ; 13
; [then-branch: 100 | i2@62@02 < V@7@02]
(assert (< i2@62@02 V@7@02))
; [eval] 0 <= i3
(push) ; 14
; [then-branch: 101 | 0 <= i3@63@02 | live]
; [else-branch: 101 | !(0 <= i3@63@02) | live]
(push) ; 15
; [then-branch: 101 | 0 <= i3@63@02]
(assert (<= 0 i3@63@02))
; [eval] i3 < V
(push) ; 16
; [then-branch: 102 | i3@63@02 < V@7@02 | live]
; [else-branch: 102 | !(i3@63@02 < V@7@02) | live]
(push) ; 17
; [then-branch: 102 | i3@63@02 < V@7@02]
(assert (< i3@63@02 V@7@02))
; [eval] aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 18
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 18
; Joined path conditions
(push) ; 18
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 19
(assert (not (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9315
;  :arith-add-rows          3219
;  :arith-assert-diseq      173
;  :arith-assert-lower      2248
;  :arith-assert-upper      1803
;  :arith-bound-prop        206
;  :arith-conflicts         221
;  :arith-eq-adapter        554
;  :arith-fixed-eqs         330
;  :arith-gcd-tests         2
;  :arith-grobner           484
;  :arith-ineq-splits       2
;  :arith-max-min           2469
;  :arith-nonlinear-bounds  248
;  :arith-nonlinear-horner  417
;  :arith-offset-eqs        918
;  :arith-patches           2
;  :arith-pivots            721
;  :conflicts               559
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1153
;  :datatype-occurs-check   678
;  :datatype-splits         945
;  :decisions               3048
;  :del-clause              8816
;  :final-checks            528
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.38
;  :memory                  5.33
;  :minimized-lits          12
;  :mk-bool-var             12817
;  :mk-clause               8863
;  :num-allocs              291862
;  :num-checks              160
;  :propagations            4047
;  :quant-instantiations    2028
;  :rlimit-count            639794)
(assert (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 18
; Joined path conditions
(assert (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)))
(push) ; 18
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9391
;  :arith-add-rows          3263
;  :arith-assert-diseq      183
;  :arith-assert-lower      2279
;  :arith-assert-upper      1820
;  :arith-bound-prop        212
;  :arith-conflicts         224
;  :arith-eq-adapter        574
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         2
;  :arith-grobner           484
;  :arith-ineq-splits       2
;  :arith-max-min           2469
;  :arith-nonlinear-bounds  248
;  :arith-nonlinear-horner  417
;  :arith-offset-eqs        928
;  :arith-patches           2
;  :arith-pivots            733
;  :conflicts               572
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1153
;  :datatype-occurs-check   678
;  :datatype-splits         945
;  :decisions               3064
;  :del-clause              8892
;  :final-checks            528
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.49
;  :memory                  5.43
;  :minimized-lits          13
;  :mk-bool-var             13004
;  :mk-clause               8995
;  :num-allocs              292677
;  :num-checks              161
;  :propagations            4110
;  :quant-instantiations    2071
;  :rlimit-count            643119
;  :time                    0.00)
; [eval] aloc(opt_get1(source), i3)
; [eval] opt_get1(source)
(push) ; 18
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 18
; Joined path conditions
(push) ; 18
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 19
(assert (not (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9391
;  :arith-add-rows          3266
;  :arith-assert-diseq      183
;  :arith-assert-lower      2279
;  :arith-assert-upper      1821
;  :arith-bound-prop        212
;  :arith-conflicts         225
;  :arith-eq-adapter        574
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         2
;  :arith-grobner           484
;  :arith-ineq-splits       2
;  :arith-max-min           2469
;  :arith-nonlinear-bounds  248
;  :arith-nonlinear-horner  417
;  :arith-offset-eqs        928
;  :arith-patches           2
;  :arith-pivots            735
;  :conflicts               573
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1153
;  :datatype-occurs-check   678
;  :datatype-splits         945
;  :decisions               3064
;  :del-clause              8892
;  :final-checks            528
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.49
;  :memory                  5.42
;  :minimized-lits          13
;  :mk-bool-var             13005
;  :mk-clause               8995
;  :num-allocs              292762
;  :num-checks              162
;  :propagations            4110
;  :quant-instantiations    2071
;  :rlimit-count            643276)
(assert (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 18
; Joined path conditions
(assert (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
(push) ; 18
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9485
;  :arith-add-rows          3389
;  :arith-assert-diseq      205
;  :arith-assert-lower      2322
;  :arith-assert-upper      1837
;  :arith-bound-prop        222
;  :arith-conflicts         229
;  :arith-eq-adapter        594
;  :arith-fixed-eqs         344
;  :arith-gcd-tests         2
;  :arith-grobner           484
;  :arith-ineq-splits       2
;  :arith-max-min           2469
;  :arith-nonlinear-bounds  248
;  :arith-nonlinear-horner  417
;  :arith-offset-eqs        937
;  :arith-patches           2
;  :arith-pivots            751
;  :conflicts               593
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1153
;  :datatype-occurs-check   678
;  :datatype-splits         945
;  :decisions               3091
;  :del-clause              8976
;  :final-checks            528
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.49
;  :memory                  5.44
;  :minimized-lits          14
;  :mk-bool-var             13229
;  :mk-clause               9155
;  :num-allocs              293758
;  :num-checks              163
;  :propagations            4196
;  :quant-instantiations    2118
;  :rlimit-count            648710
;  :time                    0.00)
(pop) ; 17
(push) ; 17
; [else-branch: 102 | !(i3@63@02 < V@7@02)]
(assert (not (< i3@63@02 V@7@02)))
(pop) ; 17
(pop) ; 16
; Joined path conditions
(assert (implies
  (< i3@63@02 V@7@02)
  (and
    (< i3@63@02 V@7@02)
    (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
    (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))))
; Joined path conditions
(pop) ; 15
(push) ; 15
; [else-branch: 101 | !(0 <= i3@63@02)]
(assert (not (<= 0 i3@63@02)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (<= 0 i3@63@02)
  (and
    (<= 0 i3@63@02)
    (implies
      (< i3@63@02 V@7@02)
      (and
        (< i3@63@02 V@7@02)
        (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
        (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 100 | !(i2@62@02 < V@7@02)]
(assert (not (< i2@62@02 V@7@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (< i2@62@02 V@7@02)
  (and
    (< i2@62@02 V@7@02)
    (implies
      (<= 0 i3@63@02)
      (and
        (<= 0 i3@63@02)
        (implies
          (< i3@63@02 V@7@02)
          (and
            (< i3@63@02 V@7@02)
            (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
            (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 99 | !(0 <= i2@62@02)]
(assert (not (<= 0 i2@62@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (<= 0 i2@62@02)
  (and
    (<= 0 i2@62@02)
    (implies
      (< i2@62@02 V@7@02)
      (and
        (< i2@62@02 V@7@02)
        (implies
          (<= 0 i3@63@02)
          (and
            (<= 0 i3@63@02)
            (implies
              (< i3@63@02 V@7@02)
              (and
                (< i3@63@02 V@7@02)
                (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))))))))))
; Joined path conditions
(push) ; 10
; [then-branch: 103 | Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i2@62@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i3@63@02)) && i3@63@02 < V@7@02 && 0 <= i3@63@02 && i2@62@02 < V@7@02 && 0 <= i2@62@02 | live]
; [else-branch: 103 | !(Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i2@62@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i3@63@02)) && i3@63@02 < V@7@02 && 0 <= i3@63@02 && i2@62@02 < V@7@02 && 0 <= i2@62@02) | live]
(push) ; 11
; [then-branch: 103 | Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i2@62@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i3@63@02)) && i3@63@02 < V@7@02 && 0 <= i3@63@02 && i2@62@02 < V@7@02 && 0 <= i2@62@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
        (< i3@63@02 V@7@02))
      (<= 0 i3@63@02))
    (< i2@62@02 V@7@02))
  (<= 0 i2@62@02)))
; [eval] i2 == i3
(pop) ; 11
(push) ; 11
; [else-branch: 103 | !(Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i2@62@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, source@9@02), i3@63@02)) && i3@63@02 < V@7@02 && 0 <= i3@63@02 && i2@62@02 < V@7@02 && 0 <= i2@62@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
          (< i3@63@02 V@7@02))
        (<= 0 i3@63@02))
      (< i2@62@02 V@7@02))
    (<= 0 i2@62@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
          (< i3@63@02 V@7@02))
        (<= 0 i3@63@02))
      (< i2@62@02 V@7@02))
    (<= 0 i2@62@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
      ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
    (< i3@63@02 V@7@02)
    (<= 0 i3@63@02)
    (< i2@62@02 V@7@02)
    (<= 0 i2@62@02))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@63@02 Int)) (!
  (and
    (implies
      (<= 0 i2@62@02)
      (and
        (<= 0 i2@62@02)
        (implies
          (< i2@62@02 V@7@02)
          (and
            (< i2@62@02 V@7@02)
            (implies
              (<= 0 i3@63@02)
              (and
                (<= 0 i3@63@02)
                (implies
                  (< i3@63@02 V@7@02)
                  (and
                    (< i3@63@02 V@7@02)
                    (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                    (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
              (< i3@63@02 V@7@02))
            (<= 0 i3@63@02))
          (< i2@62@02 V@7@02))
        (<= 0 i2@62@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
        (< i3@63@02 V@7@02)
        (<= 0 i3@63@02)
        (< i2@62@02 V@7@02)
        (<= 0 i2@62@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@62@02 Int)) (!
  (forall ((i3@63@02 Int)) (!
    (and
      (implies
        (<= 0 i2@62@02)
        (and
          (<= 0 i2@62@02)
          (implies
            (< i2@62@02 V@7@02)
            (and
              (< i2@62@02 V@7@02)
              (implies
                (<= 0 i3@63@02)
                (and
                  (<= 0 i3@63@02)
                  (implies
                    (< i3@63@02 V@7@02)
                    (and
                      (< i3@63@02 V@7@02)
                      (< i2@62@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                      (< i3@63@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
                (< i3@63@02 V@7@02))
              (<= 0 i3@63@02))
            (< i2@62@02 V@7@02))
          (<= 0 i2@62@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
          (< i3@63@02 V@7@02)
          (<= 0 i3@63@02)
          (< i2@62@02 V@7@02)
          (<= 0 i2@62@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@62@02 Int)) (!
    (forall ((i3@63@02 Int)) (!
      (and
        (implies
          (<= 0 i2@62@02)
          (and
            (<= 0 i2@62@02)
            (implies
              (< i2@62@02 V@7@02)
              (and
                (< i2@62@02 V@7@02)
                (implies
                  (<= 0 i3@63@02)
                  (and
                    (<= 0 i3@63@02)
                    (implies
                      (< i3@63@02 V@7@02)
                      (and
                        (< i3@63@02 V@7@02)
                        (<
                          i2@62@02
                          (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                        (<
                          i3@63@02
                          (alen<Int> (opt_get1 $Snap.unit source@9@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
                  (< i3@63@02 V@7@02))
                (<= 0 i3@63@02))
              (< i2@62@02 V@7@02))
            (<= 0 i2@62@02))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
              ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
            (< i3@63@02 V@7@02)
            (<= 0 i3@63@02)
            (< i2@62@02 V@7@02)
            (<= 0 i2@62@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (< 0 V@7@02)
  (forall ((i2@62@02 Int)) (!
    (forall ((i3@63@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
                (< i3@63@02 V@7@02))
              (<= 0 i3@63@02))
            (< i2@62@02 V@7@02))
          (<= 0 i2@62@02))
        (= i2@62@02 i3@63@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9568
;  :arith-add-rows          3551
;  :arith-assert-diseq      212
;  :arith-assert-lower      2343
;  :arith-assert-upper      1849
;  :arith-bound-prop        229
;  :arith-conflicts         231
;  :arith-eq-adapter        606
;  :arith-fixed-eqs         349
;  :arith-gcd-tests         2
;  :arith-grobner           484
;  :arith-ineq-splits       2
;  :arith-max-min           2469
;  :arith-nonlinear-bounds  248
;  :arith-nonlinear-horner  417
;  :arith-offset-eqs        946
;  :arith-patches           2
;  :arith-pivots            776
;  :conflicts               607
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 1153
;  :datatype-occurs-check   678
;  :datatype-splits         945
;  :decisions               3109
;  :del-clause              9352
;  :final-checks            528
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.49
;  :memory                  5.47
;  :minimized-lits          15
;  :mk-bool-var             13546
;  :mk-clause               9399
;  :num-allocs              295782
;  :num-checks              164
;  :propagations            4296
;  :quant-instantiations    2209
;  :rlimit-count            659332
;  :time                    0.00)
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@62@02 Int)) (!
    (forall ((i3@63@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02)))
                (< i3@63@02 V@7@02))
              (<= 0 i3@63@02))
            (< i2@62@02 V@7@02))
          (<= 0 i2@62@02))
        (= i2@62@02 i3@63@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i3@63@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i2@62@02))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 104 | True | live]
; [else-branch: 104 | False | live]
(push) ; 7
; [then-branch: 104 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 104 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9601
;  :arith-add-rows          3560
;  :arith-assert-diseq      218
;  :arith-assert-lower      2374
;  :arith-assert-upper      1870
;  :arith-bound-prop        230
;  :arith-conflicts         231
;  :arith-eq-adapter        611
;  :arith-fixed-eqs         350
;  :arith-gcd-tests         2
;  :arith-grobner           522
;  :arith-ineq-splits       2
;  :arith-max-min           2517
;  :arith-nonlinear-bounds  250
;  :arith-nonlinear-horner  451
;  :arith-offset-eqs        950
;  :arith-patches           2
;  :arith-pivots            782
;  :conflicts               609
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 1159
;  :datatype-occurs-check   682
;  :datatype-splits         951
;  :decisions               3127
;  :del-clause              9399
;  :final-checks            533
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.48
;  :minimized-lits          16
;  :mk-bool-var             13602
;  :mk-clause               9446
;  :num-allocs              300698
;  :num-checks              165
;  :propagations            4315
;  :quant-instantiations    2219
;  :rlimit-count            681741
;  :time                    0.01)
; [then-branch: 105 | 0 < V@7@02 | live]
; [else-branch: 105 | !(0 < V@7@02) | dead]
(push) ; 7
; [then-branch: 105 | 0 < V@7@02]
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 106 | True | live]
; [else-branch: 106 | False | live]
(push) ; 7
; [then-branch: 106 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 106 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(push) ; 7
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9634
;  :arith-add-rows          3569
;  :arith-assert-diseq      224
;  :arith-assert-lower      2405
;  :arith-assert-upper      1891
;  :arith-bound-prop        231
;  :arith-conflicts         231
;  :arith-eq-adapter        616
;  :arith-fixed-eqs         351
;  :arith-gcd-tests         2
;  :arith-grobner           560
;  :arith-ineq-splits       2
;  :arith-max-min           2565
;  :arith-nonlinear-bounds  252
;  :arith-nonlinear-horner  485
;  :arith-offset-eqs        954
;  :arith-patches           2
;  :arith-pivots            788
;  :conflicts               611
;  :datatype-accessor-ax    310
;  :datatype-constructor-ax 1165
;  :datatype-occurs-check   686
;  :datatype-splits         957
;  :decisions               3145
;  :del-clause              9446
;  :final-checks            538
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.48
;  :minimized-lits          17
;  :mk-bool-var             13656
;  :mk-clause               9493
;  :num-allocs              305243
;  :num-checks              166
;  :propagations            4334
;  :quant-instantiations    2228
;  :rlimit-count            703588
;  :time                    0.00)
; [then-branch: 107 | 0 < V@7@02 | live]
; [else-branch: 107 | !(0 < V@7@02) | dead]
(push) ; 7
; [then-branch: 107 | 0 < V@7@02]
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 8
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 108 | True | live]
; [else-branch: 108 | False | live]
(push) ; 7
; [then-branch: 108 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 108 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9667
;  :arith-add-rows          3578
;  :arith-assert-diseq      230
;  :arith-assert-lower      2436
;  :arith-assert-upper      1912
;  :arith-bound-prop        232
;  :arith-conflicts         231
;  :arith-eq-adapter        621
;  :arith-fixed-eqs         352
;  :arith-gcd-tests         2
;  :arith-grobner           598
;  :arith-ineq-splits       2
;  :arith-max-min           2613
;  :arith-nonlinear-bounds  254
;  :arith-nonlinear-horner  519
;  :arith-offset-eqs        958
;  :arith-patches           2
;  :arith-pivots            794
;  :conflicts               613
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 1171
;  :datatype-occurs-check   690
;  :datatype-splits         963
;  :decisions               3163
;  :del-clause              9493
;  :final-checks            543
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.48
;  :minimized-lits          18
;  :mk-bool-var             13710
;  :mk-clause               9540
;  :num-allocs              309788
;  :num-checks              167
;  :propagations            4353
;  :quant-instantiations    2237
;  :rlimit-count            725435
;  :time                    0.01)
; [then-branch: 109 | 0 < V@7@02 | live]
; [else-branch: 109 | !(0 < V@7@02) | dead]
(push) ; 6
; [then-branch: 109 | 0 < V@7@02]
(declare-const i2@64@02 Int)
(push) ; 7
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 8
; [then-branch: 110 | 0 <= i2@64@02 | live]
; [else-branch: 110 | !(0 <= i2@64@02) | live]
(push) ; 9
; [then-branch: 110 | 0 <= i2@64@02]
(assert (<= 0 i2@64@02))
; [eval] i2 < V
(pop) ; 9
(push) ; 9
; [else-branch: 110 | !(0 <= i2@64@02)]
(assert (not (<= 0 i2@64@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< i2@64@02 V@7@02) (<= 0 i2@64@02)))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 8
; [eval] amount >= 0 * write
; [eval] 0 * write
(set-option :timeout 0)
(push) ; 9
(assert (not (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9667
;  :arith-add-rows          3579
;  :arith-assert-diseq      230
;  :arith-assert-lower      2438
;  :arith-assert-upper      1912
;  :arith-bound-prop        232
;  :arith-conflicts         231
;  :arith-eq-adapter        621
;  :arith-fixed-eqs         352
;  :arith-gcd-tests         2
;  :arith-grobner           598
;  :arith-ineq-splits       2
;  :arith-max-min           2613
;  :arith-nonlinear-bounds  254
;  :arith-nonlinear-horner  519
;  :arith-offset-eqs        958
;  :arith-patches           2
;  :arith-pivots            795
;  :conflicts               614
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 1171
;  :datatype-occurs-check   690
;  :datatype-splits         963
;  :decisions               3163
;  :del-clause              9493
;  :final-checks            543
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.48
;  :minimized-lits          18
;  :mk-bool-var             13712
;  :mk-clause               9540
;  :num-allocs              309954
;  :num-checks              168
;  :propagations            4353
;  :quant-instantiations    2237
;  :rlimit-count            725680)
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(pop) ; 8
; Joined path conditions
(assert (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No))
(declare-const $k@65@02 $Perm)
(assert ($Perm.isReadVar $k@65@02 $Perm.Write))
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 8
; Joined path conditions
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i2@64@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9667
;  :arith-add-rows          3579
;  :arith-assert-diseq      231
;  :arith-assert-lower      2440
;  :arith-assert-upper      1913
;  :arith-bound-prop        232
;  :arith-conflicts         231
;  :arith-eq-adapter        622
;  :arith-fixed-eqs         352
;  :arith-gcd-tests         2
;  :arith-grobner           598
;  :arith-ineq-splits       2
;  :arith-max-min           2613
;  :arith-nonlinear-bounds  254
;  :arith-nonlinear-horner  519
;  :arith-offset-eqs        958
;  :arith-patches           2
;  :arith-pivots            795
;  :conflicts               614
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 1171
;  :datatype-occurs-check   690
;  :datatype-splits         963
;  :decisions               3163
;  :del-clause              9493
;  :final-checks            543
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.48
;  :minimized-lits          18
;  :mk-bool-var             13716
;  :mk-clause               9542
;  :num-allocs              310150
;  :num-checks              169
;  :propagations            4354
;  :quant-instantiations    2237
;  :rlimit-count            725925)
(assert (< i2@64@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 8
; Joined path conditions
(assert (< i2@64@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 7
(declare-fun inv@66@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@65@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@64@02 Int)) (!
  (and
    (>= (* (to_real (* V@7@02 V@7@02)) $Perm.Write) $Perm.No)
    (< i2@64@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@64@02))
  :qid |option$array$-aux|)))
(push) ; 7
(assert (not (forall ((i2@64@02 Int)) (!
  (implies
    (and (< i2@64@02 V@7@02) (<= 0 i2@64@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@65@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@65@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9683
;  :arith-add-rows          3582
;  :arith-assert-diseq      239
;  :arith-assert-lower      2465
;  :arith-assert-upper      1927
;  :arith-bound-prop        232
;  :arith-conflicts         232
;  :arith-eq-adapter        629
;  :arith-fixed-eqs         353
;  :arith-gcd-tests         2
;  :arith-grobner           598
;  :arith-ineq-splits       2
;  :arith-max-min           2633
;  :arith-nonlinear-bounds  257
;  :arith-nonlinear-horner  519
;  :arith-offset-eqs        962
;  :arith-patches           2
;  :arith-pivots            800
;  :conflicts               617
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 1171
;  :datatype-occurs-check   690
;  :datatype-splits         963
;  :decisions               3176
;  :del-clause              9543
;  :final-checks            544
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.47
;  :minimized-lits          19
;  :mk-bool-var             13774
;  :mk-clause               9592
;  :num-allocs              310803
;  :num-checks              170
;  :propagations            4374
;  :quant-instantiations    2247
;  :rlimit-count            727498)
(declare-const sm@67@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r))
  :qid |qp.fvfValDef24|)))
(assert (forall ((r $Ref)) (!
  (implies
    (<
      $Perm.No
      (-
        (ite
          (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@16@02)
          $Perm.No)
        (pTaken@58@02 r)))
    (=
      ($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r))
  :qid |qp.fvfValDef25|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@02)))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef26|)))
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((i21@64@02 Int) (i22@64@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< i21@64@02 V@7@02) (<= 0 i21@64@02))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i21@64@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i21@64@02)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@65@02)))
      (and
        (and
          (and (< i22@64@02 V@7@02) (<= 0 i22@64@02))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i22@64@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i22@64@02)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@65@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i21@64@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i22@64@02)))
    (= i21@64@02 i22@64@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9694
;  :arith-add-rows          3594
;  :arith-assert-diseq      240
;  :arith-assert-lower      2470
;  :arith-assert-upper      1927
;  :arith-bound-prop        232
;  :arith-conflicts         232
;  :arith-eq-adapter        630
;  :arith-fixed-eqs         353
;  :arith-gcd-tests         2
;  :arith-grobner           598
;  :arith-ineq-splits       2
;  :arith-max-min           2633
;  :arith-nonlinear-bounds  257
;  :arith-nonlinear-horner  519
;  :arith-offset-eqs        962
;  :arith-patches           2
;  :arith-pivots            804
;  :conflicts               618
;  :datatype-accessor-ax    311
;  :datatype-constructor-ax 1171
;  :datatype-occurs-check   690
;  :datatype-splits         963
;  :decisions               3176
;  :del-clause              9566
;  :final-checks            544
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.47
;  :minimized-lits          19
;  :mk-bool-var             13843
;  :mk-clause               9634
;  :num-allocs              311940
;  :num-checks              171
;  :propagations            4376
;  :quant-instantiations    2265
;  :rlimit-count            730542
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((i2@64@02 Int)) (!
  (implies
    (and
      (and (< i2@64@02 V@7@02) (<= 0 i2@64@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@65@02)))
    (=
      (inv@66@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@64@02))
      i2@64@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@64@02))
  :qid |option$array$-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@66@02 r) V@7@02) (<= 0 (inv@66@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@65@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) (inv@66@02 r))
      r))
  :pattern ((inv@66@02 r))
  :qid |option$array$-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@66@02 r) V@7@02) (<= 0 (inv@66@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@67@02  $FVF<option<array>>) r) r))
  :pattern ((inv@66@02 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@68@02 ((r $Ref)) $Perm
  (ite
    (and (< (inv@66@02 r) V@7@02) (<= 0 (inv@66@02 r)))
    ($Perm.min
      (ite
        (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02)
        $Perm.No)
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@65@02))
    $Perm.No))
(define-fun pTaken@69@02 ((r $Ref)) $Perm
  (ite
    (and (< (inv@66@02 r) V@7@02) (<= 0 (inv@66@02 r)))
    ($Perm.min
      (-
        (ite
          (and (< (inv@17@02 r) V@7@02) (<= 0 (inv@17@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@16@02)
          $Perm.No)
        (pTaken@58@02 r))
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@65@02)
        (pTaken@68@02 r)))
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Constrain original permissions scale(_, V@7@02 * V@7@02 * W) * $k@65@02
(assert (forall ((r $Ref)) (!
  (implies
    (not
      (=
        (ite
          (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@24@02)
          $Perm.No)
        $Perm.No))
    (ite
      (and (< (inv@25@02 r) V@7@02) (<= 0 (inv@25@02 r)))
      (<
        (ite
          (and (< (inv@66@02 r) V@7@02) (<= 0 (inv@66@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@65@02)
          $Perm.No)
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@24@02))
      (<
        (ite
          (and (< (inv@66@02 r) V@7@02) (<= 0 (inv@66@02 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
            $k@65@02)
          $Perm.No)
        $Perm.No)))
  :pattern ((inv@25@02 r))
  :pattern ((inv@66@02 r))
  :qid |qp.srp27|)))
; Intermediate check if already taken enough permissions
(set-option :timeout 500)
(push) ; 7
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@66@02 r) V@7@02) (<= 0 (inv@66@02 r)))
    (=
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write))
          $k@65@02)
        (pTaken@68@02 r))
      $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9882
;  :arith-add-rows          3804
;  :arith-assert-diseq      260
;  :arith-assert-lower      2563
;  :arith-assert-upper      1977
;  :arith-bound-prop        244
;  :arith-conflicts         238
;  :arith-eq-adapter        680
;  :arith-fixed-eqs         368
;  :arith-gcd-tests         2
;  :arith-grobner           640
;  :arith-ineq-splits       2
;  :arith-max-min           2713
;  :arith-nonlinear-bounds  261
;  :arith-nonlinear-horner  557
;  :arith-offset-eqs        991
;  :arith-patches           2
;  :arith-pivots            849
;  :conflicts               635
;  :datatype-accessor-ax    312
;  :datatype-constructor-ax 1177
;  :datatype-occurs-check   694
;  :datatype-splits         969
;  :decisions               3219
;  :del-clause              9779
;  :final-checks            550
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.52
;  :memory                  5.50
;  :minimized-lits          20
;  :mk-bool-var             14163
;  :mk-clause               9862
;  :num-allocs              318922
;  :num-checks              173
;  :propagations            4490
;  :quant-instantiations    2319
;  :rlimit-count            765669
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 111 | True | live]
; [else-branch: 111 | False | live]
(push) ; 8
; [then-branch: 111 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 111 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9946
;  :arith-add-rows          3831
;  :arith-assert-diseq      266
;  :arith-assert-lower      2606
;  :arith-assert-upper      2005
;  :arith-bound-prop        247
;  :arith-conflicts         238
;  :arith-eq-adapter        690
;  :arith-fixed-eqs         373
;  :arith-gcd-tests         2
;  :arith-grobner           686
;  :arith-ineq-splits       2
;  :arith-max-min           2771
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  601
;  :arith-offset-eqs        999
;  :arith-patches           2
;  :arith-pivots            861
;  :conflicts               637
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1183
;  :datatype-occurs-check   698
;  :datatype-splits         975
;  :decisions               3241
;  :del-clause              9822
;  :final-checks            555
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.56
;  :memory                  5.52
;  :minimized-lits          21
;  :mk-bool-var             14219
;  :mk-clause               9905
;  :num-allocs              325477
;  :num-checks              174
;  :propagations            4516
;  :quant-instantiations    2327
;  :rlimit-count            805780
;  :time                    0.01)
; [then-branch: 112 | 0 < V@7@02 | live]
; [else-branch: 112 | !(0 < V@7@02) | dead]
(push) ; 8
; [then-branch: 112 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
(declare-const i2@70@02 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 113 | 0 <= i2@70@02 | live]
; [else-branch: 113 | !(0 <= i2@70@02) | live]
(push) ; 11
; [then-branch: 113 | 0 <= i2@70@02]
(assert (<= 0 i2@70@02))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 113 | !(0 <= i2@70@02)]
(assert (not (<= 0 i2@70@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 114 | i2@70@02 < V@7@02 && 0 <= i2@70@02 | live]
; [else-branch: 114 | !(i2@70@02 < V@7@02 && 0 <= i2@70@02) | live]
(push) ; 11
; [then-branch: 114 | i2@70@02 < V@7@02 && 0 <= i2@70@02]
(assert (and (< i2@70@02 V@7@02) (<= 0 i2@70@02)))
; [eval] aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 12
; Joined path conditions
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 13
(assert (not (< i2@70@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9946
;  :arith-add-rows          3832
;  :arith-assert-diseq      266
;  :arith-assert-lower      2608
;  :arith-assert-upper      2005
;  :arith-bound-prop        247
;  :arith-conflicts         238
;  :arith-eq-adapter        690
;  :arith-fixed-eqs         373
;  :arith-gcd-tests         2
;  :arith-grobner           686
;  :arith-ineq-splits       2
;  :arith-max-min           2771
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  601
;  :arith-offset-eqs        999
;  :arith-patches           2
;  :arith-pivots            861
;  :conflicts               637
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1183
;  :datatype-occurs-check   698
;  :datatype-splits         975
;  :decisions               3241
;  :del-clause              9822
;  :final-checks            555
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.56
;  :memory                  5.52
;  :minimized-lits          21
;  :mk-bool-var             14221
;  :mk-clause               9905
;  :num-allocs              325575
;  :num-checks              175
;  :propagations            4516
;  :quant-instantiations    2327
;  :rlimit-count            805976)
(assert (< i2@70@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 12
; Joined path conditions
(assert (< i2@70@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10064
;  :arith-add-rows          3930
;  :arith-assert-diseq      276
;  :arith-assert-lower      2645
;  :arith-assert-upper      2025
;  :arith-bound-prop        254
;  :arith-conflicts         241
;  :arith-eq-adapter        719
;  :arith-fixed-eqs         384
;  :arith-gcd-tests         2
;  :arith-grobner           686
;  :arith-ineq-splits       2
;  :arith-max-min           2771
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  601
;  :arith-offset-eqs        1017
;  :arith-patches           2
;  :arith-pivots            878
;  :conflicts               655
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1183
;  :datatype-occurs-check   698
;  :datatype-splits         975
;  :decisions               3262
;  :del-clause              9937
;  :final-checks            555
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.56
;  :memory                  5.51
;  :minimized-lits          22
;  :mk-bool-var             14483
;  :mk-clause               10089
;  :num-allocs              326633
;  :num-checks              176
;  :propagations            4591
;  :quant-instantiations    2372
;  :rlimit-count            810420
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 11
(push) ; 11
; [else-branch: 114 | !(i2@70@02 < V@7@02 && 0 <= i2@70@02)]
(assert (not (and (< i2@70@02 V@7@02) (<= 0 i2@70@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@70@02 V@7@02) (<= 0 i2@70@02))
  (and
    (< i2@70@02 V@7@02)
    (<= 0 i2@70@02)
    (< i2@70@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02)))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@70@02 Int)) (!
  (implies
    (and (< i2@70@02 V@7@02) (<= 0 i2@70@02))
    (and
      (< i2@70@02 V@7@02)
      (<= 0 i2@70@02)
      (< i2@70@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@70@02 Int)) (!
    (implies
      (and (< i2@70@02 V@7@02) (<= 0 i2@70@02))
      (and
        (< i2@70@02 V@7@02)
        (<= 0 i2@70@02)
        (< i2@70@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
    :qid |prog.l<no position>-aux|))))
(push) ; 7
(assert (not (implies
  (< 0 V@7@02)
  (forall ((i2@70@02 Int)) (!
    (implies
      (and (< i2@70@02 V@7@02) (<= 0 i2@70@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10124
;  :arith-add-rows          3950
;  :arith-assert-diseq      282
;  :arith-assert-lower      2664
;  :arith-assert-upper      2037
;  :arith-bound-prop        257
;  :arith-conflicts         242
;  :arith-eq-adapter        736
;  :arith-fixed-eqs         390
;  :arith-gcd-tests         2
;  :arith-grobner           686
;  :arith-ineq-splits       2
;  :arith-max-min           2771
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  601
;  :arith-offset-eqs        1023
;  :arith-patches           2
;  :arith-pivots            885
;  :conflicts               670
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1183
;  :datatype-occurs-check   698
;  :datatype-splits         975
;  :decisions               3280
;  :del-clause              10147
;  :final-checks            555
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.56
;  :memory                  5.52
;  :minimized-lits          23
;  :mk-bool-var             14649
;  :mk-clause               10232
;  :num-allocs              327545
;  :num-checks              177
;  :propagations            4638
;  :quant-instantiations    2415
;  :rlimit-count            813720
;  :time                    0.00)
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@70@02 Int)) (!
    (implies
      (and (< i2@70@02 V@7@02) (<= 0 i2@70@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@70@02))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 115 | True | live]
; [else-branch: 115 | False | live]
(push) ; 8
; [then-branch: 115 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 115 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10191
;  :arith-add-rows          3975
;  :arith-assert-diseq      288
;  :arith-assert-lower      2707
;  :arith-assert-upper      2066
;  :arith-bound-prop        260
;  :arith-conflicts         242
;  :arith-eq-adapter        746
;  :arith-fixed-eqs         395
;  :arith-gcd-tests         2
;  :arith-grobner           732
;  :arith-ineq-splits       2
;  :arith-max-min           2830
;  :arith-nonlinear-bounds  263
;  :arith-nonlinear-horner  645
;  :arith-offset-eqs        1034
;  :arith-patches           2
;  :arith-pivots            896
;  :conflicts               672
;  :datatype-accessor-ax    314
;  :datatype-constructor-ax 1189
;  :datatype-occurs-check   702
;  :datatype-splits         981
;  :decisions               3302
;  :del-clause              10190
;  :final-checks            560
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.53
;  :minimized-lits          24
;  :mk-bool-var             14706
;  :mk-clause               10275
;  :num-allocs              334689
;  :num-checks              178
;  :propagations            4664
;  :quant-instantiations    2423
;  :rlimit-count            855025
;  :time                    0.01)
; [then-branch: 116 | 0 < V@7@02 | live]
; [else-branch: 116 | !(0 < V@7@02) | dead]
(push) ; 8
; [then-branch: 116 | 0 < V@7@02]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
(declare-const i2@71@02 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 117 | 0 <= i2@71@02 | live]
; [else-branch: 117 | !(0 <= i2@71@02) | live]
(push) ; 11
; [then-branch: 117 | 0 <= i2@71@02]
(assert (<= 0 i2@71@02))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 117 | !(0 <= i2@71@02)]
(assert (not (<= 0 i2@71@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 118 | i2@71@02 < V@7@02 && 0 <= i2@71@02 | live]
; [else-branch: 118 | !(i2@71@02 < V@7@02 && 0 <= i2@71@02) | live]
(push) ; 11
; [then-branch: 118 | i2@71@02 < V@7@02 && 0 <= i2@71@02]
(assert (and (< i2@71@02 V@7@02) (<= 0 i2@71@02)))
; [eval] alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(target), i2).option$array$))
; [eval] opt_get1(aloc(opt_get1(target), i2).option$array$)
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 12
; Joined path conditions
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 13
(assert (not (< i2@71@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10191
;  :arith-add-rows          3976
;  :arith-assert-diseq      288
;  :arith-assert-lower      2709
;  :arith-assert-upper      2066
;  :arith-bound-prop        260
;  :arith-conflicts         242
;  :arith-eq-adapter        746
;  :arith-fixed-eqs         395
;  :arith-gcd-tests         2
;  :arith-grobner           732
;  :arith-ineq-splits       2
;  :arith-max-min           2830
;  :arith-nonlinear-bounds  263
;  :arith-nonlinear-horner  645
;  :arith-offset-eqs        1034
;  :arith-patches           2
;  :arith-pivots            896
;  :conflicts               672
;  :datatype-accessor-ax    314
;  :datatype-constructor-ax 1189
;  :datatype-occurs-check   702
;  :datatype-splits         981
;  :decisions               3302
;  :del-clause              10190
;  :final-checks            560
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.53
;  :minimized-lits          24
;  :mk-bool-var             14708
;  :mk-clause               10275
;  :num-allocs              334787
;  :num-checks              179
;  :propagations            4664
;  :quant-instantiations    2423
;  :rlimit-count            855221)
(assert (< i2@71@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 12
; Joined path conditions
(assert (< i2@71@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10312
;  :arith-add-rows          4073
;  :arith-assert-diseq      298
;  :arith-assert-lower      2746
;  :arith-assert-upper      2086
;  :arith-bound-prop        267
;  :arith-conflicts         245
;  :arith-eq-adapter        775
;  :arith-fixed-eqs         406
;  :arith-gcd-tests         2
;  :arith-grobner           732
;  :arith-ineq-splits       2
;  :arith-max-min           2830
;  :arith-nonlinear-bounds  263
;  :arith-nonlinear-horner  645
;  :arith-offset-eqs        1052
;  :arith-patches           2
;  :arith-pivots            911
;  :conflicts               690
;  :datatype-accessor-ax    314
;  :datatype-constructor-ax 1189
;  :datatype-occurs-check   702
;  :datatype-splits         981
;  :decisions               3323
;  :del-clause              10305
;  :final-checks            560
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.52
;  :minimized-lits          25
;  :mk-bool-var             14973
;  :mk-clause               10459
;  :num-allocs              335834
;  :num-checks              180
;  :propagations            4739
;  :quant-instantiations    2470
;  :rlimit-count            859686
;  :time                    0.00)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 13
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10312
;  :arith-add-rows          4073
;  :arith-assert-diseq      298
;  :arith-assert-lower      2746
;  :arith-assert-upper      2086
;  :arith-bound-prop        267
;  :arith-conflicts         245
;  :arith-eq-adapter        775
;  :arith-fixed-eqs         406
;  :arith-gcd-tests         2
;  :arith-grobner           732
;  :arith-ineq-splits       2
;  :arith-max-min           2830
;  :arith-nonlinear-bounds  263
;  :arith-nonlinear-horner  645
;  :arith-offset-eqs        1052
;  :arith-patches           2
;  :arith-pivots            911
;  :conflicts               691
;  :datatype-accessor-ax    314
;  :datatype-constructor-ax 1189
;  :datatype-occurs-check   702
;  :datatype-splits         981
;  :decisions               3323
;  :del-clause              10305
;  :final-checks            560
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.52
;  :minimized-lits          25
;  :mk-bool-var             14973
;  :mk-clause               10459
;  :num-allocs              335925
;  :num-checks              181
;  :propagations            4739
;  :quant-instantiations    2470
;  :rlimit-count            859781)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
    (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
    (as None<option<array>>  option<array>))))
(pop) ; 11
(push) ; 11
; [else-branch: 118 | !(i2@71@02 < V@7@02 && 0 <= i2@71@02)]
(assert (not (and (< i2@71@02 V@7@02) (<= 0 i2@71@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@71@02 V@7@02) (<= 0 i2@71@02))
  (and
    (< i2@71@02 V@7@02)
    (<= 0 i2@71@02)
    (< i2@71@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@71@02 Int)) (!
  (implies
    (and (< i2@71@02 V@7@02) (<= 0 i2@71@02))
    (and
      (< i2@71@02 V@7@02)
      (<= 0 i2@71@02)
      (< i2@71@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@71@02 Int)) (!
    (implies
      (and (< i2@71@02 V@7@02) (<= 0 i2@71@02))
      (and
        (< i2@71@02 V@7@02)
        (<= 0 i2@71@02)
        (< i2@71@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)))))
    :qid |prog.l<no position>-aux|))))
(push) ; 7
(assert (not (implies
  (< 0 V@7@02)
  (forall ((i2@71@02 Int)) (!
    (implies
      (and (< i2@71@02 V@7@02) (<= 0 i2@71@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)))))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10390
;  :arith-add-rows          4094
;  :arith-assert-diseq      306
;  :arith-assert-lower      2767
;  :arith-assert-upper      2098
;  :arith-bound-prop        271
;  :arith-conflicts         246
;  :arith-eq-adapter        793
;  :arith-fixed-eqs         412
;  :arith-gcd-tests         2
;  :arith-grobner           732
;  :arith-ineq-splits       2
;  :arith-max-min           2830
;  :arith-nonlinear-bounds  263
;  :arith-nonlinear-horner  645
;  :arith-offset-eqs        1060
;  :arith-patches           2
;  :arith-pivots            919
;  :conflicts               706
;  :datatype-accessor-ax    314
;  :datatype-constructor-ax 1189
;  :datatype-occurs-check   702
;  :datatype-splits         981
;  :decisions               3341
;  :del-clause              10522
;  :final-checks            560
;  :interface-eqs           141
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.52
;  :minimized-lits          26
;  :mk-bool-var             15151
;  :mk-clause               10609
;  :num-allocs              336895
;  :num-checks              182
;  :propagations            4792
;  :quant-instantiations    2521
;  :rlimit-count            863444
;  :time                    0.00)
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@71@02 Int)) (!
    (implies
      (and (< i2@71@02 V@7@02) (<= 0 i2@71@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02))))
        V@7@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@71@02)))))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 119 | True | live]
; [else-branch: 119 | False | live]
(push) ; 8
; [then-branch: 119 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 119 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (< 0 V@7@02))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10458
;  :arith-add-rows          4129
;  :arith-assert-diseq      312
;  :arith-assert-lower      2810
;  :arith-assert-upper      2128
;  :arith-bound-prop        274
;  :arith-conflicts         246
;  :arith-eq-adapter        804
;  :arith-fixed-eqs         417
;  :arith-gcd-tests         2
;  :arith-grobner           777
;  :arith-ineq-splits       2
;  :arith-max-min           2889
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  688
;  :arith-offset-eqs        1071
;  :arith-patches           2
;  :arith-pivots            931
;  :conflicts               708
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 1195
;  :datatype-occurs-check   706
;  :datatype-splits         987
;  :decisions               3364
;  :del-clause              10567
;  :final-checks            566
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.53
;  :minimized-lits          27
;  :mk-bool-var             15209
;  :mk-clause               10654
;  :num-allocs              343601
;  :num-checks              183
;  :propagations            4819
;  :quant-instantiations    2529
;  :rlimit-count            902644
;  :time                    0.01)
; [then-branch: 120 | 0 < V@7@02 | live]
; [else-branch: 120 | !(0 < V@7@02) | dead]
(push) ; 8
; [then-branch: 120 | 0 < V@7@02]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
(declare-const i2@72@02 Int)
(push) ; 9
; [eval] (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3)
(declare-const i3@73@02 Int)
(push) ; 10
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] 0 <= i2
(push) ; 11
; [then-branch: 121 | 0 <= i2@72@02 | live]
; [else-branch: 121 | !(0 <= i2@72@02) | live]
(push) ; 12
; [then-branch: 121 | 0 <= i2@72@02]
(assert (<= 0 i2@72@02))
; [eval] i2 < V
(push) ; 13
; [then-branch: 122 | i2@72@02 < V@7@02 | live]
; [else-branch: 122 | !(i2@72@02 < V@7@02) | live]
(push) ; 14
; [then-branch: 122 | i2@72@02 < V@7@02]
(assert (< i2@72@02 V@7@02))
; [eval] 0 <= i3
(push) ; 15
; [then-branch: 123 | 0 <= i3@73@02 | live]
; [else-branch: 123 | !(0 <= i3@73@02) | live]
(push) ; 16
; [then-branch: 123 | 0 <= i3@73@02]
(assert (<= 0 i3@73@02))
; [eval] i3 < V
(push) ; 17
; [then-branch: 124 | i3@73@02 < V@7@02 | live]
; [else-branch: 124 | !(i3@73@02 < V@7@02) | live]
(push) ; 18
; [then-branch: 124 | i3@73@02 < V@7@02]
(assert (< i3@73@02 V@7@02))
; [eval] aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 19
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 19
; Joined path conditions
(push) ; 19
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 20
(assert (not (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10458
;  :arith-add-rows          4131
;  :arith-assert-diseq      312
;  :arith-assert-lower      2814
;  :arith-assert-upper      2128
;  :arith-bound-prop        274
;  :arith-conflicts         246
;  :arith-eq-adapter        804
;  :arith-fixed-eqs         417
;  :arith-gcd-tests         2
;  :arith-grobner           777
;  :arith-ineq-splits       2
;  :arith-max-min           2889
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  688
;  :arith-offset-eqs        1071
;  :arith-patches           2
;  :arith-pivots            933
;  :conflicts               708
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 1195
;  :datatype-occurs-check   706
;  :datatype-splits         987
;  :decisions               3364
;  :del-clause              10567
;  :final-checks            566
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.53
;  :minimized-lits          27
;  :mk-bool-var             15213
;  :mk-clause               10654
;  :num-allocs              343876
;  :num-checks              184
;  :propagations            4819
;  :quant-instantiations    2529
;  :rlimit-count            902999)
(assert (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 19
; Joined path conditions
(assert (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10580
;  :arith-add-rows          4233
;  :arith-assert-diseq      323
;  :arith-assert-lower      2852
;  :arith-assert-upper      2149
;  :arith-bound-prop        282
;  :arith-conflicts         249
;  :arith-eq-adapter        835
;  :arith-fixed-eqs         428
;  :arith-gcd-tests         2
;  :arith-grobner           777
;  :arith-ineq-splits       2
;  :arith-max-min           2889
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  688
;  :arith-offset-eqs        1081
;  :arith-patches           2
;  :arith-pivots            948
;  :conflicts               726
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 1195
;  :datatype-occurs-check   706
;  :datatype-splits         987
;  :decisions               3385
;  :del-clause              10681
;  :final-checks            566
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.53
;  :minimized-lits          28
;  :mk-bool-var             15480
;  :mk-clause               10837
;  :num-allocs              344961
;  :num-checks              185
;  :propagations            4902
;  :quant-instantiations    2575
;  :rlimit-count            907512
;  :time                    0.00)
; [eval] aloc(opt_get1(target), i3)
; [eval] opt_get1(target)
(push) ; 19
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 19
; Joined path conditions
(push) ; 19
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 20
(assert (not (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10580
;  :arith-add-rows          4233
;  :arith-assert-diseq      323
;  :arith-assert-lower      2852
;  :arith-assert-upper      2149
;  :arith-bound-prop        282
;  :arith-conflicts         249
;  :arith-eq-adapter        835
;  :arith-fixed-eqs         428
;  :arith-gcd-tests         2
;  :arith-grobner           777
;  :arith-ineq-splits       2
;  :arith-max-min           2889
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  688
;  :arith-offset-eqs        1081
;  :arith-patches           2
;  :arith-pivots            948
;  :conflicts               726
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 1195
;  :datatype-occurs-check   706
;  :datatype-splits         987
;  :decisions               3385
;  :del-clause              10681
;  :final-checks            566
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.53
;  :minimized-lits          28
;  :mk-bool-var             15480
;  :mk-clause               10837
;  :num-allocs              344988
;  :num-checks              186
;  :propagations            4902
;  :quant-instantiations    2575
;  :rlimit-count            907542)
(assert (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 19
; Joined path conditions
(assert (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10728
;  :arith-add-rows          4385
;  :arith-assert-diseq      339
;  :arith-assert-lower      2897
;  :arith-assert-upper      2174
;  :arith-bound-prop        292
;  :arith-conflicts         253
;  :arith-eq-adapter        865
;  :arith-fixed-eqs         441
;  :arith-gcd-tests         2
;  :arith-grobner           777
;  :arith-ineq-splits       2
;  :arith-max-min           2889
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  688
;  :arith-offset-eqs        1098
;  :arith-patches           2
;  :arith-pivots            970
;  :conflicts               747
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 1195
;  :datatype-occurs-check   706
;  :datatype-splits         987
;  :decisions               3414
;  :del-clause              10775
;  :final-checks            566
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.63
;  :memory                  5.63
;  :minimized-lits          29
;  :mk-bool-var             15737
;  :mk-clause               11020
;  :num-allocs              346179
;  :num-checks              187
;  :propagations            4997
;  :quant-instantiations    2629
;  :rlimit-count            914063
;  :time                    0.00)
(pop) ; 18
(push) ; 18
; [else-branch: 124 | !(i3@73@02 < V@7@02)]
(assert (not (< i3@73@02 V@7@02)))
(pop) ; 18
(pop) ; 17
; Joined path conditions
(assert (implies
  (< i3@73@02 V@7@02)
  (and
    (< i3@73@02 V@7@02)
    (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
    (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))))
; Joined path conditions
(pop) ; 16
(push) ; 16
; [else-branch: 123 | !(0 <= i3@73@02)]
(assert (not (<= 0 i3@73@02)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (implies
  (<= 0 i3@73@02)
  (and
    (<= 0 i3@73@02)
    (implies
      (< i3@73@02 V@7@02)
      (and
        (< i3@73@02 V@7@02)
        (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
        (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))))))
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 122 | !(i2@72@02 < V@7@02)]
(assert (not (< i2@72@02 V@7@02)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i2@72@02 V@7@02)
  (and
    (< i2@72@02 V@7@02)
    (implies
      (<= 0 i3@73@02)
      (and
        (<= 0 i3@73@02)
        (implies
          (< i3@73@02 V@7@02)
          (and
            (< i3@73@02 V@7@02)
            (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
            (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))))))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 121 | !(0 <= i2@72@02)]
(assert (not (<= 0 i2@72@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i2@72@02)
  (and
    (<= 0 i2@72@02)
    (implies
      (< i2@72@02 V@7@02)
      (and
        (< i2@72@02 V@7@02)
        (implies
          (<= 0 i3@73@02)
          (and
            (<= 0 i3@73@02)
            (implies
              (< i3@73@02 V@7@02)
              (and
                (< i3@73@02 V@7@02)
                (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))))))))))
; Joined path conditions
(push) ; 11
; [then-branch: 125 | Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i2@72@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i3@73@02)) && i3@73@02 < V@7@02 && 0 <= i3@73@02 && i2@72@02 < V@7@02 && 0 <= i2@72@02 | live]
; [else-branch: 125 | !(Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i2@72@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i3@73@02)) && i3@73@02 < V@7@02 && 0 <= i3@73@02 && i2@72@02 < V@7@02 && 0 <= i2@72@02) | live]
(push) ; 12
; [then-branch: 125 | Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i2@72@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i3@73@02)) && i3@73@02 < V@7@02 && 0 <= i3@73@02 && i2@72@02 < V@7@02 && 0 <= i2@72@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
        (< i3@73@02 V@7@02))
      (<= 0 i3@73@02))
    (< i2@72@02 V@7@02))
  (<= 0 i2@72@02)))
; [eval] i2 == i3
(pop) ; 12
(push) ; 12
; [else-branch: 125 | !(Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i2@72@02)) == Lookup(option$array$,sm@57@02,aloc((_, _), opt_get1(_, target@8@02), i3@73@02)) && i3@73@02 < V@7@02 && 0 <= i3@73@02 && i2@72@02 < V@7@02 && 0 <= i2@72@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
          (< i3@73@02 V@7@02))
        (<= 0 i3@73@02))
      (< i2@72@02 V@7@02))
    (<= 0 i2@72@02))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
          (< i3@73@02 V@7@02))
        (<= 0 i3@73@02))
      (< i2@72@02 V@7@02))
    (<= 0 i2@72@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
      ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
    (< i3@73@02 V@7@02)
    (<= 0 i3@73@02)
    (< i2@72@02 V@7@02)
    (<= 0 i2@72@02))))
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@73@02 Int)) (!
  (and
    (implies
      (<= 0 i2@72@02)
      (and
        (<= 0 i2@72@02)
        (implies
          (< i2@72@02 V@7@02)
          (and
            (< i2@72@02 V@7@02)
            (implies
              (<= 0 i3@73@02)
              (and
                (<= 0 i3@73@02)
                (implies
                  (< i3@73@02 V@7@02)
                  (and
                    (< i3@73@02 V@7@02)
                    (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                    (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
              (< i3@73@02 V@7@02))
            (<= 0 i3@73@02))
          (< i2@72@02 V@7@02))
        (<= 0 i2@72@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
          ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
        (< i3@73@02 V@7@02)
        (<= 0 i3@73@02)
        (< i2@72@02 V@7@02)
        (<= 0 i2@72@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@72@02 Int)) (!
  (forall ((i3@73@02 Int)) (!
    (and
      (implies
        (<= 0 i2@72@02)
        (and
          (<= 0 i2@72@02)
          (implies
            (< i2@72@02 V@7@02)
            (and
              (< i2@72@02 V@7@02)
              (implies
                (<= 0 i3@73@02)
                (and
                  (<= 0 i3@73@02)
                  (implies
                    (< i3@73@02 V@7@02)
                    (and
                      (< i3@73@02 V@7@02)
                      (< i2@72@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                      (< i3@73@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
                (< i3@73@02 V@7@02))
              (<= 0 i3@73@02))
            (< i2@72@02 V@7@02))
          (<= 0 i2@72@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
            ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
          (< i3@73@02 V@7@02)
          (<= 0 i3@73@02)
          (< i2@72@02 V@7@02)
          (<= 0 i2@72@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@72@02 Int)) (!
    (forall ((i3@73@02 Int)) (!
      (and
        (implies
          (<= 0 i2@72@02)
          (and
            (<= 0 i2@72@02)
            (implies
              (< i2@72@02 V@7@02)
              (and
                (< i2@72@02 V@7@02)
                (implies
                  (<= 0 i3@73@02)
                  (and
                    (<= 0 i3@73@02)
                    (implies
                      (< i3@73@02 V@7@02)
                      (and
                        (< i3@73@02 V@7@02)
                        (<
                          i2@72@02
                          (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                        (<
                          i3@73@02
                          (alen<Int> (opt_get1 $Snap.unit target@8@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
                  (< i3@73@02 V@7@02))
                (<= 0 i3@73@02))
              (< i2@72@02 V@7@02))
            (<= 0 i2@72@02))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
              ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
            (< i3@73@02 V@7@02)
            (<= 0 i3@73@02)
            (< i2@72@02 V@7@02)
            (<= 0 i2@72@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
    :qid |prog.l<no position>-aux|))))
(push) ; 7
(assert (not (implies
  (< 0 V@7@02)
  (forall ((i2@72@02 Int)) (!
    (forall ((i3@73@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
                (< i3@73@02 V@7@02))
              (<= 0 i3@73@02))
            (< i2@72@02 V@7@02))
          (<= 0 i2@72@02))
        (= i2@72@02 i3@73@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10828
;  :arith-add-rows          4454
;  :arith-assert-diseq      346
;  :arith-assert-lower      2923
;  :arith-assert-upper      2190
;  :arith-bound-prop        299
;  :arith-conflicts         255
;  :arith-eq-adapter        886
;  :arith-fixed-eqs         448
;  :arith-gcd-tests         2
;  :arith-grobner           777
;  :arith-ineq-splits       2
;  :arith-max-min           2889
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  688
;  :arith-offset-eqs        1106
;  :arith-patches           2
;  :arith-pivots            989
;  :conflicts               765
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 1195
;  :datatype-occurs-check   706
;  :datatype-splits         987
;  :decisions               3435
;  :del-clause              11212
;  :final-checks            566
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.66
;  :memory                  5.65
;  :minimized-lits          30
;  :mk-bool-var             16096
;  :mk-clause               11299
;  :num-allocs              348182
;  :num-checks              188
;  :propagations            5099
;  :quant-instantiations    2721
;  :rlimit-count            922615
;  :time                    0.00)
(assert (implies
  (< 0 V@7@02)
  (forall ((i2@72@02 Int)) (!
    (forall ((i3@73@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
                  ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02)))
                (< i3@73@02 V@7@02))
              (<= 0 i3@73@02))
            (< i2@72@02 V@7@02))
          (<= 0 i2@72@02))
        (= i2@72@02 i3@73@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i3@73@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i2@72@02))
    :qid |prog.l<no position>|))))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not false))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10895
;  :arith-add-rows          4514
;  :arith-assert-diseq      352
;  :arith-assert-lower      2966
;  :arith-assert-upper      2218
;  :arith-bound-prop        303
;  :arith-conflicts         255
;  :arith-eq-adapter        896
;  :arith-fixed-eqs         453
;  :arith-gcd-tests         2
;  :arith-grobner           823
;  :arith-ineq-splits       2
;  :arith-max-min           2948
;  :arith-nonlinear-bounds  265
;  :arith-nonlinear-horner  732
;  :arith-offset-eqs        1117
;  :arith-patches           2
;  :arith-pivots            1001
;  :conflicts               767
;  :datatype-accessor-ax    316
;  :datatype-constructor-ax 1201
;  :datatype-occurs-check   710
;  :datatype-splits         993
;  :decisions               3457
;  :del-clause              11256
;  :final-checks            571
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.66
;  :minimized-lits          31
;  :mk-bool-var             16155
;  :mk-clause               11343
;  :num-allocs              356089
;  :num-checks              189
;  :propagations            5125
;  :quant-instantiations    2730
;  :rlimit-count            966335
;  :time                    0.01)
; [then-branch: 126 | True | live]
; [else-branch: 126 | False | dead]
(push) ; 8
; [then-branch: 126 | True]
; [eval] 0 <= i1
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not false))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10959
;  :arith-add-rows          4574
;  :arith-assert-diseq      358
;  :arith-assert-lower      3009
;  :arith-assert-upper      2246
;  :arith-bound-prop        307
;  :arith-conflicts         255
;  :arith-eq-adapter        906
;  :arith-fixed-eqs         458
;  :arith-gcd-tests         2
;  :arith-grobner           869
;  :arith-ineq-splits       2
;  :arith-max-min           3007
;  :arith-nonlinear-bounds  266
;  :arith-nonlinear-horner  776
;  :arith-offset-eqs        1125
;  :arith-patches           2
;  :arith-pivots            1013
;  :conflicts               769
;  :datatype-accessor-ax    317
;  :datatype-constructor-ax 1207
;  :datatype-occurs-check   714
;  :datatype-splits         999
;  :decisions               3479
;  :del-clause              11300
;  :final-checks            576
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          32
;  :mk-bool-var             16212
;  :mk-clause               11387
;  :num-allocs              363582
;  :num-checks              190
;  :propagations            5151
;  :quant-instantiations    2738
;  :rlimit-count            1009404
;  :time                    0.01)
; [then-branch: 127 | True | live]
; [else-branch: 127 | False | dead]
(push) ; 8
; [then-branch: 127 | True]
; [eval] i1 < V
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> 0 <= j
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not false))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11023
;  :arith-add-rows          4634
;  :arith-assert-diseq      364
;  :arith-assert-lower      3052
;  :arith-assert-upper      2274
;  :arith-bound-prop        311
;  :arith-conflicts         255
;  :arith-eq-adapter        916
;  :arith-fixed-eqs         463
;  :arith-gcd-tests         2
;  :arith-grobner           915
;  :arith-ineq-splits       2
;  :arith-max-min           3066
;  :arith-nonlinear-bounds  267
;  :arith-nonlinear-horner  820
;  :arith-offset-eqs        1133
;  :arith-patches           2
;  :arith-pivots            1025
;  :conflicts               771
;  :datatype-accessor-ax    318
;  :datatype-constructor-ax 1213
;  :datatype-occurs-check   718
;  :datatype-splits         1005
;  :decisions               3501
;  :del-clause              11344
;  :final-checks            581
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.66
;  :minimized-lits          33
;  :mk-bool-var             16269
;  :mk-clause               11431
;  :num-allocs              371134
;  :num-checks              191
;  :propagations            5177
;  :quant-instantiations    2746
;  :rlimit-count            1052584
;  :time                    0.01)
; [then-branch: 128 | True | live]
; [else-branch: 128 | False | dead]
(push) ; 8
; [then-branch: 128 | True]
; [eval] 0 <= j
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> j < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not false))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11087
;  :arith-add-rows          4694
;  :arith-assert-diseq      370
;  :arith-assert-lower      3095
;  :arith-assert-upper      2302
;  :arith-bound-prop        315
;  :arith-conflicts         255
;  :arith-eq-adapter        926
;  :arith-fixed-eqs         468
;  :arith-gcd-tests         2
;  :arith-grobner           961
;  :arith-ineq-splits       2
;  :arith-max-min           3125
;  :arith-nonlinear-bounds  268
;  :arith-nonlinear-horner  864
;  :arith-offset-eqs        1141
;  :arith-patches           2
;  :arith-pivots            1037
;  :conflicts               773
;  :datatype-accessor-ax    319
;  :datatype-constructor-ax 1219
;  :datatype-occurs-check   722
;  :datatype-splits         1011
;  :decisions               3523
;  :del-clause              11388
;  :final-checks            586
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.66
;  :minimized-lits          34
;  :mk-bool-var             16326
;  :mk-clause               11475
;  :num-allocs              378626
;  :num-checks              192
;  :propagations            5203
;  :quant-instantiations    2754
;  :rlimit-count            1095653
;  :time                    0.01)
; [then-branch: 129 | True | live]
; [else-branch: 129 | False | dead]
(push) ; 8
; [then-branch: 129 | True]
; [eval] j < V
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null
(push) ; 7
(assert (not false))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11151
;  :arith-add-rows          4754
;  :arith-assert-diseq      376
;  :arith-assert-lower      3138
;  :arith-assert-upper      2330
;  :arith-bound-prop        319
;  :arith-conflicts         255
;  :arith-eq-adapter        936
;  :arith-fixed-eqs         473
;  :arith-gcd-tests         2
;  :arith-grobner           1007
;  :arith-ineq-splits       2
;  :arith-max-min           3184
;  :arith-nonlinear-bounds  269
;  :arith-nonlinear-horner  908
;  :arith-offset-eqs        1149
;  :arith-patches           2
;  :arith-pivots            1049
;  :conflicts               775
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 1225
;  :datatype-occurs-check   726
;  :datatype-splits         1017
;  :decisions               3545
;  :del-clause              11432
;  :final-checks            591
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.66
;  :minimized-lits          35
;  :mk-bool-var             16383
;  :mk-clause               11519
;  :num-allocs              386170
;  :num-checks              193
;  :propagations            5229
;  :quant-instantiations    2762
;  :rlimit-count            1138813
;  :time                    0.01)
; [then-branch: 130 | True | live]
; [else-branch: 130 | False | dead]
(push) ; 7
; [then-branch: 130 | True]
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 8
; Joined path conditions
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 8
; Joined path conditions
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11163
;  :arith-add-rows          4779
;  :arith-assert-diseq      377
;  :arith-assert-lower      3146
;  :arith-assert-upper      2337
;  :arith-bound-prop        320
;  :arith-conflicts         257
;  :arith-eq-adapter        941
;  :arith-fixed-eqs         475
;  :arith-gcd-tests         2
;  :arith-grobner           1007
;  :arith-ineq-splits       2
;  :arith-max-min           3184
;  :arith-nonlinear-bounds  269
;  :arith-nonlinear-horner  908
;  :arith-offset-eqs        1149
;  :arith-patches           2
;  :arith-pivots            1055
;  :conflicts               778
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 1225
;  :datatype-occurs-check   726
;  :datatype-splits         1017
;  :decisions               3547
;  :del-clause              11442
;  :final-checks            591
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          35
;  :mk-bool-var             16401
;  :mk-clause               11529
;  :num-allocs              386453
;  :num-checks              194
;  :propagations            5248
;  :quant-instantiations    2767
;  :rlimit-count            1139925)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 9
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11163
;  :arith-add-rows          4779
;  :arith-assert-diseq      377
;  :arith-assert-lower      3146
;  :arith-assert-upper      2337
;  :arith-bound-prop        320
;  :arith-conflicts         257
;  :arith-eq-adapter        941
;  :arith-fixed-eqs         475
;  :arith-gcd-tests         2
;  :arith-grobner           1007
;  :arith-ineq-splits       2
;  :arith-max-min           3184
;  :arith-nonlinear-bounds  269
;  :arith-nonlinear-horner  908
;  :arith-offset-eqs        1149
;  :arith-patches           2
;  :arith-pivots            1055
;  :conflicts               779
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 1225
;  :datatype-occurs-check   726
;  :datatype-splits         1017
;  :decisions               3547
;  :del-clause              11442
;  :final-checks            591
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          35
;  :mk-bool-var             16401
;  :mk-clause               11529
;  :num-allocs              386544
;  :num-checks              195
;  :propagations            5248
;  :quant-instantiations    2767
;  :rlimit-count            1140016)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11166
;  :arith-add-rows          4783
;  :arith-assert-diseq      377
;  :arith-assert-lower      3148
;  :arith-assert-upper      2338
;  :arith-bound-prop        320
;  :arith-conflicts         258
;  :arith-eq-adapter        942
;  :arith-fixed-eqs         476
;  :arith-gcd-tests         2
;  :arith-grobner           1007
;  :arith-ineq-splits       2
;  :arith-max-min           3184
;  :arith-nonlinear-bounds  269
;  :arith-nonlinear-horner  908
;  :arith-offset-eqs        1149
;  :arith-patches           2
;  :arith-pivots            1057
;  :conflicts               780
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 1225
;  :datatype-occurs-check   726
;  :datatype-splits         1017
;  :decisions               3547
;  :del-clause              11443
;  :final-checks            591
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          35
;  :mk-bool-var             16405
;  :mk-clause               11530
;  :num-allocs              386721
;  :num-checks              196
;  :propagations            5248
;  :quant-instantiations    2767
;  :rlimit-count            1140355)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(pop) ; 8
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11173
;  :arith-add-rows          4786
;  :arith-assert-diseq      377
;  :arith-assert-lower      3149
;  :arith-assert-upper      2340
;  :arith-bound-prop        320
;  :arith-conflicts         258
;  :arith-eq-adapter        943
;  :arith-fixed-eqs         477
;  :arith-gcd-tests         2
;  :arith-grobner           1007
;  :arith-ineq-splits       2
;  :arith-max-min           3184
;  :arith-nonlinear-bounds  269
;  :arith-nonlinear-horner  908
;  :arith-offset-eqs        1151
;  :arith-patches           2
;  :arith-pivots            1058
;  :conflicts               781
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 1225
;  :datatype-occurs-check   726
;  :datatype-splits         1017
;  :decisions               3547
;  :del-clause              11443
;  :final-checks            591
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          35
;  :mk-bool-var             16410
;  :mk-clause               11530
;  :num-allocs              386912
;  :num-checks              197
;  :propagations            5248
;  :quant-instantiations    2767
;  :rlimit-count            1140747)
; [eval] exc == null
(push) ; 8
(assert (not false))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11237
;  :arith-add-rows          4850
;  :arith-assert-diseq      383
;  :arith-assert-lower      3192
;  :arith-assert-upper      2368
;  :arith-bound-prop        324
;  :arith-conflicts         258
;  :arith-eq-adapter        953
;  :arith-fixed-eqs         482
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1159
;  :arith-patches           2
;  :arith-pivots            1071
;  :conflicts               783
;  :datatype-accessor-ax    321
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3569
;  :del-clause              11487
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.66
;  :minimized-lits          36
;  :mk-bool-var             16467
;  :mk-clause               11574
;  :num-allocs              394739
;  :num-checks              198
;  :propagations            5274
;  :quant-instantiations    2775
;  :rlimit-count            1186714
;  :time                    0.01)
; [then-branch: 131 | True | live]
; [else-branch: 131 | False | dead]
(push) ; 8
; [then-branch: 131 | True]
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 9
; Joined path conditions
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 9
; Joined path conditions
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))
(set-option :timeout 0)
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@17@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@16@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
          V@7@02)
        (<=
          0
          (inv@25@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))
      (* (scale $Snap.unit (* (to_real (* V@7@02 V@7@02)) $Perm.Write)) $k@24@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11269
;  :arith-add-rows          4874
;  :arith-assert-diseq      384
;  :arith-assert-lower      3201
;  :arith-assert-upper      2378
;  :arith-bound-prop        326
;  :arith-conflicts         259
;  :arith-eq-adapter        962
;  :arith-fixed-eqs         485
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1164
;  :arith-patches           2
;  :arith-pivots            1078
;  :conflicts               791
;  :datatype-accessor-ax    321
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11534
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          36
;  :mk-bool-var             16531
;  :mk-clause               11621
;  :num-allocs              395116
;  :num-checks              199
;  :propagations            5310
;  :quant-instantiations    2784
;  :rlimit-count            1188283)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11269
;  :arith-add-rows          4874
;  :arith-assert-diseq      384
;  :arith-assert-lower      3201
;  :arith-assert-upper      2378
;  :arith-bound-prop        326
;  :arith-conflicts         259
;  :arith-eq-adapter        962
;  :arith-fixed-eqs         485
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1164
;  :arith-patches           2
;  :arith-pivots            1078
;  :conflicts               792
;  :datatype-accessor-ax    321
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11534
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          36
;  :mk-bool-var             16531
;  :mk-clause               11621
;  :num-allocs              395207
;  :num-checks              200
;  :propagations            5310
;  :quant-instantiations    2784
;  :rlimit-count            1188374)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11272
;  :arith-add-rows          4878
;  :arith-assert-diseq      384
;  :arith-assert-lower      3203
;  :arith-assert-upper      2379
;  :arith-bound-prop        326
;  :arith-conflicts         260
;  :arith-eq-adapter        963
;  :arith-fixed-eqs         486
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1164
;  :arith-patches           2
;  :arith-pivots            1080
;  :conflicts               793
;  :datatype-accessor-ax    321
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11535
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          36
;  :mk-bool-var             16535
;  :mk-clause               11622
;  :num-allocs              395381
;  :num-checks              201
;  :propagations            5310
;  :quant-instantiations    2784
;  :rlimit-count            1188709)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(pop) ; 9
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@57@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11278
;  :arith-add-rows          4881
;  :arith-assert-diseq      384
;  :arith-assert-lower      3204
;  :arith-assert-upper      2381
;  :arith-bound-prop        326
;  :arith-conflicts         260
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1081
;  :conflicts               794
;  :datatype-accessor-ax    321
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11535
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          36
;  :mk-bool-var             16540
;  :mk-clause               11622
;  :num-allocs              395572
;  :num-checks              202
;  :propagations            5310
;  :quant-instantiations    2784
;  :rlimit-count            1189099)
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 2 | !(0 < V@7@02)]
(assert (not (< 0 V@7@02)))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@14@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@14@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
; [then-branch: 132 | 0 < V@7@02 | dead]
; [else-branch: 132 | !(0 < V@7@02) | live]
(push) ; 4
; [else-branch: 132 | !(0 < V@7@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
; [then-branch: 133 | 0 < V@7@02 | dead]
; [else-branch: 133 | !(0 < V@7@02) | live]
(push) ; 4
; [else-branch: 133 | !(0 < V@7@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 3
; [then-branch: 134 | 0 < V@7@02 | dead]
; [else-branch: 134 | !(0 < V@7@02) | live]
(push) ; 4
; [else-branch: 134 | !(0 < V@7@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
; [then-branch: 135 | 0 < V@7@02 | dead]
; [else-branch: 135 | !(0 < V@7@02) | live]
(push) ; 4
; [else-branch: 135 | !(0 < V@7@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
; [then-branch: 136 | 0 < V@7@02 | dead]
; [else-branch: 136 | !(0 < V@7@02) | live]
(push) ; 4
; [else-branch: 136 | !(0 < V@7@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
; [eval] 0 < V
; [then-branch: 137 | 0 < V@7@02 | dead]
; [else-branch: 137 | !(0 < V@7@02) | live]
(push) ; 3
; [else-branch: 137 | !(0 < V@7@02)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
; [then-branch: 138 | 0 < V@7@02 | dead]
; [else-branch: 138 | !(0 < V@7@02) | live]
(push) ; 5
; [else-branch: 138 | !(0 < V@7@02)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
; [then-branch: 139 | 0 < V@7@02 | dead]
; [else-branch: 139 | !(0 < V@7@02) | live]
(push) ; 5
; [else-branch: 139 | !(0 < V@7@02)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 4
; [then-branch: 140 | 0 < V@7@02 | dead]
; [else-branch: 140 | !(0 < V@7@02) | live]
(push) ; 5
; [else-branch: 140 | !(0 < V@7@02)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
  $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@10@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
  $Snap.unit))
; [eval] i1 < V
(assert (< i1@10@02 V@7@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
  $Snap.unit))
; [eval] 0 <= j
(assert (<= 0 j@11@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
  $Snap.unit))
; [eval] j < V
(assert (< j@11@02 V@7@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))))
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= target@8@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               796
;  :datatype-accessor-ax    335
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16573
;  :mk-clause               11622
;  :num-allocs              396951
;  :num-checks              203
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1192258)
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= target@8@02 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit target@8@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               797
;  :datatype-accessor-ax    335
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16575
;  :mk-clause               11622
;  :num-allocs              397097
;  :num-checks              204
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1192407)
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(pop) ; 4
; Joined path conditions
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit target@8@02))))
(declare-const sm@74@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@75@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@75@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@75@02  $FPM) r))
  :qid |qp.resPrmSumDef29|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@75@02  $FPM) r))
  :qid |qp.resTrgDef30|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))
(push) ; 4
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@75@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               798
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16580
;  :mk-clause               11622
;  :num-allocs              397483
;  :num-checks              205
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1192848)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               799
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16581
;  :mk-clause               11622
;  :num-allocs              397573
;  :num-checks              206
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1192937)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               800
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16583
;  :mk-clause               11622
;  :num-allocs              397718
;  :num-checks              207
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1193186)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
    $Ref.null)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not (= source@9@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               801
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16585
;  :mk-clause               11622
;  :num-allocs              397875
;  :num-checks              208
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1193459)
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@02 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit source@9@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               802
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16586
;  :mk-clause               11622
;  :num-allocs              398019
;  :num-checks              209
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1193600)
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(pop) ; 4
; Joined path conditions
(assert (< i1@10@02 (alen<Int> (opt_get1 $Snap.unit source@9@02))))
(declare-const sm@76@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@77@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@77@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@77@02  $FPM) r))
  :qid |qp.resPrmSumDef32|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@77@02  $FPM) r))
  :qid |qp.resTrgDef33|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))
(push) ; 4
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@77@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               803
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16591
;  :mk-clause               11622
;  :num-allocs              398395
;  :num-checks              210
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194041)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               804
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16592
;  :mk-clause               11622
;  :num-allocs              398485
;  :num-checks              211
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194130)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               805
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16594
;  :mk-clause               11622
;  :num-allocs              398637
;  :num-checks              212
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194375)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@76@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398806
;  :num-checks              213
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194716)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))))
(assert false)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unsat
(push) ; 4
(declare-const $t@78@02 $Snap)
(assert (= $t@78@02 ($Snap.combine ($Snap.first $t@78@02) ($Snap.second $t@78@02))))
(assert (= ($Snap.first $t@78@02) $Snap.unit))
; [eval] exc == null
(assert (= exc@12@02 $Ref.null))
(assert (=
  ($Snap.second $t@78@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@78@02))
    ($Snap.second ($Snap.second $t@78@02)))))
(assert (= ($Snap.first ($Snap.second $t@78@02)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 141 | exc@12@02 == Null | live]
; [else-branch: 141 | exc@12@02 != Null | live]
(push) ; 6
; [then-branch: 141 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 141 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398865
;  :num-checks              215
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194776)
; [then-branch: 142 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 142 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 6
; [else-branch: 142 | !(0 < V@7@02 && exc@12@02 == Null)]
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second $t@78@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@78@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@78@02))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 143 | exc@12@02 == Null | live]
; [else-branch: 143 | exc@12@02 != Null | live]
(push) ; 6
; [then-branch: 143 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 143 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398882
;  :num-checks              216
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194788)
; [then-branch: 144 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 144 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 6
; [else-branch: 144 | !(0 < V@7@02 && exc@12@02 == Null)]
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@78@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 145 | exc@12@02 == Null | live]
; [else-branch: 145 | exc@12@02 != Null | live]
(push) ; 6
; [then-branch: 145 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 145 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398899
;  :num-checks              217
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194798)
; [then-branch: 146 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 146 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 5
; [else-branch: 146 | !(0 < V@7@02 && exc@12@02 == Null)]
(assert (not (and (< 0 V@7@02) (= exc@12@02 $Ref.null))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@02))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 147 | exc@12@02 == Null | live]
; [else-branch: 147 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 147 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 147 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 148 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 148 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 7
; [else-branch: 148 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 149 | exc@12@02 == Null | live]
; [else-branch: 149 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 149 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 149 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 150 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 150 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 7
; [else-branch: 150 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 151 | exc@12@02 == Null | live]
; [else-branch: 151 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 151 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 151 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 152 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 152 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 7
; [else-branch: 152 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 153 | exc@12@02 == Null | live]
; [else-branch: 153 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 153 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 153 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 154 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 154 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 7
; [else-branch: 154 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 155 | exc@12@02 == Null | live]
; [else-branch: 155 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 155 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 155 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 156 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 156 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 7
; [else-branch: 156 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 157 | exc@12@02 == Null | live]
; [else-branch: 157 | exc@12@02 != Null | live]
(push) ; 7
; [then-branch: 157 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 157 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
; [then-branch: 158 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 158 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 6
; [else-branch: 158 | !(0 < V@7@02 && exc@12@02 == Null)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 159 | exc@12@02 == Null | live]
; [else-branch: 159 | exc@12@02 != Null | live]
(push) ; 8
; [then-branch: 159 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 159 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 160 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 160 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 8
; [else-branch: 160 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 161 | exc@12@02 == Null | live]
; [else-branch: 161 | exc@12@02 != Null | live]
(push) ; 8
; [then-branch: 161 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 161 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 162 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 162 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 8
; [else-branch: 162 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 163 | exc@12@02 == Null | live]
; [else-branch: 163 | exc@12@02 != Null | live]
(push) ; 8
; [then-branch: 163 | exc@12@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 163 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 164 | 0 < V@7@02 && exc@12@02 == Null | dead]
; [else-branch: 164 | !(0 < V@7@02 && exc@12@02 == Null) | live]
(push) ; 8
; [else-branch: 164 | !(0 < V@7@02 && exc@12@02 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398916
;  :num-checks              218
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194878)
; [then-branch: 165 | exc@12@02 == Null | dead]
; [else-branch: 165 | exc@12@02 != Null | live]
(push) ; 8
; [else-branch: 165 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398933
;  :num-checks              219
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194886)
; [then-branch: 166 | exc@12@02 == Null | dead]
; [else-branch: 166 | exc@12@02 != Null | live]
(push) ; 8
; [else-branch: 166 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= j
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398950
;  :num-checks              220
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194894)
; [then-branch: 167 | exc@12@02 == Null | dead]
; [else-branch: 167 | exc@12@02 != Null | live]
(push) ; 8
; [else-branch: 167 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> j < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398967
;  :num-checks              221
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194902)
; [then-branch: 168 | exc@12@02 == Null | dead]
; [else-branch: 168 | exc@12@02 != Null | live]
(push) ; 8
; [else-branch: 168 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02)))))))))))))))))))))
; [eval] exc == null
(push) ; 7
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              398984
;  :num-checks              222
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194908)
; [then-branch: 169 | exc@12@02 == Null | dead]
; [else-branch: 169 | exc@12@02 != Null | live]
(push) ; 7
; [else-branch: 169 | exc@12@02 != Null]
(assert (not (= exc@12@02 $Ref.null)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
  $Snap.unit))
; [eval] exc == null
; [then-branch: 170 | exc@12@02 == Null | dead]
; [else-branch: 170 | exc@12@02 != Null | live]
(push) ; 8
; [else-branch: 170 | exc@12@02 != Null]
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@02))))))))))))))))))
  $Snap.unit))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(push) ; 4
; [exec]
; var return: void
(declare-const return@79@02 void)
; [exec]
; exc := null
; [exec]
; aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int := aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 5
; Joined path conditions
(declare-const sm@80@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@81@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@81@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@81@02  $FPM) r))
  :qid |qp.resPrmSumDef35|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@81@02  $FPM) r))
  :qid |qp.resTrgDef36|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@81@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399026
;  :num-checks              223
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194922)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399042
;  :num-checks              224
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194926)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399058
;  :num-checks              225
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194932)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
(pop) ; 5
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))))))
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 5
; Joined path conditions
(declare-const sm@82@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@83@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@83@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@83@02  $FPM) r))
  :qid |qp.resPrmSumDef38|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@83@02  $FPM) r))
  :qid |qp.resTrgDef39|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@83@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399098
;  :num-checks              226
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194942)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399114
;  :num-checks              227
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194946)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399130
;  :num-checks              228
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194952)
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(pop) ; 5
; Joined path conditions
(assert (<
  j@11@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))))))
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@82@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@02) i1@10@02))) j@11@02))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399149
;  :num-checks              229
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194957)
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@74@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399166
;  :num-checks              230
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194960)
(push) ; 5
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11362
;  :arith-add-rows          4899
;  :arith-assert-diseq      384
;  :arith-assert-lower      3208
;  :arith-assert-upper      2382
;  :arith-bound-prop        326
;  :arith-conflicts         261
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         487
;  :arith-gcd-tests         2
;  :arith-grobner           1055
;  :arith-ineq-splits       2
;  :arith-max-min           3243
;  :arith-nonlinear-bounds  270
;  :arith-nonlinear-horner  954
;  :arith-offset-eqs        1165
;  :arith-patches           2
;  :arith-pivots            1100
;  :conflicts               806
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1231
;  :datatype-occurs-check   730
;  :datatype-splits         1023
;  :decisions               3579
;  :del-clause              11616
;  :final-checks            596
;  :interface-eqs           142
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.62
;  :minimized-lits          36
;  :mk-bool-var             16596
;  :mk-clause               11622
;  :num-allocs              399203
;  :num-checks              231
;  :propagations            5311
;  :quant-instantiations    2784
;  :rlimit-count            1194963)
(declare-const int@84@02 Int)
(assert (=
  int@84@02
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))))))))))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@80@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@02) i1@10@02))) j@11@02)
    $Ref.null)))
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 171 | True | live]
; [else-branch: 171 | False | live]
(push) ; 6
; [then-branch: 171 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 171 | False]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 172 | 0 < V@7@02 | dead]
; [else-branch: 172 | !(0 < V@7@02) | live]
(push) ; 6
; [else-branch: 172 | !(0 < V@7@02)]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 173 | True | live]
; [else-branch: 173 | False | live]
(push) ; 6
; [then-branch: 173 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 173 | False]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 174 | 0 < V@7@02 | dead]
; [else-branch: 174 | !(0 < V@7@02) | live]
(push) ; 6
; [else-branch: 174 | !(0 < V@7@02)]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 175 | True | live]
; [else-branch: 175 | False | live]
(push) ; 6
; [then-branch: 175 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 175 | False]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
; [then-branch: 176 | 0 < V@7@02 | dead]
; [else-branch: 176 | !(0 < V@7@02) | live]
(push) ; 5
; [else-branch: 176 | !(0 < V@7@02)]
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 177 | True | live]
; [else-branch: 177 | False | live]
(push) ; 7
; [then-branch: 177 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 177 | False]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 178 | 0 < V@7@02 | dead]
; [else-branch: 178 | !(0 < V@7@02) | live]
(push) ; 7
; [else-branch: 178 | !(0 < V@7@02)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 179 | True | live]
; [else-branch: 179 | False | live]
(push) ; 7
; [then-branch: 179 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 179 | False]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 180 | 0 < V@7@02 | dead]
; [else-branch: 180 | !(0 < V@7@02) | live]
(push) ; 7
; [else-branch: 180 | !(0 < V@7@02)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 181 | True | live]
; [else-branch: 181 | False | live]
(push) ; 7
; [then-branch: 181 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 181 | False]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 182 | 0 < V@7@02 | dead]
; [else-branch: 182 | !(0 < V@7@02) | live]
(push) ; 7
; [else-branch: 182 | !(0 < V@7@02)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 183 | True | live]
; [else-branch: 183 | False | live]
(push) ; 7
; [then-branch: 183 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 183 | False]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 184 | 0 < V@7@02 | dead]
; [else-branch: 184 | !(0 < V@7@02) | live]
(push) ; 7
; [else-branch: 184 | !(0 < V@7@02)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 185 | True | live]
; [else-branch: 185 | False | live]
(push) ; 7
; [then-branch: 185 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 185 | False]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 186 | 0 < V@7@02 | dead]
; [else-branch: 186 | !(0 < V@7@02) | live]
(push) ; 7
; [else-branch: 186 | !(0 < V@7@02)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 187 | True | live]
; [else-branch: 187 | False | live]
(push) ; 7
; [then-branch: 187 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 187 | False]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
; [then-branch: 188 | 0 < V@7@02 | dead]
; [else-branch: 188 | !(0 < V@7@02) | live]
(push) ; 6
; [else-branch: 188 | !(0 < V@7@02)]
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 189 | True | live]
; [else-branch: 189 | False | live]
(push) ; 8
; [then-branch: 189 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 189 | False]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 190 | 0 < V@7@02 | dead]
; [else-branch: 190 | !(0 < V@7@02) | live]
(push) ; 8
; [else-branch: 190 | !(0 < V@7@02)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 191 | True | live]
; [else-branch: 191 | False | live]
(push) ; 8
; [then-branch: 191 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 191 | False]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 192 | 0 < V@7@02 | dead]
; [else-branch: 192 | !(0 < V@7@02) | live]
(push) ; 8
; [else-branch: 192 | !(0 < V@7@02)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 193 | True | live]
; [else-branch: 193 | False | live]
(push) ; 8
; [then-branch: 193 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 193 | False]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 194 | 0 < V@7@02 | dead]
; [else-branch: 194 | !(0 < V@7@02) | live]
(push) ; 8
; [else-branch: 194 | !(0 < V@7@02)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 7
; [then-branch: 195 | True | dead]
; [else-branch: 195 | False | live]
(push) ; 8
; [else-branch: 195 | False]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 196 | True | dead]
; [else-branch: 196 | False | live]
(push) ; 8
; [else-branch: 196 | False]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> 0 <= j
; [eval] exc == null
(push) ; 7
; [then-branch: 197 | True | dead]
; [else-branch: 197 | False | live]
(push) ; 8
; [else-branch: 197 | False]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> j < V
; [eval] exc == null
(push) ; 7
; [then-branch: 198 | True | dead]
; [else-branch: 198 | False | live]
(push) ; 8
; [else-branch: 198 | False]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null
; [then-branch: 199 | True | dead]
; [else-branch: 199 | False | live]
(push) ; 7
; [else-branch: 199 | False]
; [eval] exc == null
; [then-branch: 200 | True | dead]
; [else-branch: 200 | False | live]
(push) ; 8
; [else-branch: 200 | False]
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
