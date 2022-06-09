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
; ---------- check_unknown ----------
(declare-const i1@0@04 Int)
(declare-const p@1@04 option<array>)
(declare-const V@2@04 Int)
(declare-const exc@3@04 $Ref)
(declare-const res@4@04 void)
(declare-const i1@5@04 Int)
(declare-const p@6@04 option<array>)
(declare-const V@7@04 Int)
(declare-const exc@8@04 $Ref)
(declare-const res@9@04 void)
(push) ; 1
(declare-const $t@10@04 $Snap)
(assert (= $t@10@04 ($Snap.combine ($Snap.first $t@10@04) ($Snap.second $t@10@04))))
(assert (= ($Snap.first $t@10@04) $Snap.unit))
; [eval] 0 < V ==> p != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@7@04))))
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
(assert (not (< 0 V@7@04)))
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
; [then-branch: 0 | 0 < V@7@04 | live]
; [else-branch: 0 | !(0 < V@7@04) | live]
(push) ; 3
; [then-branch: 0 | 0 < V@7@04]
(assert (< 0 V@7@04))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(0 < V@7@04)]
(assert (not (< 0 V@7@04)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (< 0 V@7@04) (not (= p@6@04 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@10@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@10@04))
    ($Snap.second ($Snap.second $t@10@04)))))
(assert (= ($Snap.first ($Snap.second $t@10@04)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(p)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@7@04))))
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
(assert (not (< 0 V@7@04)))
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
; [then-branch: 1 | 0 < V@7@04 | live]
; [else-branch: 1 | !(0 < V@7@04) | live]
(push) ; 3
; [then-branch: 1 | 0 < V@7@04]
(assert (< 0 V@7@04))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= p@6@04 (as None<option<array>>  option<array>)))))
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
(assert (not (= p@6@04 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= p@6@04 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(0 < V@7@04)]
(assert (not (< 0 V@7@04)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@7@04)
  (and (< 0 V@7@04) (not (= p@6@04 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies (< 0 V@7@04) (= (alen<Int> (opt_get1 $Snap.unit p@6@04)) V@7@04)))
(assert (=
  ($Snap.second ($Snap.second $t@10@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@10@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@10@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@10@04))) $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@5@04))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@04)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@04))))
  $Snap.unit))
; [eval] i1 < V
(assert (< i1@5@04 V@7@04))
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 3
(assert (not (not (= p@6@04 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-add-rows          1
;  :arith-assert-lower      9
;  :arith-assert-upper      4
;  :arith-bound-prop        1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               2
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.96
;  :mk-bool-var             326
;  :mk-clause               7
;  :num-allocs              123584
;  :num-checks              6
;  :propagations            5
;  :quant-instantiations    6
;  :rlimit-count            122557)
(assert (not (= p@6@04 (as None<option<array>>  option<array>))))
(pop) ; 2
; Joined path conditions
(assert (not (= p@6@04 (as None<option<array>>  option<array>))))
(push) ; 2
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 3
(assert (not (< i1@5@04 (alen<Int> (opt_get1 $Snap.unit p@6@04)))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-add-rows          2
;  :arith-assert-lower      10
;  :arith-assert-upper      4
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               3
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.95
;  :mk-bool-var             327
;  :mk-clause               7
;  :num-allocs              123763
;  :num-checks              7
;  :propagations            5
;  :quant-instantiations    6
;  :rlimit-count            122719)
(assert (< i1@5@04 (alen<Int> (opt_get1 $Snap.unit p@6@04))))
(pop) ; 2
; Joined path conditions
(assert (< i1@5@04 (alen<Int> (opt_get1 $Snap.unit p@6@04))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@6@04) i1@5@04)
    $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@11@04 $Snap)
(assert (= $t@11@04 ($Snap.combine ($Snap.first $t@11@04) ($Snap.second $t@11@04))))
(assert (= ($Snap.first $t@11@04) $Snap.unit))
; [eval] exc == null
(assert (= exc@8@04 $Ref.null))
(assert (=
  ($Snap.second $t@11@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@11@04))
    ($Snap.second ($Snap.second $t@11@04)))))
(assert (= ($Snap.first ($Snap.second $t@11@04)) $Snap.unit))
; [eval] exc == null && 0 < V ==> p != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 2 | exc@8@04 == Null | live]
; [else-branch: 2 | exc@8@04 != Null | live]
(push) ; 4
; [then-branch: 2 | exc@8@04 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 2 | exc@8@04 != Null]
(assert (not (= exc@8@04 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@7@04) (= exc@8@04 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               72
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               3
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               7
;  :del-clause              13
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.99
;  :mk-bool-var             345
;  :mk-clause               13
;  :num-allocs              125198
;  :num-checks              9
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            124187)
(push) ; 4
(assert (not (and (< 0 V@7@04) (= exc@8@04 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               72
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               4
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   14
;  :datatype-splits         6
;  :decisions               7
;  :del-clause              13
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.99
;  :mk-bool-var             345
;  :mk-clause               13
;  :num-allocs              125267
;  :num-checks              10
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            124239)
; [then-branch: 3 | 0 < V@7@04 && exc@8@04 == Null | live]
; [else-branch: 3 | !(0 < V@7@04 && exc@8@04 == Null) | dead]
(push) ; 4
; [then-branch: 3 | 0 < V@7@04 && exc@8@04 == Null]
(assert (and (< 0 V@7@04) (= exc@8@04 $Ref.null)))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@7@04) (= exc@8@04 $Ref.null))
  (not (= p@6@04 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@11@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@11@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@11@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@11@04))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(p)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 4 | exc@8@04 == Null | live]
; [else-branch: 4 | exc@8@04 != Null | live]
(push) ; 4
; [then-branch: 4 | exc@8@04 == Null]
(assert (= exc@8@04 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 4 | exc@8@04 != Null]
(assert (not (= exc@8@04 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@7@04) (= exc@8@04 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               86
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               4
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         7
;  :decisions               9
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             348
;  :mk-clause               13
;  :num-allocs              125917
;  :num-checks              11
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            124881)
(push) ; 4
(assert (not (and (< 0 V@7@04) (= exc@8@04 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               86
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         7
;  :decisions               9
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             348
;  :mk-clause               13
;  :num-allocs              125986
;  :num-checks              12
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            124933)
; [then-branch: 5 | 0 < V@7@04 && exc@8@04 == Null | live]
; [else-branch: 5 | !(0 < V@7@04 && exc@8@04 == Null) | dead]
(push) ; 4
; [then-branch: 5 | 0 < V@7@04 && exc@8@04 == Null]
(assert (and (< 0 V@7@04) (= exc@8@04 $Ref.null)))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@7@04) (= exc@8@04 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit p@6@04)) V@7@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@11@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@11@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@11@04))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@8@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               101
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   22
;  :datatype-splits         8
;  :decisions               11
;  :del-clause              13
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             351
;  :mk-clause               13
;  :num-allocs              126654
;  :num-checks              13
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            125572)
(push) ; 4
(assert (not (= exc@8@04 $Ref.null)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               101
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   22
;  :datatype-splits         8
;  :decisions               11
;  :del-clause              13
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             351
;  :mk-clause               13
;  :num-allocs              126669
;  :num-checks              14
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            125583)
; [then-branch: 6 | exc@8@04 == Null | live]
; [else-branch: 6 | exc@8@04 != Null | dead]
(push) ; 4
; [then-branch: 6 | exc@8@04 == Null]
(assert (= exc@8@04 $Ref.null))
; [eval] 0 <= i1
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@8@04 $Ref.null) (<= 0 i1@5@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04)))))
  $Snap.unit))
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@8@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               116
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   27
;  :datatype-splits         9
;  :decisions               13
;  :del-clause              13
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             354
;  :mk-clause               13
;  :num-allocs              127276
;  :num-checks              15
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            126169)
(push) ; 4
(assert (not (= exc@8@04 $Ref.null)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               116
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   27
;  :datatype-splits         9
;  :decisions               13
;  :del-clause              13
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             354
;  :mk-clause               13
;  :num-allocs              127291
;  :num-checks              16
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            126180)
; [then-branch: 7 | exc@8@04 == Null | live]
; [else-branch: 7 | exc@8@04 != Null | dead]
(push) ; 4
; [then-branch: 7 | exc@8@04 == Null]
(assert (= exc@8@04 $Ref.null))
; [eval] i1 < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@8@04 $Ref.null) (< i1@5@04 V@7@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04)))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@8@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               132
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   32
;  :datatype-splits         11
;  :decisions               16
;  :del-clause              13
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             357
;  :mk-clause               13
;  :num-allocs              127899
;  :num-checks              17
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            126766)
(push) ; 3
(assert (not (= exc@8@04 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               132
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   32
;  :datatype-splits         11
;  :decisions               16
;  :del-clause              13
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             357
;  :mk-clause               13
;  :num-allocs              127914
;  :num-checks              18
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            126777)
; [then-branch: 8 | exc@8@04 == Null | live]
; [else-branch: 8 | exc@8@04 != Null | dead]
(push) ; 3
; [then-branch: 8 | exc@8@04 == Null]
(assert (= exc@8@04 $Ref.null))
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
; Joined path conditions
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(p), i1).int == 0
; [eval] exc == null
(push) ; 4
(push) ; 5
(assert (not (not (= exc@8@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               142
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   37
;  :datatype-splits         12
;  :decisions               18
;  :del-clause              13
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              128496
;  :num-checks              19
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            127295)
; [then-branch: 9 | exc@8@04 == Null | live]
; [else-branch: 9 | exc@8@04 != Null | dead]
(push) ; 5
; [then-branch: 9 | exc@8@04 == Null]
; [eval] aloc(opt_get1(p), i1).int == 0
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 6
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
; Joined path conditions
(push) ; 6
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 6
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@8@04 $Ref.null)
  (=
    ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@04)))))))
    0)))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@12@04 void)
; [exec]
; exc := null
; [exec]
; aloc(opt_get1(p), i1).int := 0
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 3
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
; Joined path conditions
(push) ; 3
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 3
; Joined path conditions
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null && 0 < V ==> p != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 10 | True | live]
; [else-branch: 10 | False | live]
(push) ; 4
; [then-branch: 10 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 10 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@7@04))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               145
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               5
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   38
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              13
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              129034
;  :num-checks              20
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            127765)
(push) ; 4
(assert (not (< 0 V@7@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               145
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               6
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   38
;  :datatype-splits         12
;  :decisions               19
;  :del-clause              13
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              129103
;  :num-checks              21
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            127813)
; [then-branch: 11 | 0 < V@7@04 | live]
; [else-branch: 11 | !(0 < V@7@04) | dead]
(push) ; 4
; [then-branch: 11 | 0 < V@7@04]
(assert (< 0 V@7@04))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(p)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 12 | True | live]
; [else-branch: 12 | False | live]
(push) ; 4
; [then-branch: 12 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 12 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@7@04))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               148
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               6
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   39
;  :datatype-splits         12
;  :decisions               20
;  :del-clause              13
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              129641
;  :num-checks              22
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            128244)
(push) ; 4
(assert (not (< 0 V@7@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               148
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               7
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   39
;  :datatype-splits         12
;  :decisions               20
;  :del-clause              13
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              129710
;  :num-checks              23
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            128292)
; [then-branch: 13 | 0 < V@7@04 | live]
; [else-branch: 13 | !(0 < V@7@04) | dead]
(push) ; 4
; [then-branch: 13 | 0 < V@7@04]
(assert (< 0 V@7@04))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not false))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               151
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               7
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   40
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              13
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              130253
;  :num-checks              24
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            128702)
; [then-branch: 14 | True | live]
; [else-branch: 14 | False | dead]
(push) ; 4
; [then-branch: 14 | True]
; [eval] 0 <= i1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not false))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               154
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               7
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   41
;  :datatype-splits         12
;  :decisions               22
;  :del-clause              13
;  :final-checks            26
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              130731
;  :num-checks              25
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            129060)
; [then-branch: 15 | True | live]
; [else-branch: 15 | False | dead]
(push) ; 4
; [then-branch: 15 | True]
; [eval] i1 < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null
(push) ; 3
(assert (not false))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               157
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               7
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   42
;  :datatype-splits         12
;  :decisions               23
;  :del-clause              13
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              131209
;  :num-checks              26
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            129413)
; [then-branch: 16 | True | live]
; [else-branch: 16 | False | dead]
(push) ; 3
; [then-branch: 16 | True]
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
; Joined path conditions
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 4
; Joined path conditions
; [eval] exc == null ==> aloc(opt_get1(p), i1).int == 0
; [eval] exc == null
(push) ; 4
(push) ; 5
(assert (not false))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-add-rows          3
;  :arith-assert-lower      10
;  :arith-assert-upper      5
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               7
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   43
;  :datatype-splits         12
;  :decisions               24
;  :del-clause              13
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             359
;  :mk-clause               13
;  :num-allocs              131687
;  :num-checks              27
;  :propagations            9
;  :quant-instantiations    11
;  :rlimit-count            129781)
; [then-branch: 17 | True | live]
; [else-branch: 17 | False | dead]
(push) ; 5
; [then-branch: 17 | True]
; [eval] aloc(opt_get1(p), i1).int == 0
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 6
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
; Joined path conditions
(push) ; 6
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 6
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- initializeVisited ----------
(declare-const this@13@04 $Ref)
(declare-const tid@14@04 Int)
(declare-const visited@15@04 option<array>)
(declare-const s@16@04 Int)
(declare-const V@17@04 Int)
(declare-const exc@18@04 $Ref)
(declare-const res@19@04 void)
(declare-const this@20@04 $Ref)
(declare-const tid@21@04 Int)
(declare-const visited@22@04 option<array>)
(declare-const s@23@04 Int)
(declare-const V@24@04 Int)
(declare-const exc@25@04 $Ref)
(declare-const res@26@04 void)
(push) ; 1
(declare-const $t@27@04 $Snap)
(assert (= $t@27@04 ($Snap.combine ($Snap.first $t@27@04) ($Snap.second $t@27@04))))
(assert (= ($Snap.first $t@27@04) $Snap.unit))
; [eval] this != null
(assert (not (= this@20@04 $Ref.null)))
(assert (=
  ($Snap.second $t@27@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@27@04))
    ($Snap.second ($Snap.second $t@27@04)))))
(assert (= ($Snap.first ($Snap.second $t@27@04)) $Snap.unit))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= visited@22@04 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second $t@27@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@27@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@27@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@27@04))) $Snap.unit))
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (opt_get1 $Snap.unit visited@22@04)) V@24@04))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@27@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@04))))
  $Snap.unit))
; [eval] 0 <= s
(assert (<= 0 s@23@04))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04)))))
  $Snap.unit))
; [eval] s < V
(assert (< s@23@04 V@24@04))
(declare-const k@28@04 Int)
(push) ; 2
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 3
; [then-branch: 18 | 0 <= k@28@04 | live]
; [else-branch: 18 | !(0 <= k@28@04) | live]
(push) ; 4
; [then-branch: 18 | 0 <= k@28@04]
(assert (<= 0 k@28@04))
; [eval] k < V
(pop) ; 4
(push) ; 4
; [else-branch: 18 | !(0 <= k@28@04)]
(assert (not (<= 0 k@28@04)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< k@28@04 V@24@04) (<= 0 k@28@04)))
; [eval] aloc(opt_get1(visited), k)
; [eval] opt_get1(visited)
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
(assert (not (< k@28@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               196
;  :arith-add-rows          5
;  :arith-assert-lower      14
;  :arith-assert-upper      8
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        3
;  :arith-fixed-eqs         2
;  :arith-pivots            6
;  :conflicts               7
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   43
;  :datatype-splits         12
;  :decisions               24
;  :del-clause              13
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             384
;  :mk-clause               13
;  :num-allocs              132243
;  :num-checks              28
;  :propagations            9
;  :quant-instantiations    16
;  :rlimit-count            131058)
(assert (< k@28@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 3
; Joined path conditions
(assert (< k@28@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 2
(declare-fun inv@29@04 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@28@04 Int)) (!
  (< k@28@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@28@04))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((k1@28@04 Int) (k2@28@04 Int)) (!
  (implies
    (and
      (and (< k1@28@04 V@24@04) (<= 0 k1@28@04))
      (and (< k2@28@04 V@24@04) (<= 0 k2@28@04))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k1@28@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k2@28@04)))
    (= k1@28@04 k2@28@04))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               208
;  :arith-add-rows          15
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               8
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   43
;  :datatype-splits         12
;  :decisions               24
;  :del-clause              27
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             407
;  :mk-clause               27
;  :num-allocs              132801
;  :num-checks              29
;  :propagations            14
;  :quant-instantiations    26
;  :rlimit-count            132069)
; Definitional axioms for inverse functions
(assert (forall ((k@28@04 Int)) (!
  (implies
    (and (< k@28@04 V@24@04) (<= 0 k@28@04))
    (=
      (inv@29@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@28@04))
      k@28@04))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@28@04))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@29@04 r) V@24@04) (<= 0 (inv@29@04 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) (inv@29@04 r))
      r))
  :pattern ((inv@29@04 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@28@04 Int)) (!
  (implies
    (and (< k@28@04 V@24@04) (<= 0 k@28@04))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@28@04)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@28@04))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@30@04 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@29@04 r) V@24@04) (<= 0 (inv@29@04 r)))
    (=
      ($FVF.lookup_bool (as sm@30@04  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04)))))) r)))
  :pattern (($FVF.lookup_bool (as sm@30@04  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04)))))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@04)))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@30@04  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@29@04 r) V@24@04) (<= 0 (inv@29@04 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@30@04  $FVF<Bool>) r) r))
  :pattern ((inv@29@04 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@31@04 $Snap)
(assert (= $t@31@04 ($Snap.combine ($Snap.first $t@31@04) ($Snap.second $t@31@04))))
(assert (= ($Snap.first $t@31@04) $Snap.unit))
; [eval] exc == null
(assert (= exc@25@04 $Ref.null))
(assert (=
  ($Snap.second $t@31@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@31@04))
    ($Snap.second ($Snap.second $t@31@04)))))
(assert (= ($Snap.first ($Snap.second $t@31@04)) $Snap.unit))
; [eval] exc == null ==> visited != (None(): option[array])
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@25@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               231
;  :arith-add-rows          15
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               8
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 27
;  :datatype-occurs-check   49
;  :datatype-splits         14
;  :decisions               27
;  :del-clause              27
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             420
;  :mk-clause               27
;  :num-allocs              134717
;  :num-checks              31
;  :propagations            14
;  :quant-instantiations    26
;  :rlimit-count            134732)
; [then-branch: 19 | exc@25@04 == Null | live]
; [else-branch: 19 | exc@25@04 != Null | dead]
(push) ; 4
; [then-branch: 19 | exc@25@04 == Null]
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@25@04 $Ref.null)
  (not (= visited@22@04 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@31@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@31@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@31@04))) $Snap.unit))
; [eval] exc == null ==> alen(opt_get1(visited)) == V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@25@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               245
;  :arith-add-rows          15
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               8
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   52
;  :datatype-splits         15
;  :decisions               29
;  :del-clause              27
;  :final-checks            34
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             423
;  :mk-clause               27
;  :num-allocs              135269
;  :num-checks              32
;  :propagations            14
;  :quant-instantiations    26
;  :rlimit-count            135289)
; [then-branch: 20 | exc@25@04 == Null | live]
; [else-branch: 20 | exc@25@04 != Null | dead]
(push) ; 4
; [then-branch: 20 | exc@25@04 == Null]
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@25@04 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@04)) V@24@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@31@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@04))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= s
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@25@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               260
;  :arith-add-rows          15
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               8
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   55
;  :datatype-splits         16
;  :decisions               31
;  :del-clause              27
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             426
;  :mk-clause               27
;  :num-allocs              135828
;  :num-checks              33
;  :propagations            14
;  :quant-instantiations    26
;  :rlimit-count            135864)
; [then-branch: 21 | exc@25@04 == Null | live]
; [else-branch: 21 | exc@25@04 != Null | dead]
(push) ; 4
; [then-branch: 21 | exc@25@04 == Null]
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@25@04 $Ref.null) (<= 0 s@23@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))
  $Snap.unit))
; [eval] exc == null ==> s < V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@25@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               276
;  :arith-add-rows          15
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               8
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   60
;  :datatype-splits         17
;  :decisions               33
;  :del-clause              27
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             429
;  :mk-clause               27
;  :num-allocs              136398
;  :num-checks              34
;  :propagations            14
;  :quant-instantiations    26
;  :rlimit-count            136454)
; [then-branch: 22 | exc@25@04 == Null | live]
; [else-branch: 22 | exc@25@04 != Null | dead]
(push) ; 4
; [then-branch: 22 | exc@25@04 == Null]
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@25@04 $Ref.null) (< s@23@04 V@24@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@25@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               293
;  :arith-add-rows          15
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               8
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   65
;  :datatype-splits         19
;  :decisions               36
;  :del-clause              27
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             432
;  :mk-clause               27
;  :num-allocs              136973
;  :num-checks              35
;  :propagations            14
;  :quant-instantiations    26
;  :rlimit-count            137044)
; [then-branch: 23 | exc@25@04 == Null | live]
; [else-branch: 23 | exc@25@04 != Null | dead]
(push) ; 3
; [then-branch: 23 | exc@25@04 == Null]
(declare-const k@32@04 Int)
(push) ; 4
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 5
; [then-branch: 24 | 0 <= k@32@04 | live]
; [else-branch: 24 | !(0 <= k@32@04) | live]
(push) ; 6
; [then-branch: 24 | 0 <= k@32@04]
(assert (<= 0 k@32@04))
; [eval] k < V
(pop) ; 6
(push) ; 6
; [else-branch: 24 | !(0 <= k@32@04)]
(assert (not (<= 0 k@32@04)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< k@32@04 V@24@04) (<= 0 k@32@04)))
; [eval] aloc(opt_get1(visited), k)
; [eval] opt_get1(visited)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 6
(assert (not (< k@32@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               293
;  :arith-add-rows          16
;  :arith-assert-diseq      2
;  :arith-assert-lower      19
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               8
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   65
;  :datatype-splits         19
;  :decisions               36
;  :del-clause              27
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             434
;  :mk-clause               27
;  :num-allocs              137075
;  :num-checks              36
;  :propagations            14
;  :quant-instantiations    26
;  :rlimit-count            137230)
(assert (< k@32@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 5
; Joined path conditions
(assert (< k@32@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 4
(declare-fun inv@33@04 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@32@04 Int)) (!
  (< k@32@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@32@04))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((k1@32@04 Int) (k2@32@04 Int)) (!
  (implies
    (and
      (and (< k1@32@04 V@24@04) (<= 0 k1@32@04))
      (and (< k2@32@04 V@24@04) (<= 0 k2@32@04))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k1@32@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k2@32@04)))
    (= k1@32@04 k2@32@04))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               300
;  :arith-add-rows          20
;  :arith-assert-diseq      3
;  :arith-assert-lower      23
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               9
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   65
;  :datatype-splits         19
;  :decisions               36
;  :del-clause              33
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             453
;  :mk-clause               33
;  :num-allocs              137604
;  :num-checks              37
;  :propagations            14
;  :quant-instantiations    37
;  :rlimit-count            138084)
; Definitional axioms for inverse functions
(assert (forall ((k@32@04 Int)) (!
  (implies
    (and (< k@32@04 V@24@04) (<= 0 k@32@04))
    (=
      (inv@33@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@32@04))
      k@32@04))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@32@04))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@33@04 r) V@24@04) (<= 0 (inv@33@04 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) (inv@33@04 r))
      r))
  :pattern ((inv@33@04 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@32@04 Int)) (!
  (implies
    (and (< k@32@04 V@24@04) (<= 0 k@32@04))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@32@04)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@32@04))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@34@04 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@33@04 r) V@24@04) (<= 0 (inv@33@04 r)))
    (=
      ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))) r))
  :qid |qp.fvfValDef2|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef3|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@33@04 r) V@24@04) (<= 0 (inv@33@04 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) r) r))
  :pattern ((inv@33@04 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@25@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               319
;  :arith-add-rows          20
;  :arith-assert-diseq      3
;  :arith-assert-lower      23
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               9
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   70
;  :datatype-splits         21
;  :decisions               39
;  :del-clause              33
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             463
;  :mk-clause               33
;  :num-allocs              139056
;  :num-checks              38
;  :propagations            14
;  :quant-instantiations    37
;  :rlimit-count            140543)
; [then-branch: 25 | exc@25@04 == Null | live]
; [else-branch: 25 | exc@25@04 != Null | dead]
(push) ; 5
; [then-branch: 25 | exc@25@04 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
(declare-const unknown@35@04 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false
; [eval] 0 <= unknown && unknown < V && unknown != s
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 26 | 0 <= unknown@35@04 | live]
; [else-branch: 26 | !(0 <= unknown@35@04) | live]
(push) ; 8
; [then-branch: 26 | 0 <= unknown@35@04]
(assert (<= 0 unknown@35@04))
; [eval] unknown < V
(push) ; 9
; [then-branch: 27 | unknown@35@04 < V@24@04 | live]
; [else-branch: 27 | !(unknown@35@04 < V@24@04) | live]
(push) ; 10
; [then-branch: 27 | unknown@35@04 < V@24@04]
(assert (< unknown@35@04 V@24@04))
; [eval] unknown != s
(pop) ; 10
(push) ; 10
; [else-branch: 27 | !(unknown@35@04 < V@24@04)]
(assert (not (< unknown@35@04 V@24@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 26 | !(0 <= unknown@35@04)]
(assert (not (<= 0 unknown@35@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 28 | unknown@35@04 != s@23@04 && unknown@35@04 < V@24@04 && 0 <= unknown@35@04 | live]
; [else-branch: 28 | !(unknown@35@04 != s@23@04 && unknown@35@04 < V@24@04 && 0 <= unknown@35@04) | live]
(push) ; 8
; [then-branch: 28 | unknown@35@04 != s@23@04 && unknown@35@04 < V@24@04 && 0 <= unknown@35@04]
(assert (and
  (and (not (= unknown@35@04 s@23@04)) (< unknown@35@04 V@24@04))
  (<= 0 unknown@35@04)))
; [eval] aloc(opt_get1(visited), unknown).bool == false
; [eval] aloc(opt_get1(visited), unknown)
; [eval] opt_get1(visited)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 9
; Joined path conditions
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 10
(assert (not (< unknown@35@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               320
;  :arith-add-rows          21
;  :arith-assert-diseq      6
;  :arith-assert-lower      26
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               9
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   70
;  :datatype-splits         21
;  :decisions               39
;  :del-clause              33
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             470
;  :mk-clause               37
;  :num-allocs              139303
;  :num-checks              39
;  :propagations            14
;  :quant-instantiations    37
;  :rlimit-count            140863)
(assert (< unknown@35@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@35@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04)))
(push) ; 9
(assert (not (and
  (<
    (inv@33@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))
    V@24@04)
  (<=
    0
    (inv@33@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               328
;  :arith-add-rows          32
;  :arith-assert-diseq      6
;  :arith-assert-lower      28
;  :arith-assert-upper      13
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        1
;  :arith-pivots            13
;  :conflicts               10
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   70
;  :datatype-splits         21
;  :decisions               39
;  :del-clause              33
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.10
;  :mk-bool-var             498
;  :mk-clause               50
;  :num-allocs              139692
;  :num-checks              40
;  :propagations            14
;  :quant-instantiations    50
;  :rlimit-count            141691)
(pop) ; 8
(push) ; 8
; [else-branch: 28 | !(unknown@35@04 != s@23@04 && unknown@35@04 < V@24@04 && 0 <= unknown@35@04)]
(assert (not
  (and
    (and (not (= unknown@35@04 s@23@04)) (< unknown@35@04 V@24@04))
    (<= 0 unknown@35@04))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and
    (and (not (= unknown@35@04 s@23@04)) (< unknown@35@04 V@24@04))
    (<= 0 unknown@35@04))
  (and
    (not (= unknown@35@04 s@23@04))
    (< unknown@35@04 V@24@04)
    (<= 0 unknown@35@04)
    (< unknown@35@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@35@04 Int)) (!
  (implies
    (and
      (and (not (= unknown@35@04 s@23@04)) (< unknown@35@04 V@24@04))
      (<= 0 unknown@35@04))
    (and
      (not (= unknown@35@04 s@23@04))
      (< unknown@35@04 V@24@04)
      (<= 0 unknown@35@04)
      (< unknown@35@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@25@04 $Ref.null)
  (forall ((unknown@35@04 Int)) (!
    (implies
      (and
        (and (not (= unknown@35@04 s@23@04)) (< unknown@35@04 V@24@04))
        (<= 0 unknown@35@04))
      (and
        (not (= unknown@35@04 s@23@04))
        (< unknown@35@04 V@24@04)
        (<= 0 unknown@35@04)
        (< unknown@35@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@25@04 $Ref.null)
  (forall ((unknown@35@04 Int)) (!
    (implies
      (and
        (and (not (= unknown@35@04 s@23@04)) (< unknown@35@04 V@24@04))
        (<= 0 unknown@35@04))
      (=
        ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@35@04))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@04)))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(visited), s).bool == true
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@25@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               340
;  :arith-add-rows          36
;  :arith-assert-diseq      6
;  :arith-assert-lower      28
;  :arith-assert-upper      13
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        1
;  :arith-pivots            16
;  :conflicts               10
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   74
;  :datatype-splits         22
;  :decisions               41
;  :del-clause              50
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.10
;  :mk-bool-var             502
;  :mk-clause               50
;  :num-allocs              140583
;  :num-checks              41
;  :propagations            14
;  :quant-instantiations    50
;  :rlimit-count            143075)
; [then-branch: 29 | exc@25@04 == Null | live]
; [else-branch: 29 | exc@25@04 != Null | dead]
(push) ; 5
; [then-branch: 29 | exc@25@04 == Null]
; [eval] aloc(opt_get1(visited), s).bool == true
; [eval] aloc(opt_get1(visited), s)
; [eval] opt_get1(visited)
(push) ; 6
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
; Joined path conditions
(push) ; 6
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 7
(assert (not (< s@23@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               340
;  :arith-add-rows          36
;  :arith-assert-diseq      6
;  :arith-assert-lower      28
;  :arith-assert-upper      13
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        1
;  :arith-pivots            16
;  :conflicts               10
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   74
;  :datatype-splits         22
;  :decisions               41
;  :del-clause              50
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.10
;  :mk-bool-var             502
;  :mk-clause               50
;  :num-allocs              140616
;  :num-checks              42
;  :propagations            14
;  :quant-instantiations    50
;  :rlimit-count            143110)
(assert (< s@23@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 6
; Joined path conditions
(assert (< s@23@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)))
(push) ; 6
(assert (not (and
  (<
    (inv@33@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
    V@24@04)
  (<=
    0
    (inv@33@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-add-rows          41
;  :arith-assert-diseq      6
;  :arith-assert-lower      30
;  :arith-assert-upper      15
;  :arith-bound-prop        9
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            18
;  :conflicts               11
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   74
;  :datatype-splits         22
;  :decisions               41
;  :del-clause              50
;  :final-checks            44
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             548
;  :mk-clause               85
;  :num-allocs              141009
;  :num-checks              43
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            144008)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@25@04 $Ref.null)
  (and
    (< s@23@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)))))
(assert (implies
  (= exc@25@04 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@34@04  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
    true)))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@36@04 void)
; [exec]
; var res1: void
(declare-const res1@37@04 void)
; [exec]
; var evaluationDummy: void
(declare-const evaluationDummy@38@04 void)
; [exec]
; exc := null
; [exec]
; exc, res1 := do_par_$unknown$2(visited, s, V)
; [eval] 0 < V ==> visited != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@24@04))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               359
;  :arith-add-rows          43
;  :arith-assert-diseq      6
;  :arith-assert-lower      31
;  :arith-assert-upper      15
;  :arith-bound-prop        9
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            20
;  :conflicts               11
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   75
;  :datatype-splits         22
;  :decisions               42
;  :del-clause              85
;  :final-checks            45
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             549
;  :mk-clause               85
;  :num-allocs              141524
;  :num-checks              44
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            144493)
(push) ; 4
(assert (not (< 0 V@24@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               359
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      31
;  :arith-assert-upper      16
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               12
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   75
;  :datatype-splits         22
;  :decisions               42
;  :del-clause              85
;  :final-checks            45
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             550
;  :mk-clause               85
;  :num-allocs              141600
;  :num-checks              45
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            144562)
; [then-branch: 30 | 0 < V@24@04 | live]
; [else-branch: 30 | !(0 < V@24@04) | dead]
(push) ; 4
; [then-branch: 30 | 0 < V@24@04]
(assert (< 0 V@24@04))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies
  (< 0 V@24@04)
  (not (= visited@22@04 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               359
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      31
;  :arith-assert-upper      16
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               12
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 42
;  :datatype-occurs-check   75
;  :datatype-splits         22
;  :decisions               42
;  :del-clause              85
;  :final-checks            45
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             550
;  :mk-clause               85
;  :num-allocs              141630
;  :num-checks              46
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            144593)
(assert (implies
  (< 0 V@24@04)
  (not (= visited@22@04 (as None<option<array>>  option<array>)))))
; [eval] 0 < V ==> alen(opt_get1(visited)) == V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@24@04))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               362
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      32
;  :arith-assert-upper      16
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               12
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   76
;  :datatype-splits         22
;  :decisions               43
;  :del-clause              85
;  :final-checks            46
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             551
;  :mk-clause               85
;  :num-allocs              142122
;  :num-checks              47
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            145018)
(push) ; 4
(assert (not (< 0 V@24@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               362
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      32
;  :arith-assert-upper      17
;  :arith-bound-prop        9
;  :arith-conflicts         5
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               13
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   76
;  :datatype-splits         22
;  :decisions               43
;  :del-clause              85
;  :final-checks            46
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             552
;  :mk-clause               85
;  :num-allocs              142197
;  :num-checks              48
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            145071)
; [then-branch: 31 | 0 < V@24@04 | live]
; [else-branch: 31 | !(0 < V@24@04) | dead]
(push) ; 4
; [then-branch: 31 | 0 < V@24@04]
(assert (< 0 V@24@04))
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies
  (< 0 V@24@04)
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@04)) V@24@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               362
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      33
;  :arith-assert-upper      17
;  :arith-bound-prop        9
;  :arith-conflicts         5
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               13
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   76
;  :datatype-splits         22
;  :decisions               43
;  :del-clause              85
;  :final-checks            46
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             553
;  :mk-clause               85
;  :num-allocs              142280
;  :num-checks              49
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            145157)
(assert (implies
  (< 0 V@24@04)
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@04)) V@24@04)))
; [eval] 0 < V ==> 0 <= s
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@24@04))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               365
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      34
;  :arith-assert-upper      17
;  :arith-bound-prop        9
;  :arith-conflicts         5
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               13
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 44
;  :datatype-occurs-check   77
;  :datatype-splits         22
;  :decisions               44
;  :del-clause              85
;  :final-checks            47
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             554
;  :mk-clause               85
;  :num-allocs              142777
;  :num-checks              50
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            145580)
(push) ; 4
(assert (not (< 0 V@24@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               365
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      34
;  :arith-assert-upper      18
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               14
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 44
;  :datatype-occurs-check   77
;  :datatype-splits         22
;  :decisions               44
;  :del-clause              85
;  :final-checks            47
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             555
;  :mk-clause               85
;  :num-allocs              142852
;  :num-checks              51
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            145633)
; [then-branch: 32 | 0 < V@24@04 | live]
; [else-branch: 32 | !(0 < V@24@04) | dead]
(push) ; 4
; [then-branch: 32 | 0 < V@24@04]
(assert (< 0 V@24@04))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@24@04) (<= 0 s@23@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               365
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      34
;  :arith-assert-upper      18
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               14
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 44
;  :datatype-occurs-check   77
;  :datatype-splits         22
;  :decisions               44
;  :del-clause              85
;  :final-checks            47
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             555
;  :mk-clause               85
;  :num-allocs              142886
;  :num-checks              52
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            145683)
(assert (implies (< 0 V@24@04) (<= 0 s@23@04)))
; [eval] 0 < V ==> s < V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@24@04))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               368
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               14
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   78
;  :datatype-splits         22
;  :decisions               45
;  :del-clause              85
;  :final-checks            48
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.12
;  :mk-bool-var             556
;  :mk-clause               85
;  :num-allocs              143428
;  :num-checks              53
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            146129)
(push) ; 4
(assert (not (< 0 V@24@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               368
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      35
;  :arith-assert-upper      19
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               15
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   78
;  :datatype-splits         22
;  :decisions               45
;  :del-clause              85
;  :final-checks            48
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             557
;  :mk-clause               85
;  :num-allocs              143503
;  :num-checks              54
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            146182)
; [then-branch: 33 | 0 < V@24@04 | live]
; [else-branch: 33 | !(0 < V@24@04) | dead]
(push) ; 4
; [then-branch: 33 | 0 < V@24@04]
(assert (< 0 V@24@04))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@24@04) (< s@23@04 V@24@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               368
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      35
;  :arith-assert-upper      19
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               15
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   78
;  :datatype-splits         22
;  :decisions               45
;  :del-clause              85
;  :final-checks            48
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             557
;  :mk-clause               85
;  :num-allocs              143543
;  :num-checks              55
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            146235)
(assert (implies (< 0 V@24@04) (< s@23@04 V@24@04)))
(declare-const i1@39@04 Int)
(push) ; 3
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 4
; [then-branch: 34 | 0 <= i1@39@04 | live]
; [else-branch: 34 | !(0 <= i1@39@04) | live]
(push) ; 5
; [then-branch: 34 | 0 <= i1@39@04]
(assert (<= 0 i1@39@04))
; [eval] i1 < V
(pop) ; 5
(push) ; 5
; [else-branch: 34 | !(0 <= i1@39@04)]
(assert (not (<= 0 i1@39@04)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i1@39@04 V@24@04) (<= 0 i1@39@04)))
; [eval] aloc(opt_get1(visited), i1)
; [eval] opt_get1(visited)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
; Joined path conditions
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@39@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               368
;  :arith-add-rows          44
;  :arith-assert-diseq      6
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               15
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   78
;  :datatype-splits         22
;  :decisions               45
;  :del-clause              85
;  :final-checks            48
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             559
;  :mk-clause               85
;  :num-allocs              143696
;  :num-checks              56
;  :propagations            19
;  :quant-instantiations    68
;  :rlimit-count            146449)
(assert (< i1@39@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 4
; Joined path conditions
(assert (< i1@39@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 3
(declare-fun inv@40@04 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@39@04 Int)) (!
  (< i1@39@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i1@39@04))
  :qid |bool-aux|)))
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i11@39@04 Int) (i12@39@04 Int)) (!
  (implies
    (and
      (and
        (and (< i11@39@04 V@24@04) (<= 0 i11@39@04))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@30@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i11@39@04)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i11@39@04)))
      (and
        (and (< i12@39@04 V@24@04) (<= 0 i12@39@04))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@30@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i12@39@04)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i12@39@04)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i11@39@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i12@39@04)))
    (= i11@39@04 i12@39@04))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               376
;  :arith-add-rows          46
;  :arith-assert-diseq      7
;  :arith-assert-lower      41
;  :arith-assert-upper      19
;  :arith-bound-prop        9
;  :arith-conflicts         7
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        2
;  :arith-pivots            21
;  :conflicts               16
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   78
;  :datatype-splits         22
;  :decisions               45
;  :del-clause              96
;  :final-checks            48
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.11
;  :mk-bool-var             586
;  :mk-clause               96
;  :num-allocs              144229
;  :num-checks              57
;  :propagations            19
;  :quant-instantiations    81
;  :rlimit-count            147446)
; Definitional axioms for inverse functions
(assert (forall ((i1@39@04 Int)) (!
  (implies
    (and (< i1@39@04 V@24@04) (<= 0 i1@39@04))
    (=
      (inv@40@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i1@39@04))
      i1@39@04))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) i1@39@04))
  :qid |bool-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@40@04 r) V@24@04) (<= 0 (inv@40@04 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) (inv@40@04 r))
      r))
  :pattern ((inv@40@04 r))
  :qid |bool-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@40@04 r) V@24@04) (<= 0 (inv@40@04 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@30@04  $FVF<Bool>) r) r))
  :pattern ((inv@40@04 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@41@04 ((r $Ref)) $Perm
  (ite
    (and (< (inv@40@04 r) V@24@04) (<= 0 (inv@40@04 r)))
    ($Perm.min
      (ite
        (and (< (inv@29@04 r) V@24@04) (<= 0 (inv@29@04 r)))
        $Perm.Write
        $Perm.No)
      $Perm.Write)
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Chunk depleted?
(set-option :timeout 500)
(push) ; 3
(assert (not (forall ((r $Ref)) (!
  (=
    (-
      (ite
        (and (< (inv@29@04 r) V@24@04) (<= 0 (inv@29@04 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@41@04 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               437
;  :arith-add-rows          56
;  :arith-assert-diseq      15
;  :arith-assert-lower      64
;  :arith-assert-upper      29
;  :arith-bound-prop        11
;  :arith-conflicts         10
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            33
;  :conflicts               23
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   79
;  :datatype-splits         22
;  :decisions               52
;  :del-clause              158
;  :final-checks            49
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.13
;  :mk-bool-var             682
;  :mk-clause               158
;  :num-allocs              145808
;  :num-checks              59
;  :propagations            55
;  :quant-instantiations    119
;  :rlimit-count            150166
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 3
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@40@04 r) V@24@04) (<= 0 (inv@40@04 r)))
    (= (- $Perm.Write (pTaken@41@04 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               457
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      68
;  :arith-assert-upper      34
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               24
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   79
;  :datatype-splits         22
;  :decisions               52
;  :del-clause              178
;  :final-checks            49
;  :max-generation          3
;  :max-memory              4.14
;  :memory                  4.13
;  :mk-bool-var             718
;  :mk-clause               178
;  :num-allocs              146200
;  :num-checks              60
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            151170)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
(declare-const exc@42@04 $Ref)
(declare-const res@43@04 void)
(declare-const $t@44@04 $Snap)
(assert (= $t@44@04 ($Snap.combine ($Snap.first $t@44@04) ($Snap.second $t@44@04))))
(assert (= ($Snap.first $t@44@04) $Snap.unit))
; [eval] exc == null
(assert (= exc@42@04 $Ref.null))
(assert (=
  ($Snap.second $t@44@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@44@04))
    ($Snap.second ($Snap.second $t@44@04)))))
(assert (= ($Snap.first ($Snap.second $t@44@04)) $Snap.unit))
; [eval] exc == null && 0 < V ==> visited != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 35 | exc@42@04 == Null | live]
; [else-branch: 35 | exc@42@04 != Null | live]
(push) ; 4
; [then-branch: 35 | exc@42@04 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 35 | exc@42@04 != Null]
(assert (not (= exc@42@04 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      69
;  :arith-assert-upper      34
;  :arith-bound-prop        13
;  :arith-conflicts         11
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               24
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   82
;  :datatype-splits         23
;  :decisions               54
;  :del-clause              178
;  :final-checks            51
;  :max-generation          3
;  :max-memory              4.15
;  :memory                  4.14
;  :mk-bool-var             725
;  :mk-clause               178
;  :num-allocs              146867
;  :num-checks              61
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            151930)
(push) ; 4
(assert (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      69
;  :arith-assert-upper      35
;  :arith-bound-prop        13
;  :arith-conflicts         12
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               25
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   82
;  :datatype-splits         23
;  :decisions               54
;  :del-clause              178
;  :final-checks            51
;  :max-generation          3
;  :max-memory              4.15
;  :memory                  4.14
;  :mk-bool-var             726
;  :mk-clause               178
;  :num-allocs              146941
;  :num-checks              62
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            151987)
; [then-branch: 36 | 0 < V@24@04 && exc@42@04 == Null | live]
; [else-branch: 36 | !(0 < V@24@04 && exc@42@04 == Null) | dead]
(push) ; 4
; [then-branch: 36 | 0 < V@24@04 && exc@42@04 == Null]
(assert (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@24@04) (= exc@42@04 $Ref.null))
  (not (= visited@22@04 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@44@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@44@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@44@04))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(visited)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 37 | exc@42@04 == Null | live]
; [else-branch: 37 | exc@42@04 != Null | live]
(push) ; 4
; [then-branch: 37 | exc@42@04 == Null]
(assert (= exc@42@04 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 37 | exc@42@04 != Null]
(assert (not (= exc@42@04 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               491
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      70
;  :arith-assert-upper      35
;  :arith-bound-prop        13
;  :arith-conflicts         12
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               25
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 51
;  :datatype-occurs-check   85
;  :datatype-splits         24
;  :decisions               56
;  :del-clause              178
;  :final-checks            53
;  :max-generation          3
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             730
;  :mk-clause               178
;  :num-allocs              147550
;  :num-checks              63
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            152649)
(push) ; 4
(assert (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               491
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      70
;  :arith-assert-upper      36
;  :arith-bound-prop        13
;  :arith-conflicts         13
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               26
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 51
;  :datatype-occurs-check   85
;  :datatype-splits         24
;  :decisions               56
;  :del-clause              178
;  :final-checks            53
;  :max-generation          3
;  :max-memory              4.15
;  :memory                  4.14
;  :mk-bool-var             731
;  :mk-clause               178
;  :num-allocs              147624
;  :num-checks              64
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            152706)
; [then-branch: 38 | 0 < V@24@04 && exc@42@04 == Null | live]
; [else-branch: 38 | !(0 < V@24@04 && exc@42@04 == Null) | dead]
(push) ; 4
; [then-branch: 38 | 0 < V@24@04 && exc@42@04 == Null]
(assert (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@24@04) (= exc@42@04 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@04)) V@24@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@44@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@44@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@44@04))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> 0 <= s
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 39 | exc@42@04 == Null | live]
; [else-branch: 39 | exc@42@04 != Null | live]
(push) ; 4
; [then-branch: 39 | exc@42@04 == Null]
(assert (= exc@42@04 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 39 | exc@42@04 != Null]
(assert (not (= exc@42@04 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               506
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      72
;  :arith-assert-upper      36
;  :arith-bound-prop        13
;  :arith-conflicts         13
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               26
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 53
;  :datatype-occurs-check   88
;  :datatype-splits         25
;  :decisions               58
;  :del-clause              178
;  :final-checks            55
;  :max-generation          3
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             736
;  :mk-clause               178
;  :num-allocs              148299
;  :num-checks              65
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            153436)
(push) ; 4
(assert (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               506
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      72
;  :arith-assert-upper      37
;  :arith-bound-prop        13
;  :arith-conflicts         14
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               27
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 53
;  :datatype-occurs-check   88
;  :datatype-splits         25
;  :decisions               58
;  :del-clause              178
;  :final-checks            55
;  :max-generation          3
;  :max-memory              4.15
;  :memory                  4.14
;  :mk-bool-var             737
;  :mk-clause               178
;  :num-allocs              148373
;  :num-checks              66
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            153493)
; [then-branch: 40 | 0 < V@24@04 && exc@42@04 == Null | live]
; [else-branch: 40 | !(0 < V@24@04 && exc@42@04 == Null) | dead]
(push) ; 4
; [then-branch: 40 | 0 < V@24@04 && exc@42@04 == Null]
(assert (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@24@04) (= exc@42@04 $Ref.null)) (<= 0 s@23@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> s < V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 41 | exc@42@04 == Null | live]
; [else-branch: 41 | exc@42@04 != Null | live]
(push) ; 4
; [then-branch: 41 | exc@42@04 == Null]
(assert (= exc@42@04 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 41 | exc@42@04 != Null]
(assert (not (= exc@42@04 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      73
;  :arith-assert-upper      37
;  :arith-bound-prop        13
;  :arith-conflicts         14
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               27
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 55
;  :datatype-occurs-check   93
;  :datatype-splits         26
;  :decisions               60
;  :del-clause              178
;  :final-checks            57
;  :max-generation          3
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             741
;  :mk-clause               178
;  :num-allocs              149000
;  :num-checks              67
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            154191)
(push) ; 4
(assert (not (and (< 0 V@24@04) (= exc@42@04 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      73
;  :arith-assert-upper      38
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               28
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 55
;  :datatype-occurs-check   93
;  :datatype-splits         26
;  :decisions               60
;  :del-clause              178
;  :final-checks            57
;  :max-generation          3
;  :max-memory              4.16
;  :memory                  4.14
;  :mk-bool-var             742
;  :mk-clause               178
;  :num-allocs              149074
;  :num-checks              68
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            154248)
; [then-branch: 42 | 0 < V@24@04 && exc@42@04 == Null | live]
; [else-branch: 42 | !(0 < V@24@04 && exc@42@04 == Null) | dead]
(push) ; 4
; [then-branch: 42 | 0 < V@24@04 && exc@42@04 == Null]
(assert (and (< 0 V@24@04) (= exc@42@04 $Ref.null)))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@24@04) (= exc@42@04 $Ref.null)) (< s@23@04 V@24@04)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04)))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               539
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      73
;  :arith-assert-upper      38
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               28
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   98
;  :datatype-splits         28
;  :decisions               63
;  :del-clause              178
;  :final-checks            59
;  :max-generation          3
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             745
;  :mk-clause               178
;  :num-allocs              149656
;  :num-checks              69
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            154865)
(push) ; 3
(assert (not (= exc@42@04 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               539
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      73
;  :arith-assert-upper      38
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               28
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   98
;  :datatype-splits         28
;  :decisions               63
;  :del-clause              178
;  :final-checks            59
;  :max-generation          3
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             745
;  :mk-clause               178
;  :num-allocs              149672
;  :num-checks              70
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            154876)
; [then-branch: 43 | exc@42@04 == Null | live]
; [else-branch: 43 | exc@42@04 != Null | dead]
(push) ; 3
; [then-branch: 43 | exc@42@04 == Null]
(assert (= exc@42@04 $Ref.null))
(declare-const unknown@45@04 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 44 | 0 <= unknown@45@04 | live]
; [else-branch: 44 | !(0 <= unknown@45@04) | live]
(push) ; 6
; [then-branch: 44 | 0 <= unknown@45@04]
(assert (<= 0 unknown@45@04))
; [eval] unknown < V
(pop) ; 6
(push) ; 6
; [else-branch: 44 | !(0 <= unknown@45@04)]
(assert (not (<= 0 unknown@45@04)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< unknown@45@04 V@24@04) (<= 0 unknown@45@04)))
; [eval] aloc(opt_get1(visited), unknown)
; [eval] opt_get1(visited)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 6
(assert (not (< unknown@45@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               539
;  :arith-add-rows          65
;  :arith-assert-diseq      17
;  :arith-assert-lower      75
;  :arith-assert-upper      38
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               28
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   98
;  :datatype-splits         28
;  :decisions               63
;  :del-clause              178
;  :final-checks            59
;  :max-generation          3
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             747
;  :mk-clause               178
;  :num-allocs              149774
;  :num-checks              71
;  :propagations            63
;  :quant-instantiations    132
;  :rlimit-count            155064)
(assert (< unknown@45@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 5
; Joined path conditions
(assert (< unknown@45@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 4
(declare-fun inv@46@04 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@45@04 Int)) (!
  (< unknown@45@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@45@04))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@45@04 Int) (unknown2@45@04 Int)) (!
  (implies
    (and
      (and (< unknown1@45@04 V@24@04) (<= 0 unknown1@45@04))
      (and (< unknown2@45@04 V@24@04) (<= 0 unknown2@45@04))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown1@45@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown2@45@04)))
    (= unknown1@45@04 unknown2@45@04))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               548
;  :arith-add-rows          69
;  :arith-assert-diseq      18
;  :arith-assert-lower      79
;  :arith-assert-upper      38
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            40
;  :conflicts               29
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   98
;  :datatype-splits         28
;  :decisions               63
;  :del-clause              184
;  :final-checks            59
;  :max-generation          3
;  :max-memory              4.16
;  :memory                  4.15
;  :mk-bool-var             768
;  :mk-clause               184
;  :num-allocs              150291
;  :num-checks              72
;  :propagations            63
;  :quant-instantiations    147
;  :rlimit-count            156006)
; Definitional axioms for inverse functions
(assert (forall ((unknown@45@04 Int)) (!
  (implies
    (and (< unknown@45@04 V@24@04) (<= 0 unknown@45@04))
    (=
      (inv@46@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@45@04))
      unknown@45@04))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@45@04))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) (inv@46@04 r))
      r))
  :pattern ((inv@46@04 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@45@04 Int)) (!
  (implies
    (and (< unknown@45@04 V@24@04) (<= 0 unknown@45@04))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@45@04)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@45@04))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@47@04 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
    (=
      ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))) r))
  :qid |qp.fvfValDef4|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef5|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) r) r))
  :pattern ((inv@46@04 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(visited), unknown).bool == false)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               560
;  :arith-add-rows          69
;  :arith-assert-diseq      18
;  :arith-assert-lower      79
;  :arith-assert-upper      38
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            40
;  :conflicts               29
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   103
;  :datatype-splits         29
;  :decisions               65
;  :del-clause              184
;  :final-checks            61
;  :max-generation          3
;  :max-memory              4.17
;  :memory                  4.16
;  :mk-bool-var             776
;  :mk-clause               184
;  :num-allocs              151603
;  :num-checks              73
;  :propagations            63
;  :quant-instantiations    147
;  :rlimit-count            158176)
; [then-branch: 45 | exc@42@04 == Null | live]
; [else-branch: 45 | exc@42@04 != Null | dead]
(push) ; 5
; [then-branch: 45 | exc@42@04 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(visited), unknown).bool == false)
(declare-const unknown@48@04 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V ==> aloc(opt_get1(visited), unknown).bool == false
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 46 | 0 <= unknown@48@04 | live]
; [else-branch: 46 | !(0 <= unknown@48@04) | live]
(push) ; 8
; [then-branch: 46 | 0 <= unknown@48@04]
(assert (<= 0 unknown@48@04))
; [eval] unknown < V
(pop) ; 8
(push) ; 8
; [else-branch: 46 | !(0 <= unknown@48@04)]
(assert (not (<= 0 unknown@48@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 47 | unknown@48@04 < V@24@04 && 0 <= unknown@48@04 | live]
; [else-branch: 47 | !(unknown@48@04 < V@24@04 && 0 <= unknown@48@04) | live]
(push) ; 8
; [then-branch: 47 | unknown@48@04 < V@24@04 && 0 <= unknown@48@04]
(assert (and (< unknown@48@04 V@24@04) (<= 0 unknown@48@04)))
; [eval] aloc(opt_get1(visited), unknown).bool == false
; [eval] aloc(opt_get1(visited), unknown)
; [eval] opt_get1(visited)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 9
; Joined path conditions
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 10
(assert (not (< unknown@48@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               560
;  :arith-add-rows          69
;  :arith-assert-diseq      18
;  :arith-assert-lower      81
;  :arith-assert-upper      38
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            40
;  :conflicts               29
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   103
;  :datatype-splits         29
;  :decisions               65
;  :del-clause              184
;  :final-checks            61
;  :max-generation          3
;  :max-memory              4.17
;  :memory                  4.16
;  :mk-bool-var             778
;  :mk-clause               184
;  :num-allocs              151705
;  :num-checks              74
;  :propagations            63
;  :quant-instantiations    147
;  :rlimit-count            158371)
(assert (< unknown@48@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@48@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04)))
(push) ; 9
(assert (not (and
  (<
    (inv@46@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))
    V@24@04)
  (<=
    0
    (inv@46@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               571
;  :arith-add-rows          80
;  :arith-assert-diseq      18
;  :arith-assert-lower      84
;  :arith-assert-upper      42
;  :arith-bound-prop        16
;  :arith-conflicts         16
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        5
;  :arith-pivots            44
;  :conflicts               30
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   103
;  :datatype-splits         29
;  :decisions               65
;  :del-clause              184
;  :final-checks            61
;  :max-generation          3
;  :max-memory              4.17
;  :memory                  4.16
;  :mk-bool-var             812
;  :mk-clause               199
;  :num-allocs              152044
;  :num-checks              75
;  :propagations            63
;  :quant-instantiations    163
;  :rlimit-count            159293)
(pop) ; 8
(push) ; 8
; [else-branch: 47 | !(unknown@48@04 < V@24@04 && 0 <= unknown@48@04)]
(assert (not (and (< unknown@48@04 V@24@04) (<= 0 unknown@48@04))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< unknown@48@04 V@24@04) (<= 0 unknown@48@04))
  (and
    (< unknown@48@04 V@24@04)
    (<= 0 unknown@48@04)
    (< unknown@48@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@48@04 Int)) (!
  (implies
    (and (< unknown@48@04 V@24@04) (<= 0 unknown@48@04))
    (and
      (< unknown@48@04 V@24@04)
      (<= 0 unknown@48@04)
      (< unknown@48@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@42@04 $Ref.null)
  (forall ((unknown@48@04 Int)) (!
    (implies
      (and (< unknown@48@04 V@24@04) (<= 0 unknown@48@04))
      (and
        (< unknown@48@04 V@24@04)
        (<= 0 unknown@48@04)
        (< unknown@48@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@42@04 $Ref.null)
  (forall ((unknown@48@04 Int)) (!
    (implies
      (and (< unknown@48@04 V@24@04) (<= 0 unknown@48@04))
      (=
        ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@48@04))
    :qid |prog.l<no position>|))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] exc != null
; [then-branch: 48 | exc@42@04 != Null | dead]
; [else-branch: 48 | exc@42@04 == Null | live]
(push) ; 4
; [else-branch: 48 | exc@42@04 == Null]
(pop) ; 4
; [eval] !(exc != null)
; [eval] exc != null
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               593
;  :arith-add-rows          84
;  :arith-assert-diseq      18
;  :arith-assert-lower      84
;  :arith-assert-upper      42
;  :arith-bound-prop        16
;  :arith-conflicts         16
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :conflicts               30
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   113
;  :datatype-splits         31
;  :decisions               69
;  :del-clause              199
;  :final-checks            65
;  :max-generation          3
;  :max-memory              4.17
;  :memory                  4.16
;  :mk-bool-var             816
;  :mk-clause               199
;  :num-allocs              153349
;  :num-checks              77
;  :propagations            63
;  :quant-instantiations    163
;  :rlimit-count            160890)
; [then-branch: 49 | exc@42@04 == Null | live]
; [else-branch: 49 | exc@42@04 != Null | dead]
(push) ; 4
; [then-branch: 49 | exc@42@04 == Null]
; [exec]
; evaluationDummy := res1
; [exec]
; aloc(opt_get1(visited), s).bool := true
; [eval] aloc(opt_get1(visited), s)
; [eval] opt_get1(visited)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 6
(assert (not (< s@23@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               593
;  :arith-add-rows          84
;  :arith-assert-diseq      18
;  :arith-assert-lower      84
;  :arith-assert-upper      42
;  :arith-bound-prop        16
;  :arith-conflicts         16
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        5
;  :arith-pivots            48
;  :conflicts               30
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   113
;  :datatype-splits         31
;  :decisions               69
;  :del-clause              199
;  :final-checks            65
;  :max-generation          3
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             816
;  :mk-clause               199
;  :num-allocs              153382
;  :num-checks              78
;  :propagations            63
;  :quant-instantiations    163
;  :rlimit-count            160925)
(assert (< s@23@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 5
; Joined path conditions
(assert (< s@23@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
; Definitional axioms for snapshot map values
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@47@04  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)))
; Precomputing data for removing quantified permissions
(define-fun pTaken@49@04 ((r $Ref)) $Perm
  (ite
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
    ($Perm.min
      (ite
        (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
        $Perm.Write
        $Perm.No)
      $Perm.Write)
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Chunk depleted?
(set-option :timeout 500)
(push) ; 5
(assert (not (forall ((r $Ref)) (!
  (=
    (-
      (ite
        (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@49@04 r))
    $Perm.No)
  
  ))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               701
;  :arith-add-rows          119
;  :arith-assert-diseq      21
;  :arith-assert-lower      102
;  :arith-assert-upper      52
;  :arith-bound-prop        26
;  :arith-conflicts         18
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        11
;  :arith-pivots            61
;  :conflicts               33
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   125
;  :datatype-splits         37
;  :decisions               95
;  :del-clause              303
;  :final-checks            71
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             990
;  :mk-clause               331
;  :num-allocs              155983
;  :num-checks              80
;  :propagations            105
;  :quant-instantiations    215
;  :rlimit-count            164842
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 5
(assert (not (forall ((r $Ref)) (!
  (implies
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
    (= (- $Perm.Write (pTaken@49@04 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               712
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   125
;  :datatype-splits         37
;  :decisions               95
;  :del-clause              313
;  :final-checks            71
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1008
;  :mk-clause               341
;  :num-allocs              156262
;  :num-checks              81
;  :propagations            110
;  :quant-instantiations    215
;  :rlimit-count            165464)
; Final check if taken enough permissions
; Done removing quantified permissions
(declare-const sm@50@04 $FVF<Bool>)
; Definitional axioms for singleton-FVF's value
(assert (=
  ($FVF.lookup_bool (as sm@50@04  $FVF<Bool>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
  true))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@50@04  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)))
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null ==> visited != (None(): option[array])
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               729
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   131
;  :datatype-splits         40
;  :decisions               103
;  :del-clause              329
;  :final-checks            74
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1025
;  :mk-clause               357
;  :num-allocs              157025
;  :num-checks              82
;  :propagations            118
;  :quant-instantiations    217
;  :rlimit-count            166231)
; [then-branch: 50 | exc@42@04 == Null | live]
; [else-branch: 50 | exc@42@04 != Null | dead]
(push) ; 6
; [then-branch: 50 | exc@42@04 == Null]
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies
  (= exc@42@04 $Ref.null)
  (not (= visited@22@04 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               729
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   131
;  :datatype-splits         40
;  :decisions               103
;  :del-clause              329
;  :final-checks            74
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1025
;  :mk-clause               357
;  :num-allocs              157048
;  :num-checks              83
;  :propagations            118
;  :quant-instantiations    217
;  :rlimit-count            166251)
(assert (implies
  (= exc@42@04 $Ref.null)
  (not (= visited@22@04 (as None<option<array>>  option<array>)))))
; [eval] exc == null ==> alen(opt_get1(visited)) == V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               746
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 81
;  :datatype-occurs-check   137
;  :datatype-splits         43
;  :decisions               111
;  :del-clause              345
;  :final-checks            77
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1040
;  :mk-clause               373
;  :num-allocs              157743
;  :num-checks              84
;  :propagations            126
;  :quant-instantiations    219
;  :rlimit-count            166913)
; [then-branch: 51 | exc@42@04 == Null | live]
; [else-branch: 51 | exc@42@04 != Null | dead]
(push) ; 6
; [then-branch: 51 | exc@42@04 == Null]
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
; Joined path conditions
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies
  (= exc@42@04 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@04)) V@24@04))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               746
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 81
;  :datatype-occurs-check   137
;  :datatype-splits         43
;  :decisions               111
;  :del-clause              345
;  :final-checks            77
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1040
;  :mk-clause               373
;  :num-allocs              157760
;  :num-checks              85
;  :propagations            126
;  :quant-instantiations    219
;  :rlimit-count            166938)
(assert (implies
  (= exc@42@04 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@04)) V@24@04)))
; [eval] exc == null ==> 0 <= s
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               763
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 85
;  :datatype-occurs-check   143
;  :datatype-splits         46
;  :decisions               119
;  :del-clause              361
;  :final-checks            80
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1055
;  :mk-clause               389
;  :num-allocs              158455
;  :num-checks              86
;  :propagations            134
;  :quant-instantiations    221
;  :rlimit-count            167600)
; [then-branch: 52 | exc@42@04 == Null | live]
; [else-branch: 52 | exc@42@04 != Null | dead]
(push) ; 6
; [then-branch: 52 | exc@42@04 == Null]
; [eval] 0 <= s
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies (= exc@42@04 $Ref.null) (<= 0 s@23@04))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               763
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 85
;  :datatype-occurs-check   143
;  :datatype-splits         46
;  :decisions               119
;  :del-clause              361
;  :final-checks            80
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1055
;  :mk-clause               389
;  :num-allocs              158476
;  :num-checks              87
;  :propagations            134
;  :quant-instantiations    221
;  :rlimit-count            167626)
(assert (implies (= exc@42@04 $Ref.null) (<= 0 s@23@04)))
; [eval] exc == null ==> s < V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               780
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   149
;  :datatype-splits         49
;  :decisions               127
;  :del-clause              377
;  :final-checks            83
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1070
;  :mk-clause               405
;  :num-allocs              159215
;  :num-checks              88
;  :propagations            142
;  :quant-instantiations    223
;  :rlimit-count            168304)
; [then-branch: 53 | exc@42@04 == Null | live]
; [else-branch: 53 | exc@42@04 != Null | dead]
(push) ; 6
; [then-branch: 53 | exc@42@04 == Null]
; [eval] s < V
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies (= exc@42@04 $Ref.null) (< s@23@04 V@24@04))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               780
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   149
;  :datatype-splits         49
;  :decisions               127
;  :del-clause              377
;  :final-checks            83
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1070
;  :mk-clause               405
;  :num-allocs              159248
;  :num-checks              89
;  :propagations            142
;  :quant-instantiations    223
;  :rlimit-count            168333)
(assert (implies (= exc@42@04 $Ref.null) (< s@23@04 V@24@04)))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               797
;  :arith-add-rows          132
;  :arith-assert-diseq      23
;  :arith-assert-lower      103
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 93
;  :datatype-occurs-check   155
;  :datatype-splits         52
;  :decisions               135
;  :del-clause              393
;  :final-checks            86
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1085
;  :mk-clause               421
;  :num-allocs              159993
;  :num-checks              90
;  :propagations            150
;  :quant-instantiations    225
;  :rlimit-count            169011)
; [then-branch: 54 | exc@42@04 == Null | live]
; [else-branch: 54 | exc@42@04 != Null | dead]
(push) ; 5
; [then-branch: 54 | exc@42@04 == Null]
(declare-const k@51@04 Int)
(push) ; 6
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 7
; [then-branch: 55 | 0 <= k@51@04 | live]
; [else-branch: 55 | !(0 <= k@51@04) | live]
(push) ; 8
; [then-branch: 55 | 0 <= k@51@04]
(assert (<= 0 k@51@04))
; [eval] k < V
(pop) ; 8
(push) ; 8
; [else-branch: 55 | !(0 <= k@51@04)]
(assert (not (<= 0 k@51@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< k@51@04 V@24@04) (<= 0 k@51@04)))
; [eval] aloc(opt_get1(visited), k)
; [eval] opt_get1(visited)
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
(assert (not (< k@51@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               797
;  :arith-add-rows          133
;  :arith-assert-diseq      23
;  :arith-assert-lower      105
;  :arith-assert-upper      56
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        11
;  :arith-pivots            64
;  :conflicts               34
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 93
;  :datatype-occurs-check   155
;  :datatype-splits         52
;  :decisions               135
;  :del-clause              393
;  :final-checks            86
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.25
;  :mk-bool-var             1087
;  :mk-clause               421
;  :num-allocs              160095
;  :num-checks              91
;  :propagations            150
;  :quant-instantiations    225
;  :rlimit-count            169197)
(assert (< k@51@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 7
; Joined path conditions
(assert (< k@51@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 6
(declare-fun inv@52@04 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@51@04 Int)) (!
  (< k@51@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@51@04))
  :qid |bool-aux|)))
(declare-const sm@53@04 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
    (=
      ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) r)
      ($FVF.lookup_bool (as sm@50@04  $FVF<Bool>) r)))
  :pattern (($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool (as sm@50@04  $FVF<Bool>) r))
  :qid |qp.fvfValDef6|)))
(assert (forall ((r $Ref)) (!
  (implies
    (<
      $Perm.No
      (-
        (ite
          (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@49@04 r)))
    (=
      ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))) r))
  :qid |qp.fvfValDef7|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@50@04  $FVF<Bool>) r) r)
    ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@04))))))) r) r))
  :pattern (($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef8|)))
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((k1@51@04 Int) (k2@51@04 Int)) (!
  (implies
    (and
      (and
        (and (< k1@51@04 V@24@04) (<= 0 k1@51@04))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k1@51@04)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k1@51@04)))
      (and
        (and (< k2@51@04 V@24@04) (<= 0 k2@51@04))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k2@51@04)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k2@51@04)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k1@51@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k2@51@04)))
    (= k1@51@04 k2@51@04))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               817
;  :arith-add-rows          138
;  :arith-assert-diseq      24
;  :arith-assert-lower      113
;  :arith-assert-upper      58
;  :arith-bound-prop        27
;  :arith-conflicts         19
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        11
;  :arith-pivots            66
;  :conflicts               35
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 93
;  :datatype-occurs-check   155
;  :datatype-splits         52
;  :decisions               135
;  :del-clause              421
;  :final-checks            86
;  :max-generation          4
;  :max-memory              4.30
;  :memory                  4.28
;  :mk-bool-var             1150
;  :mk-clause               458
;  :num-allocs              161211
;  :num-checks              92
;  :propagations            157
;  :quant-instantiations    251
;  :rlimit-count            171751)
; Definitional axioms for inverse functions
(assert (forall ((k@51@04 Int)) (!
  (implies
    (and (< k@51@04 V@24@04) (<= 0 k@51@04))
    (=
      (inv@52@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@51@04))
      k@51@04))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) k@51@04))
  :qid |bool-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@52@04 r) V@24@04) (<= 0 (inv@52@04 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) (inv@52@04 r))
      r))
  :pattern ((inv@52@04 r))
  :qid |bool-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@52@04 r) V@24@04) (<= 0 (inv@52@04 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) r) r))
  :pattern ((inv@52@04 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@54@04 ((r $Ref)) $Perm
  (ite
    (and (< (inv@52@04 r) V@24@04) (<= 0 (inv@52@04 r)))
    ($Perm.min
      (ite
        (=
          r
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
        $Perm.Write
        $Perm.No)
      $Perm.Write)
    $Perm.No))
(define-fun pTaken@55@04 ((r $Ref)) $Perm
  (ite
    (and (< (inv@52@04 r) V@24@04) (<= 0 (inv@52@04 r)))
    ($Perm.min
      (-
        (ite
          (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@49@04 r))
      (- $Perm.Write (pTaken@54@04 r)))
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Chunk depleted?
(set-option :timeout 500)
(push) ; 6
(assert (not (=
  (-
    (ite
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
      $Perm.Write
      $Perm.No)
    (pTaken@54@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)))
  $Perm.No)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               839
;  :arith-add-rows          141
;  :arith-assert-diseq      24
;  :arith-assert-lower      114
;  :arith-assert-upper      59
;  :arith-bound-prop        29
;  :arith-conflicts         19
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        11
;  :arith-pivots            67
;  :conflicts               36
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 97
;  :datatype-occurs-check   161
;  :datatype-splits         55
;  :decisions               143
;  :del-clause              450
;  :final-checks            89
;  :max-generation          4
;  :max-memory              4.32
;  :memory                  4.31
;  :mk-bool-var             1178
;  :mk-clause               478
;  :num-allocs              162688
;  :num-checks              94
;  :propagations            165
;  :quant-instantiations    255
;  :rlimit-count            173569)
; Intermediate check if already taken enough permissions
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@52@04 r) V@24@04) (<= 0 (inv@52@04 r)))
    (= (- $Perm.Write (pTaken@54@04 r)) $Perm.No))
  
  ))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               906
;  :arith-add-rows          165
;  :arith-assert-diseq      27
;  :arith-assert-lower      123
;  :arith-assert-upper      66
;  :arith-bound-prop        35
;  :arith-conflicts         20
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        18
;  :arith-pivots            76
;  :conflicts               37
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 101
;  :datatype-occurs-check   167
;  :datatype-splits         58
;  :decisions               158
;  :del-clause              525
;  :final-checks            92
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             1269
;  :mk-clause               553
;  :num-allocs              164141
;  :num-checks              95
;  :propagations            191
;  :quant-instantiations    283
;  :rlimit-count            176075
;  :time                    0.00)
; Chunk depleted?
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (=
    (-
      (-
        (ite
          (and (< (inv@46@04 r) V@24@04) (<= 0 (inv@46@04 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@49@04 r))
      (pTaken@55@04 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1128
;  :arith-add-rows          335
;  :arith-assert-diseq      37
;  :arith-assert-lower      171
;  :arith-assert-upper      107
;  :arith-bound-prop        61
;  :arith-conflicts         25
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        32
;  :arith-pivots            118
;  :conflicts               58
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 102
;  :datatype-occurs-check   167
;  :datatype-splits         58
;  :decisions               180
;  :del-clause              820
;  :final-checks            92
;  :max-generation          4
;  :max-memory              4.39
;  :memory                  4.38
;  :minimized-lits          7
;  :mk-bool-var             1687
;  :mk-clause               848
;  :num-allocs              166167
;  :num-checks              96
;  :propagations            322
;  :quant-instantiations    374
;  :rlimit-count            181143
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@52@04 r) V@24@04) (<= 0 (inv@52@04 r)))
    (= (- (- $Perm.Write (pTaken@54@04 r)) (pTaken@55@04 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1291
;  :arith-add-rows          401
;  :arith-assert-diseq      46
;  :arith-assert-lower      202
;  :arith-assert-upper      137
;  :arith-bound-prop        74
;  :arith-conflicts         30
;  :arith-eq-adapter        144
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        50
;  :arith-pivots            143
;  :conflicts               72
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 103
;  :datatype-occurs-check   167
;  :datatype-splits         58
;  :decisions               195
;  :del-clause              984
;  :final-checks            92
;  :max-generation          4
;  :max-memory              4.40
;  :memory                  4.39
;  :minimized-lits          8
;  :mk-bool-var             1887
;  :mk-clause               1012
;  :num-allocs              167156
;  :num-checks              97
;  :propagations            384
;  :quant-instantiations    401
;  :rlimit-count            184429
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1308
;  :arith-add-rows          401
;  :arith-assert-diseq      46
;  :arith-assert-lower      202
;  :arith-assert-upper      137
;  :arith-bound-prop        74
;  :arith-conflicts         30
;  :arith-eq-adapter        144
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        50
;  :arith-pivots            143
;  :conflicts               72
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 107
;  :datatype-occurs-check   173
;  :datatype-splits         61
;  :decisions               203
;  :del-clause              1000
;  :final-checks            95
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.40
;  :minimized-lits          8
;  :mk-bool-var             1902
;  :mk-clause               1028
;  :num-allocs              167887
;  :num-checks              98
;  :propagations            392
;  :quant-instantiations    403
;  :rlimit-count            185093)
; [then-branch: 56 | exc@42@04 == Null | live]
; [else-branch: 56 | exc@42@04 != Null | dead]
(push) ; 7
; [then-branch: 56 | exc@42@04 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
(declare-const unknown@56@04 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false
; [eval] 0 <= unknown && unknown < V && unknown != s
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 57 | 0 <= unknown@56@04 | live]
; [else-branch: 57 | !(0 <= unknown@56@04) | live]
(push) ; 10
; [then-branch: 57 | 0 <= unknown@56@04]
(assert (<= 0 unknown@56@04))
; [eval] unknown < V
(push) ; 11
; [then-branch: 58 | unknown@56@04 < V@24@04 | live]
; [else-branch: 58 | !(unknown@56@04 < V@24@04) | live]
(push) ; 12
; [then-branch: 58 | unknown@56@04 < V@24@04]
(assert (< unknown@56@04 V@24@04))
; [eval] unknown != s
(pop) ; 12
(push) ; 12
; [else-branch: 58 | !(unknown@56@04 < V@24@04)]
(assert (not (< unknown@56@04 V@24@04)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 57 | !(0 <= unknown@56@04)]
(assert (not (<= 0 unknown@56@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 59 | unknown@56@04 != s@23@04 && unknown@56@04 < V@24@04 && 0 <= unknown@56@04 | live]
; [else-branch: 59 | !(unknown@56@04 != s@23@04 && unknown@56@04 < V@24@04 && 0 <= unknown@56@04) | live]
(push) ; 10
; [then-branch: 59 | unknown@56@04 != s@23@04 && unknown@56@04 < V@24@04 && 0 <= unknown@56@04]
(assert (and
  (and (not (= unknown@56@04 s@23@04)) (< unknown@56@04 V@24@04))
  (<= 0 unknown@56@04)))
; [eval] aloc(opt_get1(visited), unknown).bool == false
; [eval] aloc(opt_get1(visited), unknown)
; [eval] opt_get1(visited)
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
(assert (not (< unknown@56@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1309
;  :arith-add-rows          404
;  :arith-assert-diseq      49
;  :arith-assert-lower      205
;  :arith-assert-upper      137
;  :arith-bound-prop        74
;  :arith-conflicts         30
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        50
;  :arith-pivots            144
;  :conflicts               72
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 107
;  :datatype-occurs-check   173
;  :datatype-splits         61
;  :decisions               203
;  :del-clause              1000
;  :final-checks            95
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.40
;  :minimized-lits          8
;  :mk-bool-var             1909
;  :mk-clause               1032
;  :num-allocs              168078
;  :num-checks              99
;  :propagations            392
;  :quant-instantiations    403
;  :rlimit-count            185436)
(assert (< unknown@56@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(pop) ; 11
; Joined path conditions
(assert (< unknown@56@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
      $Perm.Write
      $Perm.No)
    (-
      (ite
        (and
          (<
            (inv@46@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))
            V@24@04)
          (<=
            0
            (inv@46@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))))
        $Perm.Write
        $Perm.No)
      (pTaken@49@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1391
;  :arith-add-rows          432
;  :arith-assert-diseq      49
;  :arith-assert-lower      218
;  :arith-assert-upper      146
;  :arith-bound-prop        80
;  :arith-conflicts         32
;  :arith-eq-adapter        158
;  :arith-fixed-eqs         69
;  :arith-offset-eqs        57
;  :arith-pivots            150
;  :conflicts               83
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   173
;  :datatype-splits         61
;  :decisions               215
;  :del-clause              1045
;  :final-checks            95
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.40
;  :minimized-lits          8
;  :mk-bool-var             2003
;  :mk-clause               1115
;  :num-allocs              168632
;  :num-checks              100
;  :propagations            460
;  :quant-instantiations    431
;  :rlimit-count            187515)
(pop) ; 10
(push) ; 10
; [else-branch: 59 | !(unknown@56@04 != s@23@04 && unknown@56@04 < V@24@04 && 0 <= unknown@56@04)]
(assert (not
  (and
    (and (not (= unknown@56@04 s@23@04)) (< unknown@56@04 V@24@04))
    (<= 0 unknown@56@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and
    (and (not (= unknown@56@04 s@23@04)) (< unknown@56@04 V@24@04))
    (<= 0 unknown@56@04))
  (and
    (not (= unknown@56@04 s@23@04))
    (< unknown@56@04 V@24@04)
    (<= 0 unknown@56@04)
    (< unknown@56@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@56@04 Int)) (!
  (implies
    (and
      (and (not (= unknown@56@04 s@23@04)) (< unknown@56@04 V@24@04))
      (<= 0 unknown@56@04))
    (and
      (not (= unknown@56@04 s@23@04))
      (< unknown@56@04 V@24@04)
      (<= 0 unknown@56@04)
      (< unknown@56@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (= exc@42@04 $Ref.null)
  (forall ((unknown@56@04 Int)) (!
    (implies
      (and
        (and (not (= unknown@56@04 s@23@04)) (< unknown@56@04 V@24@04))
        (<= 0 unknown@56@04))
      (and
        (not (= unknown@56@04 s@23@04))
        (< unknown@56@04 V@24@04)
        (<= 0 unknown@56@04)
        (< unknown@56@04 (alen<Int> (opt_get1 $Snap.unit visited@22@04)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (= exc@42@04 $Ref.null)
  (forall ((unknown@56@04 Int)) (!
    (implies
      (and
        (and (not (= unknown@56@04 s@23@04)) (< unknown@56@04 V@24@04))
        (<= 0 unknown@56@04))
      (=
        ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1464
;  :arith-add-rows          466
;  :arith-assert-diseq      53
;  :arith-assert-lower      234
;  :arith-assert-upper      155
;  :arith-bound-prop        89
;  :arith-conflicts         34
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        66
;  :arith-pivots            168
;  :conflicts               95
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 109
;  :datatype-occurs-check   173
;  :datatype-splits         61
;  :decisions               232
;  :del-clause              1192
;  :final-checks            95
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.39
;  :minimized-lits          8
;  :mk-bool-var             2115
;  :mk-clause               1220
;  :num-allocs              169413
;  :num-checks              101
;  :propagations            531
;  :quant-instantiations    465
;  :rlimit-count            190396
;  :time                    0.00)
(assert (implies
  (= exc@42@04 $Ref.null)
  (forall ((unknown@56@04 Int)) (!
    (implies
      (and
        (and (not (= unknown@56@04 s@23@04)) (< unknown@56@04 V@24@04))
        (<= 0 unknown@56@04))
      (=
        ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) unknown@56@04))
    :qid |prog.l<no position>|))))
; [eval] exc == null ==> aloc(opt_get1(visited), s).bool == true
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@42@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1481
;  :arith-add-rows          466
;  :arith-assert-diseq      53
;  :arith-assert-lower      234
;  :arith-assert-upper      155
;  :arith-bound-prop        89
;  :arith-conflicts         34
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        66
;  :arith-pivots            168
;  :conflicts               95
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 113
;  :datatype-occurs-check   179
;  :datatype-splits         64
;  :decisions               240
;  :del-clause              1208
;  :final-checks            98
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.40
;  :minimized-lits          8
;  :mk-bool-var             2131
;  :mk-clause               1236
;  :num-allocs              170339
;  :num-checks              102
;  :propagations            539
;  :quant-instantiations    467
;  :rlimit-count            191390)
; [then-branch: 60 | exc@42@04 == Null | live]
; [else-branch: 60 | exc@42@04 != Null | dead]
(push) ; 7
; [then-branch: 60 | exc@42@04 == Null]
; [eval] aloc(opt_get1(visited), s).bool == true
; [eval] aloc(opt_get1(visited), s)
; [eval] opt_get1(visited)
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
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)))
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  $Perm.No
  (+
    (ite
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
      $Perm.Write
      $Perm.No)
    (-
      (ite
        (and
          (<
            (inv@46@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
            V@24@04)
          (<=
            0
            (inv@46@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))))
        $Perm.Write
        $Perm.No)
      (pTaken@49@04 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1481
;  :arith-add-rows          466
;  :arith-assert-diseq      53
;  :arith-assert-lower      235
;  :arith-assert-upper      155
;  :arith-bound-prop        89
;  :arith-conflicts         35
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        66
;  :arith-pivots            168
;  :conflicts               96
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 113
;  :datatype-occurs-check   179
;  :datatype-splits         64
;  :decisions               240
;  :del-clause              1208
;  :final-checks            98
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.39
;  :minimized-lits          8
;  :mk-bool-var             2132
;  :mk-clause               1236
;  :num-allocs              170574
;  :num-checks              103
;  :propagations            539
;  :quant-instantiations    467
;  :rlimit-count            191774)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (= exc@42@04 $Ref.null)
  ($FVF.loc_bool ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))))
(push) ; 6
(assert (not (implies
  (= exc@42@04 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
    true))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1481
;  :arith-add-rows          466
;  :arith-assert-diseq      53
;  :arith-assert-lower      235
;  :arith-assert-upper      155
;  :arith-bound-prop        89
;  :arith-conflicts         35
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        66
;  :arith-pivots            168
;  :conflicts               97
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 113
;  :datatype-occurs-check   179
;  :datatype-splits         64
;  :decisions               240
;  :del-clause              1208
;  :final-checks            98
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.39
;  :minimized-lits          8
;  :mk-bool-var             2132
;  :mk-clause               1236
;  :num-allocs              170708
;  :num-checks              104
;  :propagations            539
;  :quant-instantiations    467
;  :rlimit-count            191941)
(assert (implies
  (= exc@42@04 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@53@04  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@22@04) s@23@04))
    true)))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
