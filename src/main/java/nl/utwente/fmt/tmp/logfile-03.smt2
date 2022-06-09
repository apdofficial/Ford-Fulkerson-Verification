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
; ---------- do_par_$unknown$1 ----------
(declare-const target@0@03 option<array>)
(declare-const source@1@03 option<array>)
(declare-const V@2@03 Int)
(declare-const exc@3@03 $Ref)
(declare-const res@4@03 void)
(declare-const target@5@03 option<array>)
(declare-const source@6@03 option<array>)
(declare-const V@7@03 Int)
(declare-const exc@8@03 $Ref)
(declare-const res@9@03 void)
(push) ; 1
(declare-const $t@10@03 $Snap)
(assert (= $t@10@03 ($Snap.combine ($Snap.first $t@10@03) ($Snap.second $t@10@03))))
(assert (= ($Snap.first $t@10@03) $Snap.unit))
; [eval] 0 < V ==> source != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@7@03))))
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
(assert (not (< 0 V@7@03)))
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
; [then-branch: 0 | 0 < V@7@03 | live]
; [else-branch: 0 | !(0 < V@7@03) | live]
(push) ; 3
; [then-branch: 0 | 0 < V@7@03]
(assert (< 0 V@7@03))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(0 < V@7@03)]
(assert (not (< 0 V@7@03)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (not (= source@6@03 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@10@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@10@03))
    ($Snap.second ($Snap.second $t@10@03)))))
(assert (= ($Snap.first ($Snap.second $t@10@03)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(source)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@7@03))))
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
(assert (not (< 0 V@7@03)))
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
; [then-branch: 1 | 0 < V@7@03 | live]
; [else-branch: 1 | !(0 < V@7@03) | live]
(push) ; 3
; [then-branch: 1 | 0 < V@7@03]
(assert (< 0 V@7@03))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
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
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(0 < V@7@03)]
(assert (not (< 0 V@7@03)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (and
    (< 0 V@7@03)
    (not (= source@6@03 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies (< 0 V@7@03) (= (alen<Int> (opt_get1 $Snap.unit source@6@03)) V@7@03)))
(assert (=
  ($Snap.second ($Snap.second $t@10@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@10@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 2
(assert (not (not (< 0 V@7@03))))
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
;  :num-allocs              123861
;  :num-checks              6
;  :propagations            5
;  :quant-instantiations    6
;  :rlimit-count            122630
;  :time                    0.00)
(push) ; 2
(assert (not (< 0 V@7@03)))
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
;  :num-allocs              124220
;  :num-checks              7
;  :propagations            6
;  :quant-instantiations    6
;  :rlimit-count            123037)
; [then-branch: 2 | 0 < V@7@03 | live]
; [else-branch: 2 | !(0 < V@7@03) | live]
(push) ; 2
; [then-branch: 2 | 0 < V@7@03]
(assert (< 0 V@7@03))
(declare-const i1@11@03 Int)
(push) ; 3
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 4
; [then-branch: 3 | 0 <= i1@11@03 | live]
; [else-branch: 3 | !(0 <= i1@11@03) | live]
(push) ; 5
; [then-branch: 3 | 0 <= i1@11@03]
(assert (<= 0 i1@11@03))
; [eval] i1 < V
(pop) ; 5
(push) ; 5
; [else-branch: 3 | !(0 <= i1@11@03)]
(assert (not (<= 0 i1@11@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i1@11@03 V@7@03) (<= 0 i1@11@03)))
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
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
;  :num-allocs              124475
;  :num-checks              8
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            123393)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@11@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
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
;  :memory                  3.95
;  :mk-bool-var             336
;  :mk-clause               7
;  :num-allocs              124647
;  :num-checks              9
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            123556)
(assert (< i1@11@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 4
; Joined path conditions
(assert (< i1@11@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 4
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 5
(assert (not (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No)))
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
;  :num-allocs              124842
;  :num-checks              10
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            123802)
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(pop) ; 4
; Joined path conditions
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(declare-const $k@12@03 $Perm)
(assert ($Perm.isReadVar $k@12@03 $Perm.Write))
(pop) ; 3
(declare-fun inv@13@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@12@03 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@11@03 Int)) (!
  (and
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@11@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@11@03))
  :qid |option$array$-aux|)))
(push) ; 3
(assert (not (forall ((i1@11@03 Int)) (!
  (implies
    (and (< i1@11@03 V@7@03) (<= 0 i1@11@03))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@12@03)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@12@03))))
  
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
;  :num-allocs              125621
;  :num-checks              11
;  :propagations            14
;  :quant-instantiations    14
;  :rlimit-count            124846)
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i11@11@03 Int) (i12@11@03 Int)) (!
  (implies
    (and
      (and
        (and (< i11@11@03 V@7@03) (<= 0 i11@11@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@12@03)))
      (and
        (and (< i12@11@03 V@7@03) (<= 0 i12@11@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@12@03)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i11@11@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i12@11@03)))
    (= i11@11@03 i12@11@03))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               76
;  :arith-add-rows          8
;  :arith-assert-diseq      3
;  :arith-assert-lower      35
;  :arith-assert-upper      19
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
;  :mk-bool-var             393
;  :mk-clause               46
;  :num-allocs              126173
;  :num-checks              12
;  :propagations            30
;  :quant-instantiations    29
;  :rlimit-count            125819)
; Definitional axioms for inverse functions
(assert (forall ((i1@11@03 Int)) (!
  (implies
    (and
      (and (< i1@11@03 V@7@03) (<= 0 i1@11@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@12@03)))
    (=
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@11@03))
      i1@11@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@11@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@13@03 r) V@7@03) (<= 0 (inv@13@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@12@03)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) (inv@13@03 r))
      r))
  :pattern ((inv@13@03 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@11@03 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@11@03))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@11@03 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@11@03))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@11@03 Int)) (!
  (implies
    (and
      (and (< i1@11@03 V@7@03) (<= 0 i1@11@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@12@03)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@11@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@11@03))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@14@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@13@03 r) V@7@03) (<= 0 (inv@13@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@12@03))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@03)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@03)))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@03)))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@13@03 r) V@7@03) (<= 0 (inv@13@03 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) r) r))
  :pattern ((inv@13@03 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               90
;  :arith-add-rows          8
;  :arith-assert-diseq      3
;  :arith-assert-lower      51
;  :arith-assert-upper      27
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
;  :mk-bool-var             411
;  :mk-clause               51
;  :num-allocs              128061
;  :num-checks              13
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            129165)
; [then-branch: 4 | 0 < V@7@03 | live]
; [else-branch: 4 | !(0 < V@7@03) | dead]
(push) ; 4
; [then-branch: 4 | 0 < V@7@03]
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
(declare-const i1@15@03 Int)
(push) ; 5
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 6
; [then-branch: 5 | 0 <= i1@15@03 | live]
; [else-branch: 5 | !(0 <= i1@15@03) | live]
(push) ; 7
; [then-branch: 5 | 0 <= i1@15@03]
(assert (<= 0 i1@15@03))
; [eval] i1 < V
(pop) ; 7
(push) ; 7
; [else-branch: 5 | !(0 <= i1@15@03)]
(assert (not (<= 0 i1@15@03)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 6 | i1@15@03 < V@7@03 && 0 <= i1@15@03 | live]
; [else-branch: 6 | !(i1@15@03 < V@7@03 && 0 <= i1@15@03) | live]
(push) ; 7
; [then-branch: 6 | i1@15@03 < V@7@03 && 0 <= i1@15@03]
(assert (and (< i1@15@03 V@7@03) (<= 0 i1@15@03)))
; [eval] aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               90
;  :arith-add-rows          8
;  :arith-assert-diseq      3
;  :arith-assert-lower      52
;  :arith-assert-upper      28
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
;  :mk-bool-var             413
;  :mk-clause               51
;  :num-allocs              128285
;  :num-checks              14
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            129381)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i1@15@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               90
;  :arith-add-rows          10
;  :arith-assert-diseq      3
;  :arith-assert-lower      53
;  :arith-assert-upper      28
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
;  :memory                  4.00
;  :mk-bool-var             414
;  :mk-clause               51
;  :num-allocs              128435
;  :num-checks              15
;  :propagations            33
;  :quant-instantiations    32
;  :rlimit-count            129536)
(assert (< i1@15@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 8
; Joined path conditions
(assert (< i1@15@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))
      V@7@03)
    (<=
      0
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03))
  false)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               106
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      61
;  :arith-assert-upper      35
;  :arith-bound-prop        1
;  :arith-conflicts         8
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           4
;  :arith-max-min           51
;  :arith-nonlinear-bounds  4
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :conflicts               12
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   18
;  :datatype-splits         12
;  :decisions               15
;  :del-clause              41
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             437
;  :mk-clause               65
;  :num-allocs              128824
;  :num-checks              16
;  :propagations            44
;  :quant-instantiations    43
;  :rlimit-count            130513)
; [eval] (None(): option[array])
(pop) ; 7
(push) ; 7
; [else-branch: 6 | !(i1@15@03 < V@7@03 && 0 <= i1@15@03)]
(assert (not (and (< i1@15@03 V@7@03) (<= 0 i1@15@03))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i1@15@03 V@7@03) (<= 0 i1@15@03))
  (and
    (< i1@15@03 V@7@03)
    (<= 0 i1@15@03)
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@15@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03)))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@15@03 Int)) (!
  (implies
    (and (< i1@15@03 V@7@03) (<= 0 i1@15@03))
    (and
      (< i1@15@03 V@7@03)
      (<= 0 i1@15@03)
      (not (= source@6@03 (as None<option<array>>  option<array>)))
      (< i1@15@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@15@03 Int)) (!
    (implies
      (and (< i1@15@03 V@7@03) (<= 0 i1@15@03))
      (and
        (< i1@15@03 V@7@03)
        (<= 0 i1@15@03)
        (not (= source@6@03 (as None<option<array>>  option<array>)))
        (< i1@15@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@15@03 Int)) (!
    (implies
      (and (< i1@15@03 V@7@03) (<= 0 i1@15@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@15@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               119
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      76
;  :arith-assert-upper      43
;  :arith-bound-prop        1
;  :arith-conflicts         9
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        8
;  :arith-pivots            17
;  :conflicts               13
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               18
;  :del-clause              52
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             443
;  :mk-clause               65
;  :num-allocs              129949
;  :num-checks              17
;  :propagations            47
;  :quant-instantiations    43
;  :rlimit-count            132408)
; [then-branch: 7 | 0 < V@7@03 | live]
; [else-branch: 7 | !(0 < V@7@03) | dead]
(push) ; 4
; [then-branch: 7 | 0 < V@7@03]
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
(declare-const i1@16@03 Int)
(push) ; 5
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 6
; [then-branch: 8 | 0 <= i1@16@03 | live]
; [else-branch: 8 | !(0 <= i1@16@03) | live]
(push) ; 7
; [then-branch: 8 | 0 <= i1@16@03]
(assert (<= 0 i1@16@03))
; [eval] i1 < V
(pop) ; 7
(push) ; 7
; [else-branch: 8 | !(0 <= i1@16@03)]
(assert (not (<= 0 i1@16@03)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 9 | i1@16@03 < V@7@03 && 0 <= i1@16@03 | live]
; [else-branch: 9 | !(i1@16@03 < V@7@03 && 0 <= i1@16@03) | live]
(push) ; 7
; [then-branch: 9 | i1@16@03 < V@7@03 && 0 <= i1@16@03]
(assert (and (< i1@16@03 V@7@03) (<= 0 i1@16@03)))
; [eval] alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(source), i1).option$array$))
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               119
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      78
;  :arith-assert-upper      43
;  :arith-bound-prop        1
;  :arith-conflicts         9
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        8
;  :arith-pivots            18
;  :conflicts               14
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               18
;  :del-clause              52
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             445
;  :mk-clause               65
;  :num-allocs              130103
;  :num-checks              18
;  :propagations            47
;  :quant-instantiations    43
;  :rlimit-count            132628)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i1@16@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               119
;  :arith-add-rows          21
;  :arith-assert-diseq      3
;  :arith-assert-lower      79
;  :arith-assert-upper      43
;  :arith-bound-prop        1
;  :arith-conflicts         10
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        8
;  :arith-pivots            18
;  :conflicts               15
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               18
;  :del-clause              52
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             446
;  :mk-clause               65
;  :num-allocs              130253
;  :num-checks              19
;  :propagations            47
;  :quant-instantiations    43
;  :rlimit-count            132779)
(assert (< i1@16@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 8
; Joined path conditions
(assert (< i1@16@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
      V@7@03)
    (<=
      0
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03))
  false)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               135
;  :arith-add-rows          30
;  :arith-assert-diseq      3
;  :arith-assert-lower      87
;  :arith-assert-upper      50
;  :arith-bound-prop        2
;  :arith-conflicts         12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-grobner           8
;  :arith-max-min           84
;  :arith-nonlinear-bounds  6
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        10
;  :arith-pivots            21
;  :conflicts               17
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               19
;  :del-clause              55
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             471
;  :mk-clause               79
;  :num-allocs              130601
;  :num-checks              20
;  :propagations            58
;  :quant-instantiations    56
;  :rlimit-count            133795)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 9
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               135
;  :arith-add-rows          30
;  :arith-assert-diseq      3
;  :arith-assert-lower      87
;  :arith-assert-upper      50
;  :arith-bound-prop        2
;  :arith-conflicts         12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-grobner           8
;  :arith-max-min           84
;  :arith-nonlinear-bounds  6
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        10
;  :arith-pivots            21
;  :conflicts               18
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   22
;  :datatype-splits         14
;  :decisions               19
;  :del-clause              55
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             471
;  :mk-clause               79
;  :num-allocs              130692
;  :num-checks              21
;  :propagations            58
;  :quant-instantiations    56
;  :rlimit-count            133890)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
    (as None<option<array>>  option<array>))))
(pop) ; 7
(push) ; 7
; [else-branch: 9 | !(i1@16@03 < V@7@03 && 0 <= i1@16@03)]
(assert (not (and (< i1@16@03 V@7@03) (<= 0 i1@16@03))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i1@16@03 V@7@03) (<= 0 i1@16@03))
  (and
    (< i1@16@03 V@7@03)
    (<= 0 i1@16@03)
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@16@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@16@03 Int)) (!
  (implies
    (and (< i1@16@03 V@7@03) (<= 0 i1@16@03))
    (and
      (< i1@16@03 V@7@03)
      (<= 0 i1@16@03)
      (not (= source@6@03 (as None<option<array>>  option<array>)))
      (< i1@16@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@16@03 Int)) (!
    (implies
      (and (< i1@16@03 V@7@03) (<= 0 i1@16@03))
      (and
        (< i1@16@03 V@7@03)
        (<= 0 i1@16@03)
        (not (= source@6@03 (as None<option<array>>  option<array>)))
        (< i1@16@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@16@03 Int)) (!
    (implies
      (and (< i1@16@03 V@7@03) (<= 0 i1@16@03))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03))))
        V@7@03))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@16@03)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               148
;  :arith-add-rows          30
;  :arith-assert-diseq      3
;  :arith-assert-lower      102
;  :arith-assert-upper      58
;  :arith-bound-prop        2
;  :arith-conflicts         13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        11
;  :arith-pivots            22
;  :conflicts               19
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   26
;  :datatype-splits         16
;  :decisions               22
;  :del-clause              66
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             477
;  :mk-clause               79
;  :num-allocs              131838
;  :num-checks              22
;  :propagations            61
;  :quant-instantiations    56
;  :rlimit-count            135889)
; [then-branch: 10 | 0 < V@7@03 | live]
; [else-branch: 10 | !(0 < V@7@03) | dead]
(push) ; 4
; [then-branch: 10 | 0 < V@7@03]
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
(declare-const i1@17@03 Int)
(push) ; 5
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2)
(declare-const i2@18@03 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 11 | 0 <= i1@17@03 | live]
; [else-branch: 11 | !(0 <= i1@17@03) | live]
(push) ; 8
; [then-branch: 11 | 0 <= i1@17@03]
(assert (<= 0 i1@17@03))
; [eval] i1 < V
(push) ; 9
; [then-branch: 12 | i1@17@03 < V@7@03 | live]
; [else-branch: 12 | !(i1@17@03 < V@7@03) | live]
(push) ; 10
; [then-branch: 12 | i1@17@03 < V@7@03]
(assert (< i1@17@03 V@7@03))
; [eval] 0 <= i2
(push) ; 11
; [then-branch: 13 | 0 <= i2@18@03 | live]
; [else-branch: 13 | !(0 <= i2@18@03) | live]
(push) ; 12
; [then-branch: 13 | 0 <= i2@18@03]
(assert (<= 0 i2@18@03))
; [eval] i2 < V
(push) ; 13
; [then-branch: 14 | i2@18@03 < V@7@03 | live]
; [else-branch: 14 | !(i2@18@03 < V@7@03) | live]
(push) ; 14
; [then-branch: 14 | i2@18@03 < V@7@03]
(assert (< i2@18@03 V@7@03))
; [eval] aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 15
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 16
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               148
;  :arith-add-rows          30
;  :arith-assert-diseq      3
;  :arith-assert-lower      106
;  :arith-assert-upper      58
;  :arith-bound-prop        2
;  :arith-conflicts         13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        11
;  :arith-pivots            23
;  :conflicts               20
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   26
;  :datatype-splits         16
;  :decisions               22
;  :del-clause              66
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             481
;  :mk-clause               79
;  :num-allocs              132222
;  :num-checks              23
;  :propagations            61
;  :quant-instantiations    56
;  :rlimit-count            136254)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 15
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 15
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 16
(assert (not (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               148
;  :arith-add-rows          32
;  :arith-assert-diseq      3
;  :arith-assert-lower      106
;  :arith-assert-upper      59
;  :arith-bound-prop        2
;  :arith-conflicts         14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        11
;  :arith-pivots            23
;  :conflicts               21
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   26
;  :datatype-splits         16
;  :decisions               22
;  :del-clause              66
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.04
;  :mk-bool-var             482
;  :mk-clause               79
;  :num-allocs              132367
;  :num-checks              24
;  :propagations            61
;  :quant-instantiations    56
;  :rlimit-count            136409)
(assert (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 15
; Joined path conditions
(assert (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
      V@7@03)
    (<=
      0
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03))
  false)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               165
;  :arith-add-rows          41
;  :arith-assert-diseq      3
;  :arith-assert-lower      115
;  :arith-assert-upper      65
;  :arith-bound-prop        3
;  :arith-conflicts         16
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         11
;  :arith-grobner           12
;  :arith-max-min           117
;  :arith-nonlinear-bounds  8
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        15
;  :arith-pivots            26
;  :conflicts               23
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   26
;  :datatype-splits         16
;  :decisions               23
;  :del-clause              69
;  :final-checks            34
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.06
;  :mk-bool-var             506
;  :mk-clause               93
;  :num-allocs              132715
;  :num-checks              25
;  :propagations            72
;  :quant-instantiations    69
;  :rlimit-count            137427)
; [eval] aloc(opt_get1(source), i2)
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
(assert (not (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               165
;  :arith-add-rows          44
;  :arith-assert-diseq      3
;  :arith-assert-lower      115
;  :arith-assert-upper      66
;  :arith-bound-prop        3
;  :arith-conflicts         17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         11
;  :arith-grobner           12
;  :arith-max-min           117
;  :arith-nonlinear-bounds  8
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        15
;  :arith-pivots            28
;  :conflicts               24
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   26
;  :datatype-splits         16
;  :decisions               23
;  :del-clause              69
;  :final-checks            34
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.06
;  :mk-bool-var             507
;  :mk-clause               93
;  :num-allocs              132800
;  :num-checks              26
;  :propagations            72
;  :quant-instantiations    69
;  :rlimit-count            137576)
(assert (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 15
; Joined path conditions
(assert (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))
      V@7@03)
    (<=
      0
      (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03))
  false)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-add-rows          52
;  :arith-assert-diseq      3
;  :arith-assert-lower      123
;  :arith-assert-upper      72
;  :arith-bound-prop        4
;  :arith-conflicts         19
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         15
;  :arith-grobner           12
;  :arith-max-min           124
;  :arith-nonlinear-bounds  9
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        15
;  :arith-pivots            31
;  :conflicts               26
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   26
;  :datatype-splits         16
;  :decisions               24
;  :del-clause              73
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.10
;  :mk-bool-var             532
;  :mk-clause               106
;  :num-allocs              133179
;  :num-checks              27
;  :propagations            81
;  :quant-instantiations    81
;  :rlimit-count            138587)
(pop) ; 14
(push) ; 14
; [else-branch: 14 | !(i2@18@03 < V@7@03)]
(assert (not (< i2@18@03 V@7@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i2@18@03 V@7@03)
  (and
    (< i2@18@03 V@7@03)
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
    (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 13 | !(0 <= i2@18@03)]
(assert (not (<= 0 i2@18@03)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i2@18@03)
  (and
    (<= 0 i2@18@03)
    (implies
      (< i2@18@03 V@7@03)
      (and
        (< i2@18@03 V@7@03)
        (not (= source@6@03 (as None<option<array>>  option<array>)))
        (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
        (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))))))
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 12 | !(i1@17@03 < V@7@03)]
(assert (not (< i1@17@03 V@7@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (< i1@17@03 V@7@03)
  (and
    (< i1@17@03 V@7@03)
    (implies
      (<= 0 i2@18@03)
      (and
        (<= 0 i2@18@03)
        (implies
          (< i2@18@03 V@7@03)
          (and
            (< i2@18@03 V@7@03)
            (not (= source@6@03 (as None<option<array>>  option<array>)))
            (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
            (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))))))))
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= i1@17@03)]
(assert (not (<= 0 i1@17@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (<= 0 i1@17@03)
  (and
    (<= 0 i1@17@03)
    (implies
      (< i1@17@03 V@7@03)
      (and
        (< i1@17@03 V@7@03)
        (implies
          (<= 0 i2@18@03)
          (and
            (<= 0 i2@18@03)
            (implies
              (< i2@18@03 V@7@03)
              (and
                (< i2@18@03 V@7@03)
                (not (= source@6@03 (as None<option<array>>  option<array>)))
                (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))))))))))
; Joined path conditions
(push) ; 7
; [then-branch: 15 | Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i1@17@03)) == Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i2@18@03)) && i2@18@03 < V@7@03 && 0 <= i2@18@03 && i1@17@03 < V@7@03 && 0 <= i1@17@03 | live]
; [else-branch: 15 | !(Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i1@17@03)) == Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i2@18@03)) && i2@18@03 < V@7@03 && 0 <= i2@18@03 && i1@17@03 < V@7@03 && 0 <= i1@17@03) | live]
(push) ; 8
; [then-branch: 15 | Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i1@17@03)) == Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i2@18@03)) && i2@18@03 < V@7@03 && 0 <= i2@18@03 && i1@17@03 < V@7@03 && 0 <= i1@17@03]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
          ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
        (< i2@18@03 V@7@03))
      (<= 0 i2@18@03))
    (< i1@17@03 V@7@03))
  (<= 0 i1@17@03)))
; [eval] i1 == i2
(pop) ; 8
(push) ; 8
; [else-branch: 15 | !(Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i1@17@03)) == Lookup(option$array$,sm@14@03,aloc((_, _), opt_get1(_, source@6@03), i2@18@03)) && i2@18@03 < V@7@03 && 0 <= i2@18@03 && i1@17@03 < V@7@03 && 0 <= i1@17@03)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
            ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
          (< i2@18@03 V@7@03))
        (<= 0 i2@18@03))
      (< i1@17@03 V@7@03))
    (<= 0 i1@17@03))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
            ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
          (< i2@18@03 V@7@03))
        (<= 0 i2@18@03))
      (< i1@17@03 V@7@03))
    (<= 0 i1@17@03))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
      ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
    (< i2@18@03 V@7@03)
    (<= 0 i2@18@03)
    (< i1@17@03 V@7@03)
    (<= 0 i1@17@03))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@18@03 Int)) (!
  (and
    (implies
      (<= 0 i1@17@03)
      (and
        (<= 0 i1@17@03)
        (implies
          (< i1@17@03 V@7@03)
          (and
            (< i1@17@03 V@7@03)
            (implies
              (<= 0 i2@18@03)
              (and
                (<= 0 i2@18@03)
                (implies
                  (< i2@18@03 V@7@03)
                  (and
                    (< i2@18@03 V@7@03)
                    (not (= source@6@03 (as None<option<array>>  option<array>)))
                    (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                    (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
              (< i2@18@03 V@7@03))
            (<= 0 i2@18@03))
          (< i1@17@03 V@7@03))
        (<= 0 i1@17@03))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
          ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
        (< i2@18@03 V@7@03)
        (<= 0 i2@18@03)
        (< i1@17@03 V@7@03)
        (<= 0 i1@17@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@17@03 Int)) (!
  (forall ((i2@18@03 Int)) (!
    (and
      (implies
        (<= 0 i1@17@03)
        (and
          (<= 0 i1@17@03)
          (implies
            (< i1@17@03 V@7@03)
            (and
              (< i1@17@03 V@7@03)
              (implies
                (<= 0 i2@18@03)
                (and
                  (<= 0 i2@18@03)
                  (implies
                    (< i2@18@03 V@7@03)
                    (and
                      (< i2@18@03 V@7@03)
                      (not
                        (= source@6@03 (as None<option<array>>  option<array>)))
                      (< i1@17@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                      (< i2@18@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                  ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
                (< i2@18@03 V@7@03))
              (<= 0 i2@18@03))
            (< i1@17@03 V@7@03))
          (<= 0 i1@17@03))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
            ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
          (< i2@18@03 V@7@03)
          (<= 0 i2@18@03)
          (< i1@17@03 V@7@03)
          (<= 0 i1@17@03))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@17@03 Int)) (!
    (forall ((i2@18@03 Int)) (!
      (and
        (implies
          (<= 0 i1@17@03)
          (and
            (<= 0 i1@17@03)
            (implies
              (< i1@17@03 V@7@03)
              (and
                (< i1@17@03 V@7@03)
                (implies
                  (<= 0 i2@18@03)
                  (and
                    (<= 0 i2@18@03)
                    (implies
                      (< i2@18@03 V@7@03)
                      (and
                        (< i2@18@03 V@7@03)
                        (not
                          (= source@6@03 (as None<option<array>>  option<array>)))
                        (<
                          i1@17@03
                          (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                        (<
                          i2@18@03
                          (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                    ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
                  (< i2@18@03 V@7@03))
                (<= 0 i2@18@03))
              (< i1@17@03 V@7@03))
            (<= 0 i1@17@03))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
              ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
            (< i2@18@03 V@7@03)
            (<= 0 i2@18@03)
            (< i1@17@03 V@7@03)
            (<= 0 i1@17@03))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@17@03 Int)) (!
    (forall ((i2@18@03 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
                  ($FVF.lookup_option$array$ (as sm@14@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03)))
                (< i2@18@03 V@7@03))
              (<= 0 i2@18@03))
            (< i1@17@03 V@7@03))
          (<= 0 i1@17@03))
        (= i1@17@03 i2@18@03))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@18@03))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@17@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               192
;  :arith-add-rows          54
;  :arith-assert-diseq      3
;  :arith-assert-lower      138
;  :arith-assert-upper      80
;  :arith-bound-prop        4
;  :arith-conflicts         20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         15
;  :arith-grobner           16
;  :arith-max-min           150
;  :arith-nonlinear-bounds  10
;  :arith-nonlinear-horner  12
;  :arith-offset-eqs        16
;  :arith-pivots            33
;  :conflicts               27
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   30
;  :datatype-splits         18
;  :decisions               27
;  :del-clause              118
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             553
;  :mk-clause               131
;  :num-allocs              134924
;  :num-checks              28
;  :propagations            84
;  :quant-instantiations    81
;  :rlimit-count            142259)
; [then-branch: 16 | 0 < V@7@03 | live]
; [else-branch: 16 | !(0 < V@7@03) | dead]
(push) ; 4
; [then-branch: 16 | 0 < V@7@03]
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (not (= target@5@03 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               205
;  :arith-add-rows          54
;  :arith-assert-diseq      3
;  :arith-assert-lower      153
;  :arith-assert-upper      88
;  :arith-bound-prop        4
;  :arith-conflicts         21
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         15
;  :arith-grobner           20
;  :arith-max-min           176
;  :arith-nonlinear-bounds  11
;  :arith-nonlinear-horner  15
;  :arith-offset-eqs        17
;  :arith-pivots            33
;  :conflicts               28
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   34
;  :datatype-splits         20
;  :decisions               30
;  :del-clause              118
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             558
;  :mk-clause               131
;  :num-allocs              135667
;  :num-checks              29
;  :propagations            87
;  :quant-instantiations    81
;  :rlimit-count            143334)
; [then-branch: 17 | 0 < V@7@03 | live]
; [else-branch: 17 | !(0 < V@7@03) | dead]
(push) ; 4
; [then-branch: 17 | 0 < V@7@03]
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               205
;  :arith-add-rows          54
;  :arith-assert-diseq      3
;  :arith-assert-lower      153
;  :arith-assert-upper      88
;  :arith-bound-prop        4
;  :arith-conflicts         21
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         15
;  :arith-grobner           20
;  :arith-max-min           176
;  :arith-nonlinear-bounds  11
;  :arith-nonlinear-horner  15
;  :arith-offset-eqs        17
;  :arith-pivots            33
;  :conflicts               28
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   34
;  :datatype-splits         20
;  :decisions               30
;  :del-clause              118
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             558
;  :mk-clause               131
;  :num-allocs              135692
;  :num-checks              30
;  :propagations            87
;  :quant-instantiations    81
;  :rlimit-count            143355)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (< 0 V@7@03) (= (alen<Int> (opt_get1 $Snap.unit target@5@03)) V@7@03)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               225
;  :arith-add-rows          54
;  :arith-assert-diseq      3
;  :arith-assert-lower      170
;  :arith-assert-upper      97
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        18
;  :arith-pivots            34
;  :conflicts               29
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   38
;  :datatype-splits         23
;  :decisions               34
;  :del-clause              118
;  :final-checks            50
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             571
;  :mk-clause               131
;  :num-allocs              136566
;  :num-checks              31
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            144763)
; [then-branch: 18 | 0 < V@7@03 | live]
; [else-branch: 18 | !(0 < V@7@03) | dead]
(push) ; 3
; [then-branch: 18 | 0 < V@7@03]
(declare-const i1@19@03 Int)
(push) ; 4
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 5
; [then-branch: 19 | 0 <= i1@19@03 | live]
; [else-branch: 19 | !(0 <= i1@19@03) | live]
(push) ; 6
; [then-branch: 19 | 0 <= i1@19@03]
(assert (<= 0 i1@19@03))
; [eval] i1 < V
(pop) ; 6
(push) ; 6
; [else-branch: 19 | !(0 <= i1@19@03)]
(assert (not (<= 0 i1@19@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< i1@19@03 V@7@03) (<= 0 i1@19@03)))
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               225
;  :arith-add-rows          54
;  :arith-assert-diseq      3
;  :arith-assert-lower      172
;  :arith-assert-upper      97
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        18
;  :arith-pivots            34
;  :conflicts               29
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   38
;  :datatype-splits         23
;  :decisions               34
;  :del-clause              118
;  :final-checks            50
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             573
;  :mk-clause               131
;  :num-allocs              136666
;  :num-checks              32
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            144934)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i1@19@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               225
;  :arith-add-rows          54
;  :arith-assert-diseq      3
;  :arith-assert-lower      172
;  :arith-assert-upper      97
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        18
;  :arith-pivots            34
;  :conflicts               29
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   38
;  :datatype-splits         23
;  :decisions               34
;  :del-clause              118
;  :final-checks            50
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             573
;  :mk-clause               131
;  :num-allocs              136687
;  :num-checks              33
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            144965)
(assert (< i1@19@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 5
; Joined path conditions
(assert (< i1@19@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 5
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 6
(assert (not (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               225
;  :arith-add-rows          54
;  :arith-assert-diseq      3
;  :arith-assert-lower      176
;  :arith-assert-upper      100
;  :arith-bound-prop        4
;  :arith-conflicts         23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           211
;  :arith-nonlinear-bounds  13
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        18
;  :arith-pivots            34
;  :conflicts               30
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   38
;  :datatype-splits         23
;  :decisions               34
;  :del-clause              118
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             573
;  :mk-clause               131
;  :num-allocs              136861
;  :num-checks              34
;  :propagations            90
;  :quant-instantiations    86
;  :rlimit-count            145130)
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(pop) ; 5
; Joined path conditions
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(declare-const $k@20@03 $Perm)
(assert ($Perm.isReadVar $k@20@03 $Perm.Write))
(pop) ; 4
(declare-fun inv@21@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@20@03 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@19@03 Int)) (!
  (and
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@19@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@19@03))
  :qid |option$array$-aux|)))
(push) ; 4
(assert (not (forall ((i1@19@03 Int)) (!
  (implies
    (and (< i1@19@03 V@7@03) (<= 0 i1@19@03))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@20@03)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@20@03))))
  
  ))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               234
;  :arith-add-rows          54
;  :arith-assert-diseq      5
;  :arith-assert-lower      194
;  :arith-assert-upper      110
;  :arith-bound-prop        4
;  :arith-conflicts         25
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           234
;  :arith-nonlinear-bounds  16
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        19
;  :arith-pivots            36
;  :conflicts               32
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   40
;  :datatype-splits         26
;  :decisions               38
;  :del-clause              121
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             586
;  :mk-clause               136
;  :num-allocs              137532
;  :num-checks              35
;  :propagations            95
;  :quant-instantiations    86
;  :rlimit-count            146106)
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((i11@19@03 Int) (i12@19@03 Int)) (!
  (implies
    (and
      (and
        (and (< i11@19@03 V@7@03) (<= 0 i11@19@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@20@03)))
      (and
        (and (< i12@19@03 V@7@03) (<= 0 i12@19@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@20@03)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i11@19@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i12@19@03)))
    (= i11@19@03 i12@19@03))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               250
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      201
;  :arith-assert-upper      111
;  :arith-bound-prop        6
;  :arith-conflicts         25
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           234
;  :arith-nonlinear-bounds  16
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        22
;  :arith-pivots            40
;  :conflicts               33
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   40
;  :datatype-splits         26
;  :decisions               38
;  :del-clause              139
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.14
;  :mk-bool-var             612
;  :mk-clause               154
;  :num-allocs              137942
;  :num-checks              36
;  :propagations            105
;  :quant-instantiations    96
;  :rlimit-count            146977)
; Definitional axioms for inverse functions
(assert (forall ((i1@19@03 Int)) (!
  (implies
    (and
      (and (< i1@19@03 V@7@03) (<= 0 i1@19@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@20@03)))
    (=
      (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@19@03))
      i1@19@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@19@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@21@03 r) V@7@03) (<= 0 (inv@21@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@20@03)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) (inv@21@03 r))
      r))
  :pattern ((inv@21@03 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@19@03 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@19@03))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@19@03 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@19@03))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@19@03 Int)) (!
  (implies
    (and
      (and (< i1@19@03 V@7@03) (<= 0 i1@19@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@20@03)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@19@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@19@03))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@22@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@21@03 r) V@7@03) (<= 0 (inv@21@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@20@03))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))) r))
  :qid |qp.fvfValDef2|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@13@03 r) V@7@03) (<= 0 (inv@13@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@12@03))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@03)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@03)))) r))
  :qid |qp.fvfValDef3|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@03)))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef4|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@21@03 r) V@7@03) (<= 0 (inv@21@03 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) r) r))
  :pattern ((inv@21@03 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      224
;  :arith-assert-upper      125
;  :arith-bound-prop        6
;  :arith-conflicts         26
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           271
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        23
;  :arith-pivots            40
;  :conflicts               34
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   44
;  :datatype-splits         29
;  :decisions               42
;  :del-clause              139
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             626
;  :mk-clause               154
;  :num-allocs              140097
;  :num-checks              37
;  :propagations            108
;  :quant-instantiations    96
;  :rlimit-count            151557)
; [then-branch: 20 | 0 < V@7@03 | live]
; [else-branch: 20 | !(0 < V@7@03) | dead]
(push) ; 5
; [then-branch: 20 | 0 < V@7@03]
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
(declare-const i1@23@03 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 21 | 0 <= i1@23@03 | live]
; [else-branch: 21 | !(0 <= i1@23@03) | live]
(push) ; 8
; [then-branch: 21 | 0 <= i1@23@03]
(assert (<= 0 i1@23@03))
; [eval] i1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 21 | !(0 <= i1@23@03)]
(assert (not (<= 0 i1@23@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 22 | i1@23@03 < V@7@03 && 0 <= i1@23@03 | live]
; [else-branch: 22 | !(i1@23@03 < V@7@03 && 0 <= i1@23@03) | live]
(push) ; 8
; [then-branch: 22 | i1@23@03 < V@7@03 && 0 <= i1@23@03]
(assert (and (< i1@23@03 V@7@03) (<= 0 i1@23@03)))
; [eval] aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      226
;  :arith-assert-upper      125
;  :arith-bound-prop        6
;  :arith-conflicts         26
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           271
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        23
;  :arith-pivots            41
;  :conflicts               34
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   44
;  :datatype-splits         29
;  :decisions               42
;  :del-clause              139
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             628
;  :mk-clause               154
;  :num-allocs              140197
;  :num-checks              38
;  :propagations            108
;  :quant-instantiations    96
;  :rlimit-count            151742)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i1@23@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-add-rows          60
;  :arith-assert-diseq      7
;  :arith-assert-lower      226
;  :arith-assert-upper      125
;  :arith-bound-prop        6
;  :arith-conflicts         26
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           271
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        23
;  :arith-pivots            41
;  :conflicts               34
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   44
;  :datatype-splits         29
;  :decisions               42
;  :del-clause              139
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             628
;  :mk-clause               154
;  :num-allocs              140218
;  :num-checks              39
;  :propagations            108
;  :quant-instantiations    96
;  :rlimit-count            151773)
(assert (< i1@23@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 9
; Joined path conditions
(assert (< i1@23@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))
          V@7@03)
        (<=
          0
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))
          V@7@03)
        (<=
          0
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               334
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      263
;  :arith-assert-upper      152
;  :arith-bound-prop        8
;  :arith-conflicts         32
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         26
;  :arith-grobner           30
;  :arith-max-min           291
;  :arith-nonlinear-bounds  22
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        29
;  :arith-pivots            59
;  :conflicts               44
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   46
;  :datatype-splits         32
;  :decisions               69
;  :del-clause              228
;  :final-checks            62
;  :max-generation          3
;  :max-memory              4.19
;  :memory                  4.19
;  :mk-bool-var             767
;  :mk-clause               266
;  :num-allocs              141144
;  :num-checks              40
;  :propagations            178
;  :quant-instantiations    125
;  :rlimit-count            154427
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 8
(push) ; 8
; [else-branch: 22 | !(i1@23@03 < V@7@03 && 0 <= i1@23@03)]
(assert (not (and (< i1@23@03 V@7@03) (<= 0 i1@23@03))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i1@23@03 V@7@03) (<= 0 i1@23@03))
  (and
    (< i1@23@03 V@7@03)
    (<= 0 i1@23@03)
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@23@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@23@03 Int)) (!
  (implies
    (and (< i1@23@03 V@7@03) (<= 0 i1@23@03))
    (and
      (< i1@23@03 V@7@03)
      (<= 0 i1@23@03)
      (not (= target@5@03 (as None<option<array>>  option<array>)))
      (< i1@23@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@23@03 Int)) (!
    (implies
      (and (< i1@23@03 V@7@03) (<= 0 i1@23@03))
      (and
        (< i1@23@03 V@7@03)
        (<= 0 i1@23@03)
        (not (= target@5@03 (as None<option<array>>  option<array>)))
        (< i1@23@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@23@03 Int)) (!
    (implies
      (and (< i1@23@03 V@7@03) (<= 0 i1@23@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@23@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               350
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      285
;  :arith-assert-upper      166
;  :arith-bound-prop        8
;  :arith-conflicts         33
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         26
;  :arith-grobner           35
;  :arith-max-min           329
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        30
;  :arith-pivots            60
;  :conflicts               45
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   50
;  :datatype-splits         35
;  :decisions               73
;  :del-clause              251
;  :final-checks            67
;  :max-generation          3
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             774
;  :mk-clause               266
;  :num-allocs              142404
;  :num-checks              41
;  :propagations            181
;  :quant-instantiations    125
;  :rlimit-count            156580)
; [then-branch: 23 | 0 < V@7@03 | live]
; [else-branch: 23 | !(0 < V@7@03) | dead]
(push) ; 5
; [then-branch: 23 | 0 < V@7@03]
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
(declare-const i1@24@03 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 24 | 0 <= i1@24@03 | live]
; [else-branch: 24 | !(0 <= i1@24@03) | live]
(push) ; 8
; [then-branch: 24 | 0 <= i1@24@03]
(assert (<= 0 i1@24@03))
; [eval] i1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(0 <= i1@24@03)]
(assert (not (<= 0 i1@24@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 25 | i1@24@03 < V@7@03 && 0 <= i1@24@03 | live]
; [else-branch: 25 | !(i1@24@03 < V@7@03 && 0 <= i1@24@03) | live]
(push) ; 8
; [then-branch: 25 | i1@24@03 < V@7@03 && 0 <= i1@24@03]
(assert (and (< i1@24@03 V@7@03) (<= 0 i1@24@03)))
; [eval] alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(target), i1).option$array$))
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               350
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      287
;  :arith-assert-upper      166
;  :arith-bound-prop        8
;  :arith-conflicts         33
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         26
;  :arith-grobner           35
;  :arith-max-min           329
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        30
;  :arith-pivots            61
;  :conflicts               45
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   50
;  :datatype-splits         35
;  :decisions               73
;  :del-clause              251
;  :final-checks            67
;  :max-generation          3
;  :max-memory              4.21
;  :memory                  4.21
;  :mk-bool-var             776
;  :mk-clause               266
;  :num-allocs              142506
;  :num-checks              42
;  :propagations            181
;  :quant-instantiations    125
;  :rlimit-count            156765)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i1@24@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               350
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      287
;  :arith-assert-upper      166
;  :arith-bound-prop        8
;  :arith-conflicts         33
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         26
;  :arith-grobner           35
;  :arith-max-min           329
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        30
;  :arith-pivots            61
;  :conflicts               45
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   50
;  :datatype-splits         35
;  :decisions               73
;  :del-clause              251
;  :final-checks            67
;  :max-generation          3
;  :max-memory              4.21
;  :memory                  4.21
;  :mk-bool-var             776
;  :mk-clause               266
;  :num-allocs              142527
;  :num-checks              43
;  :propagations            181
;  :quant-instantiations    125
;  :rlimit-count            156796)
(assert (< i1@24@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 9
; Joined path conditions
(assert (< i1@24@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
          V@7@03)
        (<=
          0
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
          V@7@03)
        (<=
          0
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               418
;  :arith-add-rows          104
;  :arith-assert-diseq      11
;  :arith-assert-lower      324
;  :arith-assert-upper      193
;  :arith-bound-prop        10
;  :arith-conflicts         39
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         36
;  :arith-grobner           35
;  :arith-max-min           349
;  :arith-nonlinear-bounds  28
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        36
;  :arith-pivots            79
;  :conflicts               55
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   52
;  :datatype-splits         38
;  :decisions               100
;  :del-clause              340
;  :final-checks            70
;  :max-generation          3
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             917
;  :mk-clause               378
;  :num-allocs              143220
;  :num-checks              44
;  :propagations            251
;  :quant-instantiations    156
;  :rlimit-count            159348
;  :time                    0.00)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               418
;  :arith-add-rows          104
;  :arith-assert-diseq      11
;  :arith-assert-lower      324
;  :arith-assert-upper      193
;  :arith-bound-prop        10
;  :arith-conflicts         39
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         36
;  :arith-grobner           35
;  :arith-max-min           349
;  :arith-nonlinear-bounds  28
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        36
;  :arith-pivots            79
;  :conflicts               56
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   52
;  :datatype-splits         38
;  :decisions               100
;  :del-clause              340
;  :final-checks            70
;  :max-generation          3
;  :max-memory              4.24
;  :memory                  4.23
;  :mk-bool-var             917
;  :mk-clause               378
;  :num-allocs              143310
;  :num-checks              45
;  :propagations            251
;  :quant-instantiations    156
;  :rlimit-count            159443)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
    (as None<option<array>>  option<array>))))
(pop) ; 8
(push) ; 8
; [else-branch: 25 | !(i1@24@03 < V@7@03 && 0 <= i1@24@03)]
(assert (not (and (< i1@24@03 V@7@03) (<= 0 i1@24@03))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i1@24@03 V@7@03) (<= 0 i1@24@03))
  (and
    (< i1@24@03 V@7@03)
    (<= 0 i1@24@03)
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@24@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@24@03 Int)) (!
  (implies
    (and (< i1@24@03 V@7@03) (<= 0 i1@24@03))
    (and
      (< i1@24@03 V@7@03)
      (<= 0 i1@24@03)
      (not (= target@5@03 (as None<option<array>>  option<array>)))
      (< i1@24@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@24@03 Int)) (!
    (implies
      (and (< i1@24@03 V@7@03) (<= 0 i1@24@03))
      (and
        (< i1@24@03 V@7@03)
        (<= 0 i1@24@03)
        (not (= target@5@03 (as None<option<array>>  option<array>)))
        (< i1@24@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@24@03 Int)) (!
    (implies
      (and (< i1@24@03 V@7@03) (<= 0 i1@24@03))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03))))
        V@7@03))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@24@03)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@7@03))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               434
;  :arith-add-rows          104
;  :arith-assert-diseq      11
;  :arith-assert-lower      346
;  :arith-assert-upper      207
;  :arith-bound-prop        10
;  :arith-conflicts         40
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         36
;  :arith-grobner           40
;  :arith-max-min           387
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        37
;  :arith-pivots            80
;  :conflicts               57
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   56
;  :datatype-splits         41
;  :decisions               104
;  :del-clause              363
;  :final-checks            75
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             924
;  :mk-clause               378
;  :num-allocs              144592
;  :num-checks              46
;  :propagations            254
;  :quant-instantiations    156
;  :rlimit-count            161700)
; [then-branch: 26 | 0 < V@7@03 | live]
; [else-branch: 26 | !(0 < V@7@03) | dead]
(push) ; 5
; [then-branch: 26 | 0 < V@7@03]
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
(declare-const i1@25@03 Int)
(push) ; 6
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2)
(declare-const i2@26@03 Int)
(push) ; 7
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] 0 <= i1
(push) ; 8
; [then-branch: 27 | 0 <= i1@25@03 | live]
; [else-branch: 27 | !(0 <= i1@25@03) | live]
(push) ; 9
; [then-branch: 27 | 0 <= i1@25@03]
(assert (<= 0 i1@25@03))
; [eval] i1 < V
(push) ; 10
; [then-branch: 28 | i1@25@03 < V@7@03 | live]
; [else-branch: 28 | !(i1@25@03 < V@7@03) | live]
(push) ; 11
; [then-branch: 28 | i1@25@03 < V@7@03]
(assert (< i1@25@03 V@7@03))
; [eval] 0 <= i2
(push) ; 12
; [then-branch: 29 | 0 <= i2@26@03 | live]
; [else-branch: 29 | !(0 <= i2@26@03) | live]
(push) ; 13
; [then-branch: 29 | 0 <= i2@26@03]
(assert (<= 0 i2@26@03))
; [eval] i2 < V
(push) ; 14
; [then-branch: 30 | i2@26@03 < V@7@03 | live]
; [else-branch: 30 | !(i2@26@03 < V@7@03) | live]
(push) ; 15
; [then-branch: 30 | i2@26@03 < V@7@03]
(assert (< i2@26@03 V@7@03))
; [eval] aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 16
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 17
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               434
;  :arith-add-rows          104
;  :arith-assert-diseq      11
;  :arith-assert-lower      350
;  :arith-assert-upper      207
;  :arith-bound-prop        10
;  :arith-conflicts         40
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         36
;  :arith-grobner           40
;  :arith-max-min           387
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        37
;  :arith-pivots            82
;  :conflicts               57
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   56
;  :datatype-splits         41
;  :decisions               104
;  :del-clause              363
;  :final-checks            75
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             928
;  :mk-clause               378
;  :num-allocs              144869
;  :num-checks              47
;  :propagations            254
;  :quant-instantiations    156
;  :rlimit-count            162035)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 16
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 16
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 17
(assert (not (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               434
;  :arith-add-rows          104
;  :arith-assert-diseq      11
;  :arith-assert-lower      350
;  :arith-assert-upper      207
;  :arith-bound-prop        10
;  :arith-conflicts         40
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         36
;  :arith-grobner           40
;  :arith-max-min           387
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        37
;  :arith-pivots            82
;  :conflicts               57
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   56
;  :datatype-splits         41
;  :decisions               104
;  :del-clause              363
;  :final-checks            75
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             928
;  :mk-clause               378
;  :num-allocs              144890
;  :num-checks              48
;  :propagations            254
;  :quant-instantiations    156
;  :rlimit-count            162066)
(assert (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 16
; Joined path conditions
(assert (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
          V@7@03)
        (<=
          0
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
          V@7@03)
        (<=
          0
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               502
;  :arith-add-rows          128
;  :arith-assert-diseq      13
;  :arith-assert-lower      387
;  :arith-assert-upper      234
;  :arith-bound-prop        12
;  :arith-conflicts         46
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         46
;  :arith-grobner           40
;  :arith-max-min           407
;  :arith-nonlinear-bounds  34
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        43
;  :arith-pivots            99
;  :conflicts               67
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   58
;  :datatype-splits         44
;  :decisions               131
;  :del-clause              452
;  :final-checks            78
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             1069
;  :mk-clause               490
;  :num-allocs              145628
;  :num-checks              49
;  :propagations            324
;  :quant-instantiations    187
;  :rlimit-count            164606
;  :time                    0.00)
; [eval] aloc(opt_get1(target), i2)
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
(assert (not (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               502
;  :arith-add-rows          128
;  :arith-assert-diseq      13
;  :arith-assert-lower      387
;  :arith-assert-upper      234
;  :arith-bound-prop        12
;  :arith-conflicts         46
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         46
;  :arith-grobner           40
;  :arith-max-min           407
;  :arith-nonlinear-bounds  34
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        43
;  :arith-pivots            99
;  :conflicts               67
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   58
;  :datatype-splits         44
;  :decisions               131
;  :del-clause              452
;  :final-checks            78
;  :max-generation          3
;  :max-memory              4.25
;  :memory                  4.24
;  :mk-bool-var             1069
;  :mk-clause               490
;  :num-allocs              145655
;  :num-checks              50
;  :propagations            324
;  :quant-instantiations    187
;  :rlimit-count            164636)
(assert (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 16
; Joined path conditions
(assert (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))
          V@7@03)
        (<=
          0
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))
          V@7@03)
        (<=
          0
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               648
;  :arith-add-rows          190
;  :arith-assert-diseq      15
;  :arith-assert-lower      434
;  :arith-assert-upper      269
;  :arith-bound-prop        20
;  :arith-conflicts         52
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         64
;  :arith-grobner           40
;  :arith-max-min           427
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        55
;  :arith-pivots            129
;  :conflicts               81
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   64
;  :datatype-splits         53
;  :decisions               167
;  :del-clause              545
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          3
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1227
;  :mk-clause               596
;  :num-allocs              146592
;  :num-checks              51
;  :propagations            403
;  :quant-instantiations    216
;  :rlimit-count            167954
;  :time                    0.00)
(pop) ; 15
(push) ; 15
; [else-branch: 30 | !(i2@26@03 < V@7@03)]
(assert (not (< i2@26@03 V@7@03)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (< i2@26@03 V@7@03)
  (and
    (< i2@26@03 V@7@03)
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
    (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 29 | !(0 <= i2@26@03)]
(assert (not (<= 0 i2@26@03)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (<= 0 i2@26@03)
  (and
    (<= 0 i2@26@03)
    (implies
      (< i2@26@03 V@7@03)
      (and
        (< i2@26@03 V@7@03)
        (not (= target@5@03 (as None<option<array>>  option<array>)))
        (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
        (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 28 | !(i1@25@03 < V@7@03)]
(assert (not (< i1@25@03 V@7@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (< i1@25@03 V@7@03)
  (and
    (< i1@25@03 V@7@03)
    (implies
      (<= 0 i2@26@03)
      (and
        (<= 0 i2@26@03)
        (implies
          (< i2@26@03 V@7@03)
          (and
            (< i2@26@03 V@7@03)
            (not (= target@5@03 (as None<option<array>>  option<array>)))
            (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
            (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))))))))
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 27 | !(0 <= i1@25@03)]
(assert (not (<= 0 i1@25@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (<= 0 i1@25@03)
  (and
    (<= 0 i1@25@03)
    (implies
      (< i1@25@03 V@7@03)
      (and
        (< i1@25@03 V@7@03)
        (implies
          (<= 0 i2@26@03)
          (and
            (<= 0 i2@26@03)
            (implies
              (< i2@26@03 V@7@03)
              (and
                (< i2@26@03 V@7@03)
                (not (= target@5@03 (as None<option<array>>  option<array>)))
                (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))))))))))
; Joined path conditions
(push) ; 8
; [then-branch: 31 | Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i1@25@03)) == Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i2@26@03)) && i2@26@03 < V@7@03 && 0 <= i2@26@03 && i1@25@03 < V@7@03 && 0 <= i1@25@03 | live]
; [else-branch: 31 | !(Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i1@25@03)) == Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i2@26@03)) && i2@26@03 < V@7@03 && 0 <= i2@26@03 && i1@25@03 < V@7@03 && 0 <= i1@25@03) | live]
(push) ; 9
; [then-branch: 31 | Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i1@25@03)) == Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i2@26@03)) && i2@26@03 < V@7@03 && 0 <= i2@26@03 && i1@25@03 < V@7@03 && 0 <= i1@25@03]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
          ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
        (< i2@26@03 V@7@03))
      (<= 0 i2@26@03))
    (< i1@25@03 V@7@03))
  (<= 0 i1@25@03)))
; [eval] i1 == i2
(pop) ; 9
(push) ; 9
; [else-branch: 31 | !(Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i1@25@03)) == Lookup(option$array$,sm@22@03,aloc((_, _), opt_get1(_, target@5@03), i2@26@03)) && i2@26@03 < V@7@03 && 0 <= i2@26@03 && i1@25@03 < V@7@03 && 0 <= i1@25@03)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
            ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
          (< i2@26@03 V@7@03))
        (<= 0 i2@26@03))
      (< i1@25@03 V@7@03))
    (<= 0 i1@25@03))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
            ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
          (< i2@26@03 V@7@03))
        (<= 0 i2@26@03))
      (< i1@25@03 V@7@03))
    (<= 0 i1@25@03))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
      ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
    (< i2@26@03 V@7@03)
    (<= 0 i2@26@03)
    (< i1@25@03 V@7@03)
    (<= 0 i1@25@03))))
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@26@03 Int)) (!
  (and
    (implies
      (<= 0 i1@25@03)
      (and
        (<= 0 i1@25@03)
        (implies
          (< i1@25@03 V@7@03)
          (and
            (< i1@25@03 V@7@03)
            (implies
              (<= 0 i2@26@03)
              (and
                (<= 0 i2@26@03)
                (implies
                  (< i2@26@03 V@7@03)
                  (and
                    (< i2@26@03 V@7@03)
                    (not (= target@5@03 (as None<option<array>>  option<array>)))
                    (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                    (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
              (< i2@26@03 V@7@03))
            (<= 0 i2@26@03))
          (< i1@25@03 V@7@03))
        (<= 0 i1@25@03))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
          ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
        (< i2@26@03 V@7@03)
        (<= 0 i2@26@03)
        (< i1@25@03 V@7@03)
        (<= 0 i1@25@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@25@03 Int)) (!
  (forall ((i2@26@03 Int)) (!
    (and
      (implies
        (<= 0 i1@25@03)
        (and
          (<= 0 i1@25@03)
          (implies
            (< i1@25@03 V@7@03)
            (and
              (< i1@25@03 V@7@03)
              (implies
                (<= 0 i2@26@03)
                (and
                  (<= 0 i2@26@03)
                  (implies
                    (< i2@26@03 V@7@03)
                    (and
                      (< i2@26@03 V@7@03)
                      (not
                        (= target@5@03 (as None<option<array>>  option<array>)))
                      (< i1@25@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                      (< i2@26@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                  ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
                (< i2@26@03 V@7@03))
              (<= 0 i2@26@03))
            (< i1@25@03 V@7@03))
          (<= 0 i1@25@03))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
            ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
          (< i2@26@03 V@7@03)
          (<= 0 i2@26@03)
          (< i1@25@03 V@7@03)
          (<= 0 i1@25@03))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@25@03 Int)) (!
    (forall ((i2@26@03 Int)) (!
      (and
        (implies
          (<= 0 i1@25@03)
          (and
            (<= 0 i1@25@03)
            (implies
              (< i1@25@03 V@7@03)
              (and
                (< i1@25@03 V@7@03)
                (implies
                  (<= 0 i2@26@03)
                  (and
                    (<= 0 i2@26@03)
                    (implies
                      (< i2@26@03 V@7@03)
                      (and
                        (< i2@26@03 V@7@03)
                        (not
                          (= target@5@03 (as None<option<array>>  option<array>)))
                        (<
                          i1@25@03
                          (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                        (<
                          i2@26@03
                          (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
                  (< i2@26@03 V@7@03))
                (<= 0 i2@26@03))
              (< i1@25@03 V@7@03))
            (<= 0 i1@25@03))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
              ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
            (< i2@26@03 V@7@03)
            (<= 0 i2@26@03)
            (< i1@25@03 V@7@03)
            (<= 0 i1@25@03))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@7@03)
  (forall ((i1@25@03 Int)) (!
    (forall ((i2@26@03 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
                  ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03)))
                (< i2@26@03 V@7@03))
              (<= 0 i2@26@03))
            (< i1@25@03 V@7@03))
          (<= 0 i1@25@03))
        (= i1@25@03 i2@26@03))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@26@03))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@25@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))
(declare-const unknown@27@03 Int)
(declare-const unknown1@28@03 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 32 | 0 <= unknown@27@03 | live]
; [else-branch: 32 | !(0 <= unknown@27@03) | live]
(push) ; 6
; [then-branch: 32 | 0 <= unknown@27@03]
(assert (<= 0 unknown@27@03))
; [eval] unknown < V
(push) ; 7
; [then-branch: 33 | unknown@27@03 < V@7@03 | live]
; [else-branch: 33 | !(unknown@27@03 < V@7@03) | live]
(push) ; 8
; [then-branch: 33 | unknown@27@03 < V@7@03]
(assert (< unknown@27@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 34 | 0 <= unknown1@28@03 | live]
; [else-branch: 34 | !(0 <= unknown1@28@03) | live]
(push) ; 10
; [then-branch: 34 | 0 <= unknown1@28@03]
(assert (<= 0 unknown1@28@03))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 34 | !(0 <= unknown1@28@03)]
(assert (not (<= 0 unknown1@28@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 33 | !(unknown@27@03 < V@7@03)]
(assert (not (< unknown@27@03 V@7@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 32 | !(0 <= unknown@27@03)]
(assert (not (<= 0 unknown@27@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@28@03 V@7@03) (<= 0 unknown1@28@03))
    (< unknown@27@03 V@7@03))
  (<= 0 unknown@27@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               653
;  :arith-add-rows          190
;  :arith-assert-diseq      15
;  :arith-assert-lower      440
;  :arith-assert-upper      269
;  :arith-bound-prop        20
;  :arith-conflicts         52
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         64
;  :arith-grobner           40
;  :arith-max-min           427
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        55
;  :arith-pivots            135
;  :conflicts               81
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   64
;  :datatype-splits         53
;  :decisions               167
;  :del-clause              605
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          3
;  :max-memory              4.30
;  :memory                  4.29
;  :mk-bool-var             1249
;  :mk-clause               620
;  :num-allocs              147844
;  :num-checks              52
;  :propagations            403
;  :quant-instantiations    216
;  :rlimit-count            170861)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@28@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               653
;  :arith-add-rows          190
;  :arith-assert-diseq      15
;  :arith-assert-lower      440
;  :arith-assert-upper      269
;  :arith-bound-prop        20
;  :arith-conflicts         52
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         64
;  :arith-grobner           40
;  :arith-max-min           427
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        55
;  :arith-pivots            135
;  :conflicts               81
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   64
;  :datatype-splits         53
;  :decisions               167
;  :del-clause              605
;  :final-checks            85
;  :interface-eqs           2
;  :max-generation          3
;  :max-memory              4.30
;  :memory                  4.29
;  :mk-bool-var             1249
;  :mk-clause               620
;  :num-allocs              147865
;  :num-checks              53
;  :propagations            403
;  :quant-instantiations    216
;  :rlimit-count            170892)
(assert (< unknown1@28@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@28@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03)))
(push) ; 5
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))
          V@7@03)
        (<=
          0
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))
          V@7@03)
        (<=
          0
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               760
;  :arith-add-rows          207
;  :arith-assert-diseq      17
;  :arith-assert-lower      478
;  :arith-assert-upper      297
;  :arith-bound-prop        24
;  :arith-conflicts         57
;  :arith-eq-adapter        101
;  :arith-fixed-eqs         74
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        70
;  :arith-pivots            152
;  :conflicts               92
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   69
;  :datatype-splits         63
;  :decisions               203
;  :del-clause              707
;  :final-checks            92
;  :interface-eqs           4
;  :max-generation          3
;  :max-memory              4.33
;  :memory                  4.31
;  :mk-bool-var             1422
;  :mk-clause               745
;  :num-allocs              148675
;  :num-checks              54
;  :propagations            479
;  :quant-instantiations    252
;  :rlimit-count            173967
;  :time                    0.00)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               760
;  :arith-add-rows          207
;  :arith-assert-diseq      17
;  :arith-assert-lower      478
;  :arith-assert-upper      297
;  :arith-bound-prop        24
;  :arith-conflicts         57
;  :arith-eq-adapter        101
;  :arith-fixed-eqs         74
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        70
;  :arith-pivots            152
;  :conflicts               93
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   69
;  :datatype-splits         63
;  :decisions               203
;  :del-clause              707
;  :final-checks            92
;  :interface-eqs           4
;  :max-generation          3
;  :max-memory              4.33
;  :memory                  4.31
;  :mk-bool-var             1422
;  :mk-clause               745
;  :num-allocs              148765
;  :num-checks              55
;  :propagations            479
;  :quant-instantiations    252
;  :rlimit-count            174062)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@27@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               764
;  :arith-add-rows          209
;  :arith-assert-diseq      17
;  :arith-assert-lower      480
;  :arith-assert-upper      297
;  :arith-bound-prop        26
;  :arith-conflicts         57
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         74
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        70
;  :arith-pivots            154
;  :conflicts               94
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   69
;  :datatype-splits         63
;  :decisions               203
;  :del-clause              713
;  :final-checks            92
;  :interface-eqs           4
;  :max-generation          3
;  :max-memory              4.33
;  :memory                  4.31
;  :mk-bool-var             1433
;  :mk-clause               751
;  :num-allocs              148964
;  :num-checks              56
;  :propagations            479
;  :quant-instantiations    259
;  :rlimit-count            174477)
(assert (<
  unknown@27@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@27@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))))))
(pop) ; 4
(declare-fun inv@29@03 ($Ref) Int)
(declare-fun inv@30@03 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@27@03 Int) (unknown1@28@03 Int)) (!
  (and
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< unknown1@28@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@27@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))) unknown@27@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@27@03 Int) (unknown11@28@03 Int) (unknown2@27@03 Int) (unknown12@28@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@28@03 V@7@03) (<= 0 unknown11@28@03))
          (< unknown1@27@03 V@7@03))
        (<= 0 unknown1@27@03))
      (and
        (and
          (and (< unknown12@28@03 V@7@03) (<= 0 unknown12@28@03))
          (< unknown2@27@03 V@7@03))
        (<= 0 unknown2@27@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown11@28@03))) unknown1@27@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown12@28@03))) unknown2@27@03)))
    (and (= unknown1@27@03 unknown2@27@03) (= unknown11@28@03 unknown12@28@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               808
;  :arith-add-rows          219
;  :arith-assert-diseq      17
;  :arith-assert-lower      492
;  :arith-assert-upper      300
;  :arith-bound-prop        27
;  :arith-conflicts         57
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         74
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        72
;  :arith-pivots            164
;  :conflicts               95
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   69
;  :datatype-splits         63
;  :decisions               203
;  :del-clause              817
;  :final-checks            92
;  :interface-eqs           4
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.40
;  :mk-bool-var             1588
;  :mk-clause               832
;  :num-allocs              150228
;  :num-checks              57
;  :propagations            512
;  :quant-instantiations    324
;  :rlimit-count            178345
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((unknown@27@03 Int) (unknown1@28@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@28@03 V@7@03) (<= 0 unknown1@28@03))
        (< unknown@27@03 V@7@03))
      (<= 0 unknown@27@03))
    (and
      (=
        (inv@29@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))) unknown@27@03))
        unknown@27@03)
      (=
        (inv@30@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))) unknown@27@03))
        unknown1@28@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))) unknown@27@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@03 r) V@7@03) (<= 0 (inv@30@03 r)))
        (< (inv@29@03 r) V@7@03))
      (<= 0 (inv@29@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) (inv@30@03 r)))) (inv@29@03 r))
      r))
  :pattern ((inv@29@03 r))
  :pattern ((inv@30@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@27@03 Int) (unknown1@28@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@28@03 V@7@03) (<= 0 unknown1@28@03))
        (< unknown@27@03 V@7@03))
      (<= 0 unknown@27@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))) unknown@27@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@28@03))) unknown@27@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@31@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@03 r) V@7@03) (<= 0 (inv@30@03 r)))
        (< (inv@29@03 r) V@7@03))
      (<= 0 (inv@29@03 r)))
    (=
      ($FVF.lookup_int (as sm@31@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@31@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r))
  :qid |qp.fvfValDef5|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@31@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef6|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@03 r) V@7@03) (<= 0 (inv@30@03 r)))
        (< (inv@29@03 r) V@7@03))
      (<= 0 (inv@29@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@31@03  $FVF<Int>) r) r))
  :pattern ((inv@29@03 r) (inv@30@03 r))
  )))
(declare-const unknown@32@03 Int)
(declare-const unknown1@33@03 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 35 | 0 <= unknown@32@03 | live]
; [else-branch: 35 | !(0 <= unknown@32@03) | live]
(push) ; 6
; [then-branch: 35 | 0 <= unknown@32@03]
(assert (<= 0 unknown@32@03))
; [eval] unknown < V
(push) ; 7
; [then-branch: 36 | unknown@32@03 < V@7@03 | live]
; [else-branch: 36 | !(unknown@32@03 < V@7@03) | live]
(push) ; 8
; [then-branch: 36 | unknown@32@03 < V@7@03]
(assert (< unknown@32@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 37 | 0 <= unknown1@33@03 | live]
; [else-branch: 37 | !(0 <= unknown1@33@03) | live]
(push) ; 10
; [then-branch: 37 | 0 <= unknown1@33@03]
(assert (<= 0 unknown1@33@03))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 37 | !(0 <= unknown1@33@03)]
(assert (not (<= 0 unknown1@33@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 36 | !(unknown@32@03 < V@7@03)]
(assert (not (< unknown@32@03 V@7@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 35 | !(0 <= unknown@32@03)]
(assert (not (<= 0 unknown@32@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@33@03 V@7@03) (<= 0 unknown1@33@03))
    (< unknown@32@03 V@7@03))
  (<= 0 unknown@32@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               808
;  :arith-add-rows          219
;  :arith-assert-diseq      17
;  :arith-assert-lower      498
;  :arith-assert-upper      300
;  :arith-bound-prop        27
;  :arith-conflicts         57
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         74
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        72
;  :arith-pivots            166
;  :conflicts               96
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   69
;  :datatype-splits         63
;  :decisions               203
;  :del-clause              817
;  :final-checks            92
;  :interface-eqs           4
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.40
;  :mk-bool-var             1600
;  :mk-clause               832
;  :num-allocs              151494
;  :num-checks              58
;  :propagations            512
;  :quant-instantiations    324
;  :rlimit-count            181512)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@33@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               808
;  :arith-add-rows          222
;  :arith-assert-diseq      17
;  :arith-assert-lower      498
;  :arith-assert-upper      301
;  :arith-bound-prop        27
;  :arith-conflicts         58
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         74
;  :arith-grobner           40
;  :arith-max-min           447
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        72
;  :arith-pivots            168
;  :conflicts               97
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   69
;  :datatype-splits         63
;  :decisions               203
;  :del-clause              817
;  :final-checks            92
;  :interface-eqs           4
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.40
;  :mk-bool-var             1601
;  :mk-clause               832
;  :num-allocs              151638
;  :num-checks              59
;  :propagations            512
;  :quant-instantiations    324
;  :rlimit-count            181706)
(assert (< unknown1@33@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@33@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03)))
(push) ; 5
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))
          V@7@03)
        (<=
          0
          (inv@21@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@20@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))
          V@7@03)
        (<=
          0
          (inv@13@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@12@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               898
;  :arith-add-rows          242
;  :arith-assert-diseq      17
;  :arith-assert-lower      526
;  :arith-assert-upper      320
;  :arith-bound-prop        27
;  :arith-conflicts         63
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         84
;  :arith-grobner           40
;  :arith-max-min           456
;  :arith-nonlinear-bounds  44
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        84
;  :arith-pivots            181
;  :conflicts               106
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   71
;  :datatype-splits         67
;  :decisions               226
;  :del-clause              890
;  :final-checks            95
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1733
;  :mk-clause               931
;  :num-allocs              152312
;  :num-checks              60
;  :propagations            575
;  :quant-instantiations    351
;  :rlimit-count            184375
;  :time                    0.00)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               941
;  :arith-add-rows          249
;  :arith-assert-diseq      17
;  :arith-assert-lower      534
;  :arith-assert-upper      331
;  :arith-bound-prop        27
;  :arith-conflicts         66
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         89
;  :arith-grobner           40
;  :arith-max-min           465
;  :arith-nonlinear-bounds  46
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        88
;  :arith-pivots            185
;  :conflicts               112
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   73
;  :datatype-splits         71
;  :decisions               240
;  :del-clause              910
;  :final-checks            98
;  :interface-eqs           6
;  :max-generation          3
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1762
;  :mk-clause               951
;  :num-allocs              152490
;  :num-checks              61
;  :propagations            587
;  :quant-instantiations    353
;  :rlimit-count            185080)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@32@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               999
;  :arith-add-rows          263
;  :arith-assert-diseq      17
;  :arith-assert-lower      546
;  :arith-assert-upper      344
;  :arith-bound-prop        27
;  :arith-conflicts         70
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         95
;  :arith-grobner           40
;  :arith-max-min           474
;  :arith-nonlinear-bounds  48
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        95
;  :arith-pivots            193
;  :conflicts               119
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 83
;  :datatype-occurs-check   75
;  :datatype-splits         75
;  :decisions               255
;  :del-clause              931
;  :final-checks            101
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1808
;  :mk-clause               972
;  :num-allocs              152791
;  :num-checks              62
;  :propagations            599
;  :quant-instantiations    364
;  :rlimit-count            186268)
(assert (<
  unknown@32@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@32@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))))))
(pop) ; 4
(declare-fun inv@34@03 ($Ref) Int)
(declare-fun inv@35@03 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@32@03 Int) (unknown1@33@03 Int)) (!
  (and
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< unknown1@33@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@32@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))) unknown@32@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@32@03 Int) (unknown11@33@03 Int) (unknown2@32@03 Int) (unknown12@33@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@33@03 V@7@03) (<= 0 unknown11@33@03))
          (< unknown1@32@03 V@7@03))
        (<= 0 unknown1@32@03))
      (and
        (and
          (and (< unknown12@33@03 V@7@03) (<= 0 unknown12@33@03))
          (< unknown2@32@03 V@7@03))
        (<= 0 unknown2@32@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown11@33@03))) unknown1@32@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown12@33@03))) unknown2@32@03)))
    (and (= unknown1@32@03 unknown2@32@03) (= unknown11@33@03 unknown12@33@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1101
;  :arith-add-rows          346
;  :arith-assert-diseq      19
;  :arith-assert-lower      582
;  :arith-assert-upper      366
;  :arith-bound-prop        33
;  :arith-conflicts         72
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           40
;  :arith-max-min           492
;  :arith-nonlinear-bounds  52
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        102
;  :arith-pivots            217
;  :conflicts               124
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 88
;  :datatype-occurs-check   77
;  :datatype-splits         79
;  :decisions               272
;  :del-clause              1089
;  :final-checks            104
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.48
;  :memory                  4.47
;  :mk-bool-var             2011
;  :mk-clause               1104
;  :num-allocs              154234
;  :num-checks              63
;  :propagations            676
;  :quant-instantiations    433
;  :rlimit-count            192529
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((unknown@32@03 Int) (unknown1@33@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@33@03 V@7@03) (<= 0 unknown1@33@03))
        (< unknown@32@03 V@7@03))
      (<= 0 unknown@32@03))
    (and
      (=
        (inv@34@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))) unknown@32@03))
        unknown@32@03)
      (=
        (inv@35@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))) unknown@32@03))
        unknown1@33@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))) unknown@32@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@35@03 r) V@7@03) (<= 0 (inv@35@03 r)))
        (< (inv@34@03 r) V@7@03))
      (<= 0 (inv@34@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) (inv@35@03 r)))) (inv@34@03 r))
      r))
  :pattern ((inv@34@03 r))
  :pattern ((inv@35@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@32@03 Int) (unknown1@33@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@33@03 V@7@03) (<= 0 unknown1@33@03))
        (< unknown@32@03 V@7@03))
      (<= 0 unknown@32@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))) unknown@32@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@33@03))) unknown@32@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@36@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@35@03 r) V@7@03) (<= 0 (inv@35@03 r)))
        (< (inv@34@03 r) V@7@03))
      (<= 0 (inv@34@03 r)))
    (=
      ($FVF.lookup_int (as sm@36@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@36@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r))
  :qid |qp.fvfValDef7|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@03 r) V@7@03) (<= 0 (inv@30@03 r)))
        (< (inv@29@03 r) V@7@03))
      (<= 0 (inv@29@03 r)))
    (=
      ($FVF.lookup_int (as sm@36@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@36@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r))
  :qid |qp.fvfValDef8|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@36@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef9|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@35@03 r) V@7@03) (<= 0 (inv@35@03 r)))
        (< (inv@34@03 r) V@7@03))
      (<= 0 (inv@34@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@36@03  $FVF<Int>) r) r))
  :pattern ((inv@34@03 r) (inv@35@03 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 4
(declare-const $t@37@03 $Snap)
(assert (= $t@37@03 ($Snap.combine ($Snap.first $t@37@03) ($Snap.second $t@37@03))))
(assert (= ($Snap.first $t@37@03) $Snap.unit))
; [eval] exc == null
(assert (= exc@8@03 $Ref.null))
(assert (=
  ($Snap.second $t@37@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@37@03))
    ($Snap.second ($Snap.second $t@37@03)))))
(assert (= ($Snap.first ($Snap.second $t@37@03)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 38 | exc@8@03 == Null | live]
; [else-branch: 38 | exc@8@03 != Null | live]
(push) ; 6
; [then-branch: 38 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 38 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1142
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      604
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            218
;  :conflicts               125
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 97
;  :datatype-occurs-check   84
;  :datatype-splits         84
;  :decisions               282
;  :del-clause              1091
;  :final-checks            111
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2028
;  :mk-clause               1104
;  :num-allocs              156815
;  :num-checks              65
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            197928)
(push) ; 6
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1142
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      604
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            218
;  :conflicts               125
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 97
;  :datatype-occurs-check   84
;  :datatype-splits         84
;  :decisions               282
;  :del-clause              1091
;  :final-checks            111
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2028
;  :mk-clause               1104
;  :num-allocs              156833
;  :num-checks              66
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            197945)
; [then-branch: 39 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 39 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 6
; [then-branch: 39 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (not (= source@6@03 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@37@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@37@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@37@03))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 40 | exc@8@03 == Null | live]
; [else-branch: 40 | exc@8@03 != Null | live]
(push) ; 6
; [then-branch: 40 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 40 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1164
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      604
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            218
;  :conflicts               125
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 102
;  :datatype-occurs-check   87
;  :datatype-splits         85
;  :decisions               287
;  :del-clause              1091
;  :final-checks            113
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2031
;  :mk-clause               1104
;  :num-allocs              157478
;  :num-checks              67
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            198682)
(push) ; 6
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1164
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      604
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            218
;  :conflicts               125
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 102
;  :datatype-occurs-check   87
;  :datatype-splits         85
;  :decisions               287
;  :del-clause              1091
;  :final-checks            113
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2031
;  :mk-clause               1104
;  :num-allocs              157496
;  :num-checks              68
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            198699)
; [then-branch: 41 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 41 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 6
; [then-branch: 41 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1164
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      604
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            218
;  :conflicts               125
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 102
;  :datatype-occurs-check   87
;  :datatype-splits         85
;  :decisions               287
;  :del-clause              1091
;  :final-checks            113
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2031
;  :mk-clause               1104
;  :num-allocs              157521
;  :num-checks              69
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            198729)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 7
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (not (= source@6@03 (as None<option<array>>  option<array>))))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit source@6@03)) V@7@03)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@37@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 42 | exc@8@03 == Null | live]
; [else-branch: 42 | exc@8@03 != Null | live]
(push) ; 6
; [then-branch: 42 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 42 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 5
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      604
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            218
;  :conflicts               125
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   90
;  :datatype-splits         87
;  :decisions               293
;  :del-clause              1091
;  :final-checks            115
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2034
;  :mk-clause               1104
;  :num-allocs              158178
;  :num-checks              70
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            199460)
(push) ; 5
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      604
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            218
;  :conflicts               125
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   90
;  :datatype-splits         87
;  :decisions               293
;  :del-clause              1091
;  :final-checks            115
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2034
;  :mk-clause               1104
;  :num-allocs              158196
;  :num-checks              71
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            199477)
; [then-branch: 43 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 43 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 5
; [then-branch: 43 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
(declare-const i1@38@03 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 44 | 0 <= i1@38@03 | live]
; [else-branch: 44 | !(0 <= i1@38@03) | live]
(push) ; 8
; [then-branch: 44 | 0 <= i1@38@03]
(assert (<= 0 i1@38@03))
; [eval] i1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 44 | !(0 <= i1@38@03)]
(assert (not (<= 0 i1@38@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< i1@38@03 V@7@03) (<= 0 i1@38@03)))
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      606
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            219
;  :conflicts               125
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   90
;  :datatype-splits         87
;  :decisions               293
;  :del-clause              1091
;  :final-checks            115
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2036
;  :mk-clause               1104
;  :num-allocs              158291
;  :num-checks              72
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            199661)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 7
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 7
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 8
(assert (not (< i1@38@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      606
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            219
;  :conflicts               125
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   90
;  :datatype-splits         87
;  :decisions               293
;  :del-clause              1091
;  :final-checks            115
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2036
;  :mk-clause               1104
;  :num-allocs              158312
;  :num-checks              73
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            199692)
(assert (< i1@38@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 7
; Joined path conditions
(assert (< i1@38@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 7
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 8
(assert (not (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-add-rows          348
;  :arith-assert-diseq      19
;  :arith-assert-lower      606
;  :arith-assert-upper      380
;  :arith-bound-prop        33
;  :arith-conflicts         73
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           530
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            219
;  :conflicts               126
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   90
;  :datatype-splits         87
;  :decisions               293
;  :del-clause              1091
;  :final-checks            115
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2036
;  :mk-clause               1104
;  :num-allocs              158456
;  :num-checks              74
;  :propagations            679
;  :quant-instantiations    433
;  :rlimit-count            199804)
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(pop) ; 7
; Joined path conditions
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(declare-const $k@39@03 $Perm)
(assert ($Perm.isReadVar $k@39@03 $Perm.Write))
(pop) ; 6
(declare-fun inv@40@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@39@03 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@38@03 Int)) (!
  (and
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@38@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@38@03))
  :qid |option$array$-aux|)))
(push) ; 6
(assert (not (forall ((i1@38@03 Int)) (!
  (implies
    (and (< i1@38@03 V@7@03) (<= 0 i1@38@03))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@39@03)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@39@03))))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1199
;  :arith-add-rows          348
;  :arith-assert-diseq      21
;  :arith-assert-lower      619
;  :arith-assert-upper      387
;  :arith-bound-prop        33
;  :arith-conflicts         74
;  :arith-eq-adapter        134
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           545
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            222
;  :conflicts               127
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   90
;  :datatype-splits         87
;  :decisions               297
;  :del-clause              1094
;  :final-checks            116
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.49
;  :memory                  4.48
;  :mk-bool-var             2046
;  :mk-clause               1109
;  :num-allocs              159090
;  :num-checks              75
;  :propagations            681
;  :quant-instantiations    433
;  :rlimit-count            200727)
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((i11@38@03 Int) (i12@38@03 Int)) (!
  (implies
    (and
      (and
        (and (< i11@38@03 V@7@03) (<= 0 i11@38@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@39@03)))
      (and
        (and (< i12@38@03 V@7@03) (<= 0 i12@38@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@39@03)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i11@38@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i12@38@03)))
    (= i11@38@03 i12@38@03))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1218
;  :arith-add-rows          350
;  :arith-assert-diseq      23
;  :arith-assert-lower      626
;  :arith-assert-upper      387
;  :arith-bound-prop        33
;  :arith-conflicts         74
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           545
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        103
;  :arith-pivots            222
;  :conflicts               128
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 112
;  :datatype-occurs-check   90
;  :datatype-splits         87
;  :decisions               297
;  :del-clause              1124
;  :final-checks            116
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.50
;  :memory                  4.48
;  :mk-bool-var             2094
;  :mk-clause               1139
;  :num-allocs              159673
;  :num-checks              76
;  :propagations            695
;  :quant-instantiations    458
;  :rlimit-count            202365)
; Definitional axioms for inverse functions
(assert (forall ((i1@38@03 Int)) (!
  (implies
    (and
      (and (< i1@38@03 V@7@03) (<= 0 i1@38@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@39@03)))
    (=
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@38@03))
      i1@38@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@38@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@40@03 r) V@7@03) (<= 0 (inv@40@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@39@03)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) (inv@40@03 r))
      r))
  :pattern ((inv@40@03 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@38@03 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@38@03))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@38@03 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@38@03))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@38@03 Int)) (!
  (implies
    (and
      (and (< i1@38@03 V@7@03) (<= 0 i1@38@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@39@03)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@38@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@38@03))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@41@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@40@03 r) V@7@03) (<= 0 (inv@40@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@39@03))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@03))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@03))))) r))
  :qid |qp.fvfValDef10|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@03))))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef11|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@40@03 r) V@7@03) (<= 0 (inv@40@03 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) r) r))
  :pattern ((inv@40@03 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 45 | exc@8@03 == Null | live]
; [else-branch: 45 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 45 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 45 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-add-rows          350
;  :arith-assert-diseq      23
;  :arith-assert-lower      646
;  :arith-assert-upper      399
;  :arith-bound-prop        33
;  :arith-conflicts         74
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           577
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        103
;  :arith-pivots            222
;  :conflicts               128
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 118
;  :datatype-occurs-check   93
;  :datatype-splits         89
;  :decisions               303
;  :del-clause              1124
;  :final-checks            120
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.51
;  :memory                  4.49
;  :mk-bool-var             2106
;  :mk-clause               1139
;  :num-allocs              161647
;  :num-checks              77
;  :propagations            695
;  :quant-instantiations    458
;  :rlimit-count            206130)
(push) ; 7
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-add-rows          350
;  :arith-assert-diseq      23
;  :arith-assert-lower      646
;  :arith-assert-upper      399
;  :arith-bound-prop        33
;  :arith-conflicts         74
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           577
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        103
;  :arith-pivots            222
;  :conflicts               128
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 118
;  :datatype-occurs-check   93
;  :datatype-splits         89
;  :decisions               303
;  :del-clause              1124
;  :final-checks            120
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.51
;  :memory                  4.49
;  :mk-bool-var             2106
;  :mk-clause               1139
;  :num-allocs              161665
;  :num-checks              78
;  :propagations            695
;  :quant-instantiations    458
;  :rlimit-count            206147)
; [then-branch: 46 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 46 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 7
; [then-branch: 46 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
(declare-const i1@42@03 Int)
(push) ; 8
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 9
; [then-branch: 47 | 0 <= i1@42@03 | live]
; [else-branch: 47 | !(0 <= i1@42@03) | live]
(push) ; 10
; [then-branch: 47 | 0 <= i1@42@03]
(assert (<= 0 i1@42@03))
; [eval] i1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 47 | !(0 <= i1@42@03)]
(assert (not (<= 0 i1@42@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 48 | i1@42@03 < V@7@03 && 0 <= i1@42@03 | live]
; [else-branch: 48 | !(i1@42@03 < V@7@03 && 0 <= i1@42@03) | live]
(push) ; 10
; [then-branch: 48 | i1@42@03 < V@7@03 && 0 <= i1@42@03]
(assert (and (< i1@42@03 V@7@03) (<= 0 i1@42@03)))
; [eval] aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-add-rows          350
;  :arith-assert-diseq      23
;  :arith-assert-lower      648
;  :arith-assert-upper      399
;  :arith-bound-prop        33
;  :arith-conflicts         74
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           577
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        103
;  :arith-pivots            222
;  :conflicts               128
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 118
;  :datatype-occurs-check   93
;  :datatype-splits         89
;  :decisions               303
;  :del-clause              1124
;  :final-checks            120
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.51
;  :memory                  4.49
;  :mk-bool-var             2108
;  :mk-clause               1139
;  :num-allocs              161760
;  :num-checks              79
;  :propagations            695
;  :quant-instantiations    458
;  :rlimit-count            206337)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 12
(assert (not (< i1@42@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1245
;  :arith-add-rows          350
;  :arith-assert-diseq      23
;  :arith-assert-lower      648
;  :arith-assert-upper      399
;  :arith-bound-prop        33
;  :arith-conflicts         74
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           577
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        103
;  :arith-pivots            222
;  :conflicts               128
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 118
;  :datatype-occurs-check   93
;  :datatype-splits         89
;  :decisions               303
;  :del-clause              1124
;  :final-checks            120
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.51
;  :memory                  4.49
;  :mk-bool-var             2108
;  :mk-clause               1139
;  :num-allocs              161781
;  :num-checks              80
;  :propagations            695
;  :quant-instantiations    458
;  :rlimit-count            206368)
(assert (< i1@42@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 11
; Joined path conditions
(assert (< i1@42@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))
      V@7@03)
    (<=
      0
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1331
;  :arith-add-rows          374
;  :arith-assert-diseq      23
;  :arith-assert-lower      670
;  :arith-assert-upper      421
;  :arith-bound-prop        35
;  :arith-conflicts         78
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         114
;  :arith-grobner           50
;  :arith-max-min           603
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        114
;  :arith-pivots            228
;  :conflicts               137
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 129
;  :datatype-occurs-check   99
;  :datatype-splits         96
;  :decisions               327
;  :del-clause              1173
;  :final-checks            127
;  :interface-eqs           9
;  :max-generation          4
;  :max-memory              4.57
;  :memory                  4.55
;  :mk-bool-var             2238
;  :mk-clause               1214
;  :num-allocs              162552
;  :num-checks              81
;  :propagations            730
;  :quant-instantiations    488
;  :rlimit-count            209066
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 10
(push) ; 10
; [else-branch: 48 | !(i1@42@03 < V@7@03 && 0 <= i1@42@03)]
(assert (not (and (< i1@42@03 V@7@03) (<= 0 i1@42@03))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i1@42@03 V@7@03) (<= 0 i1@42@03))
  (and
    (< i1@42@03 V@7@03)
    (<= 0 i1@42@03)
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@42@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@42@03 Int)) (!
  (implies
    (and (< i1@42@03 V@7@03) (<= 0 i1@42@03))
    (and
      (< i1@42@03 V@7@03)
      (<= 0 i1@42@03)
      (not (= source@6@03 (as None<option<array>>  option<array>)))
      (< i1@42@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (forall ((i1@42@03 Int)) (!
      (implies
        (and (< i1@42@03 V@7@03) (<= 0 i1@42@03))
        (and
          (< i1@42@03 V@7@03)
          (<= 0 i1@42@03)
          (not (= source@6@03 (as None<option<array>>  option<array>)))
          (< i1@42@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (forall ((i1@42@03 Int)) (!
    (implies
      (and (< i1@42@03 V@7@03) (<= 0 i1@42@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@42@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 49 | exc@8@03 == Null | live]
; [else-branch: 49 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 49 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 49 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1359
;  :arith-add-rows          374
;  :arith-assert-diseq      23
;  :arith-assert-lower      689
;  :arith-assert-upper      433
;  :arith-bound-prop        35
;  :arith-conflicts         78
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           636
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        114
;  :arith-pivots            230
;  :conflicts               137
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 135
;  :datatype-occurs-check   102
;  :datatype-splits         98
;  :decisions               333
;  :del-clause              1199
;  :final-checks            131
;  :interface-eqs           9
;  :max-generation          4
;  :max-memory              4.57
;  :memory                  4.55
;  :mk-bool-var             2244
;  :mk-clause               1214
;  :num-allocs              163832
;  :num-checks              82
;  :propagations            730
;  :quant-instantiations    488
;  :rlimit-count            211243)
(push) ; 7
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1359
;  :arith-add-rows          374
;  :arith-assert-diseq      23
;  :arith-assert-lower      689
;  :arith-assert-upper      433
;  :arith-bound-prop        35
;  :arith-conflicts         78
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           636
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        114
;  :arith-pivots            230
;  :conflicts               137
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 135
;  :datatype-occurs-check   102
;  :datatype-splits         98
;  :decisions               333
;  :del-clause              1199
;  :final-checks            131
;  :interface-eqs           9
;  :max-generation          4
;  :max-memory              4.57
;  :memory                  4.55
;  :mk-bool-var             2244
;  :mk-clause               1214
;  :num-allocs              163850
;  :num-checks              83
;  :propagations            730
;  :quant-instantiations    488
;  :rlimit-count            211260)
; [then-branch: 50 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 50 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 7
; [then-branch: 50 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
(declare-const i1@43@03 Int)
(push) ; 8
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 9
; [then-branch: 51 | 0 <= i1@43@03 | live]
; [else-branch: 51 | !(0 <= i1@43@03) | live]
(push) ; 10
; [then-branch: 51 | 0 <= i1@43@03]
(assert (<= 0 i1@43@03))
; [eval] i1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 51 | !(0 <= i1@43@03)]
(assert (not (<= 0 i1@43@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 52 | i1@43@03 < V@7@03 && 0 <= i1@43@03 | live]
; [else-branch: 52 | !(i1@43@03 < V@7@03 && 0 <= i1@43@03) | live]
(push) ; 10
; [then-branch: 52 | i1@43@03 < V@7@03 && 0 <= i1@43@03]
(assert (and (< i1@43@03 V@7@03) (<= 0 i1@43@03)))
; [eval] alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(source), i1).option$array$))
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1359
;  :arith-add-rows          374
;  :arith-assert-diseq      23
;  :arith-assert-lower      691
;  :arith-assert-upper      433
;  :arith-bound-prop        35
;  :arith-conflicts         78
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           636
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        114
;  :arith-pivots            230
;  :conflicts               137
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 135
;  :datatype-occurs-check   102
;  :datatype-splits         98
;  :decisions               333
;  :del-clause              1199
;  :final-checks            131
;  :interface-eqs           9
;  :max-generation          4
;  :max-memory              4.57
;  :memory                  4.55
;  :mk-bool-var             2246
;  :mk-clause               1214
;  :num-allocs              163945
;  :num-checks              84
;  :propagations            730
;  :quant-instantiations    488
;  :rlimit-count            211450)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 12
(assert (not (< i1@43@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1359
;  :arith-add-rows          374
;  :arith-assert-diseq      23
;  :arith-assert-lower      691
;  :arith-assert-upper      433
;  :arith-bound-prop        35
;  :arith-conflicts         78
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           636
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        114
;  :arith-pivots            230
;  :conflicts               137
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 135
;  :datatype-occurs-check   102
;  :datatype-splits         98
;  :decisions               333
;  :del-clause              1199
;  :final-checks            131
;  :interface-eqs           9
;  :max-generation          4
;  :max-memory              4.57
;  :memory                  4.55
;  :mk-bool-var             2246
;  :mk-clause               1214
;  :num-allocs              163966
;  :num-checks              85
;  :propagations            730
;  :quant-instantiations    488
;  :rlimit-count            211481)
(assert (< i1@43@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 11
; Joined path conditions
(assert (< i1@43@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
      V@7@03)
    (<=
      0
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1431
;  :arith-add-rows          410
;  :arith-assert-diseq      23
;  :arith-assert-lower      713
;  :arith-assert-upper      454
;  :arith-bound-prop        37
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         121
;  :arith-grobner           55
;  :arith-max-min           662
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        119
;  :arith-pivots            236
;  :conflicts               148
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   106
;  :datatype-splits         103
;  :decisions               359
;  :del-clause              1254
;  :final-checks            136
;  :interface-eqs           10
;  :max-generation          4
;  :max-memory              4.57
;  :memory                  4.55
;  :mk-bool-var             2388
;  :mk-clause               1295
;  :num-allocs              164697
;  :num-checks              86
;  :propagations            760
;  :quant-instantiations    520
;  :rlimit-count            214161
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 12
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1431
;  :arith-add-rows          410
;  :arith-assert-diseq      23
;  :arith-assert-lower      713
;  :arith-assert-upper      454
;  :arith-bound-prop        37
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         121
;  :arith-grobner           55
;  :arith-max-min           662
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        119
;  :arith-pivots            236
;  :conflicts               149
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 144
;  :datatype-occurs-check   106
;  :datatype-splits         103
;  :decisions               359
;  :del-clause              1254
;  :final-checks            136
;  :interface-eqs           10
;  :max-generation          4
;  :max-memory              4.57
;  :memory                  4.55
;  :mk-bool-var             2388
;  :mk-clause               1295
;  :num-allocs              164788
;  :num-checks              87
;  :propagations            760
;  :quant-instantiations    520
;  :rlimit-count            214256)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
    (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
    (as None<option<array>>  option<array>))))
(pop) ; 10
(push) ; 10
; [else-branch: 52 | !(i1@43@03 < V@7@03 && 0 <= i1@43@03)]
(assert (not (and (< i1@43@03 V@7@03) (<= 0 i1@43@03))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i1@43@03 V@7@03) (<= 0 i1@43@03))
  (and
    (< i1@43@03 V@7@03)
    (<= 0 i1@43@03)
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@43@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@43@03 Int)) (!
  (implies
    (and (< i1@43@03 V@7@03) (<= 0 i1@43@03))
    (and
      (< i1@43@03 V@7@03)
      (<= 0 i1@43@03)
      (not (= source@6@03 (as None<option<array>>  option<array>)))
      (< i1@43@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (forall ((i1@43@03 Int)) (!
      (implies
        (and (< i1@43@03 V@7@03) (<= 0 i1@43@03))
        (and
          (< i1@43@03 V@7@03)
          (<= 0 i1@43@03)
          (not (= source@6@03 (as None<option<array>>  option<array>)))
          (< i1@43@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (forall ((i1@43@03 Int)) (!
    (implies
      (and (< i1@43@03 V@7@03) (<= 0 i1@43@03))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03))))
        V@7@03))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@43@03)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 53 | exc@8@03 == Null | live]
; [else-branch: 53 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 53 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 53 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1460
;  :arith-add-rows          411
;  :arith-assert-diseq      23
;  :arith-assert-lower      732
;  :arith-assert-upper      466
;  :arith-bound-prop        37
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         121
;  :arith-grobner           60
;  :arith-max-min           695
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        119
;  :arith-pivots            239
;  :conflicts               149
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   109
;  :datatype-splits         105
;  :decisions               365
;  :del-clause              1280
;  :final-checks            140
;  :interface-eqs           10
;  :max-generation          4
;  :max-memory              4.58
;  :memory                  4.56
;  :mk-bool-var             2394
;  :mk-clause               1295
;  :num-allocs              166087
;  :num-checks              88
;  :propagations            760
;  :quant-instantiations    520
;  :rlimit-count            216553)
(push) ; 7
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1460
;  :arith-add-rows          411
;  :arith-assert-diseq      23
;  :arith-assert-lower      732
;  :arith-assert-upper      466
;  :arith-bound-prop        37
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         121
;  :arith-grobner           60
;  :arith-max-min           695
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        119
;  :arith-pivots            239
;  :conflicts               149
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   109
;  :datatype-splits         105
;  :decisions               365
;  :del-clause              1280
;  :final-checks            140
;  :interface-eqs           10
;  :max-generation          4
;  :max-memory              4.58
;  :memory                  4.56
;  :mk-bool-var             2394
;  :mk-clause               1295
;  :num-allocs              166105
;  :num-checks              89
;  :propagations            760
;  :quant-instantiations    520
;  :rlimit-count            216570)
; [then-branch: 54 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 54 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 7
; [then-branch: 54 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
(declare-const i1@44@03 Int)
(push) ; 8
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2)
(declare-const i2@45@03 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 55 | 0 <= i1@44@03 | live]
; [else-branch: 55 | !(0 <= i1@44@03) | live]
(push) ; 11
; [then-branch: 55 | 0 <= i1@44@03]
(assert (<= 0 i1@44@03))
; [eval] i1 < V
(push) ; 12
; [then-branch: 56 | i1@44@03 < V@7@03 | live]
; [else-branch: 56 | !(i1@44@03 < V@7@03) | live]
(push) ; 13
; [then-branch: 56 | i1@44@03 < V@7@03]
(assert (< i1@44@03 V@7@03))
; [eval] 0 <= i2
(push) ; 14
; [then-branch: 57 | 0 <= i2@45@03 | live]
; [else-branch: 57 | !(0 <= i2@45@03) | live]
(push) ; 15
; [then-branch: 57 | 0 <= i2@45@03]
(assert (<= 0 i2@45@03))
; [eval] i2 < V
(push) ; 16
; [then-branch: 58 | i2@45@03 < V@7@03 | live]
; [else-branch: 58 | !(i2@45@03 < V@7@03) | live]
(push) ; 17
; [then-branch: 58 | i2@45@03 < V@7@03]
(assert (< i2@45@03 V@7@03))
; [eval] aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 18
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 19
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1460
;  :arith-add-rows          411
;  :arith-assert-diseq      23
;  :arith-assert-lower      736
;  :arith-assert-upper      466
;  :arith-bound-prop        37
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         121
;  :arith-grobner           60
;  :arith-max-min           695
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        119
;  :arith-pivots            241
;  :conflicts               149
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   109
;  :datatype-splits         105
;  :decisions               365
;  :del-clause              1280
;  :final-checks            140
;  :interface-eqs           10
;  :max-generation          4
;  :max-memory              4.58
;  :memory                  4.56
;  :mk-bool-var             2398
;  :mk-clause               1295
;  :num-allocs              166383
;  :num-checks              90
;  :propagations            760
;  :quant-instantiations    520
;  :rlimit-count            216914)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 18
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 18
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 19
(assert (not (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1460
;  :arith-add-rows          411
;  :arith-assert-diseq      23
;  :arith-assert-lower      736
;  :arith-assert-upper      466
;  :arith-bound-prop        37
;  :arith-conflicts         82
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         121
;  :arith-grobner           60
;  :arith-max-min           695
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        119
;  :arith-pivots            241
;  :conflicts               149
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 150
;  :datatype-occurs-check   109
;  :datatype-splits         105
;  :decisions               365
;  :del-clause              1280
;  :final-checks            140
;  :interface-eqs           10
;  :max-generation          4
;  :max-memory              4.58
;  :memory                  4.56
;  :mk-bool-var             2398
;  :mk-clause               1295
;  :num-allocs              166404
;  :num-checks              91
;  :propagations            760
;  :quant-instantiations    520
;  :rlimit-count            216945)
(assert (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 18
; Joined path conditions
(assert (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
      V@7@03)
    (<=
      0
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1538
;  :arith-add-rows          438
;  :arith-assert-diseq      23
;  :arith-assert-lower      758
;  :arith-assert-upper      487
;  :arith-bound-prop        39
;  :arith-conflicts         86
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         128
;  :arith-grobner           60
;  :arith-max-min           721
;  :arith-nonlinear-bounds  70
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        124
;  :arith-pivots            247
;  :conflicts               158
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   113
;  :datatype-splits         110
;  :decisions               388
;  :del-clause              1327
;  :final-checks            145
;  :interface-eqs           11
;  :max-generation          4
;  :max-memory              4.61
;  :memory                  4.60
;  :mk-bool-var             2528
;  :mk-clause               1368
;  :num-allocs              167144
;  :num-checks              92
;  :propagations            793
;  :quant-instantiations    552
;  :rlimit-count            219525
;  :time                    0.00)
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
(push) ; 19
(assert (not (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1538
;  :arith-add-rows          438
;  :arith-assert-diseq      23
;  :arith-assert-lower      758
;  :arith-assert-upper      487
;  :arith-bound-prop        39
;  :arith-conflicts         86
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         128
;  :arith-grobner           60
;  :arith-max-min           721
;  :arith-nonlinear-bounds  70
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        124
;  :arith-pivots            247
;  :conflicts               158
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   113
;  :datatype-splits         110
;  :decisions               388
;  :del-clause              1327
;  :final-checks            145
;  :interface-eqs           11
;  :max-generation          4
;  :max-memory              4.61
;  :memory                  4.60
;  :mk-bool-var             2528
;  :mk-clause               1368
;  :num-allocs              167171
;  :num-checks              93
;  :propagations            793
;  :quant-instantiations    552
;  :rlimit-count            219555)
(assert (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 18
; Joined path conditions
(assert (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))
      V@7@03)
    (<=
      0
      (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1672
;  :arith-add-rows          547
;  :arith-assert-diseq      29
;  :arith-assert-lower      800
;  :arith-assert-upper      525
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           60
;  :arith-max-min           769
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        135
;  :arith-pivots            264
;  :conflicts               169
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 169
;  :datatype-occurs-check   119
;  :datatype-splits         116
;  :decisions               424
;  :del-clause              1424
;  :final-checks            152
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2725
;  :mk-clause               1503
;  :num-allocs              168185
;  :num-checks              94
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            224486
;  :time                    0.00)
(pop) ; 17
(push) ; 17
; [else-branch: 58 | !(i2@45@03 < V@7@03)]
(assert (not (< i2@45@03 V@7@03)))
(pop) ; 17
(pop) ; 16
; Joined path conditions
(assert (implies
  (< i2@45@03 V@7@03)
  (and
    (< i2@45@03 V@7@03)
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
    (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))))
; Joined path conditions
(pop) ; 15
(push) ; 15
; [else-branch: 57 | !(0 <= i2@45@03)]
(assert (not (<= 0 i2@45@03)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (<= 0 i2@45@03)
  (and
    (<= 0 i2@45@03)
    (implies
      (< i2@45@03 V@7@03)
      (and
        (< i2@45@03 V@7@03)
        (not (= source@6@03 (as None<option<array>>  option<array>)))
        (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
        (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 56 | !(i1@44@03 < V@7@03)]
(assert (not (< i1@44@03 V@7@03)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (< i1@44@03 V@7@03)
  (and
    (< i1@44@03 V@7@03)
    (implies
      (<= 0 i2@45@03)
      (and
        (<= 0 i2@45@03)
        (implies
          (< i2@45@03 V@7@03)
          (and
            (< i2@45@03 V@7@03)
            (not (= source@6@03 (as None<option<array>>  option<array>)))
            (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
            (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 55 | !(0 <= i1@44@03)]
(assert (not (<= 0 i1@44@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (<= 0 i1@44@03)
  (and
    (<= 0 i1@44@03)
    (implies
      (< i1@44@03 V@7@03)
      (and
        (< i1@44@03 V@7@03)
        (implies
          (<= 0 i2@45@03)
          (and
            (<= 0 i2@45@03)
            (implies
              (< i2@45@03 V@7@03)
              (and
                (< i2@45@03 V@7@03)
                (not (= source@6@03 (as None<option<array>>  option<array>)))
                (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))))))))))
; Joined path conditions
(push) ; 10
; [then-branch: 59 | Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i1@44@03)) == Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i2@45@03)) && i2@45@03 < V@7@03 && 0 <= i2@45@03 && i1@44@03 < V@7@03 && 0 <= i1@44@03 | live]
; [else-branch: 59 | !(Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i1@44@03)) == Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i2@45@03)) && i2@45@03 < V@7@03 && 0 <= i2@45@03 && i1@44@03 < V@7@03 && 0 <= i1@44@03) | live]
(push) ; 11
; [then-branch: 59 | Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i1@44@03)) == Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i2@45@03)) && i2@45@03 < V@7@03 && 0 <= i2@45@03 && i1@44@03 < V@7@03 && 0 <= i1@44@03]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
          ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
        (< i2@45@03 V@7@03))
      (<= 0 i2@45@03))
    (< i1@44@03 V@7@03))
  (<= 0 i1@44@03)))
; [eval] i1 == i2
(pop) ; 11
(push) ; 11
; [else-branch: 59 | !(Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i1@44@03)) == Lookup(option$array$,sm@41@03,aloc((_, _), opt_get1(_, source@6@03), i2@45@03)) && i2@45@03 < V@7@03 && 0 <= i2@45@03 && i1@44@03 < V@7@03 && 0 <= i1@44@03)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
            ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
          (< i2@45@03 V@7@03))
        (<= 0 i2@45@03))
      (< i1@44@03 V@7@03))
    (<= 0 i1@44@03))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
            ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
          (< i2@45@03 V@7@03))
        (<= 0 i2@45@03))
      (< i1@44@03 V@7@03))
    (<= 0 i1@44@03))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
      ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
    (< i2@45@03 V@7@03)
    (<= 0 i2@45@03)
    (< i1@44@03 V@7@03)
    (<= 0 i1@44@03))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@45@03 Int)) (!
  (and
    (implies
      (<= 0 i1@44@03)
      (and
        (<= 0 i1@44@03)
        (implies
          (< i1@44@03 V@7@03)
          (and
            (< i1@44@03 V@7@03)
            (implies
              (<= 0 i2@45@03)
              (and
                (<= 0 i2@45@03)
                (implies
                  (< i2@45@03 V@7@03)
                  (and
                    (< i2@45@03 V@7@03)
                    (not (= source@6@03 (as None<option<array>>  option<array>)))
                    (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                    (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
              (< i2@45@03 V@7@03))
            (<= 0 i2@45@03))
          (< i1@44@03 V@7@03))
        (<= 0 i1@44@03))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
          ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
        (< i2@45@03 V@7@03)
        (<= 0 i2@45@03)
        (< i1@44@03 V@7@03)
        (<= 0 i1@44@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@44@03 Int)) (!
  (forall ((i2@45@03 Int)) (!
    (and
      (implies
        (<= 0 i1@44@03)
        (and
          (<= 0 i1@44@03)
          (implies
            (< i1@44@03 V@7@03)
            (and
              (< i1@44@03 V@7@03)
              (implies
                (<= 0 i2@45@03)
                (and
                  (<= 0 i2@45@03)
                  (implies
                    (< i2@45@03 V@7@03)
                    (and
                      (< i2@45@03 V@7@03)
                      (not
                        (= source@6@03 (as None<option<array>>  option<array>)))
                      (< i1@44@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                      (< i2@45@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                  ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
                (< i2@45@03 V@7@03))
              (<= 0 i2@45@03))
            (< i1@44@03 V@7@03))
          (<= 0 i1@44@03))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
            ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
          (< i2@45@03 V@7@03)
          (<= 0 i2@45@03)
          (< i1@44@03 V@7@03)
          (<= 0 i1@44@03))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (forall ((i1@44@03 Int)) (!
      (forall ((i2@45@03 Int)) (!
        (and
          (implies
            (<= 0 i1@44@03)
            (and
              (<= 0 i1@44@03)
              (implies
                (< i1@44@03 V@7@03)
                (and
                  (< i1@44@03 V@7@03)
                  (implies
                    (<= 0 i2@45@03)
                    (and
                      (<= 0 i2@45@03)
                      (implies
                        (< i2@45@03 V@7@03)
                        (and
                          (< i2@45@03 V@7@03)
                          (not
                            (=
                              source@6@03
                              (as None<option<array>>  option<array>)))
                          (<
                            i1@44@03
                            (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                          (<
                            i2@45@03
                            (alen<Int> (opt_get1 $Snap.unit source@6@03)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                      ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
                    (< i2@45@03 V@7@03))
                  (<= 0 i2@45@03))
                (< i1@44@03 V@7@03))
              (<= 0 i1@44@03))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
              (< i2@45@03 V@7@03)
              (<= 0 i2@45@03)
              (< i1@44@03 V@7@03)
              (<= 0 i1@44@03))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (forall ((i1@44@03 Int)) (!
    (forall ((i2@45@03 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
                  ($FVF.lookup_option$array$ (as sm@41@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03)))
                (< i2@45@03 V@7@03))
              (<= 0 i2@45@03))
            (< i1@44@03 V@7@03))
          (<= 0 i1@44@03))
        (= i1@44@03 i2@45@03))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i2@45@03))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) i1@44@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 60 | exc@8@03 == Null | live]
; [else-branch: 60 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 60 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 60 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1702
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      819
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 175
;  :datatype-occurs-check   122
;  :datatype-splits         118
;  :decisions               430
;  :del-clause              1512
;  :final-checks            156
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2744
;  :mk-clause               1527
;  :num-allocs              170035
;  :num-checks              95
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            228386)
(push) ; 7
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1702
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      819
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 175
;  :datatype-occurs-check   122
;  :datatype-splits         118
;  :decisions               430
;  :del-clause              1512
;  :final-checks            156
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2744
;  :mk-clause               1527
;  :num-allocs              170053
;  :num-checks              96
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            228403)
; [then-branch: 61 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 61 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 7
; [then-branch: 61 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (not (= target@5@03 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 62 | exc@8@03 == Null | live]
; [else-branch: 62 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 62 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 62 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(push) ; 7
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1733
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      819
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 181
;  :datatype-occurs-check   125
;  :datatype-splits         120
;  :decisions               436
;  :del-clause              1512
;  :final-checks            158
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2748
;  :mk-clause               1527
;  :num-allocs              170732
;  :num-checks              97
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            229211)
(push) ; 7
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1733
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      819
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 181
;  :datatype-occurs-check   125
;  :datatype-splits         120
;  :decisions               436
;  :del-clause              1512
;  :final-checks            158
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2748
;  :mk-clause               1527
;  :num-allocs              170750
;  :num-checks              98
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            229228)
; [then-branch: 63 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 63 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 7
; [then-branch: 63 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1733
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      819
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 181
;  :datatype-occurs-check   125
;  :datatype-splits         120
;  :decisions               436
;  :del-clause              1512
;  :final-checks            158
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2748
;  :mk-clause               1527
;  :num-allocs              170775
;  :num-checks              99
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            229258)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (not (= target@5@03 (as None<option<array>>  option<array>))))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit target@5@03)) V@7@03)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 64 | exc@8@03 == Null | live]
; [else-branch: 64 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 64 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 64 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1766
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      819
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   128
;  :datatype-splits         123
;  :decisions               443
;  :del-clause              1512
;  :final-checks            160
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2752
;  :mk-clause               1527
;  :num-allocs              171459
;  :num-checks              100
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            230052)
(push) ; 6
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1766
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      819
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   128
;  :datatype-splits         123
;  :decisions               443
;  :del-clause              1512
;  :final-checks            160
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2752
;  :mk-clause               1527
;  :num-allocs              171477
;  :num-checks              101
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            230069)
; [then-branch: 65 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 65 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 6
; [then-branch: 65 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
(declare-const i1@46@03 Int)
(push) ; 7
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 8
; [then-branch: 66 | 0 <= i1@46@03 | live]
; [else-branch: 66 | !(0 <= i1@46@03) | live]
(push) ; 9
; [then-branch: 66 | 0 <= i1@46@03]
(assert (<= 0 i1@46@03))
; [eval] i1 < V
(pop) ; 9
(push) ; 9
; [else-branch: 66 | !(0 <= i1@46@03)]
(assert (not (<= 0 i1@46@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< i1@46@03 V@7@03) (<= 0 i1@46@03)))
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1766
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      821
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   128
;  :datatype-splits         123
;  :decisions               443
;  :del-clause              1512
;  :final-checks            160
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2754
;  :mk-clause               1527
;  :num-allocs              171572
;  :num-checks              102
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            230249)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i1@46@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1766
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      821
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               169
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   128
;  :datatype-splits         123
;  :decisions               443
;  :del-clause              1512
;  :final-checks            160
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2754
;  :mk-clause               1527
;  :num-allocs              171593
;  :num-checks              103
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            230280)
(assert (< i1@46@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 8
; Joined path conditions
(assert (< i1@46@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 8
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 9
(assert (not (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1766
;  :arith-add-rows          557
;  :arith-assert-diseq      29
;  :arith-assert-lower      821
;  :arith-assert-upper      537
;  :arith-bound-prop        44
;  :arith-conflicts         91
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           802
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               170
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 188
;  :datatype-occurs-check   128
;  :datatype-splits         123
;  :decisions               443
;  :del-clause              1512
;  :final-checks            160
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2754
;  :mk-clause               1527
;  :num-allocs              171737
;  :num-checks              104
;  :propagations            862
;  :quant-instantiations    589
;  :rlimit-count            230392)
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(pop) ; 8
; Joined path conditions
(assert (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
(declare-const $k@47@03 $Perm)
(assert ($Perm.isReadVar $k@47@03 $Perm.Write))
(pop) ; 7
(declare-fun inv@48@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@47@03 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@46@03 Int)) (!
  (and
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@46@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    (>= (* (to_real (* V@7@03 V@7@03)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@46@03))
  :qid |option$array$-aux|)))
(push) ; 7
(assert (not (forall ((i1@46@03 Int)) (!
  (implies
    (and (< i1@46@03 V@7@03) (<= 0 i1@46@03))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@47@03)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@47@03))))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1777
;  :arith-add-rows          557
;  :arith-assert-diseq      31
;  :arith-assert-lower      836
;  :arith-assert-upper      546
;  :arith-bound-prop        44
;  :arith-conflicts         92
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           821
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        135
;  :arith-pivots            269
;  :conflicts               171
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 192
;  :datatype-occurs-check   128
;  :datatype-splits         123
;  :decisions               447
;  :del-clause              1515
;  :final-checks            161
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2764
;  :mk-clause               1532
;  :num-allocs              172379
;  :num-checks              105
;  :propagations            864
;  :quant-instantiations    589
;  :rlimit-count            231330)
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((i11@46@03 Int) (i12@46@03 Int)) (!
  (implies
    (and
      (and
        (and (< i11@46@03 V@7@03) (<= 0 i11@46@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@47@03)))
      (and
        (and (< i12@46@03 V@7@03) (<= 0 i12@46@03))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
            $k@47@03)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i11@46@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i12@46@03)))
    (= i11@46@03 i12@46@03))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1794
;  :arith-add-rows          563
;  :arith-assert-diseq      33
;  :arith-assert-lower      841
;  :arith-assert-upper      546
;  :arith-bound-prop        46
;  :arith-conflicts         92
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         143
;  :arith-grobner           65
;  :arith-max-min           821
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        137
;  :arith-pivots            273
;  :conflicts               172
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 192
;  :datatype-occurs-check   128
;  :datatype-splits         123
;  :decisions               447
;  :del-clause              1537
;  :final-checks            161
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.79
;  :mk-bool-var             2804
;  :mk-clause               1554
;  :num-allocs              172937
;  :num-checks              106
;  :propagations            872
;  :quant-instantiations    612
;  :rlimit-count            232872)
; Definitional axioms for inverse functions
(assert (forall ((i1@46@03 Int)) (!
  (implies
    (and
      (and (< i1@46@03 V@7@03) (<= 0 i1@46@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@47@03)))
    (=
      (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@46@03))
      i1@46@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@46@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@48@03 r) V@7@03) (<= 0 (inv@48@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@47@03)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) (inv@48@03 r))
      r))
  :pattern ((inv@48@03 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@46@03 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@46@03))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@46@03 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@46@03))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@46@03 Int)) (!
  (implies
    (and
      (and (< i1@46@03 V@7@03) (<= 0 i1@46@03))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@47@03)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@46@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@46@03))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@49@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@48@03 r) V@7@03) (<= 0 (inv@48@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@47@03))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@40@03 r) V@7@03) (<= 0 (inv@40@03 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write))
          $k@39@03))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@03))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@03))))) r))
  :qid |qp.fvfValDef13|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@37@03))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef14|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@48@03 r) V@7@03) (<= 0 (inv@48@03 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) r) r))
  :pattern ((inv@48@03 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 67 | exc@8@03 == Null | live]
; [else-branch: 67 | exc@8@03 != Null | live]
(push) ; 8
; [then-branch: 67 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 67 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1830
;  :arith-add-rows          563
;  :arith-assert-diseq      33
;  :arith-assert-lower      866
;  :arith-assert-upper      562
;  :arith-bound-prop        46
;  :arith-conflicts         92
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         143
;  :arith-grobner           70
;  :arith-max-min           861
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        137
;  :arith-pivots            273
;  :conflicts               172
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 199
;  :datatype-occurs-check   131
;  :datatype-splits         126
;  :decisions               454
;  :del-clause              1537
;  :final-checks            165
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.80
;  :mk-bool-var             2818
;  :mk-clause               1554
;  :num-allocs              175164
;  :num-checks              107
;  :propagations            872
;  :quant-instantiations    612
;  :rlimit-count            237681)
(push) ; 8
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1830
;  :arith-add-rows          563
;  :arith-assert-diseq      33
;  :arith-assert-lower      866
;  :arith-assert-upper      562
;  :arith-bound-prop        46
;  :arith-conflicts         92
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         143
;  :arith-grobner           70
;  :arith-max-min           861
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        137
;  :arith-pivots            273
;  :conflicts               172
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 199
;  :datatype-occurs-check   131
;  :datatype-splits         126
;  :decisions               454
;  :del-clause              1537
;  :final-checks            165
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.80
;  :mk-bool-var             2818
;  :mk-clause               1554
;  :num-allocs              175182
;  :num-checks              108
;  :propagations            872
;  :quant-instantiations    612
;  :rlimit-count            237698)
; [then-branch: 68 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 68 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 8
; [then-branch: 68 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
(declare-const i1@50@03 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 69 | 0 <= i1@50@03 | live]
; [else-branch: 69 | !(0 <= i1@50@03) | live]
(push) ; 11
; [then-branch: 69 | 0 <= i1@50@03]
(assert (<= 0 i1@50@03))
; [eval] i1 < V
(pop) ; 11
(push) ; 11
; [else-branch: 69 | !(0 <= i1@50@03)]
(assert (not (<= 0 i1@50@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 70 | i1@50@03 < V@7@03 && 0 <= i1@50@03 | live]
; [else-branch: 70 | !(i1@50@03 < V@7@03 && 0 <= i1@50@03) | live]
(push) ; 11
; [then-branch: 70 | i1@50@03 < V@7@03 && 0 <= i1@50@03]
(assert (and (< i1@50@03 V@7@03) (<= 0 i1@50@03)))
; [eval] aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 13
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1830
;  :arith-add-rows          563
;  :arith-assert-diseq      33
;  :arith-assert-lower      868
;  :arith-assert-upper      562
;  :arith-bound-prop        46
;  :arith-conflicts         92
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         143
;  :arith-grobner           70
;  :arith-max-min           861
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        137
;  :arith-pivots            274
;  :conflicts               172
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 199
;  :datatype-occurs-check   131
;  :datatype-splits         126
;  :decisions               454
;  :del-clause              1537
;  :final-checks            165
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.80
;  :mk-bool-var             2820
;  :mk-clause               1554
;  :num-allocs              175277
;  :num-checks              109
;  :propagations            872
;  :quant-instantiations    612
;  :rlimit-count            237892)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 13
(assert (not (< i1@50@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1830
;  :arith-add-rows          563
;  :arith-assert-diseq      33
;  :arith-assert-lower      868
;  :arith-assert-upper      562
;  :arith-bound-prop        46
;  :arith-conflicts         92
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         143
;  :arith-grobner           70
;  :arith-max-min           861
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        137
;  :arith-pivots            274
;  :conflicts               172
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 199
;  :datatype-occurs-check   131
;  :datatype-splits         126
;  :decisions               454
;  :del-clause              1537
;  :final-checks            165
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.80
;  :mk-bool-var             2820
;  :mk-clause               1554
;  :num-allocs              175298
;  :num-checks              110
;  :propagations            872
;  :quant-instantiations    612
;  :rlimit-count            237923)
(assert (< i1@50@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 12
; Joined path conditions
(assert (< i1@50@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))
          V@7@03)
        (<=
          0
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))
          V@7@03)
        (<=
          0
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2056
;  :arith-add-rows          617
;  :arith-assert-diseq      35
;  :arith-assert-lower      949
;  :arith-assert-upper      627
;  :arith-bound-prop        51
;  :arith-conflicts         100
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         162
;  :arith-grobner           70
;  :arith-max-min           925
;  :arith-nonlinear-bounds  96
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        146
;  :arith-pivots            302
;  :conflicts               189
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 211
;  :datatype-occurs-check   137
;  :datatype-splits         135
;  :decisions               570
;  :del-clause              1921
;  :final-checks            172
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.86
;  :mk-bool-var             3354
;  :mk-clause               2009
;  :num-allocs              176977
;  :num-checks              111
;  :propagations            1068
;  :quant-instantiations    715
;  :rlimit-count            245399
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 11
(push) ; 11
; [else-branch: 70 | !(i1@50@03 < V@7@03 && 0 <= i1@50@03)]
(assert (not (and (< i1@50@03 V@7@03) (<= 0 i1@50@03))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i1@50@03 V@7@03) (<= 0 i1@50@03))
  (and
    (< i1@50@03 V@7@03)
    (<= 0 i1@50@03)
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@50@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03)))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@50@03 Int)) (!
  (implies
    (and (< i1@50@03 V@7@03) (<= 0 i1@50@03))
    (and
      (< i1@50@03 V@7@03)
      (<= 0 i1@50@03)
      (not (= target@5@03 (as None<option<array>>  option<array>)))
      (< i1@50@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (forall ((i1@50@03 Int)) (!
      (implies
        (and (< i1@50@03 V@7@03) (<= 0 i1@50@03))
        (and
          (< i1@50@03 V@7@03)
          (<= 0 i1@50@03)
          (not (= target@5@03 (as None<option<array>>  option<array>)))
          (< i1@50@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (forall ((i1@50@03 Int)) (!
    (implies
      (and (< i1@50@03 V@7@03) (<= 0 i1@50@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@50@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 71 | exc@8@03 == Null | live]
; [else-branch: 71 | exc@8@03 != Null | live]
(push) ; 8
; [then-branch: 71 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 71 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2093
;  :arith-add-rows          617
;  :arith-assert-diseq      35
;  :arith-assert-lower      973
;  :arith-assert-upper      643
;  :arith-bound-prop        51
;  :arith-conflicts         100
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         162
;  :arith-grobner           75
;  :arith-max-min           966
;  :arith-nonlinear-bounds  96
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        146
;  :arith-pivots            304
;  :conflicts               189
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   140
;  :datatype-splits         138
;  :decisions               577
;  :del-clause              1992
;  :final-checks            176
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.86
;  :mk-bool-var             3361
;  :mk-clause               2009
;  :num-allocs              178316
;  :num-checks              112
;  :propagations            1068
;  :quant-instantiations    715
;  :rlimit-count            247735)
(push) ; 8
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2093
;  :arith-add-rows          617
;  :arith-assert-diseq      35
;  :arith-assert-lower      973
;  :arith-assert-upper      643
;  :arith-bound-prop        51
;  :arith-conflicts         100
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         162
;  :arith-grobner           75
;  :arith-max-min           966
;  :arith-nonlinear-bounds  96
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        146
;  :arith-pivots            304
;  :conflicts               189
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   140
;  :datatype-splits         138
;  :decisions               577
;  :del-clause              1992
;  :final-checks            176
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.86
;  :mk-bool-var             3361
;  :mk-clause               2009
;  :num-allocs              178334
;  :num-checks              113
;  :propagations            1068
;  :quant-instantiations    715
;  :rlimit-count            247752)
; [then-branch: 72 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 72 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 8
; [then-branch: 72 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
(declare-const i1@51@03 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 73 | 0 <= i1@51@03 | live]
; [else-branch: 73 | !(0 <= i1@51@03) | live]
(push) ; 11
; [then-branch: 73 | 0 <= i1@51@03]
(assert (<= 0 i1@51@03))
; [eval] i1 < V
(pop) ; 11
(push) ; 11
; [else-branch: 73 | !(0 <= i1@51@03)]
(assert (not (<= 0 i1@51@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 74 | i1@51@03 < V@7@03 && 0 <= i1@51@03 | live]
; [else-branch: 74 | !(i1@51@03 < V@7@03 && 0 <= i1@51@03) | live]
(push) ; 11
; [then-branch: 74 | i1@51@03 < V@7@03 && 0 <= i1@51@03]
(assert (and (< i1@51@03 V@7@03) (<= 0 i1@51@03)))
; [eval] alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V
; [eval] alen(opt_get1(aloc(opt_get1(target), i1).option$array$))
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 13
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2093
;  :arith-add-rows          617
;  :arith-assert-diseq      35
;  :arith-assert-lower      975
;  :arith-assert-upper      643
;  :arith-bound-prop        51
;  :arith-conflicts         100
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         162
;  :arith-grobner           75
;  :arith-max-min           966
;  :arith-nonlinear-bounds  96
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        146
;  :arith-pivots            304
;  :conflicts               189
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   140
;  :datatype-splits         138
;  :decisions               577
;  :del-clause              1992
;  :final-checks            176
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.86
;  :mk-bool-var             3363
;  :mk-clause               2009
;  :num-allocs              178429
;  :num-checks              114
;  :propagations            1068
;  :quant-instantiations    715
;  :rlimit-count            247942)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 13
(assert (not (< i1@51@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2093
;  :arith-add-rows          617
;  :arith-assert-diseq      35
;  :arith-assert-lower      975
;  :arith-assert-upper      643
;  :arith-bound-prop        51
;  :arith-conflicts         100
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         162
;  :arith-grobner           75
;  :arith-max-min           966
;  :arith-nonlinear-bounds  96
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        146
;  :arith-pivots            304
;  :conflicts               189
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 218
;  :datatype-occurs-check   140
;  :datatype-splits         138
;  :decisions               577
;  :del-clause              1992
;  :final-checks            176
;  :interface-eqs           11
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.86
;  :mk-bool-var             3363
;  :mk-clause               2009
;  :num-allocs              178450
;  :num-checks              115
;  :propagations            1068
;  :quant-instantiations    715
;  :rlimit-count            247973)
(assert (< i1@51@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 12
; Joined path conditions
(assert (< i1@51@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
          V@7@03)
        (<=
          0
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
          V@7@03)
        (<=
          0
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          674
;  :arith-assert-diseq      36
;  :arith-assert-lower      1078
;  :arith-assert-upper      728
;  :arith-bound-prop        59
;  :arith-conflicts         109
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         188
;  :arith-gcd-tests         1
;  :arith-grobner           75
;  :arith-ineq-splits       1
;  :arith-max-min           1070
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        208
;  :arith-patches           1
;  :arith-pivots            334
;  :conflicts               208
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 281
;  :datatype-occurs-check   192
;  :datatype-splits         199
;  :decisions               747
;  :del-clause              2412
;  :final-checks            207
;  :interface-eqs           21
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4077
;  :mk-clause               2500
;  :num-allocs              180679
;  :num-checks              116
;  :propagations            1316
;  :quant-instantiations    819
;  :rlimit-count            256810
;  :time                    0.00)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 13
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2581
;  :arith-add-rows          674
;  :arith-assert-diseq      36
;  :arith-assert-lower      1078
;  :arith-assert-upper      728
;  :arith-bound-prop        59
;  :arith-conflicts         109
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         188
;  :arith-gcd-tests         1
;  :arith-grobner           75
;  :arith-ineq-splits       1
;  :arith-max-min           1070
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        208
;  :arith-patches           1
;  :arith-pivots            334
;  :conflicts               209
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 281
;  :datatype-occurs-check   192
;  :datatype-splits         199
;  :decisions               747
;  :del-clause              2412
;  :final-checks            207
;  :interface-eqs           21
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4077
;  :mk-clause               2500
;  :num-allocs              180770
;  :num-checks              117
;  :propagations            1316
;  :quant-instantiations    819
;  :rlimit-count            256905)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
    (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
    (as None<option<array>>  option<array>))))
(pop) ; 11
(push) ; 11
; [else-branch: 74 | !(i1@51@03 < V@7@03 && 0 <= i1@51@03)]
(assert (not (and (< i1@51@03 V@7@03) (<= 0 i1@51@03))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i1@51@03 V@7@03) (<= 0 i1@51@03))
  (and
    (< i1@51@03 V@7@03)
    (<= 0 i1@51@03)
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@51@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@51@03 Int)) (!
  (implies
    (and (< i1@51@03 V@7@03) (<= 0 i1@51@03))
    (and
      (< i1@51@03 V@7@03)
      (<= 0 i1@51@03)
      (not (= target@5@03 (as None<option<array>>  option<array>)))
      (< i1@51@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (forall ((i1@51@03 Int)) (!
      (implies
        (and (< i1@51@03 V@7@03) (<= 0 i1@51@03))
        (and
          (< i1@51@03 V@7@03)
          (<= 0 i1@51@03)
          (not (= target@5@03 (as None<option<array>>  option<array>)))
          (< i1@51@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (forall ((i1@51@03 Int)) (!
    (implies
      (and (< i1@51@03 V@7@03) (<= 0 i1@51@03))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03))))
        V@7@03))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@51@03)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 75 | exc@8@03 == Null | live]
; [else-branch: 75 | exc@8@03 != Null | live]
(push) ; 8
; [then-branch: 75 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 75 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2619
;  :arith-add-rows          674
;  :arith-assert-diseq      36
;  :arith-assert-lower      1102
;  :arith-assert-upper      744
;  :arith-bound-prop        59
;  :arith-conflicts         109
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         188
;  :arith-gcd-tests         1
;  :arith-grobner           80
;  :arith-ineq-splits       1
;  :arith-max-min           1111
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        208
;  :arith-patches           1
;  :arith-pivots            337
;  :conflicts               209
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   197
;  :datatype-splits         202
;  :decisions               754
;  :del-clause              2483
;  :final-checks            211
;  :interface-eqs           21
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4084
;  :mk-clause               2500
;  :num-allocs              182131
;  :num-checks              118
;  :propagations            1316
;  :quant-instantiations    819
;  :rlimit-count            259349)
(push) ; 8
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2619
;  :arith-add-rows          674
;  :arith-assert-diseq      36
;  :arith-assert-lower      1102
;  :arith-assert-upper      744
;  :arith-bound-prop        59
;  :arith-conflicts         109
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         188
;  :arith-gcd-tests         1
;  :arith-grobner           80
;  :arith-ineq-splits       1
;  :arith-max-min           1111
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        208
;  :arith-patches           1
;  :arith-pivots            337
;  :conflicts               209
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   197
;  :datatype-splits         202
;  :decisions               754
;  :del-clause              2483
;  :final-checks            211
;  :interface-eqs           21
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4084
;  :mk-clause               2500
;  :num-allocs              182149
;  :num-checks              119
;  :propagations            1316
;  :quant-instantiations    819
;  :rlimit-count            259366)
; [then-branch: 76 | 0 < V@7@03 && exc@8@03 == Null | live]
; [else-branch: 76 | !(0 < V@7@03 && exc@8@03 == Null) | dead]
(push) ; 8
; [then-branch: 76 | 0 < V@7@03 && exc@8@03 == Null]
(assert (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
(declare-const i1@52@03 Int)
(push) ; 9
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2)
(declare-const i2@53@03 Int)
(push) ; 10
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] 0 <= i1
(push) ; 11
; [then-branch: 77 | 0 <= i1@52@03 | live]
; [else-branch: 77 | !(0 <= i1@52@03) | live]
(push) ; 12
; [then-branch: 77 | 0 <= i1@52@03]
(assert (<= 0 i1@52@03))
; [eval] i1 < V
(push) ; 13
; [then-branch: 78 | i1@52@03 < V@7@03 | live]
; [else-branch: 78 | !(i1@52@03 < V@7@03) | live]
(push) ; 14
; [then-branch: 78 | i1@52@03 < V@7@03]
(assert (< i1@52@03 V@7@03))
; [eval] 0 <= i2
(push) ; 15
; [then-branch: 79 | 0 <= i2@53@03 | live]
; [else-branch: 79 | !(0 <= i2@53@03) | live]
(push) ; 16
; [then-branch: 79 | 0 <= i2@53@03]
(assert (<= 0 i2@53@03))
; [eval] i2 < V
(push) ; 17
; [then-branch: 80 | i2@53@03 < V@7@03 | live]
; [else-branch: 80 | !(i2@53@03 < V@7@03) | live]
(push) ; 18
; [then-branch: 80 | i2@53@03 < V@7@03]
(assert (< i2@53@03 V@7@03))
; [eval] aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 19
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 20
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2619
;  :arith-add-rows          674
;  :arith-assert-diseq      36
;  :arith-assert-lower      1106
;  :arith-assert-upper      744
;  :arith-bound-prop        59
;  :arith-conflicts         109
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         188
;  :arith-gcd-tests         1
;  :arith-grobner           80
;  :arith-ineq-splits       1
;  :arith-max-min           1111
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        208
;  :arith-patches           1
;  :arith-pivots            338
;  :conflicts               209
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   197
;  :datatype-splits         202
;  :decisions               754
;  :del-clause              2483
;  :final-checks            211
;  :interface-eqs           21
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4088
;  :mk-clause               2500
;  :num-allocs              182421
;  :num-checks              120
;  :propagations            1316
;  :quant-instantiations    819
;  :rlimit-count            259705)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 19
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 19
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 20
(assert (not (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2619
;  :arith-add-rows          674
;  :arith-assert-diseq      36
;  :arith-assert-lower      1106
;  :arith-assert-upper      744
;  :arith-bound-prop        59
;  :arith-conflicts         109
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         188
;  :arith-gcd-tests         1
;  :arith-grobner           80
;  :arith-ineq-splits       1
;  :arith-max-min           1111
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        208
;  :arith-patches           1
;  :arith-pivots            338
;  :conflicts               209
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 288
;  :datatype-occurs-check   197
;  :datatype-splits         202
;  :decisions               754
;  :del-clause              2483
;  :final-checks            211
;  :interface-eqs           21
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4088
;  :mk-clause               2500
;  :num-allocs              182442
;  :num-checks              121
;  :propagations            1316
;  :quant-instantiations    819
;  :rlimit-count            259736)
(assert (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 19
; Joined path conditions
(assert (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
          V@7@03)
        (<=
          0
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
          V@7@03)
        (<=
          0
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2867
;  :arith-add-rows          745
;  :arith-assert-diseq      38
;  :arith-assert-lower      1183
;  :arith-assert-upper      805
;  :arith-bound-prop        65
;  :arith-conflicts         116
;  :arith-eq-adapter        235
;  :arith-fixed-eqs         208
;  :arith-gcd-tests         1
;  :arith-grobner           80
;  :arith-ineq-splits       1
;  :arith-max-min           1175
;  :arith-nonlinear-bounds  125
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        218
;  :arith-patches           1
;  :arith-pivots            367
;  :conflicts               226
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   205
;  :datatype-splits         215
;  :decisions               858
;  :del-clause              2822
;  :final-checks            220
;  :interface-eqs           22
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4626
;  :mk-clause               2910
;  :num-allocs              183924
;  :num-checks              122
;  :propagations            1492
;  :quant-instantiations    914
;  :rlimit-count            266824
;  :time                    0.00)
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
(push) ; 20
(assert (not (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2867
;  :arith-add-rows          745
;  :arith-assert-diseq      38
;  :arith-assert-lower      1183
;  :arith-assert-upper      805
;  :arith-bound-prop        65
;  :arith-conflicts         116
;  :arith-eq-adapter        235
;  :arith-fixed-eqs         208
;  :arith-gcd-tests         1
;  :arith-grobner           80
;  :arith-ineq-splits       1
;  :arith-max-min           1175
;  :arith-nonlinear-bounds  125
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        218
;  :arith-patches           1
;  :arith-pivots            367
;  :conflicts               226
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 305
;  :datatype-occurs-check   205
;  :datatype-splits         215
;  :decisions               858
;  :del-clause              2822
;  :final-checks            220
;  :interface-eqs           22
;  :max-generation          5
;  :max-memory              4.92
;  :memory                  4.90
;  :mk-bool-var             4626
;  :mk-clause               2910
;  :num-allocs              183951
;  :num-checks              123
;  :propagations            1492
;  :quant-instantiations    914
;  :rlimit-count            266854)
(assert (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 19
; Joined path conditions
(assert (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))
          V@7@03)
        (<=
          0
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))
          V@7@03)
        (<=
          0
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3220
;  :arith-add-rows          957
;  :arith-assert-diseq      53
;  :arith-assert-lower      1306
;  :arith-assert-upper      902
;  :arith-bound-prop        81
;  :arith-conflicts         126
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         240
;  :arith-gcd-tests         1
;  :arith-grobner           80
;  :arith-ineq-splits       1
;  :arith-max-min           1265
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        239
;  :arith-patches           1
;  :arith-pivots            421
;  :conflicts               244
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 323
;  :datatype-occurs-check   215
;  :datatype-splits         230
;  :decisions               1029
;  :del-clause              3344
;  :final-checks            231
;  :interface-eqs           22
;  :max-generation          5
;  :max-memory              5.00
;  :memory                  5.00
;  :minimized-lits          1
;  :mk-bool-var             5283
;  :mk-clause               3475
;  :num-allocs              185883
;  :num-checks              124
;  :propagations            1791
;  :quant-instantiations    1035
;  :rlimit-count            278096
;  :time                    0.00)
(pop) ; 18
(push) ; 18
; [else-branch: 80 | !(i2@53@03 < V@7@03)]
(assert (not (< i2@53@03 V@7@03)))
(pop) ; 18
(pop) ; 17
; Joined path conditions
(assert (implies
  (< i2@53@03 V@7@03)
  (and
    (< i2@53@03 V@7@03)
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
    (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))))
; Joined path conditions
(pop) ; 16
(push) ; 16
; [else-branch: 79 | !(0 <= i2@53@03)]
(assert (not (<= 0 i2@53@03)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (implies
  (<= 0 i2@53@03)
  (and
    (<= 0 i2@53@03)
    (implies
      (< i2@53@03 V@7@03)
      (and
        (< i2@53@03 V@7@03)
        (not (= target@5@03 (as None<option<array>>  option<array>)))
        (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
        (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))))))
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 78 | !(i1@52@03 < V@7@03)]
(assert (not (< i1@52@03 V@7@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i1@52@03 V@7@03)
  (and
    (< i1@52@03 V@7@03)
    (implies
      (<= 0 i2@53@03)
      (and
        (<= 0 i2@53@03)
        (implies
          (< i2@53@03 V@7@03)
          (and
            (< i2@53@03 V@7@03)
            (not (= target@5@03 (as None<option<array>>  option<array>)))
            (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
            (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))))))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 77 | !(0 <= i1@52@03)]
(assert (not (<= 0 i1@52@03)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i1@52@03)
  (and
    (<= 0 i1@52@03)
    (implies
      (< i1@52@03 V@7@03)
      (and
        (< i1@52@03 V@7@03)
        (implies
          (<= 0 i2@53@03)
          (and
            (<= 0 i2@53@03)
            (implies
              (< i2@53@03 V@7@03)
              (and
                (< i2@53@03 V@7@03)
                (not (= target@5@03 (as None<option<array>>  option<array>)))
                (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))))))))))
; Joined path conditions
(push) ; 11
; [then-branch: 81 | Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i1@52@03)) == Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i2@53@03)) && i2@53@03 < V@7@03 && 0 <= i2@53@03 && i1@52@03 < V@7@03 && 0 <= i1@52@03 | live]
; [else-branch: 81 | !(Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i1@52@03)) == Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i2@53@03)) && i2@53@03 < V@7@03 && 0 <= i2@53@03 && i1@52@03 < V@7@03 && 0 <= i1@52@03) | live]
(push) ; 12
; [then-branch: 81 | Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i1@52@03)) == Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i2@53@03)) && i2@53@03 < V@7@03 && 0 <= i2@53@03 && i1@52@03 < V@7@03 && 0 <= i1@52@03]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
          ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
        (< i2@53@03 V@7@03))
      (<= 0 i2@53@03))
    (< i1@52@03 V@7@03))
  (<= 0 i1@52@03)))
; [eval] i1 == i2
(pop) ; 12
(push) ; 12
; [else-branch: 81 | !(Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i1@52@03)) == Lookup(option$array$,sm@49@03,aloc((_, _), opt_get1(_, target@5@03), i2@53@03)) && i2@53@03 < V@7@03 && 0 <= i2@53@03 && i1@52@03 < V@7@03 && 0 <= i1@52@03)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
            ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
          (< i2@53@03 V@7@03))
        (<= 0 i2@53@03))
      (< i1@52@03 V@7@03))
    (<= 0 i1@52@03))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
            ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
          (< i2@53@03 V@7@03))
        (<= 0 i2@53@03))
      (< i1@52@03 V@7@03))
    (<= 0 i1@52@03))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
      ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
    (< i2@53@03 V@7@03)
    (<= 0 i2@53@03)
    (< i1@52@03 V@7@03)
    (<= 0 i1@52@03))))
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@53@03 Int)) (!
  (and
    (implies
      (<= 0 i1@52@03)
      (and
        (<= 0 i1@52@03)
        (implies
          (< i1@52@03 V@7@03)
          (and
            (< i1@52@03 V@7@03)
            (implies
              (<= 0 i2@53@03)
              (and
                (<= 0 i2@53@03)
                (implies
                  (< i2@53@03 V@7@03)
                  (and
                    (< i2@53@03 V@7@03)
                    (not (= target@5@03 (as None<option<array>>  option<array>)))
                    (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                    (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
              (< i2@53@03 V@7@03))
            (<= 0 i2@53@03))
          (< i1@52@03 V@7@03))
        (<= 0 i1@52@03))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
          ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
        (< i2@53@03 V@7@03)
        (<= 0 i2@53@03)
        (< i1@52@03 V@7@03)
        (<= 0 i1@52@03))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@52@03 Int)) (!
  (forall ((i2@53@03 Int)) (!
    (and
      (implies
        (<= 0 i1@52@03)
        (and
          (<= 0 i1@52@03)
          (implies
            (< i1@52@03 V@7@03)
            (and
              (< i1@52@03 V@7@03)
              (implies
                (<= 0 i2@53@03)
                (and
                  (<= 0 i2@53@03)
                  (implies
                    (< i2@53@03 V@7@03)
                    (and
                      (< i2@53@03 V@7@03)
                      (not
                        (= target@5@03 (as None<option<array>>  option<array>)))
                      (< i1@52@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                      (< i2@53@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                  ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
                (< i2@53@03 V@7@03))
              (<= 0 i2@53@03))
            (< i1@52@03 V@7@03))
          (<= 0 i1@52@03))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
            ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
          (< i2@53@03 V@7@03)
          (<= 0 i2@53@03)
          (< i1@52@03 V@7@03)
          (<= 0 i1@52@03))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (and
    (< 0 V@7@03)
    (= exc@8@03 $Ref.null)
    (forall ((i1@52@03 Int)) (!
      (forall ((i2@53@03 Int)) (!
        (and
          (implies
            (<= 0 i1@52@03)
            (and
              (<= 0 i1@52@03)
              (implies
                (< i1@52@03 V@7@03)
                (and
                  (< i1@52@03 V@7@03)
                  (implies
                    (<= 0 i2@53@03)
                    (and
                      (<= 0 i2@53@03)
                      (implies
                        (< i2@53@03 V@7@03)
                        (and
                          (< i2@53@03 V@7@03)
                          (not
                            (=
                              target@5@03
                              (as None<option<array>>  option<array>)))
                          (<
                            i1@52@03
                            (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                          (<
                            i2@53@03
                            (alen<Int> (opt_get1 $Snap.unit target@5@03)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                      ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
                    (< i2@53@03 V@7@03))
                  (<= 0 i2@53@03))
                (< i1@52@03 V@7@03))
              (<= 0 i1@52@03))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
              (< i2@53@03 V@7@03)
              (<= 0 i2@53@03)
              (< i1@52@03 V@7@03)
              (<= 0 i1@52@03))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@7@03) (= exc@8@03 $Ref.null))
  (forall ((i1@52@03 Int)) (!
    (forall ((i2@53@03 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
                  ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03)))
                (< i2@53@03 V@7@03))
              (<= 0 i2@53@03))
            (< i1@52@03 V@7@03))
          (<= 0 i1@52@03))
        (= i1@52@03 i2@53@03))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i2@53@03))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) i1@52@03))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03)))))))))))))))))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@8@03 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3259
;  :arith-add-rows          959
;  :arith-assert-diseq      53
;  :arith-assert-lower      1330
;  :arith-assert-upper      918
;  :arith-bound-prop        81
;  :arith-conflicts         126
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         240
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1306
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        239
;  :arith-patches           1
;  :arith-pivots            427
;  :conflicts               244
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 331
;  :datatype-occurs-check   220
;  :datatype-splits         234
;  :decisions               1037
;  :del-clause              3482
;  :final-checks            235
;  :interface-eqs           22
;  :max-generation          5
;  :max-memory              5.01
;  :memory                  4.99
;  :minimized-lits          1
;  :mk-bool-var             5303
;  :mk-clause               3499
;  :num-allocs              187723
;  :num-checks              125
;  :propagations            1791
;  :quant-instantiations    1035
;  :rlimit-count            281887)
(push) ; 7
(assert (not (= exc@8@03 $Ref.null)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3259
;  :arith-add-rows          959
;  :arith-assert-diseq      53
;  :arith-assert-lower      1330
;  :arith-assert-upper      918
;  :arith-bound-prop        81
;  :arith-conflicts         126
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         240
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1306
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        239
;  :arith-patches           1
;  :arith-pivots            427
;  :conflicts               244
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 331
;  :datatype-occurs-check   220
;  :datatype-splits         234
;  :decisions               1037
;  :del-clause              3482
;  :final-checks            235
;  :interface-eqs           22
;  :max-generation          5
;  :max-memory              5.01
;  :memory                  4.99
;  :minimized-lits          1
;  :mk-bool-var             5303
;  :mk-clause               3499
;  :num-allocs              187741
;  :num-checks              126
;  :propagations            1791
;  :quant-instantiations    1035
;  :rlimit-count            281898)
; [then-branch: 82 | exc@8@03 == Null | live]
; [else-branch: 82 | exc@8@03 != Null | dead]
(push) ; 7
; [then-branch: 82 | exc@8@03 == Null]
(assert (= exc@8@03 $Ref.null))
(declare-const unknown@54@03 Int)
(declare-const unknown1@55@03 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 83 | 0 <= unknown@54@03 | live]
; [else-branch: 83 | !(0 <= unknown@54@03) | live]
(push) ; 10
; [then-branch: 83 | 0 <= unknown@54@03]
(assert (<= 0 unknown@54@03))
; [eval] unknown < V
(push) ; 11
; [then-branch: 84 | unknown@54@03 < V@7@03 | live]
; [else-branch: 84 | !(unknown@54@03 < V@7@03) | live]
(push) ; 12
; [then-branch: 84 | unknown@54@03 < V@7@03]
(assert (< unknown@54@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 13
; [then-branch: 85 | 0 <= unknown1@55@03 | live]
; [else-branch: 85 | !(0 <= unknown1@55@03) | live]
(push) ; 14
; [then-branch: 85 | 0 <= unknown1@55@03]
(assert (<= 0 unknown1@55@03))
; [eval] unknown1 < V
(pop) ; 14
(push) ; 14
; [else-branch: 85 | !(0 <= unknown1@55@03)]
(assert (not (<= 0 unknown1@55@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 84 | !(unknown@54@03 < V@7@03)]
(assert (not (< unknown@54@03 V@7@03)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 83 | !(0 <= unknown@54@03)]
(assert (not (<= 0 unknown@54@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@55@03 V@7@03) (<= 0 unknown1@55@03))
    (< unknown@54@03 V@7@03))
  (<= 0 unknown@54@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3259
;  :arith-add-rows          959
;  :arith-assert-diseq      53
;  :arith-assert-lower      1336
;  :arith-assert-upper      918
;  :arith-bound-prop        81
;  :arith-conflicts         126
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         240
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1306
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        239
;  :arith-patches           1
;  :arith-pivots            427
;  :conflicts               244
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 331
;  :datatype-occurs-check   220
;  :datatype-splits         234
;  :decisions               1037
;  :del-clause              3482
;  :final-checks            235
;  :interface-eqs           22
;  :max-generation          5
;  :max-memory              5.01
;  :memory                  5.00
;  :minimized-lits          1
;  :mk-bool-var             5309
;  :mk-clause               3499
;  :num-allocs              188011
;  :num-checks              127
;  :propagations            1791
;  :quant-instantiations    1035
;  :rlimit-count            282359)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< unknown1@55@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3259
;  :arith-add-rows          959
;  :arith-assert-diseq      53
;  :arith-assert-lower      1336
;  :arith-assert-upper      918
;  :arith-bound-prop        81
;  :arith-conflicts         126
;  :arith-eq-adapter        265
;  :arith-fixed-eqs         240
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1306
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        239
;  :arith-patches           1
;  :arith-pivots            427
;  :conflicts               244
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 331
;  :datatype-occurs-check   220
;  :datatype-splits         234
;  :decisions               1037
;  :del-clause              3482
;  :final-checks            235
;  :interface-eqs           22
;  :max-generation          5
;  :max-memory              5.01
;  :memory                  5.00
;  :minimized-lits          1
;  :mk-bool-var             5309
;  :mk-clause               3499
;  :num-allocs              188032
;  :num-checks              128
;  :propagations            1791
;  :quant-instantiations    1035
;  :rlimit-count            282390)
(assert (< unknown1@55@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 9
; Joined path conditions
(assert (< unknown1@55@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))
          V@7@03)
        (<=
          0
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))
          V@7@03)
        (<=
          0
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3622
;  :arith-add-rows          1021
;  :arith-assert-diseq      55
;  :arith-assert-lower      1412
;  :arith-assert-upper      981
;  :arith-bound-prop        86
;  :arith-conflicts         135
;  :arith-eq-adapter        290
;  :arith-fixed-eqs         262
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1370
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        267
;  :arith-patches           1
;  :arith-pivots            461
;  :conflicts               263
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 369
;  :datatype-occurs-check   242
;  :datatype-splits         272
;  :decisions               1163
;  :del-clause              3834
;  :final-checks            250
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.02
;  :memory                  5.01
;  :minimized-lits          1
;  :mk-bool-var             5899
;  :mk-clause               3922
;  :num-allocs              189706
;  :num-checks              129
;  :propagations            1989
;  :quant-instantiations    1127
;  :rlimit-count            290339
;  :time                    0.00)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3622
;  :arith-add-rows          1021
;  :arith-assert-diseq      55
;  :arith-assert-lower      1412
;  :arith-assert-upper      981
;  :arith-bound-prop        86
;  :arith-conflicts         135
;  :arith-eq-adapter        290
;  :arith-fixed-eqs         262
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1370
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        267
;  :arith-patches           1
;  :arith-pivots            461
;  :conflicts               264
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 369
;  :datatype-occurs-check   242
;  :datatype-splits         272
;  :decisions               1163
;  :del-clause              3834
;  :final-checks            250
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.02
;  :memory                  5.01
;  :minimized-lits          1
;  :mk-bool-var             5899
;  :mk-clause               3922
;  :num-allocs              189797
;  :num-checks              130
;  :propagations            1989
;  :quant-instantiations    1127
;  :rlimit-count            290434)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  unknown@54@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          1026
;  :arith-assert-diseq      55
;  :arith-assert-lower      1415
;  :arith-assert-upper      982
;  :arith-bound-prop        86
;  :arith-conflicts         136
;  :arith-eq-adapter        291
;  :arith-fixed-eqs         263
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1370
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        267
;  :arith-patches           1
;  :arith-pivots            465
;  :conflicts               265
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 369
;  :datatype-occurs-check   242
;  :datatype-splits         272
;  :decisions               1163
;  :del-clause              3838
;  :final-checks            250
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.02
;  :memory                  5.01
;  :minimized-lits          1
;  :mk-bool-var             5910
;  :mk-clause               3926
;  :num-allocs              190002
;  :num-checks              131
;  :propagations            1991
;  :quant-instantiations    1134
;  :rlimit-count            290937)
(assert (<
  unknown@54@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))))))
(pop) ; 9
; Joined path conditions
(assert (<
  unknown@54@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))))))
(pop) ; 8
(declare-fun inv@56@03 ($Ref) Int)
(declare-fun inv@57@03 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@54@03 Int) (unknown1@55@03 Int)) (!
  (and
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< unknown1@55@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@54@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))) unknown@54@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 8
(assert (not (forall ((unknown1@54@03 Int) (unknown11@55@03 Int) (unknown2@54@03 Int) (unknown12@55@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@55@03 V@7@03) (<= 0 unknown11@55@03))
          (< unknown1@54@03 V@7@03))
        (<= 0 unknown1@54@03))
      (and
        (and
          (and (< unknown12@55@03 V@7@03) (<= 0 unknown12@55@03))
          (< unknown2@54@03 V@7@03))
        (<= 0 unknown2@54@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown11@55@03))) unknown1@54@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown12@55@03))) unknown2@54@03)))
    (and (= unknown1@54@03 unknown2@54@03) (= unknown11@55@03 unknown12@55@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3666
;  :arith-add-rows          1034
;  :arith-assert-diseq      55
;  :arith-assert-lower      1425
;  :arith-assert-upper      984
;  :arith-bound-prop        86
;  :arith-conflicts         136
;  :arith-eq-adapter        295
;  :arith-fixed-eqs         263
;  :arith-gcd-tests         1
;  :arith-grobner           85
;  :arith-ineq-splits       1
;  :arith-max-min           1370
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        267
;  :arith-patches           1
;  :arith-pivots            474
;  :conflicts               266
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 369
;  :datatype-occurs-check   242
;  :datatype-splits         272
;  :decisions               1163
;  :del-clause              4006
;  :final-checks            250
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.10
;  :minimized-lits          1
;  :mk-bool-var             6126
;  :mk-clause               4023
;  :num-allocs              191411
;  :num-checks              132
;  :propagations            2019
;  :quant-instantiations    1225
;  :rlimit-count            296061
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((unknown@54@03 Int) (unknown1@55@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@55@03 V@7@03) (<= 0 unknown1@55@03))
        (< unknown@54@03 V@7@03))
      (<= 0 unknown@54@03))
    (and
      (=
        (inv@56@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))) unknown@54@03))
        unknown@54@03)
      (=
        (inv@57@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))) unknown@54@03))
        unknown1@55@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))) unknown@54@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@57@03 r) V@7@03) (<= 0 (inv@57@03 r)))
        (< (inv@56@03 r) V@7@03))
      (<= 0 (inv@56@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) (inv@57@03 r)))) (inv@56@03 r))
      r))
  :pattern ((inv@56@03 r))
  :pattern ((inv@57@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@54@03 Int) (unknown1@55@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@55@03 V@7@03) (<= 0 unknown1@55@03))
        (< unknown@54@03 V@7@03))
      (<= 0 unknown@54@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))) unknown@54@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@55@03))) unknown@54@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@58@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@57@03 r) V@7@03) (<= 0 (inv@57@03 r)))
        (< (inv@56@03 r) V@7@03))
      (<= 0 (inv@56@03 r)))
    (=
      ($FVF.lookup_int (as sm@58@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@58@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r))
  :qid |qp.fvfValDef15|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@58@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef16|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@57@03 r) V@7@03) (<= 0 (inv@57@03 r)))
        (< (inv@56@03 r) V@7@03))
      (<= 0 (inv@56@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@58@03  $FVF<Int>) r) r))
  :pattern ((inv@56@03 r) (inv@57@03 r))
  )))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@8@03 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3701
;  :arith-add-rows          1034
;  :arith-assert-diseq      55
;  :arith-assert-lower      1449
;  :arith-assert-upper      1000
;  :arith-bound-prop        86
;  :arith-conflicts         136
;  :arith-eq-adapter        295
;  :arith-fixed-eqs         263
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1411
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        267
;  :arith-patches           1
;  :arith-pivots            474
;  :conflicts               266
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 377
;  :datatype-occurs-check   247
;  :datatype-splits         276
;  :decisions               1171
;  :del-clause              4006
;  :final-checks            254
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.11
;  :minimized-lits          1
;  :mk-bool-var             6136
;  :mk-clause               4023
;  :num-allocs              193208
;  :num-checks              133
;  :propagations            2019
;  :quant-instantiations    1225
;  :rlimit-count            300065
;  :time                    0.00)
; [then-branch: 86 | exc@8@03 == Null | live]
; [else-branch: 86 | exc@8@03 != Null | dead]
(push) ; 8
; [then-branch: 86 | exc@8@03 == Null]
(declare-const unknown@59@03 Int)
(declare-const unknown1@60@03 Int)
(push) ; 9
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 10
; [then-branch: 87 | 0 <= unknown@59@03 | live]
; [else-branch: 87 | !(0 <= unknown@59@03) | live]
(push) ; 11
; [then-branch: 87 | 0 <= unknown@59@03]
(assert (<= 0 unknown@59@03))
; [eval] unknown < V
(push) ; 12
; [then-branch: 88 | unknown@59@03 < V@7@03 | live]
; [else-branch: 88 | !(unknown@59@03 < V@7@03) | live]
(push) ; 13
; [then-branch: 88 | unknown@59@03 < V@7@03]
(assert (< unknown@59@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 14
; [then-branch: 89 | 0 <= unknown1@60@03 | live]
; [else-branch: 89 | !(0 <= unknown1@60@03) | live]
(push) ; 15
; [then-branch: 89 | 0 <= unknown1@60@03]
(assert (<= 0 unknown1@60@03))
; [eval] unknown1 < V
(pop) ; 15
(push) ; 15
; [else-branch: 89 | !(0 <= unknown1@60@03)]
(assert (not (<= 0 unknown1@60@03)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 88 | !(unknown@59@03 < V@7@03)]
(assert (not (< unknown@59@03 V@7@03)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 87 | !(0 <= unknown@59@03)]
(assert (not (<= 0 unknown@59@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@60@03 V@7@03) (<= 0 unknown1@60@03))
    (< unknown@59@03 V@7@03))
  (<= 0 unknown@59@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 11
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3701
;  :arith-add-rows          1034
;  :arith-assert-diseq      55
;  :arith-assert-lower      1455
;  :arith-assert-upper      1000
;  :arith-bound-prop        86
;  :arith-conflicts         136
;  :arith-eq-adapter        295
;  :arith-fixed-eqs         263
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1411
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        267
;  :arith-patches           1
;  :arith-pivots            477
;  :conflicts               266
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 377
;  :datatype-occurs-check   247
;  :datatype-splits         276
;  :decisions               1171
;  :del-clause              4006
;  :final-checks            254
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.11
;  :minimized-lits          1
;  :mk-bool-var             6142
;  :mk-clause               4023
;  :num-allocs              193478
;  :num-checks              134
;  :propagations            2019
;  :quant-instantiations    1225
;  :rlimit-count            300535)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (< unknown1@60@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3701
;  :arith-add-rows          1034
;  :arith-assert-diseq      55
;  :arith-assert-lower      1455
;  :arith-assert-upper      1000
;  :arith-bound-prop        86
;  :arith-conflicts         136
;  :arith-eq-adapter        295
;  :arith-fixed-eqs         263
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1411
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        267
;  :arith-patches           1
;  :arith-pivots            477
;  :conflicts               266
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 377
;  :datatype-occurs-check   247
;  :datatype-splits         276
;  :decisions               1171
;  :del-clause              4006
;  :final-checks            254
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.11
;  :minimized-lits          1
;  :mk-bool-var             6142
;  :mk-clause               4023
;  :num-allocs              193499
;  :num-checks              135
;  :propagations            2019
;  :quant-instantiations    1225
;  :rlimit-count            300566)
(assert (< unknown1@60@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 10
; Joined path conditions
(assert (< unknown1@60@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03)))
(push) ; 10
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))
          V@7@03)
        (<=
          0
          (inv@48@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@47@03)
      $Perm.No)
    (ite
      (and
        (<
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))
          V@7@03)
        (<=
          0
          (inv@40@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))))
      (* (scale $Snap.unit (* (to_real (* V@7@03 V@7@03)) $Perm.Write)) $k@39@03)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3895
;  :arith-add-rows          1073
;  :arith-assert-diseq      56
;  :arith-assert-lower      1500
;  :arith-assert-upper      1042
;  :arith-bound-prop        87
;  :arith-conflicts         143
;  :arith-eq-adapter        312
;  :arith-fixed-eqs         284
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1441
;  :arith-nonlinear-bounds  168
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        288
;  :arith-patches           1
;  :arith-pivots            497
;  :conflicts               280
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 394
;  :datatype-occurs-check   255
;  :datatype-splits         294
;  :decisions               1246
;  :del-clause              4243
;  :final-checks            263
;  :interface-eqs           29
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.12
;  :minimized-lits          2
;  :mk-bool-var             6515
;  :mk-clause               4309
;  :num-allocs              194646
;  :num-checks              136
;  :propagations            2139
;  :quant-instantiations    1287
;  :rlimit-count            306003
;  :time                    0.00)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 11
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4033
;  :arith-add-rows          1094
;  :arith-assert-diseq      56
;  :arith-assert-lower      1523
;  :arith-assert-upper      1072
;  :arith-bound-prop        88
;  :arith-conflicts         147
;  :arith-eq-adapter        318
;  :arith-fixed-eqs         295
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1471
;  :arith-nonlinear-bounds  175
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        303
;  :arith-patches           1
;  :arith-pivots            502
;  :conflicts               291
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 411
;  :datatype-occurs-check   263
;  :datatype-splits         312
;  :decisions               1301
;  :del-clause              4358
;  :final-checks            272
;  :interface-eqs           32
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.12
;  :minimized-lits          2
;  :mk-bool-var             6686
;  :mk-clause               4424
;  :num-allocs              195100
;  :num-checks              137
;  :propagations            2194
;  :quant-instantiations    1300
;  :rlimit-count            308219
;  :time                    0.00)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))
    (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))
    (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (<
  unknown@59@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03)))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4199
;  :arith-add-rows          1121
;  :arith-assert-diseq      56
;  :arith-assert-lower      1553
;  :arith-assert-upper      1108
;  :arith-bound-prop        88
;  :arith-conflicts         153
;  :arith-eq-adapter        328
;  :arith-fixed-eqs         310
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1501
;  :arith-nonlinear-bounds  182
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        322
;  :arith-patches           1
;  :arith-pivots            509
;  :conflicts               303
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 428
;  :datatype-occurs-check   271
;  :datatype-splits         330
;  :decisions               1358
;  :del-clause              4475
;  :final-checks            281
;  :interface-eqs           35
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.16
;  :minimized-lits          2
;  :mk-bool-var             6879
;  :mk-clause               4541
;  :num-allocs              195695
;  :num-checks              138
;  :propagations            2257
;  :quant-instantiations    1322
;  :rlimit-count            310969
;  :time                    0.00)
(assert (<
  unknown@59@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))))))
(pop) ; 10
; Joined path conditions
(assert (<
  unknown@59@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))))))
(pop) ; 9
(declare-fun inv@61@03 ($Ref) Int)
(declare-fun inv@62@03 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@59@03 Int) (unknown1@60@03 Int)) (!
  (and
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< unknown1@60@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@59@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))) unknown@59@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 9
(assert (not (forall ((unknown1@59@03 Int) (unknown11@60@03 Int) (unknown2@59@03 Int) (unknown12@60@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@60@03 V@7@03) (<= 0 unknown11@60@03))
          (< unknown1@59@03 V@7@03))
        (<= 0 unknown1@59@03))
      (and
        (and
          (and (< unknown12@60@03 V@7@03) (<= 0 unknown12@60@03))
          (< unknown2@59@03 V@7@03))
        (<= 0 unknown2@59@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown11@60@03))) unknown1@59@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown12@60@03))) unknown2@59@03)))
    (and (= unknown1@59@03 unknown2@59@03) (= unknown11@60@03 unknown12@60@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4513
;  :arith-add-rows          1256
;  :arith-assert-diseq      58
;  :arith-assert-lower      1611
;  :arith-assert-upper      1157
;  :arith-bound-prop        100
;  :arith-conflicts         156
;  :arith-eq-adapter        343
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            549
;  :conflicts               315
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4842
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7410
;  :mk-clause               4859
;  :num-allocs              198035
;  :num-checks              139
;  :propagations            2412
;  :quant-instantiations    1438
;  :rlimit-count            321510
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((unknown@59@03 Int) (unknown1@60@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@60@03 V@7@03) (<= 0 unknown1@60@03))
        (< unknown@59@03 V@7@03))
      (<= 0 unknown@59@03))
    (and
      (=
        (inv@61@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))) unknown@59@03))
        unknown@59@03)
      (=
        (inv@62@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))) unknown@59@03))
        unknown1@60@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))) unknown@59@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@62@03 r) V@7@03) (<= 0 (inv@62@03 r)))
        (< (inv@61@03 r) V@7@03))
      (<= 0 (inv@61@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) (inv@62@03 r)))) (inv@61@03 r))
      r))
  :pattern ((inv@61@03 r))
  :pattern ((inv@62@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@59@03 Int) (unknown1@60@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@60@03 V@7@03) (<= 0 unknown1@60@03))
        (< unknown@59@03 V@7@03))
      (<= 0 unknown@59@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))) unknown@59@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@49@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@60@03))) unknown@59@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@63@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@62@03 r) V@7@03) (<= 0 (inv@62@03 r)))
        (< (inv@61@03 r) V@7@03))
      (<= 0 (inv@61@03 r)))
    (=
      ($FVF.lookup_int (as sm@63@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@63@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r))
  :qid |qp.fvfValDef17|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@57@03 r) V@7@03) (<= 0 (inv@57@03 r)))
        (< (inv@56@03 r) V@7@03))
      (<= 0 (inv@56@03 r)))
    (=
      ($FVF.lookup_int (as sm@63@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@63@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r))
  :qid |qp.fvfValDef18|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@37@03))))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@63@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef19|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@62@03 r) V@7@03) (<= 0 (inv@62@03 r)))
        (< (inv@61@03 r) V@7@03))
      (<= 0 (inv@61@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@63@03  $FVF<Int>) r) r))
  :pattern ((inv@61@03 r) (inv@62@03 r))
  )))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(push) ; 4
; [exec]
; inhale false
(pop) ; 4
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 2 | !(0 < V@7@03)]
(assert (not (< 0 V@7@03)))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@10@03))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
; [then-branch: 90 | 0 < V@7@03 | dead]
; [else-branch: 90 | !(0 < V@7@03) | live]
(push) ; 4
; [else-branch: 90 | !(0 < V@7@03)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
; [then-branch: 91 | 0 < V@7@03 | dead]
; [else-branch: 91 | !(0 < V@7@03) | live]
(push) ; 4
; [else-branch: 91 | !(0 < V@7@03)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 3
; [then-branch: 92 | 0 < V@7@03 | dead]
; [else-branch: 92 | !(0 < V@7@03) | live]
(push) ; 4
; [else-branch: 92 | !(0 < V@7@03)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
; [then-branch: 93 | 0 < V@7@03 | dead]
; [else-branch: 93 | !(0 < V@7@03) | live]
(push) ; 4
; [else-branch: 93 | !(0 < V@7@03)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
; [then-branch: 94 | 0 < V@7@03 | dead]
; [else-branch: 94 | !(0 < V@7@03) | live]
(push) ; 4
; [else-branch: 94 | !(0 < V@7@03)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
; [eval] 0 < V
; [then-branch: 95 | 0 < V@7@03 | dead]
; [else-branch: 95 | !(0 < V@7@03) | live]
(push) ; 3
; [else-branch: 95 | !(0 < V@7@03)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
; [then-branch: 96 | 0 < V@7@03 | dead]
; [else-branch: 96 | !(0 < V@7@03) | live]
(push) ; 5
; [else-branch: 96 | !(0 < V@7@03)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
; [then-branch: 97 | 0 < V@7@03 | dead]
; [else-branch: 97 | !(0 < V@7@03) | live]
(push) ; 5
; [else-branch: 97 | !(0 < V@7@03)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 4
; [then-branch: 98 | 0 < V@7@03 | dead]
; [else-branch: 98 | !(0 < V@7@03) | live]
(push) ; 5
; [else-branch: 98 | !(0 < V@7@03)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03))))))))))))))))
(declare-const unknown@64@03 Int)
(declare-const unknown1@65@03 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 99 | 0 <= unknown@64@03 | live]
; [else-branch: 99 | !(0 <= unknown@64@03) | live]
(push) ; 6
; [then-branch: 99 | 0 <= unknown@64@03]
(assert (<= 0 unknown@64@03))
; [eval] unknown < V
(push) ; 7
; [then-branch: 100 | unknown@64@03 < V@7@03 | live]
; [else-branch: 100 | !(unknown@64@03 < V@7@03) | live]
(push) ; 8
; [then-branch: 100 | unknown@64@03 < V@7@03]
(assert (< unknown@64@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 101 | 0 <= unknown1@65@03 | live]
; [else-branch: 101 | !(0 <= unknown1@65@03) | live]
(push) ; 10
; [then-branch: 101 | 0 <= unknown1@65@03]
(assert (<= 0 unknown1@65@03))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 101 | !(0 <= unknown1@65@03)]
(assert (not (<= 0 unknown1@65@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 100 | !(unknown@64@03 < V@7@03)]
(assert (not (< unknown@64@03 V@7@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 99 | !(0 <= unknown@64@03)]
(assert (not (<= 0 unknown@64@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@65@03 V@7@03) (<= 0 unknown1@65@03))
    (< unknown@64@03 V@7@03))
  (<= 0 unknown@64@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4573
;  :arith-add-rows          1256
;  :arith-assert-diseq      58
;  :arith-assert-lower      1615
;  :arith-assert-upper      1160
;  :arith-bound-prop        100
;  :arith-conflicts         158
;  :arith-eq-adapter        343
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            555
;  :conflicts               318
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4853
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.22
;  :minimized-lits          2
;  :mk-bool-var             7437
;  :mk-clause               4859
;  :num-allocs              199761
;  :num-checks              140
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            324449)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@65@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4573
;  :arith-add-rows          1257
;  :arith-assert-diseq      58
;  :arith-assert-lower      1615
;  :arith-assert-upper      1160
;  :arith-bound-prop        100
;  :arith-conflicts         158
;  :arith-eq-adapter        343
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            555
;  :conflicts               319
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4853
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.22
;  :minimized-lits          2
;  :mk-bool-var             7439
;  :mk-clause               4859
;  :num-allocs              199917
;  :num-checks              141
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            324603)
(assert (< unknown1@65@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@65@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(declare-const sm@66@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@67@03 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@67@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@67@03  $FPM) r))
  :qid |qp.resPrmSumDef21|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@67@03  $FPM) r))
  :qid |qp.resTrgDef22|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03)))
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@67@03  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4573
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1615
;  :arith-assert-upper      1160
;  :arith-bound-prop        100
;  :arith-conflicts         158
;  :arith-eq-adapter        343
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            555
;  :conflicts               320
;  :datatype-accessor-ax    136
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4853
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.22
;  :minimized-lits          2
;  :mk-bool-var             7444
;  :mk-clause               4859
;  :num-allocs              200322
;  :num-checks              142
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            325057)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4573
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1615
;  :arith-assert-upper      1160
;  :arith-bound-prop        100
;  :arith-conflicts         158
;  :arith-eq-adapter        343
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            555
;  :conflicts               321
;  :datatype-accessor-ax    136
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4853
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.22
;  :minimized-lits          2
;  :mk-bool-var             7445
;  :mk-clause               4859
;  :num-allocs              200412
;  :num-checks              143
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            325146)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@64@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4573
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1615
;  :arith-assert-upper      1160
;  :arith-bound-prop        100
;  :arith-conflicts         158
;  :arith-eq-adapter        343
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            555
;  :conflicts               322
;  :datatype-accessor-ax    136
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4853
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.22
;  :minimized-lits          2
;  :mk-bool-var             7447
;  :mk-clause               4859
;  :num-allocs              200565
;  :num-checks              144
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            325399)
(assert (<
  unknown@64@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@64@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))))))
(pop) ; 4
(declare-fun inv@68@03 ($Ref) Int)
(declare-fun inv@69@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@67@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@67@03  $FPM) r))
  :qid |qp.resPrmSumDef21|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@67@03  $FPM) r))
  :qid |qp.resTrgDef22|)))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@64@03 Int) (unknown1@65@03 Int)) (!
  (and
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< unknown1@65@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@64@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))) unknown@64@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@64@03 Int) (unknown11@65@03 Int) (unknown2@64@03 Int) (unknown12@65@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@65@03 V@7@03) (<= 0 unknown11@65@03))
          (< unknown1@64@03 V@7@03))
        (<= 0 unknown1@64@03))
      (and
        (and
          (and (< unknown12@65@03 V@7@03) (<= 0 unknown12@65@03))
          (< unknown2@64@03 V@7@03))
        (<= 0 unknown2@64@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown11@65@03))) unknown1@64@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown12@65@03))) unknown2@64@03)))
    (and (= unknown1@64@03 unknown2@64@03) (= unknown11@65@03 unknown12@65@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1622
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         159
;  :arith-eq-adapter        345
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               323
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4862
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7465
;  :mk-clause               4868
;  :num-allocs              201395
;  :num-checks              145
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            326883)
; Definitional axioms for inverse functions
(assert (forall ((unknown@64@03 Int) (unknown1@65@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@65@03 V@7@03) (<= 0 unknown1@65@03))
        (< unknown@64@03 V@7@03))
      (<= 0 unknown@64@03))
    (and
      (=
        (inv@68@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))) unknown@64@03))
        unknown@64@03)
      (=
        (inv@69@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))) unknown@64@03))
        unknown1@65@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))) unknown@64@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@69@03 r) V@7@03) (<= 0 (inv@69@03 r)))
        (< (inv@68@03 r) V@7@03))
      (<= 0 (inv@68@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) (inv@69@03 r)))) (inv@68@03 r))
      r))
  :pattern ((inv@68@03 r))
  :pattern ((inv@69@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@64@03 Int) (unknown1@65@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@65@03 V@7@03) (<= 0 unknown1@65@03))
        (< unknown@64@03 V@7@03))
      (<= 0 unknown@64@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))) unknown@64@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@66@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@65@03))) unknown@64@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@70@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@69@03 r) V@7@03) (<= 0 (inv@69@03 r)))
        (< (inv@68@03 r) V@7@03))
      (<= 0 (inv@68@03 r)))
    (=
      ($FVF.lookup_int (as sm@70@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@70@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r))
  :qid |qp.fvfValDef23|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@70@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef24|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@69@03 r) V@7@03) (<= 0 (inv@69@03 r)))
        (< (inv@68@03 r) V@7@03))
      (<= 0 (inv@68@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@70@03  $FVF<Int>) r) r))
  :pattern ((inv@68@03 r) (inv@69@03 r))
  )))
(declare-const unknown@71@03 Int)
(declare-const unknown1@72@03 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 102 | 0 <= unknown@71@03 | live]
; [else-branch: 102 | !(0 <= unknown@71@03) | live]
(push) ; 6
; [then-branch: 102 | 0 <= unknown@71@03]
(assert (<= 0 unknown@71@03))
; [eval] unknown < V
(push) ; 7
; [then-branch: 103 | unknown@71@03 < V@7@03 | live]
; [else-branch: 103 | !(unknown@71@03 < V@7@03) | live]
(push) ; 8
; [then-branch: 103 | unknown@71@03 < V@7@03]
(assert (< unknown@71@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 104 | 0 <= unknown1@72@03 | live]
; [else-branch: 104 | !(0 <= unknown1@72@03) | live]
(push) ; 10
; [then-branch: 104 | 0 <= unknown1@72@03]
(assert (<= 0 unknown1@72@03))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 104 | !(0 <= unknown1@72@03)]
(assert (not (<= 0 unknown1@72@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 103 | !(unknown@71@03 < V@7@03)]
(assert (not (< unknown@71@03 V@7@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 102 | !(0 <= unknown@71@03)]
(assert (not (<= 0 unknown@71@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@72@03 V@7@03) (<= 0 unknown1@72@03))
    (< unknown@71@03 V@7@03))
  (<= 0 unknown@71@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1628
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         161
;  :arith-eq-adapter        345
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               326
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4862
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7477
;  :mk-clause               4868
;  :num-allocs              202683
;  :num-checks              146
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            330025)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@72@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1628
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         161
;  :arith-eq-adapter        345
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               327
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4862
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7478
;  :mk-clause               4868
;  :num-allocs              202825
;  :num-checks              147
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            330170)
(assert (< unknown1@72@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@72@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(declare-const sm@73@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@74@03 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@74@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@74@03  $FPM) r))
  :qid |qp.resPrmSumDef26|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@74@03  $FPM) r))
  :qid |qp.resTrgDef27|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03)))
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@74@03  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1628
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         161
;  :arith-eq-adapter        345
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               328
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4862
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7483
;  :mk-clause               4868
;  :num-allocs              203201
;  :num-checks              148
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            330623)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1628
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         161
;  :arith-eq-adapter        345
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               329
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4862
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7484
;  :mk-clause               4868
;  :num-allocs              203291
;  :num-checks              149
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            330712)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@71@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1628
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         161
;  :arith-eq-adapter        345
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               330
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4862
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7486
;  :mk-clause               4868
;  :num-allocs              203446
;  :num-checks              150
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            330965)
(assert (<
  unknown@71@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@71@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))))))
(pop) ; 4
(declare-fun inv@75@03 ($Ref) Int)
(declare-fun inv@76@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@74@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@74@03  $FPM) r))
  :qid |qp.resPrmSumDef26|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@74@03  $FPM) r))
  :qid |qp.resTrgDef27|)))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@71@03 Int) (unknown1@72@03 Int)) (!
  (and
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< unknown1@72@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@71@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))) unknown@71@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@71@03 Int) (unknown11@72@03 Int) (unknown2@71@03 Int) (unknown12@72@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@72@03 V@7@03) (<= 0 unknown11@72@03))
          (< unknown1@71@03 V@7@03))
        (<= 0 unknown1@71@03))
      (and
        (and
          (and (< unknown12@72@03 V@7@03) (<= 0 unknown12@72@03))
          (< unknown2@71@03 V@7@03))
        (<= 0 unknown2@71@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown11@72@03))) unknown1@71@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown12@72@03))) unknown2@71@03)))
    (and (= unknown1@71@03 unknown2@71@03) (= unknown11@72@03 unknown12@72@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4578
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1636
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         162
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               331
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   287
;  :datatype-splits         360
;  :decisions               1434
;  :del-clause              4871
;  :final-checks            294
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7505
;  :mk-clause               4877
;  :num-allocs              204253
;  :num-checks              151
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            332456)
; Definitional axioms for inverse functions
(assert (forall ((unknown@71@03 Int) (unknown1@72@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@72@03 V@7@03) (<= 0 unknown1@72@03))
        (< unknown@71@03 V@7@03))
      (<= 0 unknown@71@03))
    (and
      (=
        (inv@75@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))) unknown@71@03))
        unknown@71@03)
      (=
        (inv@76@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))) unknown@71@03))
        unknown1@72@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))) unknown@71@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@76@03 r) V@7@03) (<= 0 (inv@76@03 r)))
        (< (inv@75@03 r) V@7@03))
      (<= 0 (inv@75@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) (inv@76@03 r)))) (inv@75@03 r))
      r))
  :pattern ((inv@75@03 r))
  :pattern ((inv@76@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@71@03 Int) (unknown1@72@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@72@03 V@7@03) (<= 0 unknown1@72@03))
        (< unknown@71@03 V@7@03))
      (<= 0 unknown@71@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))) unknown@71@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@73@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@72@03))) unknown@71@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@77@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@76@03 r) V@7@03) (<= 0 (inv@76@03 r)))
        (< (inv@75@03 r) V@7@03))
      (<= 0 (inv@75@03 r)))
    (=
      ($FVF.lookup_int (as sm@77@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@77@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r))
  :qid |qp.fvfValDef28|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@69@03 r) V@7@03) (<= 0 (inv@69@03 r)))
        (< (inv@68@03 r) V@7@03))
      (<= 0 (inv@68@03 r)))
    (=
      ($FVF.lookup_int (as sm@77@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@77@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r))
  :qid |qp.fvfValDef29|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@03)))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@77@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef30|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@76@03 r) V@7@03) (<= 0 (inv@76@03 r)))
        (< (inv@75@03 r) V@7@03))
      (<= 0 (inv@75@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@77@03  $FVF<Int>) r) r))
  :pattern ((inv@75@03 r) (inv@76@03 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 4
(declare-const $t@78@03 $Snap)
(assert (= $t@78@03 ($Snap.combine ($Snap.first $t@78@03) ($Snap.second $t@78@03))))
(assert (= ($Snap.first $t@78@03) $Snap.unit))
; [eval] exc == null
(assert (= exc@8@03 $Ref.null))
(assert (=
  ($Snap.second $t@78@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@78@03))
    ($Snap.second ($Snap.second $t@78@03)))))
(assert (= ($Snap.first ($Snap.second $t@78@03)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 105 | exc@8@03 == Null | live]
; [else-branch: 105 | exc@8@03 != Null | live]
(push) ; 6
; [then-branch: 105 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 105 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4597
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1636
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         162
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               331
;  :datatype-accessor-ax    139
;  :datatype-constructor-ax 460
;  :datatype-occurs-check   290
;  :datatype-splits         362
;  :decisions               1436
;  :del-clause              4871
;  :final-checks            296
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7519
;  :mk-clause               4877
;  :num-allocs              205908
;  :num-checks              153
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            336603)
; [then-branch: 106 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 106 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 6
; [else-branch: 106 | !(0 < V@7@03 && exc@8@03 == Null)]
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second $t@78@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@78@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@78@03))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 107 | exc@8@03 == Null | live]
; [else-branch: 107 | exc@8@03 != Null | live]
(push) ; 6
; [then-branch: 107 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 107 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4603
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1636
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         162
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               331
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 460
;  :datatype-occurs-check   290
;  :datatype-splits         362
;  :decisions               1436
;  :del-clause              4871
;  :final-checks            296
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7521
;  :mk-clause               4877
;  :num-allocs              206015
;  :num-checks              154
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            336810)
; [then-branch: 108 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 108 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 6
; [else-branch: 108 | !(0 < V@7@03 && exc@8@03 == Null)]
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@78@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 109 | exc@8@03 == Null | live]
; [else-branch: 109 | exc@8@03 != Null | live]
(push) ; 6
; [then-branch: 109 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 109 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4608
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1636
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         162
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               331
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 460
;  :datatype-occurs-check   290
;  :datatype-splits         362
;  :decisions               1436
;  :del-clause              4871
;  :final-checks            296
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7522
;  :mk-clause               4877
;  :num-allocs              206124
;  :num-checks              155
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            336990)
; [then-branch: 110 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 110 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 5
; [else-branch: 110 | !(0 < V@7@03 && exc@8@03 == Null)]
(assert (not (and (< 0 V@7@03) (= exc@8@03 $Ref.null))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@03))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 111 | exc@8@03 == Null | live]
; [else-branch: 111 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 111 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 111 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 112 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 112 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 7
; [else-branch: 112 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 113 | exc@8@03 == Null | live]
; [else-branch: 113 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 113 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 113 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 114 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 114 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 7
; [else-branch: 114 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 115 | exc@8@03 == Null | live]
; [else-branch: 115 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 115 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 115 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 116 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 116 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 7
; [else-branch: 116 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 117 | exc@8@03 == Null | live]
; [else-branch: 117 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 117 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 117 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 118 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 118 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 7
; [else-branch: 118 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 119 | exc@8@03 == Null | live]
; [else-branch: 119 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 119 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 119 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 120 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 120 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 7
; [else-branch: 120 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 121 | exc@8@03 == Null | live]
; [else-branch: 121 | exc@8@03 != Null | live]
(push) ; 7
; [then-branch: 121 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 121 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
; [then-branch: 122 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 122 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 6
; [else-branch: 122 | !(0 < V@7@03 && exc@8@03 == Null)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 123 | exc@8@03 == Null | live]
; [else-branch: 123 | exc@8@03 != Null | live]
(push) ; 8
; [then-branch: 123 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 123 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 124 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 124 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 8
; [else-branch: 124 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 125 | exc@8@03 == Null | live]
; [else-branch: 125 | exc@8@03 != Null | live]
(push) ; 8
; [then-branch: 125 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 125 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 126 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 126 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 8
; [else-branch: 126 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 127 | exc@8@03 == Null | live]
; [else-branch: 127 | exc@8@03 != Null | live]
(push) ; 8
; [then-branch: 127 | exc@8@03 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 127 | exc@8@03 != Null]
(assert (not (= exc@8@03 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 128 | 0 < V@7@03 && exc@8@03 == Null | dead]
; [else-branch: 128 | !(0 < V@7@03 && exc@8@03 == Null) | live]
(push) ; 8
; [else-branch: 128 | !(0 < V@7@03 && exc@8@03 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03)))))))))))))))))
; [eval] exc == null
(push) ; 7
(assert (not (not (= exc@8@03 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4691
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1636
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         162
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            556
;  :conflicts               331
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   295
;  :datatype-splits         364
;  :decisions               1440
;  :del-clause              4871
;  :final-checks            298
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7544
;  :mk-clause               4877
;  :num-allocs              207647
;  :num-checks              156
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            339904)
; [then-branch: 129 | exc@8@03 == Null | live]
; [else-branch: 129 | exc@8@03 != Null | dead]
(push) ; 7
; [then-branch: 129 | exc@8@03 == Null]
(declare-const unknown@79@03 Int)
(declare-const unknown1@80@03 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 130 | 0 <= unknown@79@03 | live]
; [else-branch: 130 | !(0 <= unknown@79@03) | live]
(push) ; 10
; [then-branch: 130 | 0 <= unknown@79@03]
(assert (<= 0 unknown@79@03))
; [eval] unknown < V
(push) ; 11
; [then-branch: 131 | unknown@79@03 < V@7@03 | live]
; [else-branch: 131 | !(unknown@79@03 < V@7@03) | live]
(push) ; 12
; [then-branch: 131 | unknown@79@03 < V@7@03]
(assert (< unknown@79@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 13
; [then-branch: 132 | 0 <= unknown1@80@03 | live]
; [else-branch: 132 | !(0 <= unknown1@80@03) | live]
(push) ; 14
; [then-branch: 132 | 0 <= unknown1@80@03]
(assert (<= 0 unknown1@80@03))
; [eval] unknown1 < V
(pop) ; 14
(push) ; 14
; [else-branch: 132 | !(0 <= unknown1@80@03)]
(assert (not (<= 0 unknown1@80@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 131 | !(unknown@79@03 < V@7@03)]
(assert (not (< unknown@79@03 V@7@03)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 130 | !(0 <= unknown@79@03)]
(assert (not (<= 0 unknown@79@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@80@03 V@7@03) (<= 0 unknown1@80@03))
    (< unknown@79@03 V@7@03))
  (<= 0 unknown@79@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@5@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4691
;  :arith-add-rows          1258
;  :arith-assert-diseq      58
;  :arith-assert-lower      1642
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         164
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            559
;  :conflicts               334
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   295
;  :datatype-splits         364
;  :decisions               1440
;  :del-clause              4871
;  :final-checks            298
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7551
;  :mk-clause               4877
;  :num-allocs              207978
;  :num-checks              157
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            340394)
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@5@03 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< unknown1@80@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4691
;  :arith-add-rows          1259
;  :arith-assert-diseq      58
;  :arith-assert-lower      1642
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         164
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            559
;  :conflicts               335
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   295
;  :datatype-splits         364
;  :decisions               1440
;  :del-clause              4871
;  :final-checks            298
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7553
;  :mk-clause               4877
;  :num-allocs              208121
;  :num-checks              158
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            340540)
(assert (< unknown1@80@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(pop) ; 9
; Joined path conditions
(assert (< unknown1@80@03 (alen<Int> (opt_get1 $Snap.unit target@5@03))))
(declare-const sm@81@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@82@03 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@82@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@82@03  $FPM) r))
  :qid |qp.resPrmSumDef32|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@82@03  $FPM) r))
  :qid |qp.resTrgDef33|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03)))
(push) ; 9
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@82@03  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4691
;  :arith-add-rows          1260
;  :arith-assert-diseq      58
;  :arith-assert-lower      1642
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         164
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            559
;  :conflicts               336
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   295
;  :datatype-splits         364
;  :decisions               1440
;  :del-clause              4871
;  :final-checks            298
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7558
;  :mk-clause               4877
;  :num-allocs              208502
;  :num-checks              159
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            340994)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4691
;  :arith-add-rows          1260
;  :arith-assert-diseq      58
;  :arith-assert-lower      1642
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         164
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            559
;  :conflicts               337
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   295
;  :datatype-splits         364
;  :decisions               1440
;  :del-clause              4871
;  :final-checks            298
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7559
;  :mk-clause               4877
;  :num-allocs              208592
;  :num-checks              160
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            341083)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  unknown@79@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4691
;  :arith-add-rows          1260
;  :arith-assert-diseq      58
;  :arith-assert-lower      1642
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         164
;  :arith-eq-adapter        347
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            559
;  :conflicts               338
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   295
;  :datatype-splits         364
;  :decisions               1440
;  :del-clause              4871
;  :final-checks            298
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7561
;  :mk-clause               4877
;  :num-allocs              208742
;  :num-checks              161
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            341332)
(assert (<
  unknown@79@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))))))
(pop) ; 9
; Joined path conditions
(assert (<
  unknown@79@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))))))
(pop) ; 8
(declare-fun inv@83@03 ($Ref) Int)
(declare-fun inv@84@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@82@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@82@03  $FPM) r))
  :qid |qp.resPrmSumDef32|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@82@03  $FPM) r))
  :qid |qp.resTrgDef33|)))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@79@03 Int) (unknown1@80@03 Int)) (!
  (and
    (not (= target@5@03 (as None<option<array>>  option<array>)))
    (< unknown1@80@03 (alen<Int> (opt_get1 $Snap.unit target@5@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@79@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))) unknown@79@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 8
(assert (not (forall ((unknown1@79@03 Int) (unknown11@80@03 Int) (unknown2@79@03 Int) (unknown12@80@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@80@03 V@7@03) (<= 0 unknown11@80@03))
          (< unknown1@79@03 V@7@03))
        (<= 0 unknown1@79@03))
      (and
        (and
          (and (< unknown12@80@03 V@7@03) (<= 0 unknown12@80@03))
          (< unknown2@79@03 V@7@03))
        (<= 0 unknown2@79@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown11@80@03))) unknown1@79@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown12@80@03))) unknown2@79@03)))
    (and (= unknown1@79@03 unknown2@79@03) (= unknown11@80@03 unknown12@80@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4693
;  :arith-add-rows          1260
;  :arith-assert-diseq      58
;  :arith-assert-lower      1650
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         165
;  :arith-eq-adapter        349
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            560
;  :conflicts               339
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 464
;  :datatype-occurs-check   295
;  :datatype-splits         364
;  :decisions               1440
;  :del-clause              4880
;  :final-checks            298
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7580
;  :mk-clause               4886
;  :num-allocs              209537
;  :num-checks              162
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            342826)
; Definitional axioms for inverse functions
(assert (forall ((unknown@79@03 Int) (unknown1@80@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@80@03 V@7@03) (<= 0 unknown1@80@03))
        (< unknown@79@03 V@7@03))
      (<= 0 unknown@79@03))
    (and
      (=
        (inv@83@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))) unknown@79@03))
        unknown@79@03)
      (=
        (inv@84@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))) unknown@79@03))
        unknown1@80@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))) unknown@79@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@84@03 r) V@7@03) (<= 0 (inv@84@03 r)))
        (< (inv@83@03 r) V@7@03))
      (<= 0 (inv@83@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@5@03) (inv@84@03 r)))) (inv@83@03 r))
      r))
  :pattern ((inv@83@03 r))
  :pattern ((inv@84@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@79@03 Int) (unknown1@80@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@80@03 V@7@03) (<= 0 unknown1@80@03))
        (< unknown@79@03 V@7@03))
      (<= 0 unknown@79@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))) unknown@79@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@81@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@5@03) unknown1@80@03))) unknown@79@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@85@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@84@03 r) V@7@03) (<= 0 (inv@84@03 r)))
        (< (inv@83@03 r) V@7@03))
      (<= 0 (inv@83@03 r)))
    (=
      ($FVF.lookup_int (as sm@85@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@85@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r))
  :qid |qp.fvfValDef34|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@85@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef35|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@84@03 r) V@7@03) (<= 0 (inv@84@03 r)))
        (< (inv@83@03 r) V@7@03))
      (<= 0 (inv@83@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@85@03  $FVF<Int>) r) r))
  :pattern ((inv@83@03 r) (inv@84@03 r))
  )))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@8@03 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4717
;  :arith-add-rows          1260
;  :arith-assert-diseq      58
;  :arith-assert-lower      1650
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         165
;  :arith-eq-adapter        349
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            560
;  :conflicts               339
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   300
;  :datatype-splits         366
;  :decisions               1444
;  :del-clause              4880
;  :final-checks            300
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7588
;  :mk-clause               4886
;  :num-allocs              210900
;  :num-checks              163
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            346018)
; [then-branch: 133 | exc@8@03 == Null | live]
; [else-branch: 133 | exc@8@03 != Null | dead]
(push) ; 8
; [then-branch: 133 | exc@8@03 == Null]
(declare-const unknown@86@03 Int)
(declare-const unknown1@87@03 Int)
(push) ; 9
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 10
; [then-branch: 134 | 0 <= unknown@86@03 | live]
; [else-branch: 134 | !(0 <= unknown@86@03) | live]
(push) ; 11
; [then-branch: 134 | 0 <= unknown@86@03]
(assert (<= 0 unknown@86@03))
; [eval] unknown < V
(push) ; 12
; [then-branch: 135 | unknown@86@03 < V@7@03 | live]
; [else-branch: 135 | !(unknown@86@03 < V@7@03) | live]
(push) ; 13
; [then-branch: 135 | unknown@86@03 < V@7@03]
(assert (< unknown@86@03 V@7@03))
; [eval] 0 <= unknown1
(push) ; 14
; [then-branch: 136 | 0 <= unknown1@87@03 | live]
; [else-branch: 136 | !(0 <= unknown1@87@03) | live]
(push) ; 15
; [then-branch: 136 | 0 <= unknown1@87@03]
(assert (<= 0 unknown1@87@03))
; [eval] unknown1 < V
(pop) ; 15
(push) ; 15
; [else-branch: 136 | !(0 <= unknown1@87@03)]
(assert (not (<= 0 unknown1@87@03)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 135 | !(unknown@86@03 < V@7@03)]
(assert (not (< unknown@86@03 V@7@03)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 134 | !(0 <= unknown@86@03)]
(assert (not (<= 0 unknown@86@03)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@87@03 V@7@03) (<= 0 unknown1@87@03))
    (< unknown@86@03 V@7@03))
  (<= 0 unknown@86@03)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 11
(assert (not (not (= source@6@03 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4717
;  :arith-add-rows          1260
;  :arith-assert-diseq      58
;  :arith-assert-lower      1656
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         167
;  :arith-eq-adapter        349
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            561
;  :conflicts               342
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   300
;  :datatype-splits         366
;  :decisions               1444
;  :del-clause              4880
;  :final-checks            300
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7594
;  :mk-clause               4886
;  :num-allocs              211231
;  :num-checks              164
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            346498)
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not (= source@6@03 (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (< unknown1@87@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4717
;  :arith-add-rows          1261
;  :arith-assert-diseq      58
;  :arith-assert-lower      1656
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         167
;  :arith-eq-adapter        349
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            561
;  :conflicts               343
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   300
;  :datatype-splits         366
;  :decisions               1444
;  :del-clause              4880
;  :final-checks            300
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7595
;  :mk-clause               4886
;  :num-allocs              211373
;  :num-checks              165
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            346644)
(assert (< unknown1@87@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(pop) ; 10
; Joined path conditions
(assert (< unknown1@87@03 (alen<Int> (opt_get1 $Snap.unit source@6@03))))
(declare-const sm@88@03 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@89@03 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@89@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@89@03  $FPM) r))
  :qid |qp.resPrmSumDef37|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@89@03  $FPM) r))
  :qid |qp.resTrgDef38|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03)))
(push) ; 10
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@89@03  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4717
;  :arith-add-rows          1262
;  :arith-assert-diseq      58
;  :arith-assert-lower      1656
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         167
;  :arith-eq-adapter        349
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            561
;  :conflicts               344
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   300
;  :datatype-splits         366
;  :decisions               1444
;  :del-clause              4880
;  :final-checks            300
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7600
;  :mk-clause               4886
;  :num-allocs              211748
;  :num-checks              166
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            347098)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 11
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4717
;  :arith-add-rows          1262
;  :arith-assert-diseq      58
;  :arith-assert-lower      1656
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         167
;  :arith-eq-adapter        349
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            561
;  :conflicts               345
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   300
;  :datatype-splits         366
;  :decisions               1444
;  :del-clause              4880
;  :final-checks            300
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7601
;  :mk-clause               4886
;  :num-allocs              211838
;  :num-checks              167
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            347187)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))
    (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))
    (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (<
  unknown@86@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03)))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4717
;  :arith-add-rows          1262
;  :arith-assert-diseq      58
;  :arith-assert-lower      1656
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         167
;  :arith-eq-adapter        349
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            561
;  :conflicts               346
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   300
;  :datatype-splits         366
;  :decisions               1444
;  :del-clause              4880
;  :final-checks            300
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7603
;  :mk-clause               4886
;  :num-allocs              211991
;  :num-checks              168
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            347440)
(assert (<
  unknown@86@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))))))
(pop) ; 10
; Joined path conditions
(assert (<
  unknown@86@03
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))))))
(pop) ; 9
(declare-fun inv@90@03 ($Ref) Int)
(declare-fun inv@91@03 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@89@03  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@89@03  $FPM) r))
  :qid |qp.resPrmSumDef37|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@89@03  $FPM) r))
  :qid |qp.resTrgDef38|)))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@86@03 Int) (unknown1@87@03 Int)) (!
  (and
    (not (= source@6@03 (as None<option<array>>  option<array>)))
    (< unknown1@87@03 (alen<Int> (opt_get1 $Snap.unit source@6@03)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))
        (as None<option<array>>  option<array>)))
    (<
      unknown@86@03
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))) unknown@86@03))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 9
(assert (not (forall ((unknown1@86@03 Int) (unknown11@87@03 Int) (unknown2@86@03 Int) (unknown12@87@03 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@87@03 V@7@03) (<= 0 unknown11@87@03))
          (< unknown1@86@03 V@7@03))
        (<= 0 unknown1@86@03))
      (and
        (and
          (and (< unknown12@87@03 V@7@03) (<= 0 unknown12@87@03))
          (< unknown2@86@03 V@7@03))
        (<= 0 unknown2@86@03))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown11@87@03))) unknown1@86@03)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown12@87@03))) unknown2@86@03)))
    (and (= unknown1@86@03 unknown2@86@03) (= unknown11@87@03 unknown12@87@03)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4719
;  :arith-add-rows          1263
;  :arith-assert-diseq      58
;  :arith-assert-lower      1664
;  :arith-assert-upper      1161
;  :arith-bound-prop        100
;  :arith-conflicts         168
;  :arith-eq-adapter        351
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         1
;  :arith-grobner           90
;  :arith-ineq-splits       1
;  :arith-max-min           1544
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        344
;  :arith-patches           1
;  :arith-pivots            564
;  :conflicts               347
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 468
;  :datatype-occurs-check   300
;  :datatype-splits         366
;  :decisions               1444
;  :del-clause              4889
;  :final-checks            300
;  :interface-eqs           39
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          2
;  :mk-bool-var             7622
;  :mk-clause               4895
;  :num-allocs              212794
;  :num-checks              169
;  :propagations            2413
;  :quant-instantiations    1438
;  :rlimit-count            348952)
; Definitional axioms for inverse functions
(assert (forall ((unknown@86@03 Int) (unknown1@87@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@87@03 V@7@03) (<= 0 unknown1@87@03))
        (< unknown@86@03 V@7@03))
      (<= 0 unknown@86@03))
    (and
      (=
        (inv@90@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))) unknown@86@03))
        unknown@86@03)
      (=
        (inv@91@03 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))) unknown@86@03))
        unknown1@87@03)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))) unknown@86@03))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@91@03 r) V@7@03) (<= 0 (inv@91@03 r)))
        (< (inv@90@03 r) V@7@03))
      (<= 0 (inv@90@03 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@03) (inv@91@03 r)))) (inv@90@03 r))
      r))
  :pattern ((inv@90@03 r))
  :pattern ((inv@91@03 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@86@03 Int) (unknown1@87@03 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@87@03 V@7@03) (<= 0 unknown1@87@03))
        (< unknown@86@03 V@7@03))
      (<= 0 unknown@86@03))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))) unknown@86@03)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@88@03  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@03) unknown1@87@03))) unknown@86@03))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@92@03 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@91@03 r) V@7@03) (<= 0 (inv@91@03 r)))
        (< (inv@90@03 r) V@7@03))
      (<= 0 (inv@90@03 r)))
    (=
      ($FVF.lookup_int (as sm@92@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@92@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r))
  :qid |qp.fvfValDef39|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@84@03 r) V@7@03) (<= 0 (inv@84@03 r)))
        (< (inv@83@03 r) V@7@03))
      (<= 0 (inv@83@03 r)))
    (=
      ($FVF.lookup_int (as sm@92@03  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@92@03  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r))
  :qid |qp.fvfValDef40|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@03))))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@92@03  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef41|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@91@03 r) V@7@03) (<= 0 (inv@91@03 r)))
        (< (inv@90@03 r) V@7@03))
      (<= 0 (inv@90@03 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@92@03  $FVF<Int>) r) r))
  :pattern ((inv@90@03 r) (inv@91@03 r))
  )))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(push) ; 4
; [exec]
; inhale false
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
