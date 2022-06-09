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
; ---------- do_par_$unknown$ ----------
(declare-const p@0@05 option<array>)
(declare-const V@1@05 Int)
(declare-const exc@2@05 $Ref)
(declare-const res@3@05 void)
(declare-const p@4@05 option<array>)
(declare-const V@5@05 Int)
(declare-const exc@6@05 $Ref)
(declare-const res@7@05 void)
(push) ; 1
(declare-const $t@8@05 $Snap)
(assert (= $t@8@05 ($Snap.combine ($Snap.first $t@8@05) ($Snap.second $t@8@05))))
(assert (= ($Snap.first $t@8@05) $Snap.unit))
; [eval] 0 < V ==> p != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@5@05))))
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
(assert (not (< 0 V@5@05)))
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
; [then-branch: 0 | 0 < V@5@05 | live]
; [else-branch: 0 | !(0 < V@5@05) | live]
(push) ; 3
; [then-branch: 0 | 0 < V@5@05]
(assert (< 0 V@5@05))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(0 < V@5@05)]
(assert (not (< 0 V@5@05)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (< 0 V@5@05) (not (= p@4@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@8@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@8@05))
    ($Snap.second ($Snap.second $t@8@05)))))
(assert (= ($Snap.first ($Snap.second $t@8@05)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(p)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@5@05))))
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
(assert (not (< 0 V@5@05)))
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
; [then-branch: 1 | 0 < V@5@05 | live]
; [else-branch: 1 | !(0 < V@5@05) | live]
(push) ; 3
; [then-branch: 1 | 0 < V@5@05]
(assert (< 0 V@5@05))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= p@4@05 (as None<option<array>>  option<array>)))))
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
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(0 < V@5@05)]
(assert (not (< 0 V@5@05)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@5@05)
  (and (< 0 V@5@05) (not (= p@4@05 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies (< 0 V@5@05) (= (alen<Int> (opt_get1 $Snap.unit p@4@05)) V@5@05)))
(declare-const i1@9@05 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 2 | 0 <= i1@9@05 | live]
; [else-branch: 2 | !(0 <= i1@9@05) | live]
(push) ; 4
; [then-branch: 2 | 0 <= i1@9@05]
(assert (<= 0 i1@9@05))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 2 | !(0 <= i1@9@05)]
(assert (not (<= 0 i1@9@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< i1@9@05 V@5@05) (<= 0 i1@9@05)))
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 3
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 4
(assert (not (not (= p@4@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27
;  :arith-add-rows          1
;  :arith-assert-lower      9
;  :arith-assert-upper      4
;  :arith-bound-prop        1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               2
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.94
;  :mk-bool-var             322
;  :mk-clause               7
;  :num-allocs              123527
;  :num-checks              6
;  :propagations            5
;  :quant-instantiations    6
;  :rlimit-count            122309)
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(pop) ; 3
; Joined path conditions
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(push) ; 3
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 4
(assert (not (< i1@9@05 (alen<Int> (opt_get1 $Snap.unit p@4@05)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27
;  :arith-add-rows          2
;  :arith-assert-lower      10
;  :arith-assert-upper      4
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        2
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               3
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.94
;  :mk-bool-var             323
;  :mk-clause               7
;  :num-allocs              123708
;  :num-checks              7
;  :propagations            5
;  :quant-instantiations    6
;  :rlimit-count            122471)
(assert (< i1@9@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
(pop) ; 3
; Joined path conditions
(assert (< i1@9@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
(pop) ; 2
(declare-fun inv@10@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@9@05 Int)) (!
  (and
    (not (= p@4@05 (as None<option<array>>  option<array>)))
    (< i1@9@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) i1@9@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((i11@9@05 Int) (i12@9@05 Int)) (!
  (implies
    (and
      (and (< i11@9@05 V@5@05) (<= 0 i11@9@05))
      (and (< i12@9@05 V@5@05) (<= 0 i12@9@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) i11@9@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) i12@9@05)))
    (= i11@9@05 i12@9@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               49
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      17
;  :arith-assert-upper      4
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-pivots            6
;  :conflicts               4
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              28
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.97
;  :mk-bool-var             363
;  :mk-clause               34
;  :num-allocs              124462
;  :num-checks              8
;  :propagations            21
;  :quant-instantiations    23
;  :rlimit-count            123672
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((i1@9@05 Int)) (!
  (implies
    (and (< i1@9@05 V@5@05) (<= 0 i1@9@05))
    (=
      (inv@10@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) i1@9@05))
      i1@9@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) i1@9@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@10@05 r) V@5@05) (<= 0 (inv@10@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) (inv@10@05 r))
      r))
  :pattern ((inv@10@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((i1@9@05 Int)) (!
  (implies
    (and (< i1@9@05 V@5@05) (<= 0 i1@9@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) i1@9@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) i1@9@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@11@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@10@05 r) V@5@05) (<= 0 (inv@10@05 r)))
    (=
      ($FVF.lookup_int (as sm@11@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second $t@8@05))) r)))
  :pattern (($FVF.lookup_int (as sm@11@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second $t@8@05))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second $t@8@05))) r) r)
  :pattern (($FVF.lookup_int (as sm@11@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@10@05 r) V@5@05) (<= 0 (inv@10@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@11@05  $FVF<Int>) r) r))
  :pattern ((inv@10@05 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@12@05 $Snap)
(assert (= $t@12@05 ($Snap.combine ($Snap.first $t@12@05) ($Snap.second $t@12@05))))
(assert (= ($Snap.first $t@12@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@6@05 $Ref.null))
(assert (=
  ($Snap.second $t@12@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@12@05))
    ($Snap.second ($Snap.second $t@12@05)))))
(assert (= ($Snap.first ($Snap.second $t@12@05)) $Snap.unit))
; [eval] exc == null && 0 < V ==> p != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 3 | exc@6@05 == Null | live]
; [else-branch: 3 | exc@6@05 != Null | live]
(push) ; 4
; [then-branch: 3 | exc@6@05 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 3 | exc@6@05 != Null]
(assert (not (= exc@6@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@5@05) (= exc@6@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               84
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      23
;  :arith-assert-upper      6
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-pivots            10
;  :conflicts               4
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   16
;  :datatype-splits         7
;  :decisions               9
;  :del-clause              30
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.99
;  :mk-bool-var             393
;  :mk-clause               36
;  :num-allocs              126413
;  :num-checks              10
;  :propagations            26
;  :quant-instantiations    33
;  :rlimit-count            126514)
(push) ; 4
(assert (not (and (< 0 V@5@05) (= exc@6@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               91
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      23
;  :arith-assert-upper      7
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-pivots            10
;  :conflicts               4
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   21
;  :datatype-splits         9
;  :decisions               11
;  :del-clause              30
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.99
;  :mk-bool-var             395
;  :mk-clause               36
;  :num-allocs              126787
;  :num-checks              11
;  :propagations            27
;  :quant-instantiations    33
;  :rlimit-count            126939)
; [then-branch: 4 | 0 < V@5@05 && exc@6@05 == Null | live]
; [else-branch: 4 | !(0 < V@5@05 && exc@6@05 == Null) | live]
(push) ; 4
; [then-branch: 4 | 0 < V@5@05 && exc@6@05 == Null]
(assert (and (< 0 V@5@05) (= exc@6@05 $Ref.null)))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(push) ; 4
; [else-branch: 4 | !(0 < V@5@05 && exc@6@05 == Null)]
(assert (not (and (< 0 V@5@05) (= exc@6@05 $Ref.null))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and (< 0 V@5@05) (= exc@6@05 $Ref.null))
  (not (= p@4@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@12@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@12@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@12@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@12@05))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(p)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 5 | exc@6@05 == Null | live]
; [else-branch: 5 | exc@6@05 != Null | live]
(push) ; 4
; [then-branch: 5 | exc@6@05 == Null]
(assert (= exc@6@05 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 5 | exc@6@05 != Null]
(assert (not (= exc@6@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@5@05) (= exc@6@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               110
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      26
;  :arith-assert-upper      8
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-pivots            12
;  :conflicts               4
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   26
;  :datatype-splits         11
;  :decisions               13
;  :del-clause              31
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             407
;  :mk-clause               37
;  :num-allocs              127402
;  :num-checks              12
;  :propagations            30
;  :quant-instantiations    38
;  :rlimit-count            127716)
(push) ; 4
(assert (not (and (< 0 V@5@05) (= exc@6@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               117
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      26
;  :arith-assert-upper      9
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-pivots            12
;  :conflicts               4
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   31
;  :datatype-splits         13
;  :decisions               15
;  :del-clause              31
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.99
;  :mk-bool-var             409
;  :mk-clause               37
;  :num-allocs              127784
;  :num-checks              13
;  :propagations            31
;  :quant-instantiations    38
;  :rlimit-count            128143)
; [then-branch: 6 | 0 < V@5@05 && exc@6@05 == Null | live]
; [else-branch: 6 | !(0 < V@5@05 && exc@6@05 == Null) | live]
(push) ; 4
; [then-branch: 6 | 0 < V@5@05 && exc@6@05 == Null]
(assert (and (< 0 V@5@05) (= exc@6@05 $Ref.null)))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= p@4@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      29
;  :arith-assert-upper      10
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         5
;  :arith-pivots            13
;  :conflicts               5
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   31
;  :datatype-splits         13
;  :decisions               15
;  :del-clause              31
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             417
;  :mk-clause               37
;  :num-allocs              127958
;  :num-checks              14
;  :propagations            34
;  :quant-instantiations    43
;  :rlimit-count            128349)
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(pop) ; 4
(push) ; 4
; [else-branch: 6 | !(0 < V@5@05 && exc@6@05 == Null)]
(assert (not (and (< 0 V@5@05) (= exc@6@05 $Ref.null))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@5@05) (= exc@6@05 $Ref.null))
  (and
    (< 0 V@5@05)
    (= exc@6@05 $Ref.null)
    (not (= p@4@05 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies
  (and (< 0 V@5@05) (= exc@6@05 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit p@4@05)) V@5@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@12@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@05)))))))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= exc@6@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      32
;  :arith-assert-upper      11
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         6
;  :arith-pivots            16
;  :conflicts               5
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   36
;  :datatype-splits         16
;  :decisions               20
;  :del-clause              32
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             429
;  :mk-clause               38
;  :num-allocs              128523
;  :num-checks              15
;  :propagations            36
;  :quant-instantiations    48
;  :rlimit-count            129147)
(push) ; 3
(assert (not (= exc@6@05 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      32
;  :arith-assert-upper      11
;  :arith-bound-prop        2
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         6
;  :arith-pivots            16
;  :conflicts               5
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   36
;  :datatype-splits         16
;  :decisions               20
;  :del-clause              32
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             429
;  :mk-clause               38
;  :num-allocs              128539
;  :num-checks              16
;  :propagations            36
;  :quant-instantiations    48
;  :rlimit-count            129158)
; [then-branch: 7 | exc@6@05 == Null | live]
; [else-branch: 7 | exc@6@05 != Null | dead]
(push) ; 3
; [then-branch: 7 | exc@6@05 == Null]
(assert (= exc@6@05 $Ref.null))
(declare-const unknown@13@05 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 8 | 0 <= unknown@13@05 | live]
; [else-branch: 8 | !(0 <= unknown@13@05) | live]
(push) ; 6
; [then-branch: 8 | 0 <= unknown@13@05]
(assert (<= 0 unknown@13@05))
; [eval] unknown < V
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(0 <= unknown@13@05)]
(assert (not (<= 0 unknown@13@05)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< unknown@13@05 V@5@05) (<= 0 unknown@13@05)))
; [eval] aloc(opt_get1(p), unknown)
; [eval] opt_get1(p)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= p@4@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               149
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      37
;  :arith-assert-upper      12
;  :arith-bound-prop        3
;  :arith-conflicts         1
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-pivots            17
;  :conflicts               6
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   36
;  :datatype-splits         16
;  :decisions               20
;  :del-clause              32
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             439
;  :mk-clause               39
;  :num-allocs              128721
;  :num-checks              17
;  :propagations            39
;  :quant-instantiations    53
;  :rlimit-count            129436)
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown@13@05 (alen<Int> (opt_get1 $Snap.unit p@4@05)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               149
;  :arith-add-rows          7
;  :arith-assert-diseq      2
;  :arith-assert-lower      38
;  :arith-assert-upper      12
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-pivots            19
;  :conflicts               7
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   36
;  :datatype-splits         16
;  :decisions               20
;  :del-clause              32
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.99
;  :mk-bool-var             440
;  :mk-clause               39
;  :num-allocs              128873
;  :num-checks              18
;  :propagations            39
;  :quant-instantiations    53
;  :rlimit-count            129626)
(assert (< unknown@13@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
(pop) ; 5
; Joined path conditions
(assert (< unknown@13@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
(pop) ; 4
(declare-fun inv@14@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@13@05 Int)) (!
  (and
    (not (= p@4@05 (as None<option<array>>  option<array>)))
    (< unknown@13@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@13@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@13@05 Int) (unknown2@13@05 Int)) (!
  (implies
    (and
      (and (< unknown1@13@05 V@5@05) (<= 0 unknown1@13@05))
      (and (< unknown2@13@05 V@5@05) (<= 0 unknown2@13@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown1@13@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown2@13@05)))
    (= unknown1@13@05 unknown2@13@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               160
;  :arith-add-rows          9
;  :arith-assert-diseq      3
;  :arith-assert-lower      40
;  :arith-assert-upper      14
;  :arith-bound-prop        4
;  :arith-conflicts         2
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         7
;  :arith-pivots            22
;  :conflicts               8
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   36
;  :datatype-splits         16
;  :decisions               20
;  :del-clause              47
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.00
;  :mk-bool-var             462
;  :mk-clause               53
;  :num-allocs              129393
;  :num-checks              19
;  :propagations            47
;  :quant-instantiations    66
;  :rlimit-count            130639)
; Definitional axioms for inverse functions
(assert (forall ((unknown@13@05 Int)) (!
  (implies
    (and (< unknown@13@05 V@5@05) (<= 0 unknown@13@05))
    (=
      (inv@14@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@13@05))
      unknown@13@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@13@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@14@05 r) V@5@05) (<= 0 (inv@14@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) (inv@14@05 r))
      r))
  :pattern ((inv@14@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@13@05 Int)) (!
  (implies
    (and (< unknown@13@05 V@5@05) (<= 0 unknown@13@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@13@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@13@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@15@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@14@05 r) V@5@05) (<= 0 (inv@14@05 r)))
    (=
      ($FVF.lookup_int (as sm@15@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@15@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@05))))) r))
  :qid |qp.fvfValDef2|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@15@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef3|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@14@05 r) V@5@05) (<= 0 (inv@14@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@15@05  $FVF<Int>) r) r))
  :pattern ((inv@14@05 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@05))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@6@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               175
;  :arith-add-rows          9
;  :arith-assert-diseq      3
;  :arith-assert-lower      43
;  :arith-assert-upper      15
;  :arith-bound-prop        4
;  :arith-conflicts         2
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         8
;  :arith-pivots            24
;  :conflicts               8
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   41
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              48
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             479
;  :mk-clause               54
;  :num-allocs              130744
;  :num-checks              20
;  :propagations            49
;  :quant-instantiations    71
;  :rlimit-count            132824)
; [then-branch: 9 | exc@6@05 == Null | live]
; [else-branch: 9 | exc@6@05 != Null | dead]
(push) ; 5
; [then-branch: 9 | exc@6@05 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
(declare-const unknown@16@05 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 10 | 0 <= unknown@16@05 | live]
; [else-branch: 10 | !(0 <= unknown@16@05) | live]
(push) ; 8
; [then-branch: 10 | 0 <= unknown@16@05]
(assert (<= 0 unknown@16@05))
; [eval] unknown < V
(pop) ; 8
(push) ; 8
; [else-branch: 10 | !(0 <= unknown@16@05)]
(assert (not (<= 0 unknown@16@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 11 | unknown@16@05 < V@5@05 && 0 <= unknown@16@05 | live]
; [else-branch: 11 | !(unknown@16@05 < V@5@05 && 0 <= unknown@16@05) | live]
(push) ; 8
; [then-branch: 11 | unknown@16@05 < V@5@05 && 0 <= unknown@16@05]
(assert (and (< unknown@16@05 V@5@05) (<= 0 unknown@16@05)))
; [eval] aloc(opt_get1(p), unknown).int == 0
; [eval] aloc(opt_get1(p), unknown)
; [eval] opt_get1(p)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= p@4@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               181
;  :arith-add-rows          9
;  :arith-assert-diseq      3
;  :arith-assert-lower      48
;  :arith-assert-upper      16
;  :arith-bound-prop        5
;  :arith-conflicts         2
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         9
;  :arith-pivots            25
;  :conflicts               9
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   41
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              48
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             489
;  :mk-clause               55
;  :num-allocs              130931
;  :num-checks              21
;  :propagations            52
;  :quant-instantiations    76
;  :rlimit-count            133107)
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= p@4@05 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< unknown@16@05 (alen<Int> (opt_get1 $Snap.unit p@4@05)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               181
;  :arith-add-rows          12
;  :arith-assert-diseq      3
;  :arith-assert-lower      48
;  :arith-assert-upper      17
;  :arith-bound-prop        5
;  :arith-conflicts         3
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         9
;  :arith-pivots            27
;  :conflicts               10
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   41
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              48
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             490
;  :mk-clause               55
;  :num-allocs              131074
;  :num-checks              22
;  :propagations            52
;  :quant-instantiations    76
;  :rlimit-count            133301)
(assert (< unknown@16@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@16@05 (alen<Int> (opt_get1 $Snap.unit p@4@05))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@15@05  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05)))
(push) ; 9
(assert (not (and
  (<
    (inv@14@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))
    V@5@05)
  (<=
    0
    (inv@14@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               196
;  :arith-add-rows          20
;  :arith-assert-diseq      3
;  :arith-assert-lower      51
;  :arith-assert-upper      20
;  :arith-bound-prop        7
;  :arith-conflicts         4
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         11
;  :arith-pivots            30
;  :conflicts               11
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   41
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              48
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             519
;  :mk-clause               65
;  :num-allocs              131471
;  :num-checks              23
;  :propagations            56
;  :quant-instantiations    90
;  :rlimit-count            134224)
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(unknown@16@05 < V@5@05 && 0 <= unknown@16@05)]
(assert (not (and (< unknown@16@05 V@5@05) (<= 0 unknown@16@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< unknown@16@05 V@5@05) (<= 0 unknown@16@05))
  (and
    (< unknown@16@05 V@5@05)
    (<= 0 unknown@16@05)
    (not (= p@4@05 (as None<option<array>>  option<array>)))
    (< unknown@16@05 (alen<Int> (opt_get1 $Snap.unit p@4@05)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@15@05  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@16@05 Int)) (!
  (implies
    (and (< unknown@16@05 V@5@05) (<= 0 unknown@16@05))
    (and
      (< unknown@16@05 V@5@05)
      (<= 0 unknown@16@05)
      (not (= p@4@05 (as None<option<array>>  option<array>)))
      (< unknown@16@05 (alen<Int> (opt_get1 $Snap.unit p@4@05)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@15@05  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@6@05 $Ref.null)
  (forall ((unknown@16@05 Int)) (!
    (implies
      (and (< unknown@16@05 V@5@05) (<= 0 unknown@16@05))
      (and
        (< unknown@16@05 V@5@05)
        (<= 0 unknown@16@05)
        (not (= p@4@05 (as None<option<array>>  option<array>)))
        (< unknown@16@05 (alen<Int> (opt_get1 $Snap.unit p@4@05)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@15@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@6@05 $Ref.null)
  (forall ((unknown@16@05 Int)) (!
    (implies
      (and (< unknown@16@05 V@5@05) (<= 0 unknown@16@05))
      (=
        ($FVF.lookup_int (as sm@15@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@4@05) unknown@16@05))
    :qid |prog.l<no position>|))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- initializeWithZeros ----------
(declare-const this@17@05 $Ref)
(declare-const tid@18@05 Int)
(declare-const p@19@05 option<array>)
(declare-const V@20@05 Int)
(declare-const exc@21@05 $Ref)
(declare-const res@22@05 void)
(declare-const this@23@05 $Ref)
(declare-const tid@24@05 Int)
(declare-const p@25@05 option<array>)
(declare-const V@26@05 Int)
(declare-const exc@27@05 $Ref)
(declare-const res@28@05 void)
(push) ; 1
(declare-const $t@29@05 $Snap)
(assert (= $t@29@05 ($Snap.combine ($Snap.first $t@29@05) ($Snap.second $t@29@05))))
(assert (= ($Snap.first $t@29@05) $Snap.unit))
; [eval] this != null
(assert (not (= this@23@05 $Ref.null)))
(assert (=
  ($Snap.second $t@29@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@29@05))
    ($Snap.second ($Snap.second $t@29@05)))))
(assert (= ($Snap.first ($Snap.second $t@29@05)) $Snap.unit))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= p@25@05 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second $t@29@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@29@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@29@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@29@05))) $Snap.unit))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (opt_get1 $Snap.unit p@25@05)) V@26@05))
(declare-const k@30@05 Int)
(push) ; 2
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 3
; [then-branch: 12 | 0 <= k@30@05 | live]
; [else-branch: 12 | !(0 <= k@30@05) | live]
(push) ; 4
; [then-branch: 12 | 0 <= k@30@05]
(assert (<= 0 k@30@05))
; [eval] k < V
(pop) ; 4
(push) ; 4
; [else-branch: 12 | !(0 <= k@30@05)]
(assert (not (<= 0 k@30@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< k@30@05 V@26@05) (<= 0 k@30@05)))
; [eval] aloc(opt_get1(p), k)
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
(push) ; 4
(assert (not (< k@30@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               220
;  :arith-add-rows          24
;  :arith-assert-diseq      3
;  :arith-assert-lower      55
;  :arith-assert-upper      21
;  :arith-bound-prop        7
;  :arith-conflicts         4
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         12
;  :arith-pivots            36
;  :conflicts               11
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   41
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              65
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.04
;  :mk-bool-var             538
;  :mk-clause               65
;  :num-allocs              132031
;  :num-checks              24
;  :propagations            56
;  :quant-instantiations    95
;  :rlimit-count            135335)
(assert (< k@30@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 3
; Joined path conditions
(assert (< k@30@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 2
(declare-fun inv@31@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@30@05 Int)) (!
  (< k@30@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@30@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((k1@30@05 Int) (k2@30@05 Int)) (!
  (implies
    (and
      (and (< k1@30@05 V@26@05) (<= 0 k1@30@05))
      (and (< k2@30@05 V@26@05) (<= 0 k2@30@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k1@30@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k2@30@05)))
    (= k1@30@05 k2@30@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               236
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      59
;  :arith-assert-upper      23
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        1
;  :arith-pivots            44
;  :conflicts               12
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   41
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              80
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.04
;  :mk-bool-var             564
;  :mk-clause               80
;  :num-allocs              132535
;  :num-checks              25
;  :propagations            62
;  :quant-instantiations    105
;  :rlimit-count            136354)
; Definitional axioms for inverse functions
(assert (forall ((k@30@05 Int)) (!
  (implies
    (and (< k@30@05 V@26@05) (<= 0 k@30@05))
    (=
      (inv@31@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@30@05))
      k@30@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@30@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@31@05 r) V@26@05) (<= 0 (inv@31@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@31@05 r))
      r))
  :pattern ((inv@31@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@30@05 Int)) (!
  (implies
    (and (< k@30@05 V@26@05) (<= 0 k@30@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@30@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@30@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@32@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@31@05 r) V@26@05) (<= 0 (inv@31@05 r)))
    (=
      ($FVF.lookup_int (as sm@32@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second $t@29@05)))) r)))
  :pattern (($FVF.lookup_int (as sm@32@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second $t@29@05)))) r))
  :qid |qp.fvfValDef4|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second $t@29@05)))) r) r)
  :pattern (($FVF.lookup_int (as sm@32@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef5|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@31@05 r) V@26@05) (<= 0 (inv@31@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@32@05  $FVF<Int>) r) r))
  :pattern ((inv@31@05 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@33@05 $Snap)
(assert (= $t@33@05 ($Snap.combine ($Snap.first $t@33@05) ($Snap.second $t@33@05))))
(assert (= ($Snap.first $t@33@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@27@05 $Ref.null))
(assert (=
  ($Snap.second $t@33@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@33@05))
    ($Snap.second ($Snap.second $t@33@05)))))
(assert (= ($Snap.first ($Snap.second $t@33@05)) $Snap.unit))
; [eval] exc == null ==> p != (None(): option[array])
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@27@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               259
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      59
;  :arith-assert-upper      23
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        1
;  :arith-pivots            44
;  :conflicts               12
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   47
;  :datatype-splits         20
;  :decisions               27
;  :del-clause              80
;  :final-checks            26
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             577
;  :mk-clause               80
;  :num-allocs              134340
;  :num-checks              27
;  :propagations            62
;  :quant-instantiations    105
;  :rlimit-count            138933)
; [then-branch: 13 | exc@27@05 == Null | live]
; [else-branch: 13 | exc@27@05 != Null | dead]
(push) ; 4
; [then-branch: 13 | exc@27@05 == Null]
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@27@05 $Ref.null)
  (not (= p@25@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@33@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@33@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@33@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@33@05))) $Snap.unit))
; [eval] exc == null ==> alen(opt_get1(p)) == V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@27@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               273
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      59
;  :arith-assert-upper      23
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        1
;  :arith-pivots            44
;  :conflicts               12
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   52
;  :datatype-splits         21
;  :decisions               29
;  :del-clause              80
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             580
;  :mk-clause               80
;  :num-allocs              134850
;  :num-checks              28
;  :propagations            62
;  :quant-instantiations    105
;  :rlimit-count            139484)
; [then-branch: 14 | exc@27@05 == Null | live]
; [else-branch: 14 | exc@27@05 != Null | dead]
(push) ; 4
; [then-branch: 14 | exc@27@05 == Null]
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
  (= exc@27@05 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit p@25@05)) V@26@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@33@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@05)))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@27@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               288
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      59
;  :arith-assert-upper      23
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        1
;  :arith-pivots            44
;  :conflicts               12
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   57
;  :datatype-splits         23
;  :decisions               32
;  :del-clause              80
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             583
;  :mk-clause               80
;  :num-allocs              135359
;  :num-checks              29
;  :propagations            62
;  :quant-instantiations    105
;  :rlimit-count            140026)
; [then-branch: 15 | exc@27@05 == Null | live]
; [else-branch: 15 | exc@27@05 != Null | dead]
(push) ; 3
; [then-branch: 15 | exc@27@05 == Null]
(declare-const k@34@05 Int)
(push) ; 4
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 5
; [then-branch: 16 | 0 <= k@34@05 | live]
; [else-branch: 16 | !(0 <= k@34@05) | live]
(push) ; 6
; [then-branch: 16 | 0 <= k@34@05]
(assert (<= 0 k@34@05))
; [eval] k < V
(pop) ; 6
(push) ; 6
; [else-branch: 16 | !(0 <= k@34@05)]
(assert (not (<= 0 k@34@05)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< k@34@05 V@26@05) (<= 0 k@34@05)))
; [eval] aloc(opt_get1(p), k)
; [eval] opt_get1(p)
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
(assert (not (< k@34@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               290
;  :arith-add-rows          30
;  :arith-assert-diseq      4
;  :arith-assert-lower      62
;  :arith-assert-upper      24
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :conflicts               12
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   57
;  :datatype-splits         23
;  :decisions               32
;  :del-clause              80
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.05
;  :mk-bool-var             588
;  :mk-clause               80
;  :num-allocs              135478
;  :num-checks              30
;  :propagations            62
;  :quant-instantiations    105
;  :rlimit-count            140230)
(assert (< k@34@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 5
; Joined path conditions
(assert (< k@34@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 4
(declare-fun inv@35@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@34@05 Int)) (!
  (< k@34@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@34@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((k1@34@05 Int) (k2@34@05 Int)) (!
  (implies
    (and
      (and (< k1@34@05 V@26@05) (<= 0 k1@34@05))
      (and (< k2@34@05 V@26@05) (<= 0 k2@34@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k1@34@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k2@34@05)))
    (= k1@34@05 k2@34@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               297
;  :arith-add-rows          32
;  :arith-assert-diseq      5
;  :arith-assert-lower      66
;  :arith-assert-upper      24
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        1
;  :arith-pivots            48
;  :conflicts               13
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   57
;  :datatype-splits         23
;  :decisions               32
;  :del-clause              87
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.04
;  :mk-bool-var             609
;  :mk-clause               87
;  :num-allocs              136003
;  :num-checks              31
;  :propagations            62
;  :quant-instantiations    116
;  :rlimit-count            141105)
; Definitional axioms for inverse functions
(assert (forall ((k@34@05 Int)) (!
  (implies
    (and (< k@34@05 V@26@05) (<= 0 k@34@05))
    (=
      (inv@35@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@34@05))
      k@34@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@34@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@35@05 r))
      r))
  :pattern ((inv@35@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@34@05 Int)) (!
  (implies
    (and (< k@34@05 V@26@05) (<= 0 k@34@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@34@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@34@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@36@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
    (=
      ($FVF.lookup_int (as sm@36@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@36@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef6|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@36@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef7|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@36@05  $FVF<Int>) r) r))
  :pattern ((inv@35@05 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@05)))))
  $Snap.unit))
; [eval] exc == null ==> valid_graph_vertices(this, p, V)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@27@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               314
;  :arith-add-rows          32
;  :arith-assert-diseq      5
;  :arith-assert-lower      66
;  :arith-assert-upper      24
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        1
;  :arith-pivots            48
;  :conflicts               13
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   62
;  :datatype-splits         25
;  :decisions               35
;  :del-clause              87
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.06
;  :mk-bool-var             619
;  :mk-clause               87
;  :num-allocs              137383
;  :num-checks              32
;  :propagations            62
;  :quant-instantiations    116
;  :rlimit-count            143452)
; [then-branch: 17 | exc@27@05 == Null | live]
; [else-branch: 17 | exc@27@05 != Null | dead]
(push) ; 5
; [then-branch: 17 | exc@27@05 == Null]
; [eval] valid_graph_vertices(this, p, V)
(push) ; 6
; [eval] this != null
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
; Joined path conditions
(declare-const i1@37@05 Int)
(push) ; 7
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 8
; [then-branch: 18 | 0 <= i1@37@05 | live]
; [else-branch: 18 | !(0 <= i1@37@05) | live]
(push) ; 9
; [then-branch: 18 | 0 <= i1@37@05]
(assert (<= 0 i1@37@05))
; [eval] i1 < V
(pop) ; 9
(push) ; 9
; [else-branch: 18 | !(0 <= i1@37@05)]
(assert (not (<= 0 i1@37@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< i1@37@05 V@26@05) (<= 0 i1@37@05)))
(declare-const $k@38@05 $Perm)
(assert ($Perm.isReadVar $k@38@05 $Perm.Write))
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
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
(assert (not (< i1@37@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               316
;  :arith-add-rows          32
;  :arith-assert-diseq      6
;  :arith-assert-lower      71
;  :arith-assert-upper      26
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        1
;  :arith-pivots            49
;  :conflicts               13
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   62
;  :datatype-splits         25
;  :decisions               35
;  :del-clause              87
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.06
;  :mk-bool-var             628
;  :mk-clause               89
;  :num-allocs              137575
;  :num-checks              33
;  :propagations            63
;  :quant-instantiations    116
;  :rlimit-count            143806)
(assert (< i1@37@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 8
; Joined path conditions
(assert (< i1@37@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 7
(declare-fun inv@39@05 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@38@05 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@37@05 Int)) (!
  (< i1@37@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
  :qid |int-aux|)))
(push) ; 7
(assert (not (forall ((i1@37@05 Int)) (!
  (implies
    (and (< i1@37@05 V@26@05) (<= 0 i1@37@05))
    (or (= $k@38@05 $Perm.No) (< $Perm.No $k@38@05)))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               316
;  :arith-add-rows          32
;  :arith-assert-diseq      7
;  :arith-assert-lower      73
;  :arith-assert-upper      27
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        1
;  :arith-pivots            50
;  :conflicts               14
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   62
;  :datatype-splits         25
;  :decisions               35
;  :del-clause              89
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.06
;  :mk-bool-var             635
;  :mk-clause               91
;  :num-allocs              138010
;  :num-checks              34
;  :propagations            64
;  :quant-instantiations    116
;  :rlimit-count            144355)
; Definitional axioms for snapshot map domain
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((i11@37@05 Int) (i12@37@05 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< i11@37@05 V@26@05) (<= 0 i11@37@05))
          ($FVF.loc_int ($FVF.lookup_int (as sm@36@05  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@37@05)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@37@05)))
        (< $Perm.No $k@38@05))
      (and
        (and
          (and (< i12@37@05 V@26@05) (<= 0 i12@37@05))
          ($FVF.loc_int ($FVF.lookup_int (as sm@36@05  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@37@05)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@37@05)))
        (< $Perm.No $k@38@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@37@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@37@05)))
    (= i11@37@05 i12@37@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               327
;  :arith-add-rows          39
;  :arith-assert-diseq      8
;  :arith-assert-lower      77
;  :arith-assert-upper      27
;  :arith-bound-prop        9
;  :arith-conflicts         4
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        1
;  :arith-pivots            55
;  :conflicts               15
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   62
;  :datatype-splits         25
;  :decisions               35
;  :del-clause              97
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.10
;  :mk-bool-var             663
;  :mk-clause               99
;  :num-allocs              138459
;  :num-checks              35
;  :propagations            64
;  :quant-instantiations    133
;  :rlimit-count            145385)
; Definitional axioms for inverse functions
(assert (forall ((i1@37@05 Int)) (!
  (implies
    (and (and (< i1@37@05 V@26@05) (<= 0 i1@37@05)) (< $Perm.No $k@38@05))
    (=
      (inv@39@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
      i1@37@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
      (< $Perm.No $k@38@05))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@39@05 r))
      r))
  :pattern ((inv@39@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@36@05  $FVF<Int>) r) r))
  :pattern ((inv@39@05 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@40@05 ((r $Ref)) $Perm
  (ite
    (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
    ($Perm.min
      (ite
        (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
        $Perm.Write
        $Perm.No)
      $k@38@05)
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Constrain original permissions $k@38@05
(assert (forall ((r $Ref)) (!
  (implies
    (not
      (=
        (ite
          (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
          $Perm.Write
          $Perm.No)
        $Perm.No))
    (ite
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
      (<
        (ite
          (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
          $k@38@05
          $Perm.No)
        $Perm.Write)
      (<
        (ite
          (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
          $k@38@05
          $Perm.No)
        $Perm.No)))
  :pattern ((inv@35@05 r))
  :pattern ((inv@39@05 r))
  :qid |qp.srp8|)))
; Intermediate check if already taken enough permissions
(set-option :timeout 500)
(push) ; 7
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
    (= (- $k@38@05 (pTaken@40@05 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               367
;  :arith-add-rows          47
;  :arith-assert-diseq      9
;  :arith-assert-lower      85
;  :arith-assert-upper      32
;  :arith-bound-prop        15
;  :arith-conflicts         4
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        6
;  :arith-pivots            63
;  :conflicts               16
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 32
;  :datatype-occurs-check   67
;  :datatype-splits         27
;  :decisions               38
;  :del-clause              132
;  :final-checks            34
;  :max-generation          4
;  :max-memory              4.14
;  :memory                  4.13
;  :mk-bool-var             723
;  :mk-clause               132
;  :num-allocs              140213
;  :num-checks              37
;  :propagations            72
;  :quant-instantiations    153
;  :rlimit-count            148467)
; Final check if taken enough permissions
; Done removing quantified permissions
(declare-const sm@41@05 $FVF<Int>)
; Definitional axioms for snapshot map domain
(assert (forall ((r $Ref)) (!
  (iff
    (Set_in r ($FVF.domain_int (as sm@41@05  $FVF<Int>)))
    (and
      (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
      (< $Perm.No $k@38@05)))
  :pattern ((Set_in r ($FVF.domain_int (as sm@41@05  $FVF<Int>))))
  :qid |qp.fvfDomDef11|)))
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
        (< $Perm.No $k@38@05))
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r))))
    (=
      ($FVF.lookup_int (as sm@41@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@41@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef9|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@41@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef10|)))
(pop) ; 6
; Joined path conditions
(assert ($Perm.isReadVar $k@38@05 $Perm.Write))
(assert (forall ((i1@37@05 Int)) (!
  (implies
    (and (and (< i1@37@05 V@26@05) (<= 0 i1@37@05)) (< $Perm.No $k@38@05))
    (=
      (inv@39@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
      i1@37@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
      (< $Perm.No $k@38@05))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@39@05 r))
      r))
  :pattern ((inv@39@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (iff
    (Set_in r ($FVF.domain_int (as sm@41@05  $FVF<Int>)))
    (and
      (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
      (< $Perm.No $k@38@05)))
  :pattern ((Set_in r ($FVF.domain_int (as sm@41@05  $FVF<Int>))))
  :qid |qp.fvfDomDef11|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
        (< $Perm.No $k@38@05))
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r))))
    (=
      ($FVF.lookup_int (as sm@41@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@41@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef9|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@41@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef10|)))
(assert (and
  (forall ((i1@37@05 Int)) (!
    (< i1@37@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
    :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
    :qid |int-aux|))
  (forall ((r $Ref)) (!
    (implies
      (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@36@05  $FVF<Int>) r) r))
    :pattern ((inv@39@05 r))
    ))
  (forall ((r $Ref)) (!
    (implies
      (not
        (=
          (ite
            (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
            $Perm.Write
            $Perm.No)
          $Perm.No))
      (ite
        (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
        (<
          (ite
            (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
            $k@38@05
            $Perm.No)
          $Perm.Write)
        (<
          (ite
            (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
            $k@38@05
            $Perm.No)
          $Perm.No)))
    :pattern ((inv@35@05 r))
    :pattern ((inv@39@05 r))
    :qid |qp.srp8|))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert ($Perm.isReadVar $k@38@05 $Perm.Write))
(assert (forall ((i1@37@05 Int)) (!
  (implies
    (and (and (< i1@37@05 V@26@05) (<= 0 i1@37@05)) (< $Perm.No $k@38@05))
    (=
      (inv@39@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
      i1@37@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
      (< $Perm.No $k@38@05))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@39@05 r))
      r))
  :pattern ((inv@39@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (iff
    (Set_in r ($FVF.domain_int (as sm@41@05  $FVF<Int>)))
    (and
      (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
      (< $Perm.No $k@38@05)))
  :pattern ((Set_in r ($FVF.domain_int (as sm@41@05  $FVF<Int>))))
  :qid |qp.fvfDomDef11|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
        (< $Perm.No $k@38@05))
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r))))
    (=
      ($FVF.lookup_int (as sm@41@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@41@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef9|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@41@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef10|)))
(assert (implies
  (= exc@27@05 $Ref.null)
  (and
    (forall ((i1@37@05 Int)) (!
      (< i1@37@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@37@05))
      :qid |int-aux|))
    (forall ((r $Ref)) (!
      (implies
        (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@36@05  $FVF<Int>) r) r))
      :pattern ((inv@39@05 r))
      ))
    (forall ((r $Ref)) (!
      (implies
        (not
          (=
            (ite
              (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
              $Perm.Write
              $Perm.No)
            $Perm.No))
        (ite
          (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
          (<
            (ite
              (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
              $k@38@05
              $Perm.No)
            $Perm.Write)
          (<
            (ite
              (and (< (inv@39@05 r) V@26@05) (<= 0 (inv@39@05 r)))
              $k@38@05
              $Perm.No)
            $Perm.No)))
      :pattern ((inv@35@05 r))
      :pattern ((inv@39@05 r))
      :qid |qp.srp8|)))))
(assert (implies
  (= exc@27@05 $Ref.null)
  (valid_graph_vertices ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        $Snap.unit
        ($SortWrappers.$FVF<Int>To$Snap (as sm@41@05  $FVF<Int>))))) this@23@05 p@25@05 V@26@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@33@05)))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@27@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-add-rows          48
;  :arith-assert-diseq      11
;  :arith-assert-lower      90
;  :arith-assert-upper      35
;  :arith-bound-prop        15
;  :arith-conflicts         4
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         19
;  :arith-offset-eqs        6
;  :arith-pivots            64
;  :conflicts               16
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 35
;  :datatype-occurs-check   75
;  :datatype-splits         29
;  :decisions               41
;  :del-clause              132
;  :final-checks            36
;  :max-generation          4
;  :max-memory              4.17
;  :memory                  4.16
;  :mk-bool-var             770
;  :mk-clause               165
;  :num-allocs              142851
;  :num-checks              38
;  :propagations            88
;  :quant-instantiations    157
;  :rlimit-count            152847)
; [then-branch: 19 | exc@27@05 == Null | live]
; [else-branch: 19 | exc@27@05 != Null | dead]
(push) ; 5
; [then-branch: 19 | exc@27@05 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
(declare-const unknown@42@05 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 20 | 0 <= unknown@42@05 | live]
; [else-branch: 20 | !(0 <= unknown@42@05) | live]
(push) ; 8
; [then-branch: 20 | 0 <= unknown@42@05]
(assert (<= 0 unknown@42@05))
; [eval] unknown < V
(pop) ; 8
(push) ; 8
; [else-branch: 20 | !(0 <= unknown@42@05)]
(assert (not (<= 0 unknown@42@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 21 | unknown@42@05 < V@26@05 && 0 <= unknown@42@05 | live]
; [else-branch: 21 | !(unknown@42@05 < V@26@05 && 0 <= unknown@42@05) | live]
(push) ; 8
; [then-branch: 21 | unknown@42@05 < V@26@05 && 0 <= unknown@42@05]
(assert (and (< unknown@42@05 V@26@05) (<= 0 unknown@42@05)))
; [eval] aloc(opt_get1(p), unknown).int == 0
; [eval] aloc(opt_get1(p), unknown)
; [eval] opt_get1(p)
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
(assert (not (< unknown@42@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-add-rows          49
;  :arith-assert-diseq      11
;  :arith-assert-lower      92
;  :arith-assert-upper      35
;  :arith-bound-prop        15
;  :arith-conflicts         4
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         19
;  :arith-offset-eqs        6
;  :arith-pivots            64
;  :conflicts               16
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 35
;  :datatype-occurs-check   75
;  :datatype-splits         29
;  :decisions               41
;  :del-clause              132
;  :final-checks            36
;  :max-generation          4
;  :max-memory              4.17
;  :memory                  4.16
;  :mk-bool-var             772
;  :mk-clause               165
;  :num-allocs              142954
;  :num-checks              39
;  :propagations            88
;  :quant-instantiations    157
;  :rlimit-count            153043)
(assert (< unknown@42@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@42@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(declare-const sm@43@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
    (=
      ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef13|)))
(declare-const pm@44@05 $FPM)
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@44@05  $FPM) r)
    (ite
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resPrmSumDef14|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resTrgDef15|)))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05)))
(push) ; 9
(assert (not (<
  $Perm.No
  ($FVF.perm_int (as pm@44@05  $FPM) (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               425
;  :arith-add-rows          68
;  :arith-assert-diseq      13
;  :arith-assert-lower      101
;  :arith-assert-upper      45
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        6
;  :arith-pivots            71
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 35
;  :datatype-occurs-check   75
;  :datatype-splits         29
;  :decisions               43
;  :del-clause              134
;  :final-checks            36
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.20
;  :mk-bool-var             852
;  :mk-clause               208
;  :num-allocs              144223
;  :num-checks              40
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            155717)
(pop) ; 8
(push) ; 8
; [else-branch: 21 | !(unknown@42@05 < V@26@05 && 0 <= unknown@42@05)]
(assert (not (and (< unknown@42@05 V@26@05) (<= 0 unknown@42@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
    (=
      ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef13|)))
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@44@05  $FPM) r)
    (ite
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resPrmSumDef14|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resTrgDef15|)))
(assert (implies
  (and (< unknown@42@05 V@26@05) (<= 0 unknown@42@05))
  (and
    (< unknown@42@05 V@26@05)
    (<= 0 unknown@42@05)
    (< unknown@42@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
    (=
      ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef13|)))
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@44@05  $FPM) r)
    (ite
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resPrmSumDef14|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resTrgDef15|)))
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@42@05 Int)) (!
  (implies
    (and (< unknown@42@05 V@26@05) (<= 0 unknown@42@05))
    (and
      (< unknown@42@05 V@26@05)
      (<= 0 unknown@42@05)
      (< unknown@42@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
    (=
      ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@43@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef13|)))
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@44@05  $FPM) r)
    (ite
      (and (< (inv@35@05 r) V@26@05) (<= 0 (inv@35@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resPrmSumDef14|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@33@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@44@05  $FPM) r))
  :qid |qp.resTrgDef15|)))
(assert (implies
  (= exc@27@05 $Ref.null)
  (forall ((unknown@42@05 Int)) (!
    (implies
      (and (< unknown@42@05 V@26@05) (<= 0 unknown@42@05))
      (and
        (< unknown@42@05 V@26@05)
        (<= 0 unknown@42@05)
        (< unknown@42@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@43@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@27@05 $Ref.null)
  (forall ((unknown@42@05 Int)) (!
    (implies
      (and (< unknown@42@05 V@26@05) (<= 0 unknown@42@05))
      (=
        ($FVF.lookup_int (as sm@43@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@42@05))
    :qid |prog.l<no position>|))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@45@05 void)
; [exec]
; var res1: void
(declare-const res1@46@05 void)
; [exec]
; var evaluationDummy: void
(declare-const evaluationDummy@47@05 void)
; [exec]
; exc := null
; [exec]
; exc, res1 := do_par_$unknown$(p, V)
; [eval] 0 < V ==> p != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@26@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               430
;  :arith-add-rows          76
;  :arith-assert-diseq      13
;  :arith-assert-lower      103
;  :arith-assert-upper      46
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        6
;  :arith-pivots            80
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   76
;  :datatype-splits         29
;  :decisions               44
;  :del-clause              209
;  :final-checks            37
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             856
;  :mk-clause               209
;  :num-allocs              145188
;  :num-checks              41
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            156816)
(push) ; 4
(assert (not (< 0 V@26@05)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               435
;  :arith-add-rows          76
;  :arith-assert-diseq      13
;  :arith-assert-lower      104
;  :arith-assert-upper      48
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        6
;  :arith-pivots            83
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 37
;  :datatype-occurs-check   77
;  :datatype-splits         29
;  :decisions               45
;  :del-clause              210
;  :final-checks            38
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             860
;  :mk-clause               210
;  :num-allocs              145673
;  :num-checks              42
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            157235)
; [then-branch: 22 | 0 < V@26@05 | live]
; [else-branch: 22 | !(0 < V@26@05) | live]
(push) ; 4
; [then-branch: 22 | 0 < V@26@05]
(assert (< 0 V@26@05))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(push) ; 4
; [else-branch: 22 | !(0 < V@26@05)]
(assert (not (< 0 V@26@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@26@05) (not (= p@25@05 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               435
;  :arith-add-rows          76
;  :arith-assert-diseq      13
;  :arith-assert-lower      104
;  :arith-assert-upper      48
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        6
;  :arith-pivots            83
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 37
;  :datatype-occurs-check   77
;  :datatype-splits         29
;  :decisions               45
;  :del-clause              210
;  :final-checks            38
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             860
;  :mk-clause               210
;  :num-allocs              145704
;  :num-checks              43
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            157280)
(assert (implies (< 0 V@26@05) (not (= p@25@05 (as None<option<array>>  option<array>)))))
; [eval] 0 < V ==> alen(opt_get1(p)) == V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@26@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               440
;  :arith-add-rows          76
;  :arith-assert-diseq      13
;  :arith-assert-lower      106
;  :arith-assert-upper      49
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         27
;  :arith-offset-eqs        6
;  :arith-pivots            85
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 38
;  :datatype-occurs-check   78
;  :datatype-splits         29
;  :decisions               46
;  :del-clause              211
;  :final-checks            39
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             864
;  :mk-clause               211
;  :num-allocs              146179
;  :num-checks              44
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            157725)
(push) ; 4
(assert (not (< 0 V@26@05)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               445
;  :arith-add-rows          76
;  :arith-assert-diseq      13
;  :arith-assert-lower      107
;  :arith-assert-upper      51
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        6
;  :arith-pivots            87
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   79
;  :datatype-splits         29
;  :decisions               47
;  :del-clause              212
;  :final-checks            40
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             868
;  :mk-clause               212
;  :num-allocs              146663
;  :num-checks              45
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            158140)
; [then-branch: 23 | 0 < V@26@05 | live]
; [else-branch: 23 | !(0 < V@26@05) | live]
(push) ; 4
; [then-branch: 23 | 0 < V@26@05]
(assert (< 0 V@26@05))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 23 | !(0 < V@26@05)]
(assert (not (< 0 V@26@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@26@05) (= (alen<Int> (opt_get1 $Snap.unit p@25@05)) V@26@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               447
;  :arith-add-rows          76
;  :arith-assert-diseq      13
;  :arith-assert-lower      109
;  :arith-assert-upper      52
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        6
;  :arith-pivots            89
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   79
;  :datatype-splits         29
;  :decisions               47
;  :del-clause              212
;  :final-checks            40
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             872
;  :mk-clause               212
;  :num-allocs              146770
;  :num-checks              46
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            158262)
(assert (implies (< 0 V@26@05) (= (alen<Int> (opt_get1 $Snap.unit p@25@05)) V@26@05)))
(declare-const i1@48@05 Int)
(push) ; 3
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 4
; [then-branch: 24 | 0 <= i1@48@05 | live]
; [else-branch: 24 | !(0 <= i1@48@05) | live]
(push) ; 5
; [then-branch: 24 | 0 <= i1@48@05]
(assert (<= 0 i1@48@05))
; [eval] i1 < V
(pop) ; 5
(push) ; 5
; [else-branch: 24 | !(0 <= i1@48@05)]
(assert (not (<= 0 i1@48@05)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i1@48@05 V@26@05) (<= 0 i1@48@05)))
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
(push) ; 5
(assert (not (< i1@48@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               449
;  :arith-add-rows          77
;  :arith-assert-diseq      13
;  :arith-assert-lower      112
;  :arith-assert-upper      53
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        6
;  :arith-pivots            91
;  :conflicts               19
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   79
;  :datatype-splits         29
;  :decisions               47
;  :del-clause              212
;  :final-checks            40
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             877
;  :mk-clause               212
;  :num-allocs              146883
;  :num-checks              47
;  :propagations            99
;  :quant-instantiations    184
;  :rlimit-count            158492)
(assert (< i1@48@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 4
; Joined path conditions
(assert (< i1@48@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 3
(declare-fun inv@49@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@48@05 Int)) (!
  (< i1@48@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@48@05))
  :qid |int-aux|)))
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i11@48@05 Int) (i12@48@05 Int)) (!
  (implies
    (and
      (and
        (and (< i11@48@05 V@26@05) (<= 0 i11@48@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@32@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@48@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@48@05)))
      (and
        (and (< i12@48@05 V@26@05) (<= 0 i12@48@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@32@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@48@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@48@05)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@48@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@48@05)))
    (= i11@48@05 i12@48@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               458
;  :arith-add-rows          77
;  :arith-assert-diseq      14
;  :arith-assert-lower      115
;  :arith-assert-upper      54
;  :arith-bound-prop        19
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        6
;  :arith-pivots            93
;  :conflicts               20
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   79
;  :datatype-splits         29
;  :decisions               47
;  :del-clause              220
;  :final-checks            40
;  :max-generation          4
;  :max-memory              4.20
;  :memory                  4.19
;  :mk-bool-var             904
;  :mk-clause               220
;  :num-allocs              147414
;  :num-checks              48
;  :propagations            99
;  :quant-instantiations    197
;  :rlimit-count            159489)
; Definitional axioms for inverse functions
(assert (forall ((i1@48@05 Int)) (!
  (implies
    (and (< i1@48@05 V@26@05) (<= 0 i1@48@05))
    (=
      (inv@49@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@48@05))
      i1@48@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@48@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@49@05 r) V@26@05) (<= 0 (inv@49@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@49@05 r))
      r))
  :pattern ((inv@49@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@49@05 r) V@26@05) (<= 0 (inv@49@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@32@05  $FVF<Int>) r) r))
  :pattern ((inv@49@05 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@50@05 ((r $Ref)) $Perm
  (ite
    (and (< (inv@49@05 r) V@26@05) (<= 0 (inv@49@05 r)))
    ($Perm.min
      (ite
        (and (< (inv@31@05 r) V@26@05) (<= 0 (inv@31@05 r)))
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
        (and (< (inv@31@05 r) V@26@05) (<= 0 (inv@31@05 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@50@05 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               524
;  :arith-add-rows          88
;  :arith-assert-diseq      22
;  :arith-assert-lower      139
;  :arith-assert-upper      65
;  :arith-bound-prop        21
;  :arith-conflicts         9
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        6
;  :arith-pivots            105
;  :conflicts               27
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   80
;  :datatype-splits         29
;  :decisions               54
;  :del-clause              270
;  :final-checks            41
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             996
;  :mk-clause               270
;  :num-allocs              148928
;  :num-checks              50
;  :propagations            134
;  :quant-instantiations    235
;  :rlimit-count            162297
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 3
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@49@05 r) V@26@05) (<= 0 (inv@49@05 r)))
    (= (- $Perm.Write (pTaken@50@05 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               540
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      144
;  :arith-assert-upper      71
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        6
;  :arith-pivots            111
;  :conflicts               28
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   80
;  :datatype-splits         29
;  :decisions               54
;  :del-clause              287
;  :final-checks            41
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             1033
;  :mk-clause               287
;  :num-allocs              149336
;  :num-checks              51
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            163296)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
(declare-const exc@51@05 $Ref)
(declare-const res@52@05 void)
(declare-const $t@53@05 $Snap)
(assert (= $t@53@05 ($Snap.combine ($Snap.first $t@53@05) ($Snap.second $t@53@05))))
(assert (= ($Snap.first $t@53@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@51@05 $Ref.null))
(assert (=
  ($Snap.second $t@53@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@53@05))
    ($Snap.second ($Snap.second $t@53@05)))))
(assert (= ($Snap.first ($Snap.second $t@53@05)) $Snap.unit))
; [eval] exc == null && 0 < V ==> p != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 25 | exc@51@05 == Null | live]
; [else-branch: 25 | exc@51@05 != Null | live]
(push) ; 4
; [then-branch: 25 | exc@51@05 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 25 | exc@51@05 != Null]
(assert (not (= exc@51@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@26@05) (= exc@51@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               562
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      146
;  :arith-assert-upper      72
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         37
;  :arith-offset-eqs        6
;  :arith-pivots            113
;  :conflicts               28
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   83
;  :datatype-splits         30
;  :decisions               56
;  :del-clause              288
;  :final-checks            43
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.22
;  :minimized-lits          1
;  :mk-bool-var             1043
;  :mk-clause               288
;  :num-allocs              149984
;  :num-checks              52
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            164076)
(push) ; 4
(assert (not (and (< 0 V@26@05) (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               571
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      147
;  :arith-assert-upper      74
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        6
;  :arith-pivots            116
;  :conflicts               28
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   86
;  :datatype-splits         31
;  :decisions               58
;  :del-clause              289
;  :final-checks            45
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.22
;  :minimized-lits          1
;  :mk-bool-var             1048
;  :mk-clause               289
;  :num-allocs              150478
;  :num-checks              53
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            164535)
; [then-branch: 26 | 0 < V@26@05 && exc@51@05 == Null | live]
; [else-branch: 26 | !(0 < V@26@05 && exc@51@05 == Null) | live]
(push) ; 4
; [then-branch: 26 | 0 < V@26@05 && exc@51@05 == Null]
(assert (and (< 0 V@26@05) (= exc@51@05 $Ref.null)))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(push) ; 4
; [else-branch: 26 | !(0 < V@26@05 && exc@51@05 == Null)]
(assert (not (and (< 0 V@26@05) (= exc@51@05 $Ref.null))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and (< 0 V@26@05) (= exc@51@05 $Ref.null))
  (not (= p@25@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@53@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@53@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@53@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@53@05))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(p)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 27 | exc@51@05 == Null | live]
; [else-branch: 27 | exc@51@05 != Null | live]
(push) ; 4
; [then-branch: 27 | exc@51@05 == Null]
(assert (= exc@51@05 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 27 | exc@51@05 != Null]
(assert (not (= exc@51@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@26@05) (= exc@51@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               587
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      149
;  :arith-assert-upper      75
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         39
;  :arith-offset-eqs        6
;  :arith-pivots            118
;  :conflicts               28
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   91
;  :datatype-splits         32
;  :decisions               60
;  :del-clause              290
;  :final-checks            47
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.22
;  :minimized-lits          1
;  :mk-bool-var             1055
;  :mk-clause               290
;  :num-allocs              151079
;  :num-checks              54
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            165233)
(push) ; 4
(assert (not (and (< 0 V@26@05) (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               597
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      150
;  :arith-assert-upper      77
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        6
;  :arith-pivots            121
;  :conflicts               28
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   96
;  :datatype-splits         33
;  :decisions               62
;  :del-clause              291
;  :final-checks            49
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.22
;  :minimized-lits          1
;  :mk-bool-var             1060
;  :mk-clause               291
;  :num-allocs              151575
;  :num-checks              55
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            165695)
; [then-branch: 28 | 0 < V@26@05 && exc@51@05 == Null | live]
; [else-branch: 28 | !(0 < V@26@05 && exc@51@05 == Null) | live]
(push) ; 4
; [then-branch: 28 | 0 < V@26@05 && exc@51@05 == Null]
(assert (and (< 0 V@26@05) (= exc@51@05 $Ref.null)))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 28 | !(0 < V@26@05 && exc@51@05 == Null)]
(assert (not (and (< 0 V@26@05) (= exc@51@05 $Ref.null))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and (< 0 V@26@05) (= exc@51@05 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit p@25@05)) V@26@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@53@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@05)))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               614
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      152
;  :arith-assert-upper      78
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         41
;  :arith-offset-eqs        6
;  :arith-pivots            123
;  :conflicts               28
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   101
;  :datatype-splits         35
;  :decisions               65
;  :del-clause              291
;  :final-checks            51
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.22
;  :minimized-lits          1
;  :mk-bool-var             1067
;  :mk-clause               291
;  :num-allocs              152168
;  :num-checks              56
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            166352)
(push) ; 3
(assert (not (= exc@51@05 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               614
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      152
;  :arith-assert-upper      78
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         41
;  :arith-offset-eqs        6
;  :arith-pivots            123
;  :conflicts               28
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   101
;  :datatype-splits         35
;  :decisions               65
;  :del-clause              291
;  :final-checks            51
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.22
;  :minimized-lits          1
;  :mk-bool-var             1067
;  :mk-clause               291
;  :num-allocs              152185
;  :num-checks              57
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            166363)
; [then-branch: 29 | exc@51@05 == Null | live]
; [else-branch: 29 | exc@51@05 != Null | dead]
(push) ; 3
; [then-branch: 29 | exc@51@05 == Null]
(assert (= exc@51@05 $Ref.null))
(declare-const unknown@54@05 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 30 | 0 <= unknown@54@05 | live]
; [else-branch: 30 | !(0 <= unknown@54@05) | live]
(push) ; 6
; [then-branch: 30 | 0 <= unknown@54@05]
(assert (<= 0 unknown@54@05))
; [eval] unknown < V
(pop) ; 6
(push) ; 6
; [else-branch: 30 | !(0 <= unknown@54@05)]
(assert (not (<= 0 unknown@54@05)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< unknown@54@05 V@26@05) (<= 0 unknown@54@05)))
; [eval] aloc(opt_get1(p), unknown)
; [eval] opt_get1(p)
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
(assert (not (< unknown@54@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               616
;  :arith-add-rows          95
;  :arith-assert-diseq      24
;  :arith-assert-lower      154
;  :arith-assert-upper      80
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        6
;  :arith-pivots            124
;  :conflicts               28
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   101
;  :datatype-splits         35
;  :decisions               65
;  :del-clause              291
;  :final-checks            51
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.22
;  :minimized-lits          1
;  :mk-bool-var             1072
;  :mk-clause               291
;  :num-allocs              152321
;  :num-checks              58
;  :propagations            139
;  :quant-instantiations    248
;  :rlimit-count            166562)
(assert (< unknown@54@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 5
; Joined path conditions
(assert (< unknown@54@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 4
(declare-fun inv@55@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@54@05 Int)) (!
  (< unknown@54@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@54@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@54@05 Int) (unknown2@54@05 Int)) (!
  (implies
    (and
      (and (< unknown1@54@05 V@26@05) (<= 0 unknown1@54@05))
      (and (< unknown2@54@05 V@26@05) (<= 0 unknown2@54@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown1@54@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown2@54@05)))
    (= unknown1@54@05 unknown2@54@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               625
;  :arith-add-rows          95
;  :arith-assert-diseq      25
;  :arith-assert-lower      158
;  :arith-assert-upper      80
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        6
;  :arith-pivots            125
;  :conflicts               29
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 52
;  :datatype-occurs-check   101
;  :datatype-splits         35
;  :decisions               65
;  :del-clause              298
;  :final-checks            51
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.21
;  :minimized-lits          1
;  :mk-bool-var             1095
;  :mk-clause               298
;  :num-allocs              152866
;  :num-checks              59
;  :propagations            139
;  :quant-instantiations    263
;  :rlimit-count            167486)
; Definitional axioms for inverse functions
(assert (forall ((unknown@54@05 Int)) (!
  (implies
    (and (< unknown@54@05 V@26@05) (<= 0 unknown@54@05))
    (=
      (inv@55@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@54@05))
      unknown@54@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@54@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@55@05 r))
      r))
  :pattern ((inv@55@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@54@05 Int)) (!
  (implies
    (and (< unknown@54@05 V@26@05) (<= 0 unknown@54@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@54@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@54@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@56@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
    (=
      ($FVF.lookup_int (as sm@56@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@56@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef16|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@56@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef17|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) r) r))
  :pattern ((inv@55@05 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@53@05))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               635
;  :arith-add-rows          95
;  :arith-assert-diseq      25
;  :arith-assert-lower      158
;  :arith-assert-upper      80
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        6
;  :arith-pivots            125
;  :conflicts               29
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   106
;  :datatype-splits         36
;  :decisions               67
;  :del-clause              298
;  :final-checks            53
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.23
;  :minimized-lits          1
;  :mk-bool-var             1103
;  :mk-clause               298
;  :num-allocs              154115
;  :num-checks              60
;  :propagations            139
;  :quant-instantiations    263
;  :rlimit-count            169552)
; [then-branch: 31 | exc@51@05 == Null | live]
; [else-branch: 31 | exc@51@05 != Null | dead]
(push) ; 5
; [then-branch: 31 | exc@51@05 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
(declare-const unknown@57@05 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 32 | 0 <= unknown@57@05 | live]
; [else-branch: 32 | !(0 <= unknown@57@05) | live]
(push) ; 8
; [then-branch: 32 | 0 <= unknown@57@05]
(assert (<= 0 unknown@57@05))
; [eval] unknown < V
(pop) ; 8
(push) ; 8
; [else-branch: 32 | !(0 <= unknown@57@05)]
(assert (not (<= 0 unknown@57@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 33 | unknown@57@05 < V@26@05 && 0 <= unknown@57@05 | live]
; [else-branch: 33 | !(unknown@57@05 < V@26@05 && 0 <= unknown@57@05) | live]
(push) ; 8
; [then-branch: 33 | unknown@57@05 < V@26@05 && 0 <= unknown@57@05]
(assert (and (< unknown@57@05 V@26@05) (<= 0 unknown@57@05)))
; [eval] aloc(opt_get1(p), unknown).int == 0
; [eval] aloc(opt_get1(p), unknown)
; [eval] opt_get1(p)
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
(assert (not (< unknown@57@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               637
;  :arith-add-rows          96
;  :arith-assert-diseq      25
;  :arith-assert-lower      161
;  :arith-assert-upper      81
;  :arith-bound-prop        22
;  :arith-conflicts         10
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         43
;  :arith-offset-eqs        6
;  :arith-pivots            127
;  :conflicts               29
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   106
;  :datatype-splits         36
;  :decisions               67
;  :del-clause              298
;  :final-checks            53
;  :max-generation          4
;  :max-memory              4.24
;  :memory                  4.23
;  :minimized-lits          1
;  :mk-bool-var             1108
;  :mk-clause               298
;  :num-allocs              154235
;  :num-checks              61
;  :propagations            139
;  :quant-instantiations    263
;  :rlimit-count            169788)
(assert (< unknown@57@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@57@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05)))
(push) ; 9
(assert (not (and
  (<
    (inv@55@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))
    V@26@05)
  (<=
    0
    (inv@55@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               664
;  :arith-add-rows          103
;  :arith-assert-diseq      25
;  :arith-assert-lower      164
;  :arith-assert-upper      84
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        13
;  :arith-pivots            130
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   106
;  :datatype-splits         36
;  :decisions               67
;  :del-clause              298
;  :final-checks            53
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1152
;  :mk-clause               320
;  :num-allocs              154612
;  :num-checks              62
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            170784)
(pop) ; 8
(push) ; 8
; [else-branch: 33 | !(unknown@57@05 < V@26@05 && 0 <= unknown@57@05)]
(assert (not (and (< unknown@57@05 V@26@05) (<= 0 unknown@57@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< unknown@57@05 V@26@05) (<= 0 unknown@57@05))
  (and
    (< unknown@57@05 V@26@05)
    (<= 0 unknown@57@05)
    (< unknown@57@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@57@05 Int)) (!
  (implies
    (and (< unknown@57@05 V@26@05) (<= 0 unknown@57@05))
    (and
      (< unknown@57@05 V@26@05)
      (<= 0 unknown@57@05)
      (< unknown@57@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@51@05 $Ref.null)
  (forall ((unknown@57@05 Int)) (!
    (implies
      (and (< unknown@57@05 V@26@05) (<= 0 unknown@57@05))
      (and
        (< unknown@57@05 V@26@05)
        (<= 0 unknown@57@05)
        (< unknown@57@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@51@05 $Ref.null)
  (forall ((unknown@57@05 Int)) (!
    (implies
      (and (< unknown@57@05 V@26@05) (<= 0 unknown@57@05))
      (=
        ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@57@05))
    :qid |prog.l<no position>|))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] exc != null
; [then-branch: 34 | exc@51@05 != Null | dead]
; [else-branch: 34 | exc@51@05 == Null | live]
(push) ; 4
; [else-branch: 34 | exc@51@05 == Null]
(pop) ; 4
; [eval] !(exc != null)
; [eval] exc != null
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               682
;  :arith-add-rows          106
;  :arith-assert-diseq      25
;  :arith-assert-lower      164
;  :arith-assert-upper      84
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        13
;  :arith-pivots            135
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   116
;  :datatype-splits         38
;  :decisions               71
;  :del-clause              320
;  :final-checks            57
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1156
;  :mk-clause               320
;  :num-allocs              155805
;  :num-checks              64
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            172336)
; [then-branch: 35 | exc@51@05 == Null | live]
; [else-branch: 35 | exc@51@05 != Null | dead]
(push) ; 4
; [then-branch: 35 | exc@51@05 == Null]
; [exec]
; evaluationDummy := res1
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null ==> p != (None(): option[array])
; [eval] exc == null
(push) ; 5
(push) ; 6
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               691
;  :arith-add-rows          106
;  :arith-assert-diseq      25
;  :arith-assert-lower      164
;  :arith-assert-upper      84
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        13
;  :arith-pivots            135
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   121
;  :datatype-splits         39
;  :decisions               73
;  :del-clause              320
;  :final-checks            59
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1157
;  :mk-clause               320
;  :num-allocs              156222
;  :num-checks              65
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            172749)
; [then-branch: 36 | exc@51@05 == Null | live]
; [else-branch: 36 | exc@51@05 != Null | dead]
(push) ; 6
; [then-branch: 36 | exc@51@05 == Null]
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies
  (= exc@51@05 $Ref.null)
  (not (= p@25@05 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               691
;  :arith-add-rows          106
;  :arith-assert-diseq      25
;  :arith-assert-lower      164
;  :arith-assert-upper      84
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        13
;  :arith-pivots            135
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   121
;  :datatype-splits         39
;  :decisions               73
;  :del-clause              320
;  :final-checks            59
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1157
;  :mk-clause               320
;  :num-allocs              156246
;  :num-checks              66
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            172769)
(assert (implies
  (= exc@51@05 $Ref.null)
  (not (= p@25@05 (as None<option<array>>  option<array>)))))
; [eval] exc == null ==> alen(opt_get1(p)) == V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               700
;  :arith-add-rows          106
;  :arith-assert-diseq      25
;  :arith-assert-lower      164
;  :arith-assert-upper      84
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        13
;  :arith-pivots            135
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   126
;  :datatype-splits         40
;  :decisions               75
;  :del-clause              320
;  :final-checks            61
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1158
;  :mk-clause               320
;  :num-allocs              156665
;  :num-checks              67
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            173182)
; [then-branch: 37 | exc@51@05 == Null | live]
; [else-branch: 37 | exc@51@05 != Null | dead]
(push) ; 6
; [then-branch: 37 | exc@51@05 == Null]
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
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
  (= exc@51@05 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit p@25@05)) V@26@05))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               700
;  :arith-add-rows          106
;  :arith-assert-diseq      25
;  :arith-assert-lower      164
;  :arith-assert-upper      84
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        13
;  :arith-pivots            135
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   126
;  :datatype-splits         40
;  :decisions               75
;  :del-clause              320
;  :final-checks            61
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1158
;  :mk-clause               320
;  :num-allocs              156683
;  :num-checks              68
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            173207)
(assert (implies
  (= exc@51@05 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit p@25@05)) V@26@05)))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               709
;  :arith-add-rows          106
;  :arith-assert-diseq      25
;  :arith-assert-lower      164
;  :arith-assert-upper      84
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        13
;  :arith-pivots            135
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   131
;  :datatype-splits         41
;  :decisions               77
;  :del-clause              320
;  :final-checks            63
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1159
;  :mk-clause               320
;  :num-allocs              157102
;  :num-checks              69
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            173615)
; [then-branch: 38 | exc@51@05 == Null | live]
; [else-branch: 38 | exc@51@05 != Null | dead]
(push) ; 5
; [then-branch: 38 | exc@51@05 == Null]
(declare-const k@58@05 Int)
(push) ; 6
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 7
; [then-branch: 39 | 0 <= k@58@05 | live]
; [else-branch: 39 | !(0 <= k@58@05) | live]
(push) ; 8
; [then-branch: 39 | 0 <= k@58@05]
(assert (<= 0 k@58@05))
; [eval] k < V
(pop) ; 8
(push) ; 8
; [else-branch: 39 | !(0 <= k@58@05)]
(assert (not (<= 0 k@58@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< k@58@05 V@26@05) (<= 0 k@58@05)))
; [eval] aloc(opt_get1(p), k)
; [eval] opt_get1(p)
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
(assert (not (< k@58@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               711
;  :arith-add-rows          107
;  :arith-assert-diseq      25
;  :arith-assert-lower      167
;  :arith-assert-upper      85
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        86
;  :arith-fixed-eqs         47
;  :arith-offset-eqs        13
;  :arith-pivots            136
;  :conflicts               30
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   131
;  :datatype-splits         41
;  :decisions               77
;  :del-clause              320
;  :final-checks            63
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1164
;  :mk-clause               320
;  :num-allocs              157216
;  :num-checks              70
;  :propagations            144
;  :quant-instantiations    284
;  :rlimit-count            173834)
(assert (< k@58@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 7
; Joined path conditions
(assert (< k@58@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 6
(declare-fun inv@59@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@58@05 Int)) (!
  (< k@58@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@58@05))
  :qid |int-aux|)))
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((k1@58@05 Int) (k2@58@05 Int)) (!
  (implies
    (and
      (and
        (and (< k1@58@05 V@26@05) (<= 0 k1@58@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) k1@58@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) k1@58@05)))
      (and
        (and (< k2@58@05 V@26@05) (<= 0 k2@58@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) k2@58@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) k2@58@05)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k1@58@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k2@58@05)))
    (= k1@58@05 k2@58@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-add-rows          114
;  :arith-assert-diseq      26
;  :arith-assert-lower      171
;  :arith-assert-upper      85
;  :arith-bound-prop        29
;  :arith-conflicts         10
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         47
;  :arith-offset-eqs        13
;  :arith-pivots            142
;  :conflicts               31
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 64
;  :datatype-occurs-check   131
;  :datatype-splits         41
;  :decisions               77
;  :del-clause              328
;  :final-checks            63
;  :max-generation          4
;  :max-memory              4.25
;  :memory                  4.24
;  :minimized-lits          1
;  :mk-bool-var             1195
;  :mk-clause               328
;  :num-allocs              157795
;  :num-checks              71
;  :propagations            144
;  :quant-instantiations    305
;  :rlimit-count            175076)
; Definitional axioms for inverse functions
(assert (forall ((k@58@05 Int)) (!
  (implies
    (and (< k@58@05 V@26@05) (<= 0 k@58@05))
    (=
      (inv@59@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@58@05))
      k@58@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) k@58@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@59@05 r) V@26@05) (<= 0 (inv@59@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@59@05 r))
      r))
  :pattern ((inv@59@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@59@05 r) V@26@05) (<= 0 (inv@59@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) r) r))
  :pattern ((inv@59@05 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@60@05 ((r $Ref)) $Perm
  (ite
    (and (< (inv@59@05 r) V@26@05) (<= 0 (inv@59@05 r)))
    ($Perm.min
      (ite
        (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
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
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (=
    (-
      (ite
        (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@60@05 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               819
;  :arith-add-rows          149
;  :arith-assert-diseq      34
;  :arith-assert-lower      199
;  :arith-assert-upper      100
;  :arith-bound-prop        35
;  :arith-conflicts         13
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         55
;  :arith-offset-eqs        13
;  :arith-pivots            162
;  :conflicts               38
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 67
;  :datatype-occurs-check   136
;  :datatype-splits         42
;  :decisions               85
;  :del-clause              395
;  :final-checks            65
;  :max-generation          4
;  :max-memory              4.26
;  :memory                  4.26
;  :minimized-lits          2
;  :mk-bool-var             1334
;  :mk-clause               395
;  :num-allocs              159518
;  :num-checks              73
;  :propagations            182
;  :quant-instantiations    363
;  :rlimit-count            178732
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@59@05 r) V@26@05) (<= 0 (inv@59@05 r)))
    (= (- $Perm.Write (pTaken@60@05 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               845
;  :arith-add-rows          156
;  :arith-assert-diseq      36
;  :arith-assert-lower      204
;  :arith-assert-upper      105
;  :arith-bound-prop        38
;  :arith-conflicts         13
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        16
;  :arith-pivots            168
;  :conflicts               39
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 67
;  :datatype-occurs-check   136
;  :datatype-splits         42
;  :decisions               85
;  :del-clause              419
;  :final-checks            65
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.26
;  :minimized-lits          2
;  :mk-bool-var             1387
;  :mk-clause               419
;  :num-allocs              159987
;  :num-checks              74
;  :propagations            190
;  :quant-instantiations    384
;  :rlimit-count            179926)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null ==> valid_graph_vertices(this, p, V)
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               854
;  :arith-add-rows          156
;  :arith-assert-diseq      36
;  :arith-assert-lower      204
;  :arith-assert-upper      105
;  :arith-bound-prop        38
;  :arith-conflicts         13
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        16
;  :arith-pivots            168
;  :conflicts               39
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   141
;  :datatype-splits         43
;  :decisions               87
;  :del-clause              419
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.26
;  :minimized-lits          2
;  :mk-bool-var             1388
;  :mk-clause               419
;  :num-allocs              160418
;  :num-checks              75
;  :propagations            190
;  :quant-instantiations    384
;  :rlimit-count            180338)
; [then-branch: 40 | exc@51@05 == Null | live]
; [else-branch: 40 | exc@51@05 != Null | dead]
(push) ; 7
; [then-branch: 40 | exc@51@05 == Null]
; [eval] valid_graph_vertices(this, p, V)
(push) ; 8
; [eval] this != null
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 9
; Joined path conditions
(declare-const i1@61@05 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 41 | 0 <= i1@61@05 | live]
; [else-branch: 41 | !(0 <= i1@61@05) | live]
(push) ; 11
; [then-branch: 41 | 0 <= i1@61@05]
(assert (<= 0 i1@61@05))
; [eval] i1 < V
(pop) ; 11
(push) ; 11
; [else-branch: 41 | !(0 <= i1@61@05)]
(assert (not (<= 0 i1@61@05)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(assert (and (< i1@61@05 V@26@05) (<= 0 i1@61@05)))
(declare-const $k@62@05 $Perm)
(assert ($Perm.isReadVar $k@62@05 $Perm.Write))
; [eval] aloc(opt_get1(p), i1)
; [eval] opt_get1(p)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 10
; Joined path conditions
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(set-option :timeout 0)
(push) ; 11
(assert (not (< i1@61@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               856
;  :arith-add-rows          157
;  :arith-assert-diseq      37
;  :arith-assert-lower      209
;  :arith-assert-upper      107
;  :arith-bound-prop        38
;  :arith-conflicts         13
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         58
;  :arith-offset-eqs        16
;  :arith-pivots            170
;  :conflicts               39
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   141
;  :datatype-splits         43
;  :decisions               87
;  :del-clause              419
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1397
;  :mk-clause               421
;  :num-allocs              160608
;  :num-checks              76
;  :propagations            191
;  :quant-instantiations    384
;  :rlimit-count            180714)
(assert (< i1@61@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 10
; Joined path conditions
(assert (< i1@61@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 9
(declare-fun inv@63@05 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@62@05 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@61@05 Int)) (!
  (< i1@61@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
  :qid |int-aux|)))
(push) ; 9
(assert (not (forall ((i1@61@05 Int)) (!
  (implies
    (and (< i1@61@05 V@26@05) (<= 0 i1@61@05))
    (or (= $k@62@05 $Perm.No) (< $Perm.No $k@62@05)))
  
  ))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               856
;  :arith-add-rows          157
;  :arith-assert-diseq      38
;  :arith-assert-lower      211
;  :arith-assert-upper      108
;  :arith-bound-prop        38
;  :arith-conflicts         13
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         58
;  :arith-offset-eqs        16
;  :arith-pivots            172
;  :conflicts               40
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   141
;  :datatype-splits         43
;  :decisions               87
;  :del-clause              421
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.27
;  :memory                  4.26
;  :minimized-lits          2
;  :mk-bool-var             1404
;  :mk-clause               423
;  :num-allocs              161043
;  :num-checks              77
;  :propagations            192
;  :quant-instantiations    384
;  :rlimit-count            181266)
; Definitional axioms for snapshot map domain
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 9
(assert (not (forall ((i11@61@05 Int) (i12@61@05 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< i11@61@05 V@26@05) (<= 0 i11@61@05))
          ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@61@05)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@61@05)))
        (< $Perm.No $k@62@05))
      (and
        (and
          (and (< i12@61@05 V@26@05) (<= 0 i12@61@05))
          ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@61@05)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@61@05)))
        (< $Perm.No $k@62@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i11@61@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i12@61@05)))
    (= i11@61@05 i12@61@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               871
;  :arith-add-rows          160
;  :arith-assert-diseq      39
;  :arith-assert-lower      215
;  :arith-assert-upper      108
;  :arith-bound-prop        38
;  :arith-conflicts         13
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         58
;  :arith-offset-eqs        16
;  :arith-pivots            174
;  :conflicts               41
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   141
;  :datatype-splits         43
;  :decisions               87
;  :del-clause              429
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.28
;  :memory                  4.27
;  :minimized-lits          2
;  :mk-bool-var             1436
;  :mk-clause               431
;  :num-allocs              161501
;  :num-checks              78
;  :propagations            192
;  :quant-instantiations    409
;  :rlimit-count            182369)
; Definitional axioms for inverse functions
(assert (forall ((i1@61@05 Int)) (!
  (implies
    (and (and (< i1@61@05 V@26@05) (<= 0 i1@61@05)) (< $Perm.No $k@62@05))
    (=
      (inv@63@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
      i1@61@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
      (< $Perm.No $k@62@05))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@63@05 r))
      r))
  :pattern ((inv@63@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) r) r))
  :pattern ((inv@63@05 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@64@05 ((r $Ref)) $Perm
  (ite
    (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
    ($Perm.min
      (ite
        (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
        $Perm.Write
        $Perm.No)
      $k@62@05)
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Constrain original permissions $k@62@05
(assert (forall ((r $Ref)) (!
  (implies
    (not
      (=
        (ite
          (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
          $Perm.Write
          $Perm.No)
        $Perm.No))
    (ite
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
      (<
        (ite
          (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
          $k@62@05
          $Perm.No)
        $Perm.Write)
      (<
        (ite
          (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
          $k@62@05
          $Perm.No)
        $Perm.No)))
  :pattern ((inv@55@05 r))
  :pattern ((inv@63@05 r))
  :qid |qp.srp18|)))
; Intermediate check if already taken enough permissions
(set-option :timeout 500)
(push) ; 9
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
    (= (- $k@62@05 (pTaken@64@05 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               919
;  :arith-add-rows          171
;  :arith-assert-diseq      40
;  :arith-assert-lower      225
;  :arith-assert-upper      113
;  :arith-bound-prop        46
;  :arith-conflicts         13
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        23
;  :arith-pivots            184
;  :conflicts               42
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 71
;  :datatype-occurs-check   146
;  :datatype-splits         44
;  :decisions               89
;  :del-clause              470
;  :final-checks            69
;  :max-generation          4
;  :max-memory              4.30
;  :memory                  4.28
;  :minimized-lits          2
;  :mk-bool-var             1506
;  :mk-clause               470
;  :num-allocs              163232
;  :num-checks              80
;  :propagations            201
;  :quant-instantiations    436
;  :rlimit-count            185636)
; Final check if taken enough permissions
; Done removing quantified permissions
(declare-const sm@65@05 $FVF<Int>)
; Definitional axioms for snapshot map domain
(assert (forall ((r $Ref)) (!
  (iff
    (Set_in r ($FVF.domain_int (as sm@65@05  $FVF<Int>)))
    (and
      (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
      (< $Perm.No $k@62@05)))
  :pattern ((Set_in r ($FVF.domain_int (as sm@65@05  $FVF<Int>))))
  :qid |qp.fvfDomDef21|)))
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
        (< $Perm.No $k@62@05))
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r))))
    (=
      ($FVF.lookup_int (as sm@65@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@65@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef19|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@65@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef20|)))
(pop) ; 8
; Joined path conditions
(assert ($Perm.isReadVar $k@62@05 $Perm.Write))
(assert (forall ((i1@61@05 Int)) (!
  (implies
    (and (and (< i1@61@05 V@26@05) (<= 0 i1@61@05)) (< $Perm.No $k@62@05))
    (=
      (inv@63@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
      i1@61@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
      (< $Perm.No $k@62@05))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@63@05 r))
      r))
  :pattern ((inv@63@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (iff
    (Set_in r ($FVF.domain_int (as sm@65@05  $FVF<Int>)))
    (and
      (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
      (< $Perm.No $k@62@05)))
  :pattern ((Set_in r ($FVF.domain_int (as sm@65@05  $FVF<Int>))))
  :qid |qp.fvfDomDef21|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
        (< $Perm.No $k@62@05))
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r))))
    (=
      ($FVF.lookup_int (as sm@65@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@65@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef19|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@65@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef20|)))
(assert (and
  (forall ((i1@61@05 Int)) (!
    (< i1@61@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
    :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
    :qid |int-aux|))
  (forall ((r $Ref)) (!
    (implies
      (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) r) r))
    :pattern ((inv@63@05 r))
    ))
  (forall ((r $Ref)) (!
    (implies
      (not
        (=
          (ite
            (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
            $Perm.Write
            $Perm.No)
          $Perm.No))
      (ite
        (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
        (<
          (ite
            (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
            $k@62@05
            $Perm.No)
          $Perm.Write)
        (<
          (ite
            (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
            $k@62@05
            $Perm.No)
          $Perm.No)))
    :pattern ((inv@55@05 r))
    :pattern ((inv@63@05 r))
    :qid |qp.srp18|))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert ($Perm.isReadVar $k@62@05 $Perm.Write))
(assert (forall ((i1@61@05 Int)) (!
  (implies
    (and (and (< i1@61@05 V@26@05) (<= 0 i1@61@05)) (< $Perm.No $k@62@05))
    (=
      (inv@63@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
      i1@61@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
      (< $Perm.No $k@62@05))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) (inv@63@05 r))
      r))
  :pattern ((inv@63@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (iff
    (Set_in r ($FVF.domain_int (as sm@65@05  $FVF<Int>)))
    (and
      (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
      (< $Perm.No $k@62@05)))
  :pattern ((Set_in r ($FVF.domain_int (as sm@65@05  $FVF<Int>))))
  :qid |qp.fvfDomDef21|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
        (< $Perm.No $k@62@05))
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r))))
    (=
      ($FVF.lookup_int (as sm@65@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@65@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef19|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@65@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef20|)))
(assert (implies
  (= exc@51@05 $Ref.null)
  (and
    (forall ((i1@61@05 Int)) (!
      (< i1@61@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) i1@61@05))
      :qid |int-aux|))
    (forall ((r $Ref)) (!
      (implies
        (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@56@05  $FVF<Int>) r) r))
      :pattern ((inv@63@05 r))
      ))
    (forall ((r $Ref)) (!
      (implies
        (not
          (=
            (ite
              (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
              $Perm.Write
              $Perm.No)
            $Perm.No))
        (ite
          (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
          (<
            (ite
              (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
              $k@62@05
              $Perm.No)
            $Perm.Write)
          (<
            (ite
              (and (< (inv@63@05 r) V@26@05) (<= 0 (inv@63@05 r)))
              $k@62@05
              $Perm.No)
            $Perm.No)))
      :pattern ((inv@55@05 r))
      :pattern ((inv@63@05 r))
      :qid |qp.srp18|)))))
(set-option :timeout 0)
(push) ; 6
(assert (not (implies
  (= exc@51@05 $Ref.null)
  (valid_graph_vertices ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        $Snap.unit
        ($SortWrappers.$FVF<Int>To$Snap (as sm@65@05  $FVF<Int>))))) this@23@05 p@25@05 V@26@05))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1182
;  :arith-add-rows          400
;  :arith-assert-diseq      42
;  :arith-assert-lower      275
;  :arith-assert-upper      153
;  :arith-bound-prop        89
;  :arith-conflicts         19
;  :arith-eq-adapter        160
;  :arith-fixed-eqs         87
;  :arith-offset-eqs        75
;  :arith-pivots            248
;  :conflicts               55
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   146
;  :datatype-splits         44
;  :decisions               108
;  :del-clause              812
;  :final-checks            69
;  :max-generation          4
;  :max-memory              4.49
;  :memory                  4.46
;  :minimized-lits          2
;  :mk-bool-var             2006
;  :mk-clause               814
;  :num-allocs              167457
;  :num-checks              81
;  :propagations            328
;  :quant-instantiations    588
;  :rlimit-count            197582
;  :time                    0.00)
(assert (implies
  (= exc@51@05 $Ref.null)
  (valid_graph_vertices ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        $Snap.unit
        ($SortWrappers.$FVF<Int>To$Snap (as sm@65@05  $FVF<Int>))))) this@23@05 p@25@05 V@26@05)))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@51@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1206
;  :arith-add-rows          401
;  :arith-assert-diseq      43
;  :arith-assert-lower      278
;  :arith-assert-upper      155
;  :arith-bound-prop        89
;  :arith-conflicts         19
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         88
;  :arith-offset-eqs        75
;  :arith-pivots            249
;  :conflicts               55
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   155
;  :datatype-splits         46
;  :decisions               111
;  :del-clause              812
;  :final-checks            71
;  :max-generation          4
;  :max-memory              4.49
;  :memory                  4.47
;  :minimized-lits          2
;  :mk-bool-var             2040
;  :mk-clause               845
;  :num-allocs              168236
;  :num-checks              82
;  :propagations            343
;  :quant-instantiations    592
;  :rlimit-count            198495)
; [then-branch: 42 | exc@51@05 == Null | live]
; [else-branch: 42 | exc@51@05 != Null | dead]
(push) ; 7
; [then-branch: 42 | exc@51@05 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0)
(declare-const unknown@66@05 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < V ==> aloc(opt_get1(p), unknown).int == 0
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 43 | 0 <= unknown@66@05 | live]
; [else-branch: 43 | !(0 <= unknown@66@05) | live]
(push) ; 10
; [then-branch: 43 | 0 <= unknown@66@05]
(assert (<= 0 unknown@66@05))
; [eval] unknown < V
(pop) ; 10
(push) ; 10
; [else-branch: 43 | !(0 <= unknown@66@05)]
(assert (not (<= 0 unknown@66@05)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 44 | unknown@66@05 < V@26@05 && 0 <= unknown@66@05 | live]
; [else-branch: 44 | !(unknown@66@05 < V@26@05 && 0 <= unknown@66@05) | live]
(push) ; 10
; [then-branch: 44 | unknown@66@05 < V@26@05 && 0 <= unknown@66@05]
(assert (and (< unknown@66@05 V@26@05) (<= 0 unknown@66@05)))
; [eval] aloc(opt_get1(p), unknown).int == 0
; [eval] aloc(opt_get1(p), unknown)
; [eval] opt_get1(p)
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
(assert (not (< unknown@66@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1206
;  :arith-add-rows          402
;  :arith-assert-diseq      43
;  :arith-assert-lower      280
;  :arith-assert-upper      155
;  :arith-bound-prop        89
;  :arith-conflicts         19
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         88
;  :arith-offset-eqs        75
;  :arith-pivots            249
;  :conflicts               55
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   155
;  :datatype-splits         46
;  :decisions               111
;  :del-clause              812
;  :final-checks            71
;  :max-generation          4
;  :max-memory              4.49
;  :memory                  4.47
;  :minimized-lits          2
;  :mk-bool-var             2042
;  :mk-clause               845
;  :num-allocs              168342
;  :num-checks              83
;  :propagations            343
;  :quant-instantiations    592
;  :rlimit-count            198689)
(assert (< unknown@66@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(pop) ; 11
; Joined path conditions
(assert (< unknown@66@05 (alen<Int> (opt_get1 $Snap.unit p@25@05))))
(declare-const sm@67@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
    (=
      ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef22|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef23|)))
(declare-const pm@68@05 $FPM)
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@68@05  $FPM) r)
    (ite
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resPrmSumDef24|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resTrgDef25|)))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05)))
(push) ; 11
(assert (not (<
  $Perm.No
  ($FVF.perm_int (as pm@68@05  $FPM) (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1230
;  :arith-add-rows          424
;  :arith-assert-diseq      44
;  :arith-assert-lower      286
;  :arith-assert-upper      162
;  :arith-bound-prop        94
;  :arith-conflicts         20
;  :arith-eq-adapter        168
;  :arith-fixed-eqs         94
;  :arith-offset-eqs        75
;  :arith-pivots            255
;  :conflicts               57
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   155
;  :datatype-splits         46
;  :decisions               112
;  :del-clause              812
;  :final-checks            71
;  :max-generation          4
;  :max-memory              4.49
;  :memory                  4.47
;  :minimized-lits          2
;  :mk-bool-var             2121
;  :mk-clause               891
;  :num-allocs              169455
;  :num-checks              84
;  :propagations            350
;  :quant-instantiations    627
;  :rlimit-count            201470)
(pop) ; 10
(push) ; 10
; [else-branch: 44 | !(unknown@66@05 < V@26@05 && 0 <= unknown@66@05)]
(assert (not (and (< unknown@66@05 V@26@05) (<= 0 unknown@66@05))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
    (=
      ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef22|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef23|)))
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@68@05  $FPM) r)
    (ite
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resPrmSumDef24|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resTrgDef25|)))
(assert (implies
  (and (< unknown@66@05 V@26@05) (<= 0 unknown@66@05))
  (and
    (< unknown@66@05 V@26@05)
    (<= 0 unknown@66@05)
    (< unknown@66@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
    (=
      ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef22|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef23|)))
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@68@05  $FPM) r)
    (ite
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resPrmSumDef24|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resTrgDef25|)))
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@66@05 Int)) (!
  (implies
    (and (< unknown@66@05 V@26@05) (<= 0 unknown@66@05))
    (and
      (< unknown@66@05 V@26@05)
      (<= 0 unknown@66@05)
      (< unknown@66@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
    (=
      ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r))
  :qid |qp.fvfValDef22|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@67@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef23|)))
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_int (as pm@68@05  $FPM) r)
    (ite
      (and (< (inv@55@05 r) V@26@05) (<= 0 (inv@55@05 r)))
      $Perm.Write
      $Perm.No))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resPrmSumDef24|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@53@05))))) r) r))
  :pattern (($FVF.perm_int (as pm@68@05  $FPM) r))
  :qid |qp.resTrgDef25|)))
(assert (implies
  (= exc@51@05 $Ref.null)
  (forall ((unknown@66@05 Int)) (!
    (implies
      (and (< unknown@66@05 V@26@05) (<= 0 unknown@66@05))
      (and
        (< unknown@66@05 V@26@05)
        (<= 0 unknown@66@05)
        (< unknown@66@05 (alen<Int> (opt_get1 $Snap.unit p@25@05)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@67@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (= exc@51@05 $Ref.null)
  (forall ((unknown@66@05 Int)) (!
    (implies
      (and (< unknown@66@05 V@26@05) (<= 0 unknown@66@05))
      (=
        ($FVF.lookup_int (as sm@67@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1255
;  :arith-add-rows          479
;  :arith-assert-diseq      44
;  :arith-assert-lower      293
;  :arith-assert-upper      168
;  :arith-bound-prop        99
;  :arith-conflicts         21
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         99
;  :arith-offset-eqs        75
;  :arith-pivots            273
;  :conflicts               60
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   155
;  :datatype-splits         46
;  :decisions               114
;  :del-clause              913
;  :final-checks            71
;  :max-generation          4
;  :max-memory              4.49
;  :memory                  4.46
;  :minimized-lits          2
;  :mk-bool-var             2195
;  :mk-clause               946
;  :num-allocs              170934
;  :num-checks              85
;  :propagations            361
;  :quant-instantiations    661
;  :rlimit-count            205373)
(assert (implies
  (= exc@51@05 $Ref.null)
  (forall ((unknown@66@05 Int)) (!
    (implies
      (and (< unknown@66@05 V@26@05) (<= 0 unknown@66@05))
      (=
        ($FVF.lookup_int (as sm@67@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@25@05) unknown@66@05))
    :qid |prog.l<no position>|))))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
