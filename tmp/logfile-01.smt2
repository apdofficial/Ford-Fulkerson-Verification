(get-info :version)
; (:version "4.8.6")
; Started: 2022-06-16 09:19:35
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
(declare-sort Seq<Seq<Int>>)
(declare-sort Seq<Int>)
(declare-sort Set<Int>)
(declare-sort Set<Bool>)
(declare-sort Set<option<array>>)
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
(declare-fun $SortWrappers.Seq<Seq<Int>>To$Snap (Seq<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapToSeq<Seq<Int>> ($Snap) Seq<Seq<Int>>)
(assert (forall ((x Seq<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapToSeq<Seq<Int>>($SortWrappers.Seq<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.Seq<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapToSeq<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Seq<Seq<Int>>To$Snap($SortWrappers.$SnapToSeq<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapToSeq<Seq<Int>> x))
    :qid |$Snap.Seq<Seq<Int>>To$SnapToSeq<Seq<Int>>|
    )))
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
(declare-fun Seq_length (Seq<Seq<Int>>) Int)
(declare-const Seq_empty Seq<Seq<Int>>)
(declare-fun Seq_singleton (Seq<Int>) Seq<Seq<Int>>)
(declare-fun Seq_build (Seq<Seq<Int>> Seq<Int>) Seq<Seq<Int>>)
(declare-fun Seq_index (Seq<Seq<Int>> Int) Seq<Int>)
(declare-fun Seq_append (Seq<Seq<Int>> Seq<Seq<Int>>) Seq<Seq<Int>>)
(declare-fun Seq_update (Seq<Seq<Int>> Int Seq<Int>) Seq<Seq<Int>>)
(declare-fun Seq_contains (Seq<Seq<Int>> Seq<Int>) Bool)
(declare-fun Seq_take (Seq<Seq<Int>> Int) Seq<Seq<Int>>)
(declare-fun Seq_drop (Seq<Seq<Int>> Int) Seq<Seq<Int>>)
(declare-fun Seq_equal (Seq<Seq<Int>> Seq<Seq<Int>>) Bool)
(declare-fun Seq_sameuntil (Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
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
(declare-fun SquareIntMatrix ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SquareIntMatrix%limited ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SquareIntMatrix%stateless ($Ref Seq<Seq<Int>> Int) Bool)
(declare-fun NonNegativeCapacities ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun NonNegativeCapacities%limited ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun NonNegativeCapacities%stateless ($Ref Seq<Seq<Int>> Int) Bool)
(declare-fun FlowNetwork ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowNetwork%limited ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowNetwork%stateless ($Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun SumOutgoingFlow ($Snap $Ref Seq<Seq<Int>> Int Int Int) Int)
(declare-fun SumOutgoingFlow%limited ($Snap $Ref Seq<Seq<Int>> Int Int Int) Int)
(declare-fun SumOutgoingFlow%stateless ($Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun SumIncomingFlow ($Snap $Ref Seq<Seq<Int>> Int Int Int) Int)
(declare-fun SumIncomingFlow%limited ($Snap $Ref Seq<Seq<Int>> Int Int Int) Int)
(declare-fun SumIncomingFlow%stateless ($Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun CapacityConstraint ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
(declare-fun CapacityConstraint%limited ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
(declare-fun CapacityConstraint%stateless ($Ref Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
(declare-fun FlowConservation ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowConservation%limited ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowConservation%stateless ($Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun aloc ($Snap array Int) $Ref)
(declare-fun aloc%limited ($Snap array Int) $Ref)
(declare-fun aloc%stateless (array Int) Bool)
(declare-fun opt_get1 ($Snap option<array>) array)
(declare-fun opt_get1%limited ($Snap option<array>) array)
(declare-fun opt_get1%stateless (option<array>) Bool)
(declare-fun valid_graph_vertices1 ($Snap $Ref Seq<Int> Int) Bool)
(declare-fun valid_graph_vertices1%limited ($Snap $Ref Seq<Int> Int) Bool)
(declare-fun valid_graph_vertices1%stateless ($Ref Seq<Int> Int) Bool)
(declare-fun ValidFlow ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun ValidFlow%limited ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun ValidFlow%stateless ($Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun SquareIntMatrix1 ($Snap $Ref option<array> Int) Bool)
(declare-fun SquareIntMatrix1%limited ($Snap $Ref option<array> Int) Bool)
(declare-fun SquareIntMatrix1%stateless ($Ref option<array> Int) Bool)
(declare-fun any_as ($Snap any) any)
(declare-fun any_as%limited ($Snap any) any)
(declare-fun any_as%stateless (any) Bool)
(declare-fun unknown_ ($Snap option<array> Int Int) Seq<Int>)
(declare-fun unknown%limited ($Snap option<array> Int Int) Seq<Int>)
(declare-fun unknown%stateless (option<array> Int Int) Bool)
(declare-fun AugPath ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int Seq<Int>) Bool)
(declare-fun AugPath%limited ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int Seq<Int>) Bool)
(declare-fun AugPath%stateless ($Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int Seq<Int>) Bool)
(declare-fun opt_get ($Snap option<any>) any)
(declare-fun opt_get%limited ($Snap option<any>) any)
(declare-fun opt_get%stateless (option<any>) Bool)
(declare-fun NonNegativeCapacities1 ($Snap $Ref option<array> Int) Bool)
(declare-fun NonNegativeCapacities1%limited ($Snap $Ref option<array> Int) Bool)
(declare-fun NonNegativeCapacities1%stateless ($Ref option<array> Int) Bool)
(declare-fun as_any ($Snap any) any)
(declare-fun as_any%limited ($Snap any) any)
(declare-fun as_any%stateless (any) Bool)
(declare-fun valid_graph_vertices ($Snap $Ref option<array> Int) Bool)
(declare-fun valid_graph_vertices%limited ($Snap $Ref option<array> Int) Bool)
(declare-fun valid_graph_vertices%stateless ($Ref option<array> Int) Bool)
(declare-fun type ($Snap $Ref) Int)
(declare-fun type%limited ($Snap $Ref) Int)
(declare-fun type%stateless ($Ref) Bool)
(declare-fun subtype ($Snap Int Int) Bool)
(declare-fun subtype%limited ($Snap Int Int) Bool)
(declare-fun subtype%stateless (Int Int) Bool)
(declare-fun matrixValues ($Snap $Ref option<array> Int) Seq<Seq<Int>>)
(declare-fun matrixValues%limited ($Snap $Ref option<array> Int) Seq<Seq<Int>>)
(declare-fun matrixValues%stateless ($Ref option<array> Int) Bool)
(declare-fun ExAugPath ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun ExAugPath%limited ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun ExAugPath%stateless ($Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun opt_or_else ($Snap option<any> any) any)
(declare-fun opt_or_else%limited ($Snap option<any> any) any)
(declare-fun opt_or_else%stateless (option<any> any) Bool)
(declare-fun FlowNetwork1 ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun FlowNetwork1%limited ($Snap $Ref option<array> Int Int Int) Bool)
(declare-fun FlowNetwork1%stateless ($Ref option<array> Int Int Int) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun lock_inv_FordFulkerson%trigger ($Snap $Ref) Bool)
(declare-fun lock_held_FordFulkerson%trigger ($Snap $Ref) Bool)
(declare-fun lock_inv_Object%trigger ($Snap $Ref) Bool)
(declare-fun lock_held_Object%trigger ($Snap $Ref) Bool)
; ////////// Uniqueness assumptions from domains
; ////////// Axioms
(assert (forall ((s Seq<Seq<Int>>)) (!
  (<= 0 (Seq_length s))
  :pattern ((Seq_length s))
  :qid |$Seq[Seq[Int]]_prog.seq_length_non_negative|)))
(assert (= (Seq_length (as Seq_empty  Seq<Seq<Int>>)) 0))
(assert (forall ((s Seq<Seq<Int>>)) (!
  (implies (= (Seq_length s) 0) (= s (as Seq_empty  Seq<Seq<Int>>)))
  :pattern ((Seq_length s))
  :qid |$Seq[Seq[Int]]_prog.only_empty_seq_length_zero|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Seq_length (Seq_singleton e)) 1)
  :pattern ((Seq_length (Seq_singleton e)))
  :qid |$Seq[Seq[Int]]_prog.length_singleton_seq|)))
(assert (forall ((s Seq<Seq<Int>>) (e Seq<Int>)) (!
  (= (Seq_length (Seq_build s e)) (+ 1 (Seq_length s)))
  :pattern ((Seq_length (Seq_build s e)))
  :qid |$Seq[Seq[Int]]_prog.length_seq_build_inc_by_one|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>)) (!
  (ite
    (= i (Seq_length s))
    (= (Seq_index (Seq_build s e) i) e)
    (= (Seq_index (Seq_build s e) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_build s e) i))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_build|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Seq<Int>>)))
      (not (= s2 (as Seq_empty  Seq<Seq<Int>>))))
    (= (Seq_length (Seq_append s1 s2)) (+ (Seq_length s1) (Seq_length s2))))
  :pattern ((Seq_length (Seq_append s1 s2)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_over_append|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Seq_index (Seq_singleton e) 0) e)
  :pattern ((Seq_index (Seq_singleton e) 0))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_singleton|)))
(assert (forall ((e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Seq_contains (Seq_singleton e1) e2) (= e1 e2))
  :pattern ((Seq_contains (Seq_singleton e1) e2))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_singleton|)))
(assert (forall ((s Seq<Seq<Int>>)) (!
  (= (Seq_append (as Seq_empty  Seq<Seq<Int>>) s) s)
  :pattern ((Seq_append (as Seq_empty  Seq<Seq<Int>>) s))
  :qid |$Seq[Seq[Int]]_prog.seq_append_empty_left|)))
(assert (forall ((s Seq<Seq<Int>>)) (!
  (= (Seq_append s (as Seq_empty  Seq<Seq<Int>>)) s)
  :pattern ((Seq_append s (as Seq_empty  Seq<Seq<Int>>)))
  :qid |$Seq[Seq[Int]]_prog.seq_append_empty_right|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>) (i Int)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Seq<Int>>)))
      (not (= s2 (as Seq_empty  Seq<Seq<Int>>))))
    (ite
      (< i (Seq_length s1))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s1 i))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s2 (- i (Seq_length s1))))))
  :pattern ((Seq_index (Seq_append s1 s2) i))
  :pattern ((Seq_index s1 i) (Seq_append s1 s2))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_append|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>)) (!
  (implies
    (and (<= 0 i) (< i (Seq_length s)))
    (= (Seq_length (Seq_update s i e)) (Seq_length s)))
  :pattern ((Seq_length (Seq_update s i e)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_invariant_over_update|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (j Int)) (!
  (ite
    (implies (and (<= 0 i) (< i (Seq_length s))) (= i j))
    (= (Seq_index (Seq_update s i e) j) e)
    (= (Seq_index (Seq_update s i e) j) (Seq_index s j)))
  :pattern ((Seq_index (Seq_update s i e) j))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_update|)))
(assert (forall ((s Seq<Seq<Int>>) (e Seq<Int>)) (!
  (=
    (Seq_contains s e)
    (exists ((i Int)) (!
      (and (<= 0 i) (and (< i (Seq_length s)) (= (Seq_index s i) e)))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains s e))
  :qid |$Seq[Seq[Int]]_prog.seq_element_contains_index_exists|)))
(assert (forall ((e Seq<Int>)) (!
  (not (Seq_contains (as Seq_empty  Seq<Seq<Int>>) e))
  :pattern ((Seq_contains (as Seq_empty  Seq<Seq<Int>>) e))
  :qid |$Seq[Seq[Int]]_prog.empty_seq_contains_nothing|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>) (e Seq<Int>)) (!
  (=
    (Seq_contains (Seq_append s1 s2) e)
    (or (Seq_contains s1 e) (Seq_contains s2 e)))
  :pattern ((Seq_contains (Seq_append s1 s2) e))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_append|)))
(assert (forall ((s Seq<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Seq_contains (Seq_build s e1) e2) (or (= e1 e2) (Seq_contains s e2)))
  :pattern ((Seq_contains (Seq_build s e1) e2))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_build|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies (<= n 0) (= (Seq_take s n) (as Seq_empty  Seq<Seq<Int>>)))
  :pattern ((Seq_take s n))
  :qid |$Seq[Seq[Int]]_prog.seq_take_negative_length|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (e Seq<Int>)) (!
  (=
    (Seq_contains (Seq_take s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (< i n) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_take s n) e))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_take_index_exists|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies (<= n 0) (= (Seq_drop s n) s))
  :pattern ((Seq_drop s n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_negative_length|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (e Seq<Int>)) (!
  (=
    (Seq_contains (Seq_drop s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (<= n i) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_drop s n) e))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_drop_index_exists|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>)) (!
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
  :qid |$Seq[Seq[Int]]_prog.extensional_seq_equality|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>)) (!
  (implies (Seq_equal s1 s2) (= s1 s2))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Seq[Int]]_prog.seq_equality_identity|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>) (n Int)) (!
  (=
    (Seq_sameuntil s1 s2 n)
    (forall ((i Int)) (!
      (implies (and (<= 0 i) (< i n)) (= (Seq_index s1 i) (Seq_index s2 i)))
      :pattern ((Seq_index s1 i))
      :pattern ((Seq_index s2 i))
      )))
  :pattern ((Seq_sameuntil s1 s2 n))
  :qid |$Seq[Seq[Int]]_prog.extensional_seq_equality_prefix|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_take s n)) n)
      (= (Seq_length (Seq_take s n)) (Seq_length s))))
  :pattern ((Seq_length (Seq_take s n)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_over_take|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< i (Seq_length s))))
    (= (Seq_index (Seq_take s n) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_take s n) i))
  :pattern ((Seq_index s i) (Seq_take s n))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_take|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_drop s n)) (- (Seq_length s) n))
      (= (Seq_length (Seq_drop s n)) 0)))
  :pattern ((Seq_length (Seq_drop s n)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_over_drop|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= 0 i) (< i (- (Seq_length s) n))))
    (= (Seq_index (Seq_drop s n) i) (Seq_index s (+ i n))))
  :pattern ((Seq_index (Seq_drop s n) i))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_drop_1|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_index (Seq_drop s n) (- i n)) (Seq_index s i)))
  :pattern ((Seq_index s i) (Seq_drop s n))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_drop_2|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_take (Seq_update s i e) n) (Seq_update (Seq_take s n) i e)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_take_over_update_1|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= n i) (< i (Seq_length s)))
    (= (Seq_take (Seq_update s i e) n) (Seq_take s n)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_take_over_update_2|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_update (Seq_drop s n) (- i n) e)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_over_update_1|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_drop s n)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_over_update_2|)))
(assert (forall ((s Seq<Seq<Int>>) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 n) (<= n (Seq_length s)))
    (= (Seq_drop (Seq_build s e) n) (Seq_build (Seq_drop s n) e)))
  :pattern ((Seq_drop (Seq_build s e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_over_build|)))
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
(declare-fun $k@121@00 () $Perm)
(declare-fun $k@130@00 () $Perm)
(declare-fun inv@122@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun inv@131@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun inv@132@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun sm@123@00 ($Snap $Ref option<array> Int) $FVF<option<array>>)
(declare-fun $k@136@00 () $Perm)
(declare-fun inv@138@00 ($Snap option<array> Int Int $Ref) Int)
(declare-fun sm@139@00 ($Snap option<array> Int Int) $FVF<Int>)
(declare-fun $k@147@00 () $Perm)
(declare-fun inv@148@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun sm@149@00 ($Snap $Ref option<array> Int) $FVF<Int>)
(declare-fun $k@154@00 () $Perm)
(declare-fun $k@163@00 () $Perm)
(declare-fun $k@170@00 () $Perm)
(declare-fun inv@155@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun inv@164@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun inv@165@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun inv@171@00 ($Snap $Ref option<array> Int Int $Ref) Int)
(declare-fun sm@156@00 ($Snap $Ref option<array> Int) $FVF<option<array>>)
(declare-fun sm@173@00 ($Snap $Ref option<array> Int) $FVF<Int>)
(declare-fun $k@177@00 () $Perm)
(declare-fun $k@186@00 () $Perm)
(declare-fun inv@178@00 ($Snap $Ref option<array> Int Int Int $Ref) Int)
(declare-fun inv@187@00 ($Snap $Ref option<array> Int Int Int $Ref) Int)
(declare-fun inv@188@00 ($Snap $Ref option<array> Int Int Int $Ref) Int)
(declare-fun sm@179@00 ($Snap $Ref option<array> Int Int Int) $FVF<option<array>>)
(declare-fun $k@191@00 () $Perm)
(declare-fun $k@209@00 () $Perm)
(declare-fun inv@192@00 ($Snap $Ref option<array> Int Int Int $Ref) Int)
(declare-fun inv@212@00 ($Snap $Ref option<array> Int Int Int $Ref) Int)
(declare-fun inv@213@00 ($Snap $Ref option<array> Int Int Int $Ref) Int)
(declare-fun sm@194@00 ($Snap $Ref option<array> Int Int Int) $FVF<option<array>>)
(declare-fun sm@196@00 ($Snap $Ref option<array> Int Int Int) $FVF<option<array>>)
(declare-fun sm@199@00 ($Snap $Ref option<array> Int Int Int) $FVF<option<array>>)
(declare-fun sm@203@00 ($Snap $Ref option<array> Int Int Int) $FVF<option<array>>)
(declare-fun sm@205@00 ($Snap $Ref option<array> Int Int Int) $FVF<option<array>>)
(declare-fun sm@210@00 ($Snap $Ref option<array> Int Int Int) $FVF<option<array>>)
(declare-fun sm@215@00 ($Snap $Ref option<array> Int Int Int) $FVF<Int>)
(define-fun pTaken@172@00 ((r $Ref) (s@$ $Snap) (this@88@00 $Ref) (a2@89@00 option<array>) (V@90@00 Int) (i1@168@00 Int)) $Perm
  (ite
    (and
      (<
        (inv@171@00 s@$ this@88@00 a2@89@00 V@90@00 i1@168@00 r)
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1@168@00)))))
      (<= 0 (inv@171@00 s@$ this@88@00 a2@89@00 V@90@00 i1@168@00 r)))
    ($Perm.min
      (ite
        (and
          (and
            (and
              (< (inv@165@00 s@$ this@88@00 a2@89@00 V@90@00 r) V@90@00)
              (<= 0 (inv@165@00 s@$ this@88@00 a2@89@00 V@90@00 r)))
            (< (inv@164@00 s@$ this@88@00 a2@89@00 V@90@00 r) V@90@00))
          (<= 0 (inv@164@00 s@$ this@88@00 a2@89@00 V@90@00 r)))
        $k@163@00
        $Perm.No)
      $k@170@00)
    $Perm.No))
(define-fun pTaken@193@00 ((r $Ref) (s@$ $Snap) (this@102@00 $Ref) (G@103@00 option<array>) (V@104@00 Int) (s@105@00 Int) (t@106@00 Int)) $Perm
  (ite
    (and
      (<
        (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
        V@104@00)
      (<= 0 (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
    ($Perm.min
      (ite
        (and
          (<
            (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
            V@104@00)
          (<=
            0
            (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
        $k@177@00
        $Perm.No)
      $k@191@00)
    $Perm.No))
(define-fun pTaken@214@00 ((r $Ref) (s@$ $Snap) (this@102@00 $Ref) (G@103@00 option<array>) (V@104@00 Int) (s@105@00 Int) (t@106@00 Int)) $Perm
  (ite
    (and
      (and
        (and
          (<
            (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
            V@104@00)
          (<=
            0
            (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
        (<
          (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
          V@104@00))
      (<= 0 (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
    ($Perm.min
      (ite
        (and
          (and
            (and
              (<
                (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                V@104@00)
              (<=
                0
                (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
            (<
              (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00))
          (<=
            0
            (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
        $k@186@00
        $Perm.No)
      $k@209@00)
    $Perm.No))
(declare-fun $unresolved@115@00 () $Snap)
(assert (forall ((s@$ $Snap) (this@0@00 $Ref) (G@1@00 Seq<Seq<Int>>) (V@2@00 Int)) (!
  (=
    (SquareIntMatrix%limited s@$ this@0@00 G@1@00 V@2@00)
    (SquareIntMatrix s@$ this@0@00 G@1@00 V@2@00))
  :pattern ((SquareIntMatrix s@$ this@0@00 G@1@00 V@2@00))
  )))
(assert (forall ((s@$ $Snap) (this@0@00 $Ref) (G@1@00 Seq<Seq<Int>>) (V@2@00 Int)) (!
  (SquareIntMatrix%stateless this@0@00 G@1@00 V@2@00)
  :pattern ((SquareIntMatrix%limited s@$ this@0@00 G@1@00 V@2@00))
  )))
(assert (forall ((s@$ $Snap) (this@0@00 $Ref) (G@1@00 Seq<Seq<Int>>) (V@2@00 Int)) (!
  (implies
    (not (= this@0@00 $Ref.null))
    (=
      (SquareIntMatrix s@$ this@0@00 G@1@00 V@2@00)
      (and
        (= (Seq_length G@1@00) V@2@00)
        (forall ((e Seq<Int>)) (!
          (implies (Seq_contains G@1@00 e) (= (Seq_length e) V@2@00))
          :pattern ((Seq_contains G@1@00 e))
          :pattern ((Seq_length e))
          )))))
  :pattern ((SquareIntMatrix s@$ this@0@00 G@1@00 V@2@00))
  )))
(assert (forall ((s@$ $Snap) (this@4@00 $Ref) (G@5@00 Seq<Seq<Int>>) (V@6@00 Int)) (!
  (=
    (NonNegativeCapacities%limited s@$ this@4@00 G@5@00 V@6@00)
    (NonNegativeCapacities s@$ this@4@00 G@5@00 V@6@00))
  :pattern ((NonNegativeCapacities s@$ this@4@00 G@5@00 V@6@00))
  )))
(assert (forall ((s@$ $Snap) (this@4@00 $Ref) (G@5@00 Seq<Seq<Int>>) (V@6@00 Int)) (!
  (NonNegativeCapacities%stateless this@4@00 G@5@00 V@6@00)
  :pattern ((NonNegativeCapacities%limited s@$ this@4@00 G@5@00 V@6@00))
  )))
(assert (forall ((s@$ $Snap) (this@4@00 $Ref) (G@5@00 Seq<Seq<Int>>) (V@6@00 Int)) (!
  (implies
    (and
      (not (= this@4@00 $Ref.null))
      (SquareIntMatrix $Snap.unit this@4@00 G@5@00 V@6@00))
    (=
      (NonNegativeCapacities s@$ this@4@00 G@5@00 V@6@00)
      (forall ((i1 Int)) (!
        (implies
          (and (<= 0 i1) (< i1 V@6@00))
          (forall ((j Int)) (!
            (implies
              (and (<= 0 j) (< j V@6@00))
              (< 0 (Seq_index (Seq_index G@5@00 i1) j)))
            :pattern ((Seq_index (Seq_index G@5@00 i1) j))
            )))
        :pattern ((Seq_index G@5@00 i1))
        ))))
  :pattern ((NonNegativeCapacities s@$ this@4@00 G@5@00 V@6@00))
  )))
(assert (forall ((s@$ $Snap) (this@8@00 $Ref) (G@9@00 Seq<Seq<Int>>) (V@10@00 Int) (s@11@00 Int) (t@12@00 Int)) (!
  (=
    (FlowNetwork%limited s@$ this@8@00 G@9@00 V@10@00 s@11@00 t@12@00)
    (FlowNetwork s@$ this@8@00 G@9@00 V@10@00 s@11@00 t@12@00))
  :pattern ((FlowNetwork s@$ this@8@00 G@9@00 V@10@00 s@11@00 t@12@00))
  )))
(assert (forall ((s@$ $Snap) (this@8@00 $Ref) (G@9@00 Seq<Seq<Int>>) (V@10@00 Int) (s@11@00 Int) (t@12@00 Int)) (!
  (FlowNetwork%stateless this@8@00 G@9@00 V@10@00 s@11@00 t@12@00)
  :pattern ((FlowNetwork%limited s@$ this@8@00 G@9@00 V@10@00 s@11@00 t@12@00))
  )))
(assert (forall ((s@$ $Snap) (this@8@00 $Ref) (G@9@00 Seq<Seq<Int>>) (V@10@00 Int) (s@11@00 Int) (t@12@00 Int)) (!
  (implies
    (not (= this@8@00 $Ref.null))
    (=
      (FlowNetwork s@$ this@8@00 G@9@00 V@10@00 s@11@00 t@12@00)
      (and
        (and
          (and
            (and (and (<= 0 s@11@00) (< s@11@00 V@10@00)) (<= 0 t@12@00))
            (< t@12@00 V@10@00))
          (SquareIntMatrix $Snap.unit this@8@00 G@9@00 V@10@00))
        (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@8@00 G@9@00 V@10@00))))
  :pattern ((FlowNetwork s@$ this@8@00 G@9@00 V@10@00 s@11@00 t@12@00))
  )))
(assert (forall ((s@$ $Snap) (this@14@00 $Ref) (G@15@00 Seq<Seq<Int>>) (n@16@00 Int) (v@17@00 Int) (V@18@00 Int)) (!
  (=
    (SumOutgoingFlow%limited s@$ this@14@00 G@15@00 n@16@00 v@17@00 V@18@00)
    (SumOutgoingFlow s@$ this@14@00 G@15@00 n@16@00 v@17@00 V@18@00))
  :pattern ((SumOutgoingFlow s@$ this@14@00 G@15@00 n@16@00 v@17@00 V@18@00))
  )))
(assert (forall ((s@$ $Snap) (this@14@00 $Ref) (G@15@00 Seq<Seq<Int>>) (n@16@00 Int) (v@17@00 Int) (V@18@00 Int)) (!
  (SumOutgoingFlow%stateless this@14@00 G@15@00 n@16@00 v@17@00 V@18@00)
  :pattern ((SumOutgoingFlow%limited s@$ this@14@00 G@15@00 n@16@00 v@17@00 V@18@00))
  )))
(assert (forall ((s@$ $Snap) (this@14@00 $Ref) (G@15@00 Seq<Seq<Int>>) (n@16@00 Int) (v@17@00 Int) (V@18@00 Int)) (!
  (implies
    (and
      (not (= this@14@00 $Ref.null))
      (FlowNetwork $Snap.unit this@14@00 G@15@00 V@18@00 n@16@00 v@17@00))
    (=
      (SumOutgoingFlow s@$ this@14@00 G@15@00 n@16@00 v@17@00 V@18@00)
      (ite
        (< 0 n@16@00)
        (+
          (Seq_index (Seq_index G@15@00 v@17@00) n@16@00)
          (SumOutgoingFlow%limited ($Snap.combine $Snap.unit $Snap.unit) this@14@00 G@15@00 (-
            n@16@00
            1) v@17@00 V@18@00))
        0)))
  :pattern ((SumOutgoingFlow s@$ this@14@00 G@15@00 n@16@00 v@17@00 V@18@00))
  )))
(assert (forall ((s@$ $Snap) (this@20@00 $Ref) (G@21@00 Seq<Seq<Int>>) (n@22@00 Int) (v@23@00 Int) (V@24@00 Int)) (!
  (=
    (SumIncomingFlow%limited s@$ this@20@00 G@21@00 n@22@00 v@23@00 V@24@00)
    (SumIncomingFlow s@$ this@20@00 G@21@00 n@22@00 v@23@00 V@24@00))
  :pattern ((SumIncomingFlow s@$ this@20@00 G@21@00 n@22@00 v@23@00 V@24@00))
  )))
(assert (forall ((s@$ $Snap) (this@20@00 $Ref) (G@21@00 Seq<Seq<Int>>) (n@22@00 Int) (v@23@00 Int) (V@24@00 Int)) (!
  (SumIncomingFlow%stateless this@20@00 G@21@00 n@22@00 v@23@00 V@24@00)
  :pattern ((SumIncomingFlow%limited s@$ this@20@00 G@21@00 n@22@00 v@23@00 V@24@00))
  )))
(assert (forall ((s@$ $Snap) (this@20@00 $Ref) (G@21@00 Seq<Seq<Int>>) (n@22@00 Int) (v@23@00 Int) (V@24@00 Int)) (!
  (implies
    (and
      (not (= this@20@00 $Ref.null))
      (FlowNetwork $Snap.unit this@20@00 G@21@00 V@24@00 n@22@00 v@23@00))
    (=
      (SumIncomingFlow s@$ this@20@00 G@21@00 n@22@00 v@23@00 V@24@00)
      (ite
        (< 0 n@22@00)
        (+
          (Seq_index (Seq_index G@21@00 n@22@00) v@23@00)
          (SumIncomingFlow%limited ($Snap.combine $Snap.unit $Snap.unit) this@20@00 G@21@00 (-
            n@22@00
            1) v@23@00 V@24@00))
        0)))
  :pattern ((SumIncomingFlow s@$ this@20@00 G@21@00 n@22@00 v@23@00 V@24@00))
  )))
(assert (forall ((s@$ $Snap) (this@26@00 $Ref) (G@27@00 Seq<Seq<Int>>) (Gf@28@00 Seq<Seq<Int>>) (V@29@00 Int)) (!
  (=
    (CapacityConstraint%limited s@$ this@26@00 G@27@00 Gf@28@00 V@29@00)
    (CapacityConstraint s@$ this@26@00 G@27@00 Gf@28@00 V@29@00))
  :pattern ((CapacityConstraint s@$ this@26@00 G@27@00 Gf@28@00 V@29@00))
  )))
(assert (forall ((s@$ $Snap) (this@26@00 $Ref) (G@27@00 Seq<Seq<Int>>) (Gf@28@00 Seq<Seq<Int>>) (V@29@00 Int)) (!
  (CapacityConstraint%stateless this@26@00 G@27@00 Gf@28@00 V@29@00)
  :pattern ((CapacityConstraint%limited s@$ this@26@00 G@27@00 Gf@28@00 V@29@00))
  )))
(assert (forall ((s@$ $Snap) (this@26@00 $Ref) (G@27@00 Seq<Seq<Int>>) (Gf@28@00 Seq<Seq<Int>>) (V@29@00 Int)) (!
  (implies
    (and
      (not (= this@26@00 $Ref.null))
      (SquareIntMatrix $Snap.unit this@26@00 G@27@00 V@29@00)
      (SquareIntMatrix $Snap.unit this@26@00 Gf@28@00 V@29@00))
    (=
      (CapacityConstraint s@$ this@26@00 G@27@00 Gf@28@00 V@29@00)
      (forall ((i1 Int)) (!
        (implies
          (and (<= 0 i1) (< i1 V@29@00))
          (forall ((j Int)) (!
            (implies
              (and (<= 0 j) (< j V@29@00))
              (<=
                (Seq_index (Seq_index Gf@28@00 i1) j)
                (Seq_index (Seq_index G@27@00 i1) j)))
            :pattern ((Seq_index (Seq_index Gf@28@00 i1) j))
            :pattern ((Seq_index (Seq_index G@27@00 i1) j))
            )))
        :pattern ((Seq_index Gf@28@00 i1))
        :pattern ((Seq_index G@27@00 i1))
        ))))
  :pattern ((CapacityConstraint s@$ this@26@00 G@27@00 Gf@28@00 V@29@00))
  )))
(assert (forall ((s@$ $Snap) (this@31@00 $Ref) (G@32@00 Seq<Seq<Int>>) (V@33@00 Int) (s@34@00 Int) (t@35@00 Int)) (!
  (=
    (FlowConservation%limited s@$ this@31@00 G@32@00 V@33@00 s@34@00 t@35@00)
    (FlowConservation s@$ this@31@00 G@32@00 V@33@00 s@34@00 t@35@00))
  :pattern ((FlowConservation s@$ this@31@00 G@32@00 V@33@00 s@34@00 t@35@00))
  )))
(assert (forall ((s@$ $Snap) (this@31@00 $Ref) (G@32@00 Seq<Seq<Int>>) (V@33@00 Int) (s@34@00 Int) (t@35@00 Int)) (!
  (FlowConservation%stateless this@31@00 G@32@00 V@33@00 s@34@00 t@35@00)
  :pattern ((FlowConservation%limited s@$ this@31@00 G@32@00 V@33@00 s@34@00 t@35@00))
  )))
(assert (forall ((s@$ $Snap) (this@31@00 $Ref) (G@32@00 Seq<Seq<Int>>) (V@33@00 Int) (s@34@00 Int) (t@35@00 Int)) (!
  (implies
    (and
      (not (= this@31@00 $Ref.null))
      (FlowNetwork $Snap.unit this@31@00 G@32@00 V@33@00 s@34@00 t@35@00))
    (=
      (FlowConservation s@$ this@31@00 G@32@00 V@33@00 s@34@00 t@35@00)
      (and
        (and
          (<=
            (SumIncomingFlow ($Snap.combine $Snap.unit $Snap.unit) this@31@00 G@32@00 (-
              V@33@00
              1) s@34@00 V@33@00)
            (SumOutgoingFlow ($Snap.combine $Snap.unit $Snap.unit) this@31@00 G@32@00 (-
              V@33@00
              1) s@34@00 V@33@00))
          (<=
            (SumOutgoingFlow ($Snap.combine $Snap.unit $Snap.unit) this@31@00 G@32@00 (-
              V@33@00
              1) t@35@00 V@33@00)
            (SumIncomingFlow ($Snap.combine $Snap.unit $Snap.unit) this@31@00 G@32@00 (-
              V@33@00
              1) t@35@00 V@33@00)))
        (forall ((v Int) (fresh__1 Int)) (!
          (implies
            (and
              (and (and (<= 0 v) (< v V@33@00)) (not (= v s@34@00)))
              (not (= v t@35@00)))
            (=
              (SumIncomingFlow ($Snap.combine $Snap.unit $Snap.unit) this@31@00 G@32@00 (-
                V@33@00
                1) v V@33@00)
              (SumOutgoingFlow ($Snap.combine $Snap.unit $Snap.unit) this@31@00 G@32@00 (-
                V@33@00
                1) v V@33@00)))
          :pattern ((SumOutgoingFlow%limited $unresolved@115@00 this@31@00 G@32@00 fresh__1 v V@33@00))
          )))))
  :pattern ((FlowConservation s@$ this@31@00 G@32@00 V@33@00 s@34@00 t@35@00))
  )))
(assert (forall ((s@$ $Snap) (a2@37@00 array) (i1@38@00 Int)) (!
  (= (aloc%limited s@$ a2@37@00 i1@38@00) (aloc s@$ a2@37@00 i1@38@00))
  :pattern ((aloc s@$ a2@37@00 i1@38@00))
  )))
(assert (forall ((s@$ $Snap) (a2@37@00 array) (i1@38@00 Int)) (!
  (aloc%stateless a2@37@00 i1@38@00)
  :pattern ((aloc%limited s@$ a2@37@00 i1@38@00))
  )))
(assert (forall ((s@$ $Snap) (a2@37@00 array) (i1@38@00 Int)) (!
  (let ((result@39@00 (aloc%limited s@$ a2@37@00 i1@38@00))) (implies
    (and (<= 0 i1@38@00) (< i1@38@00 (alen<Int> a2@37@00)))
    (and
      (= (loc_inv_1<array> result@39@00) a2@37@00)
      (= (loc_inv_2<Int> result@39@00) i1@38@00))))
  :pattern ((aloc%limited s@$ a2@37@00 i1@38@00))
  )))
(assert (forall ((s@$ $Snap) (a2@37@00 array) (i1@38@00 Int)) (!
  (implies
    (and (<= 0 i1@38@00) (< i1@38@00 (alen<Int> a2@37@00)))
    (= (aloc s@$ a2@37@00 i1@38@00) (array_loc<Ref> a2@37@00 i1@38@00)))
  :pattern ((aloc s@$ a2@37@00 i1@38@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@40@00 option<array>)) (!
  (= (opt_get1%limited s@$ opt1@40@00) (opt_get1 s@$ opt1@40@00))
  :pattern ((opt_get1 s@$ opt1@40@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@40@00 option<array>)) (!
  (opt_get1%stateless opt1@40@00)
  :pattern ((opt_get1%limited s@$ opt1@40@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@40@00 option<array>)) (!
  (let ((result@41@00 (opt_get1%limited s@$ opt1@40@00))) (implies
    (not (= opt1@40@00 (as None<option<array>>  option<array>)))
    (= (some<option<array>> result@41@00) opt1@40@00)))
  :pattern ((opt_get1%limited s@$ opt1@40@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@40@00 option<array>)) (!
  (implies
    (not (= opt1@40@00 (as None<option<array>>  option<array>)))
    (= (opt_get1 s@$ opt1@40@00) (option_get<array> opt1@40@00)))
  :pattern ((opt_get1 s@$ opt1@40@00))
  )))
(assert (forall ((s@$ $Snap) (this@42@00 $Ref) (p@43@00 Seq<Int>) (V@44@00 Int)) (!
  (=
    (valid_graph_vertices1%limited s@$ this@42@00 p@43@00 V@44@00)
    (valid_graph_vertices1 s@$ this@42@00 p@43@00 V@44@00))
  :pattern ((valid_graph_vertices1 s@$ this@42@00 p@43@00 V@44@00))
  )))
(assert (forall ((s@$ $Snap) (this@42@00 $Ref) (p@43@00 Seq<Int>) (V@44@00 Int)) (!
  (valid_graph_vertices1%stateless this@42@00 p@43@00 V@44@00)
  :pattern ((valid_graph_vertices1%limited s@$ this@42@00 p@43@00 V@44@00))
  )))
(assert (forall ((s@$ $Snap) (this@42@00 $Ref) (p@43@00 Seq<Int>) (V@44@00 Int)) (!
  (implies
    (not (= this@42@00 $Ref.null))
    (=
      (valid_graph_vertices1 s@$ this@42@00 p@43@00 V@44@00)
      (and
        (forall ((unknown1 Int)) (!
          (implies
            (and (<= 0 unknown1) (< unknown1 (Seq_length p@43@00)))
            (<= 0 (Seq_index p@43@00 unknown1)))
          :pattern ((Seq_index p@43@00 unknown1))
          ))
        (forall ((unknown1 Int)) (!
          (implies
            (and (<= 0 unknown1) (< unknown1 (Seq_length p@43@00)))
            (< (Seq_index p@43@00 unknown1) V@44@00))
          :pattern ((Seq_index p@43@00 unknown1))
          )))))
  :pattern ((valid_graph_vertices1 s@$ this@42@00 p@43@00 V@44@00))
  )))
(assert (forall ((s@$ $Snap) (this@46@00 $Ref) (G@47@00 Seq<Seq<Int>>) (Gf@48@00 Seq<Seq<Int>>) (V@49@00 Int) (s@50@00 Int) (t@51@00 Int)) (!
  (=
    (ValidFlow%limited s@$ this@46@00 G@47@00 Gf@48@00 V@49@00 s@50@00 t@51@00)
    (ValidFlow s@$ this@46@00 G@47@00 Gf@48@00 V@49@00 s@50@00 t@51@00))
  :pattern ((ValidFlow s@$ this@46@00 G@47@00 Gf@48@00 V@49@00 s@50@00 t@51@00))
  )))
(assert (forall ((s@$ $Snap) (this@46@00 $Ref) (G@47@00 Seq<Seq<Int>>) (Gf@48@00 Seq<Seq<Int>>) (V@49@00 Int) (s@50@00 Int) (t@51@00 Int)) (!
  (ValidFlow%stateless this@46@00 G@47@00 Gf@48@00 V@49@00 s@50@00 t@51@00)
  :pattern ((ValidFlow%limited s@$ this@46@00 G@47@00 Gf@48@00 V@49@00 s@50@00 t@51@00))
  )))
(assert (forall ((s@$ $Snap) (this@46@00 $Ref) (G@47@00 Seq<Seq<Int>>) (Gf@48@00 Seq<Seq<Int>>) (V@49@00 Int) (s@50@00 Int) (t@51@00 Int)) (!
  (implies
    (and
      (not (= this@46@00 $Ref.null))
      (SquareIntMatrix $Snap.unit this@46@00 Gf@48@00 V@49@00)
      (FlowNetwork $Snap.unit this@46@00 G@47@00 V@49@00 s@50@00 t@51@00)
      (FlowNetwork $Snap.unit this@46@00 Gf@48@00 V@49@00 s@50@00 t@51@00))
    (=
      (ValidFlow s@$ this@46@00 G@47@00 Gf@48@00 V@49@00 s@50@00 t@51@00)
      (and
        (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@46@00 G@47@00 V@49@00 s@50@00 t@51@00)
        (CapacityConstraint ($Snap.combine
          $Snap.unit
          ($Snap.combine $Snap.unit $Snap.unit)) this@46@00 G@47@00 Gf@48@00 V@49@00))))
  :pattern ((ValidFlow s@$ this@46@00 G@47@00 Gf@48@00 V@49@00 s@50@00 t@51@00))
  )))
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 option<array>) (V@55@00 Int)) (!
  (=
    (SquareIntMatrix1%limited s@$ this@53@00 G@54@00 V@55@00)
    (SquareIntMatrix1 s@$ this@53@00 G@54@00 V@55@00))
  :pattern ((SquareIntMatrix1 s@$ this@53@00 G@54@00 V@55@00))
  )))
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 option<array>) (V@55@00 Int)) (!
  (SquareIntMatrix1%stateless this@53@00 G@54@00 V@55@00)
  :pattern ((SquareIntMatrix1%limited s@$ this@53@00 G@54@00 V@55@00))
  )))
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 option<array>) (V@55@00 Int)) (!
  (and
    (forall ((i1@120@00 Int)) (!
      (implies
        (and (and (< i1@120@00 V@55@00) (<= 0 i1@120@00)) (< $Perm.No $k@121@00))
        (=
          (inv@122@00 s@$ this@53@00 G@54@00 V@55@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1@120@00))
          i1@120@00))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1@120@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (< (inv@122@00 s@$ this@53@00 G@54@00 V@55@00 r) V@55@00)
            (<= 0 (inv@122@00 s@$ this@53@00 G@54@00 V@55@00 r)))
          (< $Perm.No $k@121@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@54@00) (inv@122@00 s@$ this@53@00 G@54@00 V@55@00 r))
          r))
      :pattern ((inv@122@00 s@$ this@53@00 G@54@00 V@55@00 r))
      :qid |option$array$-fctOfInv|))
    (forall ((i1@128@00 Int) (j@129@00 Int)) (!
      (implies
        (and
          (and
            (and
              (and (< j@129@00 V@55@00) (<= 0 j@129@00))
              (< i1@128@00 V@55@00))
            (<= 0 i1@128@00))
          (< $Perm.No $k@130@00))
        (and
          (=
            (inv@131@00 s@$ this@53@00 G@54@00 V@55@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1@128@00))) j@129@00))
            i1@128@00)
          (=
            (inv@132@00 s@$ this@53@00 G@54@00 V@55@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1@128@00))) j@129@00))
            j@129@00)))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1@128@00))) j@129@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (and
              (and
                (< (inv@132@00 s@$ this@53@00 G@54@00 V@55@00 r) V@55@00)
                (<= 0 (inv@132@00 s@$ this@53@00 G@54@00 V@55@00 r)))
              (< (inv@131@00 s@$ this@53@00 G@54@00 V@55@00 r) V@55@00))
            (<= 0 (inv@131@00 s@$ this@53@00 G@54@00 V@55@00 r)))
          (< $Perm.No $k@130@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@54@00) (inv@131@00 s@$ this@53@00 G@54@00 V@55@00 r)))) (inv@132@00 s@$ this@53@00 G@54@00 V@55@00 r))
          r))
      :pattern ((inv@131@00 s@$ this@53@00 G@54@00 V@55@00 r))
      :pattern ((inv@132@00 s@$ this@53@00 G@54@00 V@55@00 r))
      :qid |int-fctOfInv|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (< (inv@122@00 s@$ this@53@00 G@54@00 V@55@00 r) V@55@00)
            (<= 0 (inv@122@00 s@$ this@53@00 G@54@00 V@55@00 r)))
          (< $Perm.No $k@121@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef0|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) r))
      :qid |qp.fvfResTrgDef1|))
    ($Perm.isReadVar $k@121@00 $Perm.Write)
    ($Perm.isReadVar $k@130@00 $Perm.Write)
    (implies
      (and
        (not (= this@53@00 $Ref.null))
        (not (= G@54@00 (as None<option<array>>  option<array>)))
        (= (alen<Int> (opt_get1 $Snap.unit G@54@00)) V@55@00)
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 V@55@00))
            (not
              (=
                ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1))
                (as None<option<array>>  option<array>))))
          :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1))
          ))
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 V@55@00))
            (=
              (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1))))
              V@55@00))
          :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1)))))
          ))
        (forall ((i1 Int)) (!
          (forall ((i2 Int)) (!
            (implies
              (and
                (and
                  (and (and (<= 0 i1) (< i1 V@55@00)) (<= 0 i2))
                  (< i2 V@55@00))
                (=
                  ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1))
                  ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit G@54@00) i2))))
              (= i1 i2))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@54@00) i2))
            ))
          :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1))
          )))
      (=
        (SquareIntMatrix1 s@$ this@53@00 G@54@00 V@55@00)
        (and
          (= (alen<Int> (opt_get1 $Snap.unit G@54@00)) V@55@00)
          (forall ((i1 Int)) (!
            (implies
              (and (<= 0 i1) (< i1 V@55@00))
              (=
                (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1))))
                V@55@00))
            :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@123@00 s@$ this@53@00 G@54@00 V@55@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit G@54@00) i1)))))
            ))))))
  :pattern ((SquareIntMatrix1 s@$ this@53@00 G@54@00 V@55@00))
  )))
(assert (forall ((s@$ $Snap) (t@57@00 any)) (!
  (= (any_as%limited s@$ t@57@00) (any_as s@$ t@57@00))
  :pattern ((any_as s@$ t@57@00))
  )))
(assert (forall ((s@$ $Snap) (t@57@00 any)) (!
  (any_as%stateless t@57@00)
  :pattern ((any_as%limited s@$ t@57@00))
  )))
(assert (forall ((s@$ $Snap) (a2@59@00 option<array>) (from@60@00 Int) (to@61@00 Int)) (!
  (Seq_equal
    (unknown%limited s@$ a2@59@00 from@60@00 to@61@00)
    (unknown_ s@$ a2@59@00 from@60@00 to@61@00))
  :pattern ((unknown_ s@$ a2@59@00 from@60@00 to@61@00))
  )))
(assert (forall ((s@$ $Snap) (a2@59@00 option<array>) (from@60@00 Int) (to@61@00 Int)) (!
  (unknown%stateless a2@59@00 from@60@00 to@61@00)
  :pattern ((unknown%limited s@$ a2@59@00 from@60@00 to@61@00))
  )))
(assert (forall ((s@$ $Snap) (a2@59@00 option<array>) (from@60@00 Int) (to@61@00 Int)) (!
  (let ((result@62@00 (unknown%limited s@$ a2@59@00 from@60@00 to@61@00))) (and
    (forall ((i1@135@00 Int)) (!
      (implies
        (and
          (and (< i1@135@00 to@61@00) (<= from@60@00 i1@135@00))
          (< $Perm.No $k@136@00))
        (=
          (inv@138@00 s@$ a2@59@00 from@60@00 to@61@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit a2@59@00) i1@135@00))
          i1@135@00))
      :pattern (($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$))))) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit a2@59@00) i1@135@00)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit a2@59@00) i1@135@00)))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (< (inv@138@00 s@$ a2@59@00 from@60@00 to@61@00 r) to@61@00)
            (<= from@60@00 (inv@138@00 s@$ a2@59@00 from@60@00 to@61@00 r)))
          (< $Perm.No $k@136@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit a2@59@00) (inv@138@00 s@$ a2@59@00 from@60@00 to@61@00 r))
          r))
      :pattern ((inv@138@00 s@$ a2@59@00 from@60@00 to@61@00 r))
      :qid |int-fctOfInv|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (< (inv@138@00 s@$ a2@59@00 from@60@00 to@61@00 r) to@61@00)
            (<= from@60@00 (inv@138@00 s@$ a2@59@00 from@60@00 to@61@00 r)))
          (< $Perm.No $k@136@00)
          false)
        (=
          ($FVF.lookup_int (sm@139@00 s@$ a2@59@00 from@60@00 to@61@00) r)
          ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_int (sm@139@00 s@$ a2@59@00 from@60@00 to@61@00) r))
      :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef5|))
    (forall ((r $Ref)) (!
      ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_int (sm@139@00 s@$ a2@59@00 from@60@00 to@61@00) r))
      :qid |qp.fvfResTrgDef6|))
    ($Perm.isReadVar $k@136@00 $Perm.Write)
    (implies
      (and
        (not (= a2@59@00 (as None<option<array>>  option<array>)))
        (<= 0 from@60@00)
        (<= from@60@00 to@61@00)
        (<= to@61@00 (alen<Int> (opt_get1 $Snap.unit a2@59@00))))
      (and
        (= (Seq_length result@62@00) (- to@61@00 from@60@00))
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 (- to@61@00 from@60@00)))
            (=
              (Seq_index result@62@00 i1)
              ($FVF.lookup_int (sm@139@00 s@$ a2@59@00 from@60@00 to@61@00) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit a2@59@00) (+ i1 from@60@00)))))
          :pattern ((Seq_index result@62@00 i1))
          ))
        (forall ((i1 Int)) (!
          (implies
            (and (<= from@60@00 i1) (< i1 to@61@00))
            (=
              ($FVF.lookup_int (sm@139@00 s@$ a2@59@00 from@60@00 to@61@00) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit a2@59@00) i1))
              (Seq_index result@62@00 (- i1 from@60@00))))
          :pattern (($FVF.lookup_int (sm@139@00 s@$ a2@59@00 from@60@00 to@61@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit a2@59@00) i1)))
          ))))))
  :pattern ((unknown%limited s@$ a2@59@00 from@60@00 to@61@00))
  )))
(assert (forall ((s@$ $Snap) (this@63@00 $Ref) (G@64@00 Seq<Seq<Int>>) (Gf@65@00 Seq<Seq<Int>>) (V@66@00 Int) (s@67@00 Int) (t@68@00 Int) (P@69@00 Seq<Int>)) (!
  (=
    (AugPath%limited s@$ this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00 P@69@00)
    (AugPath s@$ this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00 P@69@00))
  :pattern ((AugPath s@$ this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00 P@69@00))
  )))
(assert (forall ((s@$ $Snap) (this@63@00 $Ref) (G@64@00 Seq<Seq<Int>>) (Gf@65@00 Seq<Seq<Int>>) (V@66@00 Int) (s@67@00 Int) (t@68@00 Int) (P@69@00 Seq<Int>)) (!
  (AugPath%stateless this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00 P@69@00)
  :pattern ((AugPath%limited s@$ this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00 P@69@00))
  )))
(assert (forall ((s@$ $Snap) (this@63@00 $Ref) (G@64@00 Seq<Seq<Int>>) (Gf@65@00 Seq<Seq<Int>>) (V@66@00 Int) (s@67@00 Int) (t@68@00 Int) (P@69@00 Seq<Int>)) (!
  (implies
    (and
      (not (= this@63@00 $Ref.null))
      (SquareIntMatrix $Snap.unit this@63@00 G@64@00 V@66@00)
      (SquareIntMatrix $Snap.unit this@63@00 Gf@65@00 V@66@00)
      (FlowNetwork $Snap.unit this@63@00 G@64@00 V@66@00 s@67@00 t@68@00)
      (FlowNetwork $Snap.unit this@63@00 Gf@65@00 V@66@00 s@67@00 t@68@00)
      (ValidFlow ($Snap.combine
        $Snap.unit
        ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit))) this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00))
    (=
      (AugPath s@$ this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00 P@69@00)
      (and
        (and
          (implies
            (and
              (and
                (and (and (<= 0 s@67@00) (< s@67@00 V@66@00)) (<= 0 t@68@00))
                (< t@68@00 V@66@00))
              (< 1 (Seq_length P@69@00)))
            (not
              (=
                (Seq_index P@69@00 0)
                (Seq_index P@69@00 (- (Seq_length P@69@00) 1)))))
          (implies
            (and
              (and
                (and (and (<= 0 s@67@00) (< s@67@00 V@66@00)) (<= 0 t@68@00))
                (< t@68@00 V@66@00))
              (< 1 (Seq_length P@69@00)))
            (valid_graph_vertices1 $Snap.unit this@63@00 P@69@00 V@66@00)))
        (implies
          (and
            (and
              (and (and (<= 0 s@67@00) (< s@67@00 V@66@00)) (<= 0 t@68@00))
              (< t@68@00 V@66@00))
            (< 1 (Seq_length P@69@00)))
          (forall ((j Int)) (!
            (implies
              (and (<= 0 j) (< j (- (Seq_length P@69@00) 1)))
              (<
                0
                (Seq_index
                  (Seq_index Gf@65@00 (Seq_index P@69@00 j))
                  (Seq_index P@69@00 (+ j 1)))))
            :pattern ((Seq_index Gf@65@00 (Seq_index P@69@00 j)))
            ))))))
  :pattern ((AugPath s@$ this@63@00 G@64@00 Gf@65@00 V@66@00 s@67@00 t@68@00 P@69@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@71@00 option<any>)) (!
  (= (opt_get%limited s@$ opt1@71@00) (opt_get s@$ opt1@71@00))
  :pattern ((opt_get s@$ opt1@71@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@71@00 option<any>)) (!
  (opt_get%stateless opt1@71@00)
  :pattern ((opt_get%limited s@$ opt1@71@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@71@00 option<any>)) (!
  (let ((result@72@00 (opt_get%limited s@$ opt1@71@00))) (implies
    (not (= opt1@71@00 (as None<option<any>>  option<any>)))
    (= (some<option<any>> result@72@00) opt1@71@00)))
  :pattern ((opt_get%limited s@$ opt1@71@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@71@00 option<any>)) (!
  (implies
    (not (= opt1@71@00 (as None<option<any>>  option<any>)))
    (= (opt_get s@$ opt1@71@00) (option_get<any> opt1@71@00)))
  :pattern ((opt_get s@$ opt1@71@00))
  )))
(assert (forall ((s@$ $Snap) (t@77@00 any)) (!
  (= (as_any%limited s@$ t@77@00) (as_any s@$ t@77@00))
  :pattern ((as_any s@$ t@77@00))
  )))
(assert (forall ((s@$ $Snap) (t@77@00 any)) (!
  (as_any%stateless t@77@00)
  :pattern ((as_any%limited s@$ t@77@00))
  )))
(assert (forall ((s@$ $Snap) (t@77@00 any)) (!
  (let ((result@78@00 (as_any%limited s@$ t@77@00))) (=
    (any_as $Snap.unit result@78@00)
    t@77@00))
  :pattern ((as_any%limited s@$ t@77@00))
  )))
(assert (forall ((s@$ $Snap) (this@79@00 $Ref) (p@80@00 option<array>) (V@81@00 Int)) (!
  (=
    (valid_graph_vertices%limited s@$ this@79@00 p@80@00 V@81@00)
    (valid_graph_vertices s@$ this@79@00 p@80@00 V@81@00))
  :pattern ((valid_graph_vertices s@$ this@79@00 p@80@00 V@81@00))
  )))
(assert (forall ((s@$ $Snap) (this@79@00 $Ref) (p@80@00 option<array>) (V@81@00 Int)) (!
  (valid_graph_vertices%stateless this@79@00 p@80@00 V@81@00)
  :pattern ((valid_graph_vertices%limited s@$ this@79@00 p@80@00 V@81@00))
  )))
(assert (forall ((s@$ $Snap) (this@79@00 $Ref) (p@80@00 option<array>) (V@81@00 Int)) (!
  (and
    (forall ((i1@146@00 Int)) (!
      (implies
        (and (and (< i1@146@00 V@81@00) (<= 0 i1@146@00)) (< $Perm.No $k@147@00))
        (=
          (inv@148@00 s@$ this@79@00 p@80@00 V@81@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@80@00) i1@146@00))
          i1@146@00))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@80@00) i1@146@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (< (inv@148@00 s@$ this@79@00 p@80@00 V@81@00 r) V@81@00)
            (<= 0 (inv@148@00 s@$ this@79@00 p@80@00 V@81@00 r)))
          (< $Perm.No $k@147@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@80@00) (inv@148@00 s@$ this@79@00 p@80@00 V@81@00 r))
          r))
      :pattern ((inv@148@00 s@$ this@79@00 p@80@00 V@81@00 r))
      :qid |int-fctOfInv|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (< (inv@148@00 s@$ this@79@00 p@80@00 V@81@00 r) V@81@00)
            (<= 0 (inv@148@00 s@$ this@79@00 p@80@00 V@81@00 r)))
          (< $Perm.No $k@147@00)
          false)
        (=
          ($FVF.lookup_int (sm@149@00 s@$ this@79@00 p@80@00 V@81@00) r)
          ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r)))
      :pattern (($FVF.lookup_int (sm@149@00 s@$ this@79@00 p@80@00 V@81@00) r))
      :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r))
      :qid |qp.fvfValDef7|))
    (forall ((r $Ref)) (!
      ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r) r)
      :pattern (($FVF.lookup_int (sm@149@00 s@$ this@79@00 p@80@00 V@81@00) r))
      :qid |qp.fvfResTrgDef8|))
    ($Perm.isReadVar $k@147@00 $Perm.Write)
    (implies
      (and
        (not (= this@79@00 $Ref.null))
        (not (= p@80@00 (as None<option<array>>  option<array>)))
        (= (alen<Int> (opt_get1 $Snap.unit p@80@00)) V@81@00))
      (=
        (valid_graph_vertices s@$ this@79@00 p@80@00 V@81@00)
        (and
          (forall ((unknown1 Int)) (!
            (implies
              (and
                (<= 0 unknown1)
                (< unknown1 (alen<Int> (opt_get1 $Snap.unit p@80@00))))
              (<=
                0
                ($FVF.lookup_int (sm@149@00 s@$ this@79@00 p@80@00 V@81@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit p@80@00) unknown1))))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@80@00) unknown1))
            ))
          (forall ((unknown1 Int)) (!
            (implies
              (and
                (<= 0 unknown1)
                (< unknown1 (alen<Int> (opt_get1 $Snap.unit p@80@00))))
              (<
                ($FVF.lookup_int (sm@149@00 s@$ this@79@00 p@80@00 V@81@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit p@80@00) unknown1))
                V@81@00))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@80@00) unknown1))
            ))))))
  :pattern ((valid_graph_vertices s@$ this@79@00 p@80@00 V@81@00))
  )))
(assert (forall ((s@$ $Snap) (type1@83@00 $Ref)) (!
  (= (type%limited s@$ type1@83@00) (type s@$ type1@83@00))
  :pattern ((type s@$ type1@83@00))
  )))
(assert (forall ((s@$ $Snap) (type1@83@00 $Ref)) (!
  (type%stateless type1@83@00)
  :pattern ((type%limited s@$ type1@83@00))
  )))
(assert (forall ((s@$ $Snap) (type1@83@00 $Ref)) (!
  (let ((result@84@00 (type%limited s@$ type1@83@00))) (and
    (<= 0 result@84@00)
    (< result@84@00 3)
    (implies (= type1@83@00 $Ref.null) (= result@84@00 0))
    (implies (not (= type1@83@00 $Ref.null)) (not (= result@84@00 0)))))
  :pattern ((type%limited s@$ type1@83@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@85@00 Int) (subtype2@86@00 Int)) (!
  (=
    (subtype%limited s@$ subtype1@85@00 subtype2@86@00)
    (subtype s@$ subtype1@85@00 subtype2@86@00))
  :pattern ((subtype s@$ subtype1@85@00 subtype2@86@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@85@00 Int) (subtype2@86@00 Int)) (!
  (subtype%stateless subtype1@85@00 subtype2@86@00)
  :pattern ((subtype%limited s@$ subtype1@85@00 subtype2@86@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@85@00 Int) (subtype2@86@00 Int)) (!
  (implies
    (and
      (<= 0 subtype1@85@00)
      (< subtype1@85@00 3)
      (<= 0 subtype2@86@00)
      (<= subtype2@86@00 2))
    (=
      (subtype s@$ subtype1@85@00 subtype2@86@00)
      (and
        (implies (= subtype1@85@00 2) (= subtype2@86@00 2))
        (implies (= subtype1@85@00 1) (= subtype2@86@00 1)))))
  :pattern ((subtype s@$ subtype1@85@00 subtype2@86@00))
  )))
(assert (forall ((s@$ $Snap) (this@88@00 $Ref) (a2@89@00 option<array>) (V@90@00 Int)) (!
  (Seq_equal
    (matrixValues%limited s@$ this@88@00 a2@89@00 V@90@00)
    (matrixValues s@$ this@88@00 a2@89@00 V@90@00))
  :pattern ((matrixValues s@$ this@88@00 a2@89@00 V@90@00))
  )))
(assert (forall ((s@$ $Snap) (this@88@00 $Ref) (a2@89@00 option<array>) (V@90@00 Int)) (!
  (matrixValues%stateless this@88@00 a2@89@00 V@90@00)
  :pattern ((matrixValues%limited s@$ this@88@00 a2@89@00 V@90@00))
  )))
(assert (forall ((s@$ $Snap) (this@88@00 $Ref) (a2@89@00 option<array>) (V@90@00 Int)) (!
  (let ((result@91@00 (matrixValues%limited s@$ this@88@00 a2@89@00 V@90@00))) (and
    (forall ((i1@153@00 Int)) (!
      (implies
        (and (and (< i1@153@00 V@90@00) (<= 0 i1@153@00)) (< $Perm.No $k@154@00))
        (=
          (inv@155@00 s@$ this@88@00 a2@89@00 V@90@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1@153@00))
          i1@153@00))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1@153@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (< (inv@155@00 s@$ this@88@00 a2@89@00 V@90@00 r) V@90@00)
            (<= 0 (inv@155@00 s@$ this@88@00 a2@89@00 V@90@00 r)))
          (< $Perm.No $k@154@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit a2@89@00) (inv@155@00 s@$ this@88@00 a2@89@00 V@90@00 r))
          r))
      :pattern ((inv@155@00 s@$ this@88@00 a2@89@00 V@90@00 r))
      :qid |option$array$-fctOfInv|))
    (forall ((i1@161@00 Int) (j@162@00 Int)) (!
      (implies
        (and
          (and
            (and
              (and (< j@162@00 V@90@00) (<= 0 j@162@00))
              (< i1@161@00 V@90@00))
            (<= 0 i1@161@00))
          (< $Perm.No $k@163@00))
        (and
          (=
            (inv@164@00 s@$ this@88@00 a2@89@00 V@90@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1@161@00))) j@162@00))
            i1@161@00)
          (=
            (inv@165@00 s@$ this@88@00 a2@89@00 V@90@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1@161@00))) j@162@00))
            j@162@00)))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1@161@00))) j@162@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (and
              (and
                (< (inv@165@00 s@$ this@88@00 a2@89@00 V@90@00 r) V@90@00)
                (<= 0 (inv@165@00 s@$ this@88@00 a2@89@00 V@90@00 r)))
              (< (inv@164@00 s@$ this@88@00 a2@89@00 V@90@00 r) V@90@00))
            (<= 0 (inv@164@00 s@$ this@88@00 a2@89@00 V@90@00 r)))
          (< $Perm.No $k@163@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit a2@89@00) (inv@164@00 s@$ this@88@00 a2@89@00 V@90@00 r)))) (inv@165@00 s@$ this@88@00 a2@89@00 V@90@00 r))
          r))
      :pattern ((inv@164@00 s@$ this@88@00 a2@89@00 V@90@00 r))
      :pattern ((inv@165@00 s@$ this@88@00 a2@89@00 V@90@00 r))
      :qid |int-fctOfInv|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (< (inv@155@00 s@$ this@88@00 a2@89@00 V@90@00 r) V@90@00)
            (<= 0 (inv@155@00 s@$ this@88@00 a2@89@00 V@90@00 r)))
          (< $Perm.No $k@154@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef9|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) r))
      :qid |qp.fvfResTrgDef10|))
    (forall ((r $Ref)) (!
      ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))) r) r)
      :pattern (($FVF.lookup_int (sm@173@00 s@$ this@88@00 a2@89@00 V@90@00) r))
      :qid |qp.fvfResTrgDef15|))
    ($Perm.isReadVar $k@154@00 $Perm.Write)
    ($Perm.isReadVar $k@163@00 $Perm.Write)
    ($Perm.isReadVar $k@170@00 $Perm.Write)
    (implies
      (and
        (not (= this@88@00 $Ref.null))
        (not (= a2@89@00 (as None<option<array>>  option<array>)))
        (= (alen<Int> (opt_get1 $Snap.unit a2@89@00)) V@90@00)
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 V@90@00))
            (not
              (=
                ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1))
                (as None<option<array>>  option<array>))))
          :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1))
          ))
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 V@90@00))
            (=
              (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1))))
              V@90@00))
          :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1)))))
          ))
        (forall ((i1 Int)) (!
          (forall ((i2 Int)) (!
            (implies
              (and
                (and
                  (and (and (<= 0 i1) (< i1 V@90@00)) (<= 0 i2))
                  (< i2 V@90@00))
                (=
                  ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1))
                  ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i2))))
              (= i1 i2))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i2))
            ))
          :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1))
          )))
      (and
        (SquareIntMatrix $Snap.unit this@88@00 result@91@00 V@90@00)
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 V@90@00))
            (Seq_equal
              (Seq_index result@91@00 i1)
              (unknown_ ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  $Snap.unit
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      $Snap.unit
                      ($SortWrappers.$FVF<Int>To$Snap (sm@173@00 s@$ this@88@00 a2@89@00 V@90@00)))))) ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1)) 0 (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1)))))))
          :pattern ((Seq_index result@91@00 i1))
          :pattern ((unknown%limited ($Snap.combine
            $Snap.unit
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  $Snap.unit
                  ($SortWrappers.$FVF<Int>To$Snap (sm@173@00 s@$ this@88@00 a2@89@00 V@90@00)))))) ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1)) 0 (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@156@00 s@$ this@88@00 a2@89@00 V@90@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit a2@89@00) i1))))))
          ))))))
  :pattern ((matrixValues%limited s@$ this@88@00 a2@89@00 V@90@00))
  )))
(assert (forall ((s@$ $Snap) (this@92@00 $Ref) (G@93@00 Seq<Seq<Int>>) (Gf@94@00 Seq<Seq<Int>>) (V@95@00 Int) (s@96@00 Int) (t@97@00 Int)) (!
  (=
    (ExAugPath%limited s@$ this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00)
    (ExAugPath s@$ this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00))
  :pattern ((ExAugPath s@$ this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00))
  )))
(assert (forall ((s@$ $Snap) (this@92@00 $Ref) (G@93@00 Seq<Seq<Int>>) (Gf@94@00 Seq<Seq<Int>>) (V@95@00 Int) (s@96@00 Int) (t@97@00 Int)) (!
  (ExAugPath%stateless this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00)
  :pattern ((ExAugPath%limited s@$ this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00))
  )))
(assert (forall ((s@$ $Snap) (this@92@00 $Ref) (G@93@00 Seq<Seq<Int>>) (Gf@94@00 Seq<Seq<Int>>) (V@95@00 Int) (s@96@00 Int) (t@97@00 Int)) (!
  (implies
    (and
      (not (= this@92@00 $Ref.null))
      (SquareIntMatrix $Snap.unit this@92@00 G@93@00 V@95@00)
      (SquareIntMatrix $Snap.unit this@92@00 Gf@94@00 V@95@00)
      (FlowNetwork $Snap.unit this@92@00 G@93@00 V@95@00 s@96@00 t@97@00)
      (FlowNetwork $Snap.unit this@92@00 Gf@94@00 V@95@00 s@96@00 t@97@00)
      (ValidFlow ($Snap.combine
        $Snap.unit
        ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit))) this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00))
    (=
      (ExAugPath s@$ this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00)
      (exists ((P Seq<Int>)) (!
        (and
          (AugPath ($Snap.combine
            $Snap.unit
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit))))) this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00 P)
          (<= (Seq_length P) V@95@00))
        :pattern ((AugPath%limited ($Snap.combine
          $Snap.unit
          ($Snap.combine
            $Snap.unit
            ($Snap.combine
              $Snap.unit
              ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit))))) this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00 P))
        :pattern ((Seq_length P))
        ))))
  :pattern ((ExAugPath s@$ this@92@00 G@93@00 Gf@94@00 V@95@00 s@96@00 t@97@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@99@00 option<any>) (alt@100@00 any)) (!
  (=
    (opt_or_else%limited s@$ opt1@99@00 alt@100@00)
    (opt_or_else s@$ opt1@99@00 alt@100@00))
  :pattern ((opt_or_else s@$ opt1@99@00 alt@100@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@99@00 option<any>) (alt@100@00 any)) (!
  (opt_or_else%stateless opt1@99@00 alt@100@00)
  :pattern ((opt_or_else%limited s@$ opt1@99@00 alt@100@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@99@00 option<any>) (alt@100@00 any)) (!
  (let ((result@101@00 (opt_or_else%limited s@$ opt1@99@00 alt@100@00))) (and
    (implies
      (= opt1@99@00 (as None<option<any>>  option<any>))
      (= result@101@00 alt@100@00))
    (implies
      (not (= opt1@99@00 (as None<option<any>>  option<any>)))
      (= result@101@00 (opt_get $Snap.unit opt1@99@00)))))
  :pattern ((opt_or_else%limited s@$ opt1@99@00 alt@100@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@99@00 option<any>) (alt@100@00 any)) (!
  (=
    (opt_or_else s@$ opt1@99@00 alt@100@00)
    (ite
      (= opt1@99@00 (as None<option<any>>  option<any>))
      alt@100@00
      (opt_get $Snap.unit opt1@99@00)))
  :pattern ((opt_or_else s@$ opt1@99@00 alt@100@00))
  )))
(assert (forall ((s@$ $Snap) (this@102@00 $Ref) (G@103@00 option<array>) (V@104@00 Int) (s@105@00 Int) (t@106@00 Int)) (!
  (=
    (FlowNetwork1%limited s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00)
    (FlowNetwork1 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))
  :pattern ((FlowNetwork1 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))
  )))
(assert (forall ((s@$ $Snap) (this@102@00 $Ref) (G@103@00 option<array>) (V@104@00 Int) (s@105@00 Int) (t@106@00 Int)) (!
  (FlowNetwork1%stateless this@102@00 G@103@00 V@104@00 s@105@00 t@106@00)
  :pattern ((FlowNetwork1%limited s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))
  )))
(assert (forall ((s@$ $Snap) (this@102@00 $Ref) (G@103@00 option<array>) (V@104@00 Int) (s@105@00 Int) (t@106@00 Int)) (!
  (and
    (forall ((i1@176@00 Int)) (!
      (implies
        (and
          (and (< i1@176@00 V@104@00) (<= 0 i1@176@00))
          (< $Perm.No $k@177@00))
        (=
          (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@176@00))
          i1@176@00))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@176@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (<
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@177@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@103@00) (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
          r))
      :pattern ((inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
      :qid |option$array$-fctOfInv|))
    (forall ((i1@184@00 Int) (j@185@00 Int)) (!
      (implies
        (and
          (and
            (and
              (and (< j@185@00 V@104@00) (<= 0 j@185@00))
              (< i1@184@00 V@104@00))
            (<= 0 i1@184@00))
          (< $Perm.No $k@186@00))
        (and
          (=
            (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@184@00))) j@185@00))
            i1@184@00)
          (=
            (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@184@00))) j@185@00))
            j@185@00)))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@184@00))) j@185@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (and
              (and
                (<
                  (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                  V@104@00)
                (<=
                  0
                  (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
              (<
                (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                V@104@00))
            (<=
              0
              (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@186@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@103@00) (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))) (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
          r))
      :pattern ((inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
      :pattern ((inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
      :qid |int-fctOfInv|))
    (forall ((i1@190@00 Int)) (!
      (implies
        (and
          (and (< i1@190@00 V@104@00) (<= 0 i1@190@00))
          (< $Perm.No $k@191@00))
        (=
          (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@190@00))
          i1@190@00))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@190@00))
      :qid |option$array$-invOfFct|))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (<
              (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@191@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@103@00) (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
          r))
      :pattern ((inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
      :qid |option$array$-fctOfInv|))
    (forall ((i1@207@00 Int) (j@208@00 Int)) (!
      (implies
        (and
          (and
            (and
              (and (< j@208@00 V@104@00) (<= 0 j@208@00))
              (< i1@207@00 V@104@00))
            (<= 0 i1@207@00))
          (< $Perm.No $k@209@00))
        (and
          (=
            (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@210@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@207@00))) j@208@00))
            i1@207@00)
          (=
            (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@210@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@207@00))) j@208@00))
            j@208@00)))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@210@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1@207@00))) j@208@00))
      :qid |int-invOfFct|))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (and
              (and
                (<
                  (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                  V@104@00)
                (<=
                  0
                  (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
              (<
                (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                V@104@00))
            (<=
              0
              (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@209@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@210@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@103@00) (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))) (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
          r))
      :pattern ((inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
      :pattern ((inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r))
      :qid |int-fctOfInv|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (<
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@177@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef17|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef18|))
    (forall ((r $Ref)) (!
      (iff
        (Set_in r ($FVF.domain_option$array$ (sm@194@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00)))
        (and
          (and
            (<
              (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@191@00)))
      :pattern ((Set_in r ($FVF.domain_option$array$ (sm@194@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))))
      :qid |qp.fvfDomDef24|))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (and
              (<
                (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                V@104@00)
              (<=
                0
                (inv@192@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
            (< $Perm.No $k@191@00))
          (ite
            (and
              (<
                (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                V@104@00)
              (<=
                0
                (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
            (< $Perm.No $k@177@00)
            false))
        (=
          ($FVF.lookup_option$array$ (sm@194@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@194@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef22|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@194@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef23|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (<
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@177@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@196@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@196@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef25|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@196@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef26|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (<
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@177@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@199@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@199@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef29|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@199@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef30|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (<
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@177@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@203@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@203@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef33|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@203@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef34|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (<
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@177@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@205@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@205@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef37|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@205@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef38|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (<
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
              V@104@00)
            (<=
              0
              (inv@178@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@177@00)
          false)
        (=
          ($FVF.lookup_option$array$ (sm@210@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r)))
      :pattern (($FVF.lookup_option$array$ (sm@210@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r))
      :qid |qp.fvfValDef41|))
    (forall ((r $Ref)) (!
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))) r) r)
      :pattern (($FVF.lookup_option$array$ (sm@210@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef42|))
    (forall ((r $Ref)) (!
      (iff
        (Set_in r ($FVF.domain_int (sm@215@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00)))
        (and
          (and
            (and
              (and
                (<
                  (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                  V@104@00)
                (<=
                  0
                  (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
              (<
                (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                V@104@00))
            (<=
              0
              (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
          (< $Perm.No $k@209@00)))
      :pattern ((Set_in r ($FVF.domain_int (sm@215@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))))
      :qid |qp.fvfDomDef48|))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (and
              (and
                (and
                  (<
                    (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                    V@104@00)
                  (<=
                    0
                    (inv@213@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
                (<
                  (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                  V@104@00))
              (<=
                0
                (inv@212@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
            (< $Perm.No $k@209@00))
          (ite
            (and
              (and
                (and
                  (<
                    (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                    V@104@00)
                  (<=
                    0
                    (inv@188@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
                (<
                  (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)
                  V@104@00))
              (<=
                0
                (inv@187@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00 r)))
            (< $Perm.No $k@186@00)
            false))
        (=
          ($FVF.lookup_int (sm@215@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r)
          ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))) r)))
      :pattern (($FVF.lookup_int (sm@215@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))) r))
      :qid |qp.fvfValDef46|))
    (forall ((r $Ref)) (!
      ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))) r) r)
      :pattern (($FVF.lookup_int (sm@215@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) r))
      :qid |qp.fvfResTrgDef47|))
    ($Perm.isReadVar $k@177@00 $Perm.Write)
    ($Perm.isReadVar $k@186@00 $Perm.Write)
    ($Perm.isReadVar $k@191@00 $Perm.Write)
    ($Perm.isReadVar $k@209@00 $Perm.Write)
    (implies
      (and
        (not (= this@102@00 $Ref.null))
        (not (= G@103@00 (as None<option<array>>  option<array>)))
        (= (alen<Int> (opt_get1 $Snap.unit G@103@00)) V@104@00)
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 V@104@00))
            (not
              (=
                ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1))
                (as None<option<array>>  option<array>))))
          :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1))
          ))
        (forall ((i1 Int)) (!
          (implies
            (and (<= 0 i1) (< i1 V@104@00))
            (=
              (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1))))
              V@104@00))
          :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1)))))
          ))
        (forall ((i1 Int)) (!
          (forall ((i2 Int)) (!
            (implies
              (and
                (and
                  (and (and (<= 0 i1) (< i1 V@104@00)) (<= 0 i2))
                  (< i2 V@104@00))
                (=
                  ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1))
                  ($FVF.lookup_option$array$ (sm@179@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit G@103@00) i2))))
              (= i1 i2))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@103@00) i2))
            ))
          :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit G@103@00) i1))
          )))
      (=
        (FlowNetwork1 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00)
        (and
          (and
            (and
              (and (and (<= 0 s@105@00) (< s@105@00 V@104@00)) (<= 0 t@106@00))
              (< t@106@00 V@104@00))
            (SquareIntMatrix1 ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  $Snap.unit
                  ($Snap.combine
                    ($SortWrappers.$FVF<option<array>>To$Snap (sm@194@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))
                    ($Snap.combine
                      $Snap.unit
                      ($Snap.combine
                        $Snap.unit
                        ($Snap.combine
                          $Snap.unit
                          ($SortWrappers.$FVF<Int>To$Snap (sm@215@00 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))))))))) this@102@00 G@103@00 V@104@00))
          (NonNegativeCapacities1 ($Snap.combine $Snap.unit $Snap.unit) this@102@00 G@103@00 V@104@00)))))
  :pattern ((FlowNetwork1 s@$ this@102@00 G@103@00 V@104@00 s@105@00 t@106@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- Object ----------
(declare-const tid@0@01 Int)
(declare-const exc@1@01 $Ref)
(declare-const res@2@01 $Ref)
(declare-const tid@3@01 Int)
(declare-const exc@4@01 $Ref)
(declare-const res@5@01 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@6@01 $Snap)
(assert (= $t@6@01 ($Snap.combine ($Snap.first $t@6@01) ($Snap.second $t@6@01))))
(assert (= ($Snap.first $t@6@01) $Snap.unit))
; [eval] exc == null
(assert (= exc@4@01 $Ref.null))
(assert (=
  ($Snap.second $t@6@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@6@01))
    ($Snap.second ($Snap.second $t@6@01)))))
(assert (= ($Snap.first ($Snap.second $t@6@01)) $Snap.unit))
; [eval] exc == null ==> res != null
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@4@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            3
;  :max-generation          1
;  :max-memory              4.25
;  :memory                  4.19
;  :mk-bool-var             355
;  :num-allocs              147464
;  :num-checks              2
;  :quant-instantiations    2
;  :rlimit-count            175855)
; [then-branch: 0 | exc@4@01 == Null | live]
; [else-branch: 0 | exc@4@01 != Null | dead]
(push) ; 4
; [then-branch: 0 | exc@4@01 == Null]
; [eval] res != null
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@4@01 $Ref.null) (not (= res@5@01 $Ref.null))))
(assert (= ($Snap.second ($Snap.second $t@6@01)) $Snap.unit))
; [eval] exc == null ==> type(res) == 2
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@4@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   3
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.25
;  :memory                  4.20
;  :mk-bool-var             357
;  :num-allocs              147869
;  :num-checks              3
;  :quant-instantiations    2
;  :rlimit-count            176353)
; [then-branch: 1 | exc@4@01 == Null | live]
; [else-branch: 1 | exc@4@01 != Null | dead]
(push) ; 4
; [then-branch: 1 | exc@4@01 == Null]
; [eval] type(res) == 2
; [eval] type(res)
(push) ; 5
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@4@01 $Ref.null) (= (type $Snap.unit res@5@01) 2)))
(pop) ; 2
(push) ; 2
; [exec]
; var return: Ref
(declare-const return@7@01 $Ref)
; [exec]
; var this: Ref
(declare-const this@8@01 $Ref)
; [exec]
; exc := null
; [exec]
; this := new()
(declare-const this@9@01 $Ref)
(assert (not (= this@9@01 $Ref.null)))
(assert (not (= this@9@01 return@7@01)))
(assert (not (= this@9@01 res@5@01)))
(assert (not (= this@9@01 this@8@01)))
; [exec]
; inhale type(this) == 2
(declare-const $t@10@01 $Snap)
(assert (= $t@10@01 $Snap.unit))
; [eval] type(this) == 2
; [eval] type(this)
(push) ; 3
(pop) ; 3
; Joined path conditions
(assert (= (type $Snap.unit this@9@01) 2))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; fold acc(lock_inv_Object(this), write)
(assert (lock_inv_Object%trigger $Snap.unit this@9@01))
; [exec]
; exhale acc(lock_inv_Object(this), write) && this != null
; [eval] this != null
; [exec]
; return := this
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null ==> res != null
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not false))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22
;  :arith-assert-diseq      1
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        4
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   5
;  :datatype-splits         1
;  :decisions               1
;  :del-clause              12
;  :final-checks            6
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.21
;  :mk-bool-var             376
;  :mk-clause               12
;  :num-allocs              148957
;  :num-checks              5
;  :propagations            5
;  :quant-instantiations    5
;  :rlimit-count            177562)
; [then-branch: 2 | True | live]
; [else-branch: 2 | False | dead]
(push) ; 4
; [then-branch: 2 | True]
; [eval] res != null
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null ==> type(res) == 2
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
; (:added-eqs               22
;  :arith-assert-diseq      1
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        4
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   6
;  :datatype-splits         1
;  :decisions               1
;  :del-clause              12
;  :final-checks            7
;  :max-generation          2
;  :max-memory              4.25
;  :memory                  4.21
;  :mk-bool-var             376
;  :mk-clause               12
;  :num-allocs              149338
;  :num-checks              6
;  :propagations            5
;  :quant-instantiations    5
;  :rlimit-count            177947)
; [then-branch: 3 | True | live]
; [else-branch: 3 | False | dead]
(push) ; 4
; [then-branch: 3 | True]
; [eval] type(res) == 2
; [eval] type(res)
(push) ; 5
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(pop) ; 2
(pop) ; 1
