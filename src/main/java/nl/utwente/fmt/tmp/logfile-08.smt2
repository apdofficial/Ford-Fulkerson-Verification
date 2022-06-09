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
; ---------- FordFulkerson ----------
(declare-const tid@0@08 Int)
(declare-const exc@1@08 $Ref)
(declare-const res@2@08 $Ref)
(declare-const tid@3@08 Int)
(declare-const exc@4@08 $Ref)
(declare-const res@5@08 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@6@08 $Snap)
(assert (= $t@6@08 $Snap.unit))
; [eval] exc == null
(assert (= exc@4@08 $Ref.null))
(pop) ; 2
(push) ; 2
; [exec]
; var return: Ref
(declare-const return@7@08 $Ref)
; [exec]
; var FordFulkerson1: Ref
(declare-const FordFulkerson1@8@08 $Ref)
; [exec]
; exc := null
; [exec]
; FordFulkerson1 := new()
(declare-const FordFulkerson1@9@08 $Ref)
(assert (not (= FordFulkerson1@9@08 $Ref.null)))
(assert (not (= FordFulkerson1@9@08 res@5@08)))
(assert (not (= FordFulkerson1@9@08 FordFulkerson1@8@08)))
(assert (not (= FordFulkerson1@9@08 return@7@08)))
; [exec]
; inhale type(FordFulkerson1) == 1
(declare-const $t@10@08 $Snap)
(assert (= $t@10@08 $Snap.unit))
; [eval] type(FordFulkerson1) == 1
; [eval] type(FordFulkerson1)
(push) ; 3
(pop) ; 3
; Joined path conditions
(assert (= (type $Snap.unit FordFulkerson1@9@08) 1))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; fold acc(lock_inv_FordFulkerson(FordFulkerson1), write)
(assert (lock_inv_FordFulkerson%trigger $Snap.unit FordFulkerson1@9@08))
; [exec]
; exhale acc(lock_inv_FordFulkerson(FordFulkerson1), write) && FordFulkerson1 != null
; [eval] FordFulkerson1 != null
; [exec]
; return := FordFulkerson1
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
(pop) ; 2
(pop) ; 1
; ---------- check_unknown2 ----------
(declare-const visited@11@08 option<array>)
(declare-const s@12@08 Int)
(declare-const V@13@08 Int)
(declare-const i1@14@08 Int)
(declare-const exc@15@08 $Ref)
(declare-const res@16@08 void)
(declare-const visited@17@08 option<array>)
(declare-const s@18@08 Int)
(declare-const V@19@08 Int)
(declare-const i1@20@08 Int)
(declare-const exc@21@08 $Ref)
(declare-const res@22@08 void)
(push) ; 1
(declare-const $t@23@08 $Snap)
(assert (= $t@23@08 ($Snap.combine ($Snap.first $t@23@08) ($Snap.second $t@23@08))))
(assert (= ($Snap.first $t@23@08) $Snap.unit))
; [eval] 0 < V ==> visited != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13
;  :arith-assert-diseq      1
;  :arith-assert-lower      5
;  :arith-assert-upper      3
;  :arith-eq-adapter        3
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   3
;  :datatype-splits         1
;  :decisions               1
;  :del-clause              12
;  :final-checks            4
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.93
;  :mk-bool-var             320
;  :mk-clause               12
;  :num-allocs              122650
;  :num-checks              3
;  :propagations            5
;  :quant-instantiations    4
;  :rlimit-count            121294)
(push) ; 3
(assert (not (< 0 V@19@08)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15
;  :arith-assert-diseq      1
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   5
;  :datatype-splits         2
;  :decisions               2
;  :del-clause              12
;  :final-checks            6
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.93
;  :mk-bool-var             322
;  :mk-clause               12
;  :num-allocs              122998
;  :num-checks              4
;  :propagations            5
;  :quant-instantiations    4
;  :rlimit-count            121682)
; [then-branch: 0 | 0 < V@19@08 | live]
; [else-branch: 0 | !(0 < V@19@08) | live]
(push) ; 3
; [then-branch: 0 | 0 < V@19@08]
(assert (< 0 V@19@08))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(0 < V@19@08)]
(assert (not (< 0 V@19@08)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (< 0 V@19@08)
  (not (= visited@17@08 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@23@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@23@08))
    ($Snap.second ($Snap.second $t@23@08)))))
(assert (= ($Snap.first ($Snap.second $t@23@08)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(visited)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               23
;  :arith-assert-diseq      1
;  :arith-assert-lower      6
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   7
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              12
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.93
;  :mk-bool-var             327
;  :mk-clause               13
;  :num-allocs              123509
;  :num-checks              5
;  :propagations            6
;  :quant-instantiations    4
;  :rlimit-count            122340)
(push) ; 3
(assert (not (< 0 V@19@08)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25
;  :arith-assert-diseq      1
;  :arith-assert-lower      6
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   9
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              12
;  :final-checks            10
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.93
;  :mk-bool-var             328
;  :mk-clause               13
;  :num-allocs              123857
;  :num-checks              6
;  :propagations            6
;  :quant-instantiations    4
;  :rlimit-count            122731)
; [then-branch: 1 | 0 < V@19@08 | live]
; [else-branch: 1 | !(0 < V@19@08) | live]
(push) ; 3
; [then-branch: 1 | 0 < V@19@08]
(assert (< 0 V@19@08))
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= visited@17@08 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25
;  :arith-assert-diseq      1
;  :arith-assert-lower      7
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :conflicts               1
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   9
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              12
;  :final-checks            10
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.93
;  :mk-bool-var             328
;  :mk-clause               13
;  :num-allocs              124000
;  :num-checks              7
;  :propagations            7
;  :quant-instantiations    4
;  :rlimit-count            122839)
(assert (not (= visited@17@08 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= visited@17@08 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(0 < V@19@08)]
(assert (not (< 0 V@19@08)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@19@08)
  (and
    (< 0 V@19@08)
    (not (= visited@17@08 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies
  (< 0 V@19@08)
  (= (alen<Int> (opt_get1 $Snap.unit visited@17@08)) V@19@08)))
(assert (=
  ($Snap.second ($Snap.second $t@23@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@23@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@23@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@23@08))) $Snap.unit))
; [eval] 0 < V ==> 0 <= s
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-assert-diseq      1
;  :arith-assert-lower      10
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   11
;  :datatype-splits         5
;  :decisions               5
;  :del-clause              13
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.95
;  :mk-bool-var             341
;  :mk-clause               19
;  :num-allocs              124708
;  :num-checks              8
;  :propagations            10
;  :quant-instantiations    9
;  :rlimit-count            123723)
(push) ; 3
(assert (not (< 0 V@19@08)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41
;  :arith-assert-diseq      1
;  :arith-assert-lower      10
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :conflicts               1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   13
;  :datatype-splits         6
;  :decisions               6
;  :del-clause              13
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.95
;  :mk-bool-var             342
;  :mk-clause               19
;  :num-allocs              125067
;  :num-checks              9
;  :propagations            11
;  :quant-instantiations    9
;  :rlimit-count            124119)
; [then-branch: 2 | 0 < V@19@08 | live]
; [else-branch: 2 | !(0 < V@19@08) | live]
(push) ; 3
; [then-branch: 2 | 0 < V@19@08]
(assert (< 0 V@19@08))
; [eval] 0 <= s
(pop) ; 3
(push) ; 3
; [else-branch: 2 | !(0 < V@19@08)]
(assert (not (< 0 V@19@08)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (< 0 V@19@08) (<= 0 s@18@08)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@23@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@08))))
  $Snap.unit))
; [eval] 0 < V ==> s < V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               55
;  :arith-assert-diseq      1
;  :arith-assert-lower      14
;  :arith-assert-upper      8
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         2
;  :arith-pivots            4
;  :conflicts               1
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   15
;  :datatype-splits         7
;  :decisions               7
;  :del-clause              14
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.96
;  :mk-bool-var             354
;  :mk-clause               21
;  :num-allocs              125692
;  :num-checks              10
;  :propagations            15
;  :quant-instantiations    14
;  :rlimit-count            124890)
(push) ; 3
(assert (not (< 0 V@19@08)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               57
;  :arith-assert-diseq      1
;  :arith-assert-lower      14
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         2
;  :arith-pivots            4
;  :conflicts               1
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              14
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.96
;  :mk-bool-var             355
;  :mk-clause               21
;  :num-allocs              126056
;  :num-checks              11
;  :propagations            16
;  :quant-instantiations    14
;  :rlimit-count            125289)
; [then-branch: 3 | 0 < V@19@08 | live]
; [else-branch: 3 | !(0 < V@19@08) | live]
(push) ; 3
; [then-branch: 3 | 0 < V@19@08]
(assert (< 0 V@19@08))
; [eval] s < V
(pop) ; 3
(push) ; 3
; [else-branch: 3 | !(0 < V@19@08)]
(assert (not (< 0 V@19@08)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (< 0 V@19@08) (< s@18@08 V@19@08)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08)))))
  $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@20@08))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@08))))))
  $Snap.unit))
; [eval] i1 < V
(assert (< i1@20@08 V@19@08))
; [eval] aloc(opt_get1(visited), i1)
; [eval] opt_get1(visited)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= visited@17@08 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               75
;  :arith-add-rows          2
;  :arith-assert-diseq      1
;  :arith-assert-lower      20
;  :arith-assert-upper      11
;  :arith-bound-prop        1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-pivots            7
;  :conflicts               2
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              14
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.98
;  :mk-bool-var             370
;  :mk-clause               23
;  :num-allocs              126423
;  :num-checks              12
;  :propagations            21
;  :quant-instantiations    19
;  :rlimit-count            126039)
(assert (not (= visited@17@08 (as None<option<array>>  option<array>))))
(pop) ; 2
; Joined path conditions
(assert (not (= visited@17@08 (as None<option<array>>  option<array>))))
(push) ; 2
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 3
(assert (not (< i1@20@08 (alen<Int> (opt_get1 $Snap.unit visited@17@08)))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               75
;  :arith-add-rows          3
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      11
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-pivots            7
;  :conflicts               3
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   17
;  :datatype-splits         8
;  :decisions               8
;  :del-clause              14
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  3.98
;  :mk-bool-var             371
;  :mk-clause               23
;  :num-allocs              126588
;  :num-checks              13
;  :propagations            21
;  :quant-instantiations    19
;  :rlimit-count            126201)
(assert (< i1@20@08 (alen<Int> (opt_get1 $Snap.unit visited@17@08))))
(pop) ; 2
; Joined path conditions
(assert (< i1@20@08 (alen<Int> (opt_get1 $Snap.unit visited@17@08))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@17@08) i1@20@08)
    $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@24@08 $Snap)
(assert (= $t@24@08 ($Snap.combine ($Snap.first $t@24@08) ($Snap.second $t@24@08))))
(assert (= ($Snap.first $t@24@08) $Snap.unit))
; [eval] exc == null
(assert (= exc@21@08 $Ref.null))
(assert (=
  ($Snap.second $t@24@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@08))
    ($Snap.second ($Snap.second $t@24@08)))))
(assert (= ($Snap.first ($Snap.second $t@24@08)) $Snap.unit))
; [eval] exc == null && 0 < V ==> visited != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 4 | exc@21@08 == Null | live]
; [else-branch: 4 | exc@21@08 != Null | live]
(push) ; 4
; [then-branch: 4 | exc@21@08 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 4 | exc@21@08 != Null]
(assert (not (= exc@21@08 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               109
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               3
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   23
;  :datatype-splits         10
;  :decisions               11
;  :del-clause              29
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             389
;  :mk-clause               29
;  :num-allocs              128044
;  :num-checks              15
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            127689)
(push) ; 4
(assert (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               109
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               4
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   23
;  :datatype-splits         10
;  :decisions               11
;  :del-clause              29
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             389
;  :mk-clause               29
;  :num-allocs              128115
;  :num-checks              16
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            127741)
; [then-branch: 5 | 0 < V@19@08 && exc@21@08 == Null | live]
; [else-branch: 5 | !(0 < V@19@08 && exc@21@08 == Null) | dead]
(push) ; 4
; [then-branch: 5 | 0 < V@19@08 && exc@21@08 == Null]
(assert (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@19@08) (= exc@21@08 $Ref.null))
  (not (= visited@17@08 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@24@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@24@08))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(visited)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 6 | exc@21@08 == Null | live]
; [else-branch: 6 | exc@21@08 != Null | live]
(push) ; 4
; [then-branch: 6 | exc@21@08 == Null]
(assert (= exc@21@08 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 6 | exc@21@08 != Null]
(assert (not (= exc@21@08 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               4
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   26
;  :datatype-splits         11
;  :decisions               13
;  :del-clause              29
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             392
;  :mk-clause               29
;  :num-allocs              128783
;  :num-checks              17
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            128389)
(push) ; 4
(assert (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               123
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               5
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   26
;  :datatype-splits         11
;  :decisions               13
;  :del-clause              29
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.01
;  :mk-bool-var             392
;  :mk-clause               29
;  :num-allocs              128854
;  :num-checks              18
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            128441)
; [then-branch: 7 | 0 < V@19@08 && exc@21@08 == Null | live]
; [else-branch: 7 | !(0 < V@19@08 && exc@21@08 == Null) | dead]
(push) ; 4
; [then-branch: 7 | 0 < V@19@08 && exc@21@08 == Null]
(assert (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))
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
  (and (< 0 V@19@08) (= exc@21@08 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit visited@17@08)) V@19@08)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@08))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> 0 <= s
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 8 | exc@21@08 == Null | live]
; [else-branch: 8 | exc@21@08 != Null | live]
(push) ; 4
; [then-branch: 8 | exc@21@08 == Null]
(assert (= exc@21@08 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 8 | exc@21@08 != Null]
(assert (not (= exc@21@08 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               138
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               5
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   29
;  :datatype-splits         12
;  :decisions               15
;  :del-clause              29
;  :final-checks            26
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             395
;  :mk-clause               29
;  :num-allocs              129590
;  :num-checks              19
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            129158)
(push) ; 4
(assert (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               138
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               6
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   29
;  :datatype-splits         12
;  :decisions               15
;  :del-clause              29
;  :final-checks            26
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             395
;  :mk-clause               29
;  :num-allocs              129661
;  :num-checks              20
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            129210)
; [then-branch: 9 | 0 < V@19@08 && exc@21@08 == Null | live]
; [else-branch: 9 | !(0 < V@19@08 && exc@21@08 == Null) | dead]
(push) ; 4
; [then-branch: 9 | 0 < V@19@08 && exc@21@08 == Null]
(assert (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@19@08) (= exc@21@08 $Ref.null)) (<= 0 s@18@08)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> s < V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 10 | exc@21@08 == Null | live]
; [else-branch: 10 | exc@21@08 != Null | live]
(push) ; 4
; [then-branch: 10 | exc@21@08 == Null]
(assert (= exc@21@08 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 10 | exc@21@08 != Null]
(assert (not (= exc@21@08 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               154
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               6
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   32
;  :datatype-splits         13
;  :decisions               17
;  :del-clause              29
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             398
;  :mk-clause               29
;  :num-allocs              130346
;  :num-checks              21
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            129891)
(push) ; 4
(assert (not (and (< 0 V@19@08) (= exc@21@08 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               154
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   32
;  :datatype-splits         13
;  :decisions               17
;  :del-clause              29
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             398
;  :mk-clause               29
;  :num-allocs              130417
;  :num-checks              22
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            129943)
; [then-branch: 11 | 0 < V@19@08 && exc@21@08 == Null | live]
; [else-branch: 11 | !(0 < V@19@08 && exc@21@08 == Null) | dead]
(push) ; 4
; [then-branch: 11 | 0 < V@19@08 && exc@21@08 == Null]
(assert (and (< 0 V@19@08) (= exc@21@08 $Ref.null)))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@19@08) (= exc@21@08 $Ref.null)) (< s@18@08 V@19@08)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@21@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               171
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   37
;  :datatype-splits         14
;  :decisions               19
;  :del-clause              29
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             401
;  :mk-clause               29
;  :num-allocs              131063
;  :num-checks              23
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            130569)
(push) ; 4
(assert (not (= exc@21@08 $Ref.null)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               171
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   37
;  :datatype-splits         14
;  :decisions               19
;  :del-clause              29
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             401
;  :mk-clause               29
;  :num-allocs              131079
;  :num-checks              24
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            130580)
; [then-branch: 12 | exc@21@08 == Null | live]
; [else-branch: 12 | exc@21@08 != Null | dead]
(push) ; 4
; [then-branch: 12 | exc@21@08 == Null]
(assert (= exc@21@08 $Ref.null))
; [eval] 0 <= i1
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@21@08 $Ref.null) (<= 0 i1@20@08)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))))
  $Snap.unit))
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@21@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               188
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   42
;  :datatype-splits         15
;  :decisions               21
;  :del-clause              29
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               29
;  :num-allocs              131711
;  :num-checks              25
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            131198)
(push) ; 4
(assert (not (= exc@21@08 $Ref.null)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               188
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   42
;  :datatype-splits         15
;  :decisions               21
;  :del-clause              29
;  :final-checks            32
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             404
;  :mk-clause               29
;  :num-allocs              131727
;  :num-checks              26
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            131209)
; [then-branch: 13 | exc@21@08 == Null | live]
; [else-branch: 13 | exc@21@08 != Null | dead]
(push) ; 4
; [then-branch: 13 | exc@21@08 == Null]
(assert (= exc@21@08 $Ref.null))
; [eval] i1 < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@21@08 $Ref.null) (< i1@20@08 V@19@08)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@21@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   47
;  :datatype-splits         17
;  :decisions               24
;  :del-clause              29
;  :final-checks            34
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             407
;  :mk-clause               29
;  :num-allocs              132373
;  :num-checks              27
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            131827)
(push) ; 3
(assert (not (= exc@21@08 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   47
;  :datatype-splits         17
;  :decisions               24
;  :del-clause              29
;  :final-checks            34
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             407
;  :mk-clause               29
;  :num-allocs              132389
;  :num-checks              28
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            131838)
; [then-branch: 14 | exc@21@08 == Null | live]
; [else-branch: 14 | exc@21@08 != Null | dead]
(push) ; 3
; [then-branch: 14 | exc@21@08 == Null]
(assert (= exc@21@08 $Ref.null))
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
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08))))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(visited), i1).bool == false
; [eval] exc == null
(push) ; 4
(push) ; 5
(assert (not (not (= exc@21@08 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               218
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   52
;  :datatype-splits         18
;  :decisions               26
;  :del-clause              29
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.03
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              133001
;  :num-checks              29
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            132388)
; [then-branch: 15 | exc@21@08 == Null | live]
; [else-branch: 15 | exc@21@08 != Null | dead]
(push) ; 5
; [then-branch: 15 | exc@21@08 == Null]
; [eval] aloc(opt_get1(visited), i1).bool == false
; [eval] aloc(opt_get1(visited), i1)
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
(pop) ; 6
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@21@08 $Ref.null)
  (=
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@08)))))))))
    false)))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@25@08 void)
; [exec]
; exc := null
; [exec]
; aloc(opt_get1(visited), i1).bool := false
; [eval] aloc(opt_get1(visited), i1)
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
(pop) ; 3
; Joined path conditions
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null && 0 < V ==> visited != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 16 | True | live]
; [else-branch: 16 | False | live]
(push) ; 4
; [then-branch: 16 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 16 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               221
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               7
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 27
;  :datatype-occurs-check   53
;  :datatype-splits         18
;  :decisions               27
;  :del-clause              29
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              133559
;  :num-checks              30
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            132868)
(push) ; 4
(assert (not (< 0 V@19@08)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               221
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               8
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 27
;  :datatype-occurs-check   53
;  :datatype-splits         18
;  :decisions               27
;  :del-clause              29
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              133629
;  :num-checks              31
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            132916)
; [then-branch: 17 | 0 < V@19@08 | live]
; [else-branch: 17 | !(0 < V@19@08) | dead]
(push) ; 4
; [then-branch: 17 | 0 < V@19@08]
(assert (< 0 V@19@08))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(visited)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 18 | True | live]
; [else-branch: 18 | False | live]
(push) ; 4
; [then-branch: 18 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 18 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               224
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               8
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   54
;  :datatype-splits         18
;  :decisions               28
;  :del-clause              29
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              134187
;  :num-checks              32
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            133353)
(push) ; 4
(assert (not (< 0 V@19@08)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               224
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               9
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   54
;  :datatype-splits         18
;  :decisions               28
;  :del-clause              29
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              134257
;  :num-checks              33
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            133401)
; [then-branch: 19 | 0 < V@19@08 | live]
; [else-branch: 19 | !(0 < V@19@08) | dead]
(push) ; 4
; [then-branch: 19 | 0 < V@19@08]
(assert (< 0 V@19@08))
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
; [eval] exc == null && 0 < V ==> 0 <= s
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 20 | True | live]
; [else-branch: 20 | False | live]
(push) ; 4
; [then-branch: 20 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 20 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               227
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               9
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   55
;  :datatype-splits         18
;  :decisions               29
;  :del-clause              29
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              134873
;  :num-checks              34
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            133883)
(push) ; 4
(assert (not (< 0 V@19@08)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               227
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               10
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   55
;  :datatype-splits         18
;  :decisions               29
;  :del-clause              29
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              134943
;  :num-checks              35
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            133931)
; [then-branch: 21 | 0 < V@19@08 | live]
; [else-branch: 21 | !(0 < V@19@08) | dead]
(push) ; 4
; [then-branch: 21 | 0 < V@19@08]
(assert (< 0 V@19@08))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null && 0 < V ==> s < V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 22 | True | live]
; [else-branch: 22 | False | live]
(push) ; 4
; [then-branch: 22 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 22 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@19@08))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               230
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               10
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 30
;  :datatype-occurs-check   56
;  :datatype-splits         18
;  :decisions               30
;  :del-clause              29
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              135501
;  :num-checks              36
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            134368)
(push) ; 4
(assert (not (< 0 V@19@08)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               230
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               11
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 30
;  :datatype-occurs-check   56
;  :datatype-splits         18
;  :decisions               30
;  :del-clause              29
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              135571
;  :num-checks              37
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            134416)
; [then-branch: 23 | 0 < V@19@08 | live]
; [else-branch: 23 | !(0 < V@19@08) | dead]
(push) ; 4
; [then-branch: 23 | 0 < V@19@08]
(assert (< 0 V@19@08))
; [eval] s < V
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
; (:added-eqs               233
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               11
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   57
;  :datatype-splits         18
;  :decisions               31
;  :del-clause              29
;  :final-checks            41
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              136076
;  :num-checks              38
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            134787)
; [then-branch: 24 | True | live]
; [else-branch: 24 | False | dead]
(push) ; 4
; [then-branch: 24 | True]
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
; (:added-eqs               236
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               11
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 32
;  :datatype-occurs-check   58
;  :datatype-splits         18
;  :decisions               32
;  :del-clause              29
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              136574
;  :num-checks              39
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            135151)
; [then-branch: 25 | True | live]
; [else-branch: 25 | False | dead]
(push) ; 4
; [then-branch: 25 | True]
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
; (:added-eqs               239
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               11
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   59
;  :datatype-splits         18
;  :decisions               33
;  :del-clause              29
;  :final-checks            43
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              137072
;  :num-checks              40
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            135510)
; [then-branch: 26 | True | live]
; [else-branch: 26 | False | dead]
(push) ; 3
; [then-branch: 26 | True]
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
(pop) ; 4
; Joined path conditions
; [eval] exc == null ==> aloc(opt_get1(visited), i1).bool == false
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
; (:added-eqs               242
;  :arith-add-rows          4
;  :arith-assert-diseq      1
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        1
;  :arith-conflicts         1
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            7
;  :conflicts               11
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   60
;  :datatype-splits         18
;  :decisions               34
;  :del-clause              29
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.02
;  :mk-bool-var             409
;  :mk-clause               29
;  :num-allocs              137570
;  :num-checks              41
;  :propagations            25
;  :quant-instantiations    24
;  :rlimit-count            135884)
; [then-branch: 27 | True | live]
; [else-branch: 27 | False | dead]
(push) ; 5
; [then-branch: 27 | True]
; [eval] aloc(opt_get1(visited), i1).bool == false
; [eval] aloc(opt_get1(visited), i1)
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
(pop) ; 6
; Joined path conditions
(pop) ; 5
(pop) ; 4
; Joined path conditions
(pop) ; 3
(pop) ; 2
(pop) ; 1
