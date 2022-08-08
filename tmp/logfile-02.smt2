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
; ---------- initializeVisited ----------
(declare-const this@0@02 $Ref)
(declare-const tid@1@02 Int)
(declare-const visited@2@02 option<array>)
(declare-const s@3@02 Int)
(declare-const V@4@02 Int)
(declare-const exc@5@02 $Ref)
(declare-const res@6@02 void)
(declare-const this@7@02 $Ref)
(declare-const tid@8@02 Int)
(declare-const visited@9@02 option<array>)
(declare-const s@10@02 Int)
(declare-const V@11@02 Int)
(declare-const exc@12@02 $Ref)
(declare-const res@13@02 void)
(push) ; 1
(declare-const $t@14@02 $Snap)
(assert (= $t@14@02 ($Snap.combine ($Snap.first $t@14@02) ($Snap.second $t@14@02))))
(assert (= ($Snap.first $t@14@02) $Snap.unit))
; [eval] this != null
(assert (not (= this@7@02 $Ref.null)))
(assert (=
  ($Snap.second $t@14@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@14@02))
    ($Snap.second ($Snap.second $t@14@02)))))
(assert (= ($Snap.first ($Snap.second $t@14@02)) $Snap.unit))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= visited@9@02 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second $t@14@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@14@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@14@02))) $Snap.unit))
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (opt_get1 $Snap.unit visited@9@02)) V@11@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@14@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
  $Snap.unit))
; [eval] 0 <= s
(assert (<= 0 s@10@02))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))
  $Snap.unit))
; [eval] s < V
(assert (< s@10@02 V@11@02))
(declare-const k@15@02 Int)
(push) ; 2
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 3
; [then-branch: 0 | 0 <= k@15@02 | live]
; [else-branch: 0 | !(0 <= k@15@02) | live]
(push) ; 4
; [then-branch: 0 | 0 <= k@15@02]
(assert (<= 0 k@15@02))
; [eval] k < V
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= k@15@02)]
(assert (not (<= 0 k@15@02)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< k@15@02 V@11@02) (<= 0 k@15@02)))
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
(assert (not (< k@15@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            37
;  :arith-add-rows       2
;  :arith-assert-lower   7
;  :arith-assert-upper   4
;  :arith-eq-adapter     3
;  :arith-fixed-eqs      1
;  :arith-pivots         2
;  :datatype-accessor-ax 6
;  :max-generation       2
;  :max-memory           4.25
;  :memory               4.20
;  :mk-bool-var          373
;  :num-allocs           147379
;  :num-checks           1
;  :quant-instantiations 7
;  :rlimit-count         176051)
(assert (< k@15@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 3
; Joined path conditions
(assert (< k@15@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 2
(declare-fun inv@16@02 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@15@02 Int)) (!
  (< k@15@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@15@02))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((k1@15@02 Int) (k2@15@02 Int)) (!
  (implies
    (and
      (and (< k1@15@02 V@11@02) (<= 0 k1@15@02))
      (and (< k2@15@02 V@11@02) (<= 0 k2@15@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k1@15@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k2@15@02)))
    (= k1@15@02 k2@15@02))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            58
;  :arith-add-rows       27
;  :arith-assert-diseq   1
;  :arith-assert-lower   11
;  :arith-assert-upper   8
;  :arith-bound-prop     3
;  :arith-eq-adapter     4
;  :arith-fixed-eqs      1
;  :arith-offset-eqs     2
;  :arith-pivots         9
;  :conflicts            2
;  :datatype-accessor-ax 7
;  :decisions            1
;  :del-clause           17
;  :max-generation       2
;  :max-memory           4.25
;  :memory               4.23
;  :mk-bool-var          396
;  :mk-clause            17
;  :num-allocs           148069
;  :num-checks           2
;  :propagations         16
;  :quant-instantiations 17
;  :rlimit-count         177404)
; Definitional axioms for inverse functions
(assert (forall ((k@15@02 Int)) (!
  (implies
    (and (< k@15@02 V@11@02) (<= 0 k@15@02))
    (=
      (inv@16@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@15@02))
      k@15@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@15@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@16@02 r) V@11@02) (<= 0 (inv@16@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) (inv@16@02 r))
      r))
  :pattern ((inv@16@02 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@15@02 Int)) (!
  (implies
    (and (< k@15@02 V@11@02) (<= 0 k@15@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@15@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@15@02))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@17@02 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@16@02 r) V@11@02) (<= 0 (inv@16@02 r)))
    (=
      ($FVF.lookup_bool (as sm@17@02  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))) r)))
  :pattern (($FVF.lookup_bool (as sm@17@02  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@02)))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@17@02  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@16@02 r) V@11@02) (<= 0 (inv@16@02 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@17@02  $FVF<Bool>) r) r))
  :pattern ((inv@16@02 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@18@02 $Snap)
(assert (= $t@18@02 ($Snap.combine ($Snap.first $t@18@02) ($Snap.second $t@18@02))))
(assert (= ($Snap.first $t@18@02) $Snap.unit))
; [eval] exc == null
(assert (= exc@12@02 $Ref.null))
(assert (=
  ($Snap.second $t@18@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@18@02))
    ($Snap.second ($Snap.second $t@18@02)))))
(assert (= ($Snap.first ($Snap.second $t@18@02)) $Snap.unit))
; [eval] exc == null ==> visited != (None(): option[array])
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               81
;  :arith-add-rows          27
;  :arith-assert-diseq      1
;  :arith-assert-lower      11
;  :arith-assert-upper      8
;  :arith-bound-prop        3
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            9
;  :conflicts               2
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         2
;  :decisions               4
;  :del-clause              17
;  :final-checks            4
;  :max-generation          2
;  :max-memory              4.27
;  :memory                  4.26
;  :mk-bool-var             409
;  :mk-clause               17
;  :num-allocs              150065
;  :num-checks              4
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            180165)
; [then-branch: 1 | exc@12@02 == Null | live]
; [else-branch: 1 | exc@12@02 != Null | dead]
(push) ; 4
; [then-branch: 1 | exc@12@02 == Null]
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@12@02 $Ref.null)
  (not (= visited@9@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@18@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@18@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@18@02))) $Snap.unit))
; [eval] exc == null ==> alen(opt_get1(visited)) == V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               95
;  :arith-add-rows          27
;  :arith-assert-diseq      1
;  :arith-assert-lower      11
;  :arith-assert-upper      8
;  :arith-bound-prop        3
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            9
;  :conflicts               2
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   9
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              17
;  :final-checks            6
;  :max-generation          2
;  :max-memory              4.28
;  :memory                  4.27
;  :mk-bool-var             412
;  :mk-clause               17
;  :num-allocs              150629
;  :num-checks              5
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            180771)
; [then-branch: 2 | exc@12@02 == Null | live]
; [else-branch: 2 | exc@12@02 != Null | dead]
(push) ; 4
; [then-branch: 2 | exc@12@02 == Null]
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
  (= exc@12@02 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@9@02)) V@11@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@18@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@18@02))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= s
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               110
;  :arith-add-rows          27
;  :arith-assert-diseq      1
;  :arith-assert-lower      11
;  :arith-assert-upper      8
;  :arith-bound-prop        3
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            9
;  :conflicts               2
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   12
;  :datatype-splits         4
;  :decisions               8
;  :del-clause              17
;  :final-checks            8
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.28
;  :mk-bool-var             415
;  :mk-clause               17
;  :num-allocs              151190
;  :num-checks              6
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            181395)
; [then-branch: 3 | exc@12@02 == Null | live]
; [else-branch: 3 | exc@12@02 != Null | dead]
(push) ; 4
; [then-branch: 3 | exc@12@02 == Null]
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@12@02 $Ref.null) (<= 0 s@10@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
  $Snap.unit))
; [eval] exc == null ==> s < V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               126
;  :arith-add-rows          27
;  :arith-assert-diseq      1
;  :arith-assert-lower      11
;  :arith-assert-upper      8
;  :arith-bound-prop        3
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            9
;  :conflicts               2
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         5
;  :decisions               10
;  :del-clause              17
;  :final-checks            10
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.28
;  :mk-bool-var             418
;  :mk-clause               17
;  :num-allocs              151759
;  :num-checks              7
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            182034)
; [then-branch: 4 | exc@12@02 == Null | live]
; [else-branch: 4 | exc@12@02 != Null | dead]
(push) ; 4
; [then-branch: 4 | exc@12@02 == Null]
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@12@02 $Ref.null) (< s@10@02 V@11@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-add-rows          27
;  :arith-assert-diseq      1
;  :arith-assert-lower      11
;  :arith-assert-upper      8
;  :arith-bound-prop        3
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            9
;  :conflicts               2
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               13
;  :del-clause              17
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.28
;  :mk-bool-var             421
;  :mk-clause               17
;  :num-allocs              152332
;  :num-checks              8
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            182673)
; [then-branch: 5 | exc@12@02 == Null | live]
; [else-branch: 5 | exc@12@02 != Null | dead]
(push) ; 3
; [then-branch: 5 | exc@12@02 == Null]
(declare-const k@19@02 Int)
(push) ; 4
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 5
; [then-branch: 6 | 0 <= k@19@02 | live]
; [else-branch: 6 | !(0 <= k@19@02) | live]
(push) ; 6
; [then-branch: 6 | 0 <= k@19@02]
(assert (<= 0 k@19@02))
; [eval] k < V
(pop) ; 6
(push) ; 6
; [else-branch: 6 | !(0 <= k@19@02)]
(assert (not (<= 0 k@19@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< k@19@02 V@11@02) (<= 0 k@19@02)))
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
(assert (not (< k@19@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-add-rows          27
;  :arith-assert-diseq      1
;  :arith-assert-lower      12
;  :arith-assert-upper      9
;  :arith-bound-prop        3
;  :arith-eq-adapter        4
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            9
;  :conflicts               2
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               13
;  :del-clause              17
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.28
;  :mk-bool-var             423
;  :mk-clause               17
;  :num-allocs              152456
;  :num-checks              9
;  :propagations            16
;  :quant-instantiations    17
;  :rlimit-count            182850)
(assert (< k@19@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 5
; Joined path conditions
(assert (< k@19@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 4
(declare-fun inv@20@02 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@19@02 Int)) (!
  (< k@19@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@19@02))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((k1@19@02 Int) (k2@19@02 Int)) (!
  (implies
    (and
      (and (< k1@19@02 V@11@02) (<= 0 k1@19@02))
      (and (< k2@19@02 V@11@02) (<= 0 k2@19@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k1@19@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k2@19@02)))
    (= k1@19@02 k2@19@02))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               149
;  :arith-add-rows          31
;  :arith-assert-diseq      2
;  :arith-assert-lower      14
;  :arith-assert-upper      11
;  :arith-bound-prop        3
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            11
;  :conflicts               3
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               13
;  :del-clause              23
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             441
;  :mk-clause               23
;  :num-allocs              152962
;  :num-checks              10
;  :propagations            16
;  :quant-instantiations    28
;  :rlimit-count            183703)
; Definitional axioms for inverse functions
(assert (forall ((k@19@02 Int)) (!
  (implies
    (and (< k@19@02 V@11@02) (<= 0 k@19@02))
    (=
      (inv@20@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@19@02))
      k@19@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@19@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@20@02 r) V@11@02) (<= 0 (inv@20@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) (inv@20@02 r))
      r))
  :pattern ((inv@20@02 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@19@02 Int)) (!
  (implies
    (and (< k@19@02 V@11@02) (<= 0 k@19@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@19@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@19@02))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@21@02 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@20@02 r) V@11@02) (<= 0 (inv@20@02 r)))
    (=
      ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))) r))
  :qid |qp.fvfValDef2|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef3|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@20@02 r) V@11@02) (<= 0 (inv@20@02 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) r) r))
  :pattern ((inv@20@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
  $Snap.unit))
; [eval] exc == null ==> (forall k: Int :: { aloc(opt_get1(visited), k) } 0 <= k && k < V && k != s ==> aloc(opt_get1(visited), k).bool == false)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               168
;  :arith-add-rows          31
;  :arith-assert-diseq      2
;  :arith-assert-lower      14
;  :arith-assert-upper      11
;  :arith-bound-prop        3
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            11
;  :conflicts               3
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   27
;  :datatype-splits         9
;  :decisions               16
;  :del-clause              23
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.31
;  :memory                  4.30
;  :mk-bool-var             451
;  :mk-clause               23
;  :num-allocs              154428
;  :num-checks              11
;  :propagations            16
;  :quant-instantiations    28
;  :rlimit-count            186211)
; [then-branch: 7 | exc@12@02 == Null | live]
; [else-branch: 7 | exc@12@02 != Null | dead]
(push) ; 5
; [then-branch: 7 | exc@12@02 == Null]
; [eval] (forall k: Int :: { aloc(opt_get1(visited), k) } 0 <= k && k < V && k != s ==> aloc(opt_get1(visited), k).bool == false)
(declare-const k@22@02 Int)
(push) ; 6
; [eval] 0 <= k && k < V && k != s ==> aloc(opt_get1(visited), k).bool == false
; [eval] 0 <= k && k < V && k != s
; [eval] 0 <= k
(push) ; 7
; [then-branch: 8 | 0 <= k@22@02 | live]
; [else-branch: 8 | !(0 <= k@22@02) | live]
(push) ; 8
; [then-branch: 8 | 0 <= k@22@02]
(assert (<= 0 k@22@02))
; [eval] k < V
(push) ; 9
; [then-branch: 9 | k@22@02 < V@11@02 | live]
; [else-branch: 9 | !(k@22@02 < V@11@02) | live]
(push) ; 10
; [then-branch: 9 | k@22@02 < V@11@02]
(assert (< k@22@02 V@11@02))
; [eval] k != s
(pop) ; 10
(push) ; 10
; [else-branch: 9 | !(k@22@02 < V@11@02)]
(assert (not (< k@22@02 V@11@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 8 | !(0 <= k@22@02)]
(assert (not (<= 0 k@22@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 10 | k@22@02 != s@10@02 && k@22@02 < V@11@02 && 0 <= k@22@02 | live]
; [else-branch: 10 | !(k@22@02 != s@10@02 && k@22@02 < V@11@02 && 0 <= k@22@02) | live]
(push) ; 8
; [then-branch: 10 | k@22@02 != s@10@02 && k@22@02 < V@11@02 && 0 <= k@22@02]
(assert (and (and (not (= k@22@02 s@10@02)) (< k@22@02 V@11@02)) (<= 0 k@22@02)))
; [eval] aloc(opt_get1(visited), k).bool == false
; [eval] aloc(opt_get1(visited), k)
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
(assert (not (< k@22@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               168
;  :arith-add-rows          31
;  :arith-assert-diseq      4
;  :arith-assert-lower      16
;  :arith-assert-upper      12
;  :arith-bound-prop        3
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         1
;  :arith-offset-eqs        2
;  :arith-pivots            11
;  :conflicts               3
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   27
;  :datatype-splits         9
;  :decisions               16
;  :del-clause              23
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.31
;  :memory                  4.30
;  :mk-bool-var             457
;  :mk-clause               25
;  :num-allocs              154699
;  :num-checks              12
;  :propagations            16
;  :quant-instantiations    28
;  :rlimit-count            186517)
(assert (< k@22@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 9
; Joined path conditions
(assert (< k@22@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02)))
(push) ; 9
(assert (not (and
  (<
    (inv@20@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))
    V@11@02)
  (<=
    0
    (inv@20@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               176
;  :arith-add-rows          40
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      15
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        2
;  :arith-pivots            14
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   27
;  :datatype-splits         9
;  :decisions               16
;  :del-clause              23
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.31
;  :memory                  4.30
;  :mk-bool-var             485
;  :mk-clause               38
;  :num-allocs              155094
;  :num-checks              13
;  :propagations            16
;  :quant-instantiations    41
;  :rlimit-count            187320)
(pop) ; 8
(push) ; 8
; [else-branch: 10 | !(k@22@02 != s@10@02 && k@22@02 < V@11@02 && 0 <= k@22@02)]
(assert (not (and (and (not (= k@22@02 s@10@02)) (< k@22@02 V@11@02)) (<= 0 k@22@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (and (not (= k@22@02 s@10@02)) (< k@22@02 V@11@02)) (<= 0 k@22@02))
  (and
    (not (= k@22@02 s@10@02))
    (< k@22@02 V@11@02)
    (<= 0 k@22@02)
    (< k@22@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((k@22@02 Int)) (!
  (implies
    (and (and (not (= k@22@02 s@10@02)) (< k@22@02 V@11@02)) (<= 0 k@22@02))
    (and
      (not (= k@22@02 s@10@02))
      (< k@22@02 V@11@02)
      (<= 0 k@22@02)
      (< k@22@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@12@02 $Ref.null)
  (forall ((k@22@02 Int)) (!
    (implies
      (and (and (not (= k@22@02 s@10@02)) (< k@22@02 V@11@02)) (<= 0 k@22@02))
      (and
        (not (= k@22@02 s@10@02))
        (< k@22@02 V@11@02)
        (<= 0 k@22@02)
        (< k@22@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@12@02 $Ref.null)
  (forall ((k@22@02 Int)) (!
    (implies
      (and (and (not (= k@22@02 s@10@02)) (< k@22@02 V@11@02)) (<= 0 k@22@02))
      (=
        ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@22@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@18@02)))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(visited), s).bool == true
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@12@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               188
;  :arith-add-rows          44
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      15
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        2
;  :arith-pivots            17
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   31
;  :datatype-splits         10
;  :decisions               18
;  :del-clause              38
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.31
;  :memory                  4.30
;  :mk-bool-var             489
;  :mk-clause               38
;  :num-allocs              156002
;  :num-checks              14
;  :propagations            16
;  :quant-instantiations    41
;  :rlimit-count            188738)
; [then-branch: 11 | exc@12@02 == Null | live]
; [else-branch: 11 | exc@12@02 != Null | dead]
(push) ; 5
; [then-branch: 11 | exc@12@02 == Null]
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
(assert (not (< s@10@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               188
;  :arith-add-rows          44
;  :arith-assert-diseq      4
;  :arith-assert-lower      18
;  :arith-assert-upper      15
;  :arith-bound-prop        5
;  :arith-conflicts         1
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        2
;  :arith-pivots            17
;  :conflicts               4
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   31
;  :datatype-splits         10
;  :decisions               18
;  :del-clause              38
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.31
;  :memory                  4.31
;  :mk-bool-var             489
;  :mk-clause               38
;  :num-allocs              156029
;  :num-checks              15
;  :propagations            16
;  :quant-instantiations    41
;  :rlimit-count            188773)
(assert (< s@10@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 6
; Joined path conditions
(assert (< s@10@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)))
(push) ; 6
(assert (not (and
  (<
    (inv@20@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
    V@11@02)
  (<=
    0
    (inv@20@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               198
;  :arith-add-rows          51
;  :arith-assert-diseq      4
;  :arith-assert-lower      20
;  :arith-assert-upper      18
;  :arith-bound-prop        7
;  :arith-conflicts         2
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            20
;  :conflicts               5
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   31
;  :datatype-splits         10
;  :decisions               18
;  :del-clause              38
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.31
;  :mk-bool-var             517
;  :mk-clause               51
;  :num-allocs              156334
;  :num-checks              16
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            189530)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@12@02 $Ref.null)
  (and
    (< s@10@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)))))
(assert (implies
  (= exc@12@02 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@21@02  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
    true)))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@23@02 void)
; [exec]
; var res1: void
(declare-const res1@24@02 void)
; [exec]
; var evaluationDummy: void
(declare-const evaluationDummy@25@02 void)
; [exec]
; exc := null
; [exec]
; exc, res1 := do_par_$unknown$(V, visited, s)
; [eval] 0 < V ==> visited != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               201
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      21
;  :arith-assert-upper      18
;  :arith-bound-prop        7
;  :arith-conflicts         2
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               5
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   32
;  :datatype-splits         10
;  :decisions               19
;  :del-clause              51
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.31
;  :mk-bool-var             518
;  :mk-clause               51
;  :num-allocs              156847
;  :num-checks              17
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            190149)
(push) ; 4
(assert (not (< 0 V@11@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               201
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      21
;  :arith-assert-upper      19
;  :arith-bound-prop        7
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               6
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   32
;  :datatype-splits         10
;  :decisions               19
;  :del-clause              51
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             519
;  :mk-clause               51
;  :num-allocs              156921
;  :num-checks              18
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            190202)
; [then-branch: 12 | 0 < V@11@02 | live]
; [else-branch: 12 | !(0 < V@11@02) | dead]
(push) ; 4
; [then-branch: 12 | 0 < V@11@02]
(assert (< 0 V@11@02))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies
  (< 0 V@11@02)
  (not (= visited@9@02 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               201
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      21
;  :arith-assert-upper      19
;  :arith-bound-prop        7
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               6
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   32
;  :datatype-splits         10
;  :decisions               19
;  :del-clause              51
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             519
;  :mk-clause               51
;  :num-allocs              156951
;  :num-checks              19
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            190233)
(assert (implies
  (< 0 V@11@02)
  (not (= visited@9@02 (as None<option<array>>  option<array>)))))
; [eval] 0 < V ==> alen(opt_get1(visited)) == V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               204
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      22
;  :arith-assert-upper      19
;  :arith-bound-prop        7
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               6
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   33
;  :datatype-splits         10
;  :decisions               20
;  :del-clause              51
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.31
;  :mk-bool-var             520
;  :mk-clause               51
;  :num-allocs              157443
;  :num-checks              20
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            190707)
(push) ; 4
(assert (not (< 0 V@11@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               204
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      22
;  :arith-assert-upper      20
;  :arith-bound-prop        7
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               7
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   33
;  :datatype-splits         10
;  :decisions               20
;  :del-clause              51
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             521
;  :mk-clause               51
;  :num-allocs              157517
;  :num-checks              21
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            190760)
; [then-branch: 13 | 0 < V@11@02 | live]
; [else-branch: 13 | !(0 < V@11@02) | dead]
(push) ; 4
; [then-branch: 13 | 0 < V@11@02]
(assert (< 0 V@11@02))
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
  (< 0 V@11@02)
  (= (alen<Int> (opt_get1 $Snap.unit visited@9@02)) V@11@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               204
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      23
;  :arith-assert-upper      20
;  :arith-bound-prop        7
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               7
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 19
;  :datatype-occurs-check   33
;  :datatype-splits         10
;  :decisions               20
;  :del-clause              51
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             522
;  :mk-clause               51
;  :num-allocs              157600
;  :num-checks              22
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            190846)
(assert (implies
  (< 0 V@11@02)
  (= (alen<Int> (opt_get1 $Snap.unit visited@9@02)) V@11@02)))
; [eval] 0 < V ==> 0 <= s
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      24
;  :arith-assert-upper      20
;  :arith-bound-prop        7
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               7
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   34
;  :datatype-splits         10
;  :decisions               21
;  :del-clause              51
;  :final-checks            19
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.31
;  :mk-bool-var             523
;  :mk-clause               51
;  :num-allocs              158098
;  :num-checks              23
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            191318)
(push) ; 4
(assert (not (< 0 V@11@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      24
;  :arith-assert-upper      21
;  :arith-bound-prop        7
;  :arith-conflicts         5
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               8
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   34
;  :datatype-splits         10
;  :decisions               21
;  :del-clause              51
;  :final-checks            19
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             524
;  :mk-clause               51
;  :num-allocs              158172
;  :num-checks              24
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            191371)
; [then-branch: 14 | 0 < V@11@02 | live]
; [else-branch: 14 | !(0 < V@11@02) | dead]
(push) ; 4
; [then-branch: 14 | 0 < V@11@02]
(assert (< 0 V@11@02))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@11@02) (<= 0 s@10@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      24
;  :arith-assert-upper      21
;  :arith-bound-prop        7
;  :arith-conflicts         5
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               8
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   34
;  :datatype-splits         10
;  :decisions               21
;  :del-clause              51
;  :final-checks            19
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             524
;  :mk-clause               51
;  :num-allocs              158206
;  :num-checks              25
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            191421)
(assert (implies (< 0 V@11@02) (<= 0 s@10@02)))
; [eval] 0 < V ==> s < V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@02))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               210
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      25
;  :arith-assert-upper      21
;  :arith-bound-prop        7
;  :arith-conflicts         5
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               8
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   35
;  :datatype-splits         10
;  :decisions               22
;  :del-clause              51
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.31
;  :mk-bool-var             525
;  :mk-clause               51
;  :num-allocs              158749
;  :num-checks              26
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            191916)
(push) ; 4
(assert (not (< 0 V@11@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               210
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      25
;  :arith-assert-upper      22
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               9
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   35
;  :datatype-splits         10
;  :decisions               22
;  :del-clause              51
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             526
;  :mk-clause               51
;  :num-allocs              158823
;  :num-checks              27
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            191969)
; [then-branch: 15 | 0 < V@11@02 | live]
; [else-branch: 15 | !(0 < V@11@02) | dead]
(push) ; 4
; [then-branch: 15 | 0 < V@11@02]
(assert (< 0 V@11@02))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@11@02) (< s@10@02 V@11@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               210
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      25
;  :arith-assert-upper      22
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            23
;  :conflicts               9
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   35
;  :datatype-splits         10
;  :decisions               22
;  :del-clause              51
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             526
;  :mk-clause               51
;  :num-allocs              158857
;  :num-checks              28
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            192022)
(assert (implies (< 0 V@11@02) (< s@10@02 V@11@02)))
(declare-const i1@26@02 Int)
(push) ; 3
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 4
; [then-branch: 16 | 0 <= i1@26@02 | live]
; [else-branch: 16 | !(0 <= i1@26@02) | live]
(push) ; 5
; [then-branch: 16 | 0 <= i1@26@02]
(assert (<= 0 i1@26@02))
; [eval] i1 < V
(pop) ; 5
(push) ; 5
; [else-branch: 16 | !(0 <= i1@26@02)]
(assert (not (<= 0 i1@26@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i1@26@02 V@11@02) (<= 0 i1@26@02)))
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
(assert (not (< i1@26@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               210
;  :arith-add-rows          59
;  :arith-assert-diseq      4
;  :arith-assert-lower      26
;  :arith-assert-upper      23
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            24
;  :conflicts               9
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   35
;  :datatype-splits         10
;  :decisions               22
;  :del-clause              51
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             528
;  :mk-clause               51
;  :num-allocs              159018
;  :num-checks              29
;  :propagations            16
;  :quant-instantiations    54
;  :rlimit-count            192232)
(assert (< i1@26@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 4
; Joined path conditions
(assert (< i1@26@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 3
(declare-fun inv@27@02 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@26@02 Int)) (!
  (< i1@26@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i1@26@02))
  :qid |bool-aux|)))
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i11@26@02 Int) (i12@26@02 Int)) (!
  (implies
    (and
      (and
        (and (< i11@26@02 V@11@02) (<= 0 i11@26@02))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@17@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i11@26@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i11@26@02)))
      (and
        (and (< i12@26@02 V@11@02) (<= 0 i12@26@02))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@17@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i12@26@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i12@26@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i11@26@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i12@26@02)))
    (= i11@26@02 i12@26@02))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               219
;  :arith-add-rows          65
;  :arith-assert-diseq      5
;  :arith-assert-lower      29
;  :arith-assert-upper      24
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        2
;  :arith-pivots            29
;  :conflicts               10
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   35
;  :datatype-splits         10
;  :decisions               22
;  :del-clause              62
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.32
;  :memory                  4.30
;  :mk-bool-var             556
;  :mk-clause               62
;  :num-allocs              159553
;  :num-checks              30
;  :propagations            16
;  :quant-instantiations    67
;  :rlimit-count            193281)
; Definitional axioms for inverse functions
(assert (forall ((i1@26@02 Int)) (!
  (implies
    (and (< i1@26@02 V@11@02) (<= 0 i1@26@02))
    (=
      (inv@27@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i1@26@02))
      i1@26@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) i1@26@02))
  :qid |bool-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@27@02 r) V@11@02) (<= 0 (inv@27@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) (inv@27@02 r))
      r))
  :pattern ((inv@27@02 r))
  :qid |bool-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@27@02 r) V@11@02) (<= 0 (inv@27@02 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@17@02  $FVF<Bool>) r) r))
  :pattern ((inv@27@02 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@28@02 ((r $Ref)) $Perm
  (ite
    (and (< (inv@27@02 r) V@11@02) (<= 0 (inv@27@02 r)))
    ($Perm.min
      (ite
        (and (< (inv@16@02 r) V@11@02) (<= 0 (inv@16@02 r)))
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
        (and (< (inv@16@02 r) V@11@02) (<= 0 (inv@16@02 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@28@02 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               281
;  :arith-add-rows          75
;  :arith-assert-diseq      13
;  :arith-assert-lower      52
;  :arith-assert-upper      34
;  :arith-bound-prop        9
;  :arith-conflicts         9
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        2
;  :arith-pivots            41
;  :conflicts               17
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   36
;  :datatype-splits         10
;  :decisions               29
;  :del-clause              123
;  :final-checks            21
;  :max-generation          3
;  :max-memory              4.33
;  :memory                  4.32
;  :mk-bool-var             652
;  :mk-clause               123
;  :num-allocs              161129
;  :num-checks              32
;  :propagations            51
;  :quant-instantiations    105
;  :rlimit-count            196058
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 3
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@27@02 r) V@11@02) (<= 0 (inv@27@02 r)))
    (= (- $Perm.Write (pTaken@28@02 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               295
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      56
;  :arith-assert-upper      39
;  :arith-bound-prop        10
;  :arith-conflicts         10
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               18
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   36
;  :datatype-splits         10
;  :decisions               29
;  :del-clause              143
;  :final-checks            21
;  :max-generation          3
;  :max-memory              4.33
;  :memory                  4.32
;  :mk-bool-var             688
;  :mk-clause               143
;  :num-allocs              161521
;  :num-checks              33
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            197047)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
(declare-const exc@29@02 $Ref)
(declare-const res@30@02 void)
(declare-const $t@31@02 $Snap)
(assert (= $t@31@02 ($Snap.combine ($Snap.first $t@31@02) ($Snap.second $t@31@02))))
(assert (= ($Snap.first $t@31@02) $Snap.unit))
; [eval] exc == null
(assert (= exc@29@02 $Ref.null))
(assert (=
  ($Snap.second $t@31@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@31@02))
    ($Snap.second ($Snap.second $t@31@02)))))
(assert (= ($Snap.first ($Snap.second $t@31@02)) $Snap.unit))
; [eval] exc == null && 0 < V ==> visited != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 17 | exc@29@02 == Null | live]
; [else-branch: 17 | exc@29@02 != Null | live]
(push) ; 4
; [then-branch: 17 | exc@29@02 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 17 | exc@29@02 != Null]
(assert (not (= exc@29@02 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               315
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      57
;  :arith-assert-upper      39
;  :arith-bound-prop        10
;  :arith-conflicts         10
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               18
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   39
;  :datatype-splits         11
;  :decisions               31
;  :del-clause              143
;  :final-checks            23
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             695
;  :mk-clause               143
;  :num-allocs              162191
;  :num-checks              34
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            197856)
(push) ; 4
(assert (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               315
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      57
;  :arith-assert-upper      40
;  :arith-bound-prop        10
;  :arith-conflicts         11
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               19
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   39
;  :datatype-splits         11
;  :decisions               31
;  :del-clause              143
;  :final-checks            23
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             696
;  :mk-clause               143
;  :num-allocs              162265
;  :num-checks              35
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            197913)
; [then-branch: 18 | 0 < V@11@02 && exc@29@02 == Null | live]
; [else-branch: 18 | !(0 < V@11@02 && exc@29@02 == Null) | dead]
(push) ; 4
; [then-branch: 18 | 0 < V@11@02 && exc@29@02 == Null]
(assert (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@11@02) (= exc@29@02 $Ref.null))
  (not (= visited@9@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@31@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@31@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@31@02))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(visited)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 19 | exc@29@02 == Null | live]
; [else-branch: 19 | exc@29@02 != Null | live]
(push) ; 4
; [then-branch: 19 | exc@29@02 == Null]
(assert (= exc@29@02 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 19 | exc@29@02 != Null]
(assert (not (= exc@29@02 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      58
;  :arith-assert-upper      40
;  :arith-bound-prop        10
;  :arith-conflicts         11
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               19
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 27
;  :datatype-occurs-check   42
;  :datatype-splits         12
;  :decisions               33
;  :del-clause              143
;  :final-checks            25
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             700
;  :mk-clause               143
;  :num-allocs              162880
;  :num-checks              36
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            198624)
(push) ; 4
(assert (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      58
;  :arith-assert-upper      41
;  :arith-bound-prop        10
;  :arith-conflicts         12
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               20
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 27
;  :datatype-occurs-check   42
;  :datatype-splits         12
;  :decisions               33
;  :del-clause              143
;  :final-checks            25
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             701
;  :mk-clause               143
;  :num-allocs              162955
;  :num-checks              37
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            198681)
; [then-branch: 20 | 0 < V@11@02 && exc@29@02 == Null | live]
; [else-branch: 20 | !(0 < V@11@02 && exc@29@02 == Null) | dead]
(push) ; 4
; [then-branch: 20 | 0 < V@11@02 && exc@29@02 == Null]
(assert (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))
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
  (and (< 0 V@11@02) (= exc@29@02 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit visited@9@02)) V@11@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@31@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@31@02))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> 0 <= s
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 21 | exc@29@02 == Null | live]
; [else-branch: 21 | exc@29@02 != Null | live]
(push) ; 4
; [then-branch: 21 | exc@29@02 == Null]
(assert (= exc@29@02 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 21 | exc@29@02 != Null]
(assert (not (= exc@29@02 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      60
;  :arith-assert-upper      41
;  :arith-bound-prop        10
;  :arith-conflicts         12
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               20
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   45
;  :datatype-splits         13
;  :decisions               35
;  :del-clause              143
;  :final-checks            27
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             706
;  :mk-clause               143
;  :num-allocs              163636
;  :num-checks              38
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            199460)
(push) ; 4
(assert (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      60
;  :arith-assert-upper      42
;  :arith-bound-prop        10
;  :arith-conflicts         13
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               21
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   45
;  :datatype-splits         13
;  :decisions               35
;  :del-clause              143
;  :final-checks            27
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             707
;  :mk-clause               143
;  :num-allocs              163711
;  :num-checks              39
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            199517)
; [then-branch: 22 | 0 < V@11@02 && exc@29@02 == Null | live]
; [else-branch: 22 | !(0 < V@11@02 && exc@29@02 == Null) | dead]
(push) ; 4
; [then-branch: 22 | 0 < V@11@02 && exc@29@02 == Null]
(assert (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@11@02) (= exc@29@02 $Ref.null)) (<= 0 s@10@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> s < V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 23 | exc@29@02 == Null | live]
; [else-branch: 23 | exc@29@02 != Null | live]
(push) ; 4
; [then-branch: 23 | exc@29@02 == Null]
(assert (= exc@29@02 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 23 | exc@29@02 != Null]
(assert (not (= exc@29@02 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               360
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      61
;  :arith-assert-upper      42
;  :arith-bound-prop        10
;  :arith-conflicts         13
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               21
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   50
;  :datatype-splits         14
;  :decisions               37
;  :del-clause              143
;  :final-checks            29
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             711
;  :mk-clause               143
;  :num-allocs              164344
;  :num-checks              40
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            200264)
(push) ; 4
(assert (not (and (< 0 V@11@02) (= exc@29@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               360
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      61
;  :arith-assert-upper      43
;  :arith-bound-prop        10
;  :arith-conflicts         14
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               22
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   50
;  :datatype-splits         14
;  :decisions               37
;  :del-clause              143
;  :final-checks            29
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             712
;  :mk-clause               143
;  :num-allocs              164419
;  :num-checks              41
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            200321)
; [then-branch: 24 | 0 < V@11@02 && exc@29@02 == Null | live]
; [else-branch: 24 | !(0 < V@11@02 && exc@29@02 == Null) | dead]
(push) ; 4
; [then-branch: 24 | 0 < V@11@02 && exc@29@02 == Null]
(assert (and (< 0 V@11@02) (= exc@29@02 $Ref.null)))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@11@02) (= exc@29@02 $Ref.null)) (< s@10@02 V@11@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02)))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               377
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      61
;  :arith-assert-upper      43
;  :arith-bound-prop        10
;  :arith-conflicts         14
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               22
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   55
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              143
;  :final-checks            31
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             715
;  :mk-clause               143
;  :num-allocs              164996
;  :num-checks              42
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            200987)
(push) ; 3
(assert (not (= exc@29@02 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               377
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      61
;  :arith-assert-upper      43
;  :arith-bound-prop        10
;  :arith-conflicts         14
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               22
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   55
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              143
;  :final-checks            31
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.33
;  :mk-bool-var             715
;  :mk-clause               143
;  :num-allocs              165012
;  :num-checks              43
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            200998)
; [then-branch: 25 | exc@29@02 == Null | live]
; [else-branch: 25 | exc@29@02 != Null | dead]
(push) ; 3
; [then-branch: 25 | exc@29@02 == Null]
(assert (= exc@29@02 $Ref.null))
(declare-const unknown1@32@02 Int)
(push) ; 4
; [eval] 0 <= unknown1 && unknown1 < V
; [eval] 0 <= unknown1
(push) ; 5
; [then-branch: 26 | 0 <= unknown1@32@02 | live]
; [else-branch: 26 | !(0 <= unknown1@32@02) | live]
(push) ; 6
; [then-branch: 26 | 0 <= unknown1@32@02]
(assert (<= 0 unknown1@32@02))
; [eval] unknown1 < V
(pop) ; 6
(push) ; 6
; [else-branch: 26 | !(0 <= unknown1@32@02)]
(assert (not (<= 0 unknown1@32@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< unknown1@32@02 V@11@02) (<= 0 unknown1@32@02)))
; [eval] aloc(opt_get1(visited), unknown1)
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
(assert (not (< unknown1@32@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               377
;  :arith-add-rows          82
;  :arith-assert-diseq      15
;  :arith-assert-lower      63
;  :arith-assert-upper      43
;  :arith-bound-prop        10
;  :arith-conflicts         14
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               22
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   55
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              143
;  :final-checks            31
;  :max-generation          3
;  :max-memory              4.34
;  :memory                  4.34
;  :mk-bool-var             717
;  :mk-clause               143
;  :num-allocs              165114
;  :num-checks              44
;  :propagations            56
;  :quant-instantiations    118
;  :rlimit-count            201186)
(assert (< unknown1@32@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@32@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 4
(declare-fun inv@33@02 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown1@32@02 Int)) (!
  (< unknown1@32@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@32@02))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown11@32@02 Int) (unknown12@32@02 Int)) (!
  (implies
    (and
      (and (< unknown11@32@02 V@11@02) (<= 0 unknown11@32@02))
      (and (< unknown12@32@02 V@11@02) (<= 0 unknown12@32@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown11@32@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown12@32@02)))
    (= unknown11@32@02 unknown12@32@02))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               386
;  :arith-add-rows          84
;  :arith-assert-diseq      16
;  :arith-assert-lower      66
;  :arith-assert-upper      44
;  :arith-bound-prop        10
;  :arith-conflicts         14
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               23
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   55
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              149
;  :final-checks            31
;  :max-generation          3
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             738
;  :mk-clause               149
;  :num-allocs              165615
;  :num-checks              45
;  :propagations            56
;  :quant-instantiations    133
;  :rlimit-count            202098)
; Definitional axioms for inverse functions
(assert (forall ((unknown1@32@02 Int)) (!
  (implies
    (and (< unknown1@32@02 V@11@02) (<= 0 unknown1@32@02))
    (=
      (inv@33@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@32@02))
      unknown1@32@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@32@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) (inv@33@02 r))
      r))
  :pattern ((inv@33@02 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown1@32@02 Int)) (!
  (implies
    (and (< unknown1@32@02 V@11@02) (<= 0 unknown1@32@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@32@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@32@02))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@34@02 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
    (=
      ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))) r))
  :qid |qp.fvfValDef4|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef5|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) r) r))
  :pattern ((inv@33@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown1: Int :: { aloc(opt_get1(visited), unknown1) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(visited), unknown1).bool == false)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               398
;  :arith-add-rows          84
;  :arith-assert-diseq      16
;  :arith-assert-lower      66
;  :arith-assert-upper      44
;  :arith-bound-prop        10
;  :arith-conflicts         14
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            45
;  :conflicts               23
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   60
;  :datatype-splits         17
;  :decisions               42
;  :del-clause              149
;  :final-checks            33
;  :max-generation          3
;  :max-memory              4.37
;  :memory                  4.36
;  :mk-bool-var             746
;  :mk-clause               149
;  :num-allocs              166967
;  :num-checks              46
;  :propagations            56
;  :quant-instantiations    133
;  :rlimit-count            204317)
; [then-branch: 27 | exc@29@02 == Null | live]
; [else-branch: 27 | exc@29@02 != Null | dead]
(push) ; 5
; [then-branch: 27 | exc@29@02 == Null]
; [eval] (forall unknown1: Int :: { aloc(opt_get1(visited), unknown1) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(visited), unknown1).bool == false)
(declare-const unknown1@35@02 Int)
(push) ; 6
; [eval] 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(visited), unknown1).bool == false
; [eval] 0 <= unknown1 && unknown1 < V
; [eval] 0 <= unknown1
(push) ; 7
; [then-branch: 28 | 0 <= unknown1@35@02 | live]
; [else-branch: 28 | !(0 <= unknown1@35@02) | live]
(push) ; 8
; [then-branch: 28 | 0 <= unknown1@35@02]
(assert (<= 0 unknown1@35@02))
; [eval] unknown1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 28 | !(0 <= unknown1@35@02)]
(assert (not (<= 0 unknown1@35@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 29 | unknown1@35@02 < V@11@02 && 0 <= unknown1@35@02 | live]
; [else-branch: 29 | !(unknown1@35@02 < V@11@02 && 0 <= unknown1@35@02) | live]
(push) ; 8
; [then-branch: 29 | unknown1@35@02 < V@11@02 && 0 <= unknown1@35@02]
(assert (and (< unknown1@35@02 V@11@02) (<= 0 unknown1@35@02)))
; [eval] aloc(opt_get1(visited), unknown1).bool == false
; [eval] aloc(opt_get1(visited), unknown1)
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
(assert (not (< unknown1@35@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               398
;  :arith-add-rows          84
;  :arith-assert-diseq      16
;  :arith-assert-lower      68
;  :arith-assert-upper      44
;  :arith-bound-prop        10
;  :arith-conflicts         14
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        2
;  :arith-pivots            46
;  :conflicts               23
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   60
;  :datatype-splits         17
;  :decisions               42
;  :del-clause              149
;  :final-checks            33
;  :max-generation          3
;  :max-memory              4.37
;  :memory                  4.36
;  :mk-bool-var             748
;  :mk-clause               149
;  :num-allocs              167069
;  :num-checks              47
;  :propagations            56
;  :quant-instantiations    133
;  :rlimit-count            204516)
(assert (< unknown1@35@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 9
; Joined path conditions
(assert (< unknown1@35@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02)))
(push) ; 9
(assert (not (and
  (<
    (inv@33@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))
    V@11@02)
  (<=
    0
    (inv@33@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               419
;  :arith-add-rows          99
;  :arith-assert-diseq      16
;  :arith-assert-lower      71
;  :arith-assert-upper      48
;  :arith-bound-prop        14
;  :arith-conflicts         15
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        9
;  :arith-pivots            50
;  :conflicts               24
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   60
;  :datatype-splits         17
;  :decisions               42
;  :del-clause              149
;  :final-checks            33
;  :max-generation          3
;  :max-memory              4.68
;  :memory                  4.53
;  :mk-bool-var             782
;  :mk-clause               164
;  :num-allocs              167424
;  :num-checks              48
;  :propagations            59
;  :quant-instantiations    149
;  :rlimit-count            205460)
(pop) ; 8
(push) ; 8
; [else-branch: 29 | !(unknown1@35@02 < V@11@02 && 0 <= unknown1@35@02)]
(assert (not (and (< unknown1@35@02 V@11@02) (<= 0 unknown1@35@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< unknown1@35@02 V@11@02) (<= 0 unknown1@35@02))
  (and
    (< unknown1@35@02 V@11@02)
    (<= 0 unknown1@35@02)
    (< unknown1@35@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown1@35@02 Int)) (!
  (implies
    (and (< unknown1@35@02 V@11@02) (<= 0 unknown1@35@02))
    (and
      (< unknown1@35@02 V@11@02)
      (<= 0 unknown1@35@02)
      (< unknown1@35@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@29@02 $Ref.null)
  (forall ((unknown1@35@02 Int)) (!
    (implies
      (and (< unknown1@35@02 V@11@02) (<= 0 unknown1@35@02))
      (and
        (< unknown1@35@02 V@11@02)
        (<= 0 unknown1@35@02)
        (< unknown1@35@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@29@02 $Ref.null)
  (forall ((unknown1@35@02 Int)) (!
    (implies
      (and (< unknown1@35@02 V@11@02) (<= 0 unknown1@35@02))
      (=
        ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) unknown1@35@02))
    :qid |prog.l<no position>|))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] exc != null
; [then-branch: 30 | exc@29@02 != Null | dead]
; [else-branch: 30 | exc@29@02 == Null | live]
(push) ; 4
; [else-branch: 30 | exc@29@02 == Null]
(pop) ; 4
; [eval] !(exc != null)
; [eval] exc != null
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               441
;  :arith-add-rows          103
;  :arith-assert-diseq      16
;  :arith-assert-lower      71
;  :arith-assert-upper      48
;  :arith-bound-prop        14
;  :arith-conflicts         15
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        9
;  :arith-pivots            54
;  :conflicts               24
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   70
;  :datatype-splits         19
;  :decisions               46
;  :del-clause              164
;  :final-checks            37
;  :max-generation          3
;  :max-memory              4.68
;  :memory                  4.53
;  :mk-bool-var             786
;  :mk-clause               164
;  :num-allocs              168727
;  :num-checks              50
;  :propagations            59
;  :quant-instantiations    149
;  :rlimit-count            207147)
; [then-branch: 31 | exc@29@02 == Null | live]
; [else-branch: 31 | exc@29@02 != Null | dead]
(push) ; 4
; [then-branch: 31 | exc@29@02 == Null]
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
(assert (not (< s@10@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               441
;  :arith-add-rows          103
;  :arith-assert-diseq      16
;  :arith-assert-lower      71
;  :arith-assert-upper      48
;  :arith-bound-prop        14
;  :arith-conflicts         15
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        9
;  :arith-pivots            54
;  :conflicts               24
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   70
;  :datatype-splits         19
;  :decisions               46
;  :del-clause              164
;  :final-checks            37
;  :max-generation          3
;  :max-memory              4.68
;  :memory                  4.53
;  :mk-bool-var             786
;  :mk-clause               164
;  :num-allocs              168754
;  :num-checks              51
;  :propagations            59
;  :quant-instantiations    149
;  :rlimit-count            207182)
(assert (< s@10@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 5
; Joined path conditions
(assert (< s@10@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
; Definitional axioms for snapshot map values
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@34@02  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)))
; Precomputing data for removing quantified permissions
(define-fun pTaken@36@02 ((r $Ref)) $Perm
  (ite
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
    ($Perm.min
      (ite
        (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
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
        (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@36@02 r))
    $Perm.No)
  
  ))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               559
;  :arith-add-rows          129
;  :arith-assert-diseq      19
;  :arith-assert-lower      89
;  :arith-assert-upper      58
;  :arith-bound-prop        24
;  :arith-conflicts         17
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         19
;  :arith-offset-eqs        19
;  :arith-pivots            67
;  :conflicts               27
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   82
;  :datatype-splits         25
;  :decisions               73
;  :del-clause              267
;  :final-checks            43
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             962
;  :mk-clause               301
;  :num-allocs              171406
;  :num-checks              53
;  :propagations            107
;  :quant-instantiations    202
;  :rlimit-count            211269)
; Intermediate check if already taken enough permissions
(push) ; 5
(assert (not (forall ((r $Ref)) (!
  (implies
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
    (= (- $Perm.Write (pTaken@36@02 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               572
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   82
;  :datatype-splits         25
;  :decisions               73
;  :del-clause              277
;  :final-checks            43
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.63
;  :mk-bool-var             980
;  :mk-clause               311
;  :num-allocs              171702
;  :num-checks              54
;  :propagations            112
;  :quant-instantiations    202
;  :rlimit-count            212056)
; Final check if taken enough permissions
; Done removing quantified permissions
(declare-const sm@37@02 $FVF<Bool>)
; Definitional axioms for singleton-FVF's value
(assert (=
  ($FVF.lookup_bool (as sm@37@02  $FVF<Bool>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
  true))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@37@02  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)))
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
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               589
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 53
;  :datatype-occurs-check   88
;  :datatype-splits         28
;  :decisions               81
;  :del-clause              293
;  :final-checks            46
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             997
;  :mk-clause               327
;  :num-allocs              172471
;  :num-checks              55
;  :propagations            120
;  :quant-instantiations    204
;  :rlimit-count            212872)
; [then-branch: 32 | exc@29@02 == Null | live]
; [else-branch: 32 | exc@29@02 != Null | dead]
(push) ; 6
; [then-branch: 32 | exc@29@02 == Null]
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies
  (= exc@29@02 $Ref.null)
  (not (= visited@9@02 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               589
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 53
;  :datatype-occurs-check   88
;  :datatype-splits         28
;  :decisions               81
;  :del-clause              293
;  :final-checks            46
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             997
;  :mk-clause               327
;  :num-allocs              172494
;  :num-checks              56
;  :propagations            120
;  :quant-instantiations    204
;  :rlimit-count            212892)
(assert (implies
  (= exc@29@02 $Ref.null)
  (not (= visited@9@02 (as None<option<array>>  option<array>)))))
; [eval] exc == null ==> alen(opt_get1(visited)) == V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               606
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   94
;  :datatype-splits         31
;  :decisions               89
;  :del-clause              309
;  :final-checks            49
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1012
;  :mk-clause               343
;  :num-allocs              173196
;  :num-checks              57
;  :propagations            128
;  :quant-instantiations    206
;  :rlimit-count            213603)
; [then-branch: 33 | exc@29@02 == Null | live]
; [else-branch: 33 | exc@29@02 != Null | dead]
(push) ; 6
; [then-branch: 33 | exc@29@02 == Null]
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
  (= exc@29@02 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@9@02)) V@11@02))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               606
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 57
;  :datatype-occurs-check   94
;  :datatype-splits         31
;  :decisions               89
;  :del-clause              309
;  :final-checks            49
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1012
;  :mk-clause               343
;  :num-allocs              173213
;  :num-checks              58
;  :propagations            128
;  :quant-instantiations    206
;  :rlimit-count            213628)
(assert (implies
  (= exc@29@02 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@9@02)) V@11@02)))
; [eval] exc == null ==> 0 <= s
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               623
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 61
;  :datatype-occurs-check   100
;  :datatype-splits         34
;  :decisions               97
;  :del-clause              325
;  :final-checks            52
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1027
;  :mk-clause               359
;  :num-allocs              173915
;  :num-checks              59
;  :propagations            136
;  :quant-instantiations    208
;  :rlimit-count            214339)
; [then-branch: 34 | exc@29@02 == Null | live]
; [else-branch: 34 | exc@29@02 != Null | dead]
(push) ; 6
; [then-branch: 34 | exc@29@02 == Null]
; [eval] 0 <= s
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies (= exc@29@02 $Ref.null) (<= 0 s@10@02))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               623
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 61
;  :datatype-occurs-check   100
;  :datatype-splits         34
;  :decisions               97
;  :del-clause              325
;  :final-checks            52
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1027
;  :mk-clause               359
;  :num-allocs              173936
;  :num-checks              60
;  :propagations            136
;  :quant-instantiations    208
;  :rlimit-count            214365)
(assert (implies (= exc@29@02 $Ref.null) (<= 0 s@10@02)))
; [eval] exc == null ==> s < V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               640
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   106
;  :datatype-splits         37
;  :decisions               105
;  :del-clause              341
;  :final-checks            55
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1042
;  :mk-clause               375
;  :num-allocs              174682
;  :num-checks              61
;  :propagations            144
;  :quant-instantiations    210
;  :rlimit-count            215092)
; [then-branch: 35 | exc@29@02 == Null | live]
; [else-branch: 35 | exc@29@02 != Null | dead]
(push) ; 6
; [then-branch: 35 | exc@29@02 == Null]
; [eval] s < V
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies (= exc@29@02 $Ref.null) (< s@10@02 V@11@02))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               640
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   106
;  :datatype-splits         37
;  :decisions               105
;  :del-clause              341
;  :final-checks            55
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1042
;  :mk-clause               375
;  :num-allocs              174709
;  :num-checks              62
;  :propagations            144
;  :quant-instantiations    210
;  :rlimit-count            215121)
(assert (implies (= exc@29@02 $Ref.null) (< s@10@02 V@11@02)))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               657
;  :arith-add-rows          151
;  :arith-assert-diseq      21
;  :arith-assert-lower      90
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   112
;  :datatype-splits         40
;  :decisions               113
;  :del-clause              357
;  :final-checks            58
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1057
;  :mk-clause               391
;  :num-allocs              175455
;  :num-checks              63
;  :propagations            152
;  :quant-instantiations    212
;  :rlimit-count            215848)
; [then-branch: 36 | exc@29@02 == Null | live]
; [else-branch: 36 | exc@29@02 != Null | dead]
(push) ; 5
; [then-branch: 36 | exc@29@02 == Null]
(declare-const k@38@02 Int)
(push) ; 6
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 7
; [then-branch: 37 | 0 <= k@38@02 | live]
; [else-branch: 37 | !(0 <= k@38@02) | live]
(push) ; 8
; [then-branch: 37 | 0 <= k@38@02]
(assert (<= 0 k@38@02))
; [eval] k < V
(pop) ; 8
(push) ; 8
; [else-branch: 37 | !(0 <= k@38@02)]
(assert (not (<= 0 k@38@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< k@38@02 V@11@02) (<= 0 k@38@02)))
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
(assert (not (< k@38@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               657
;  :arith-add-rows          152
;  :arith-assert-diseq      21
;  :arith-assert-lower      92
;  :arith-assert-upper      62
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        21
;  :arith-pivots            71
;  :conflicts               28
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   112
;  :datatype-splits         40
;  :decisions               113
;  :del-clause              357
;  :final-checks            58
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.64
;  :mk-bool-var             1059
;  :mk-clause               391
;  :num-allocs              175557
;  :num-checks              64
;  :propagations            152
;  :quant-instantiations    212
;  :rlimit-count            216032)
(assert (< k@38@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 7
; Joined path conditions
(assert (< k@38@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 6
(declare-fun inv@39@02 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@38@02 Int)) (!
  (< k@38@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@38@02))
  :qid |bool-aux|)))
(declare-const sm@40@02 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
    (=
      ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) r)
      ($FVF.lookup_bool (as sm@37@02  $FVF<Bool>) r)))
  :pattern (($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool (as sm@37@02  $FVF<Bool>) r))
  :qid |qp.fvfValDef6|)))
(assert (forall ((r $Ref)) (!
  (implies
    (<
      $Perm.No
      (-
        (ite
          (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@36@02 r)))
    (=
      ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))) r))
  :qid |qp.fvfValDef7|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@37@02  $FVF<Bool>) r) r)
    ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@31@02))))))) r) r))
  :pattern (($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef8|)))
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((k1@38@02 Int) (k2@38@02 Int)) (!
  (implies
    (and
      (and
        (and (< k1@38@02 V@11@02) (<= 0 k1@38@02))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k1@38@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k1@38@02)))
      (and
        (and (< k2@38@02 V@11@02) (<= 0 k2@38@02))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k2@38@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k2@38@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k1@38@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k2@38@02)))
    (= k1@38@02 k2@38@02))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               681
;  :arith-add-rows          157
;  :arith-assert-diseq      22
;  :arith-assert-lower      100
;  :arith-assert-upper      64
;  :arith-bound-prop        25
;  :arith-conflicts         18
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        26
;  :arith-pivots            73
;  :conflicts               29
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   112
;  :datatype-splits         40
;  :decisions               113
;  :del-clause              385
;  :final-checks            58
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.63
;  :mk-bool-var             1121
;  :mk-clause               428
;  :num-allocs              176690
;  :num-checks              65
;  :propagations            159
;  :quant-instantiations    238
;  :rlimit-count            218582)
; Definitional axioms for inverse functions
(assert (forall ((k@38@02 Int)) (!
  (implies
    (and (< k@38@02 V@11@02) (<= 0 k@38@02))
    (=
      (inv@39@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@38@02))
      k@38@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@38@02))
  :qid |bool-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@39@02 r) V@11@02) (<= 0 (inv@39@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) (inv@39@02 r))
      r))
  :pattern ((inv@39@02 r))
  :qid |bool-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@39@02 r) V@11@02) (<= 0 (inv@39@02 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) r) r))
  :pattern ((inv@39@02 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@41@02 ((r $Ref)) $Perm
  (ite
    (and (< (inv@39@02 r) V@11@02) (<= 0 (inv@39@02 r)))
    ($Perm.min
      (ite
        (=
          r
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
        $Perm.Write
        $Perm.No)
      $Perm.Write)
    $Perm.No))
(define-fun pTaken@42@02 ((r $Ref)) $Perm
  (ite
    (and (< (inv@39@02 r) V@11@02) (<= 0 (inv@39@02 r)))
    ($Perm.min
      (-
        (ite
          (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@36@02 r))
      (- $Perm.Write (pTaken@41@02 r)))
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
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
      $Perm.Write
      $Perm.No)
    (pTaken@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)))
  $Perm.No)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               705
;  :arith-add-rows          159
;  :arith-assert-diseq      22
;  :arith-assert-lower      101
;  :arith-assert-upper      65
;  :arith-bound-prop        27
;  :arith-conflicts         18
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        28
;  :arith-pivots            74
;  :conflicts               30
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   118
;  :datatype-splits         43
;  :decisions               121
;  :del-clause              414
;  :final-checks            61
;  :max-generation          4
;  :max-memory              4.68
;  :memory                  4.65
;  :mk-bool-var             1149
;  :mk-clause               448
;  :num-allocs              178180
;  :num-checks              67
;  :propagations            167
;  :quant-instantiations    242
;  :rlimit-count            220449)
; Intermediate check if already taken enough permissions
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@39@02 r) V@11@02) (<= 0 (inv@39@02 r)))
    (= (- $Perm.Write (pTaken@41@02 r)) $Perm.No))
  
  ))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               772
;  :arith-add-rows          180
;  :arith-assert-diseq      25
;  :arith-assert-lower      110
;  :arith-assert-upper      72
;  :arith-bound-prop        33
;  :arith-conflicts         19
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        35
;  :arith-pivots            82
;  :conflicts               31
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   124
;  :datatype-splits         46
;  :decisions               135
;  :del-clause              488
;  :final-checks            64
;  :max-generation          4
;  :max-memory              4.75
;  :memory                  4.74
;  :mk-bool-var             1240
;  :mk-clause               522
;  :num-allocs              179651
;  :num-checks              68
;  :propagations            193
;  :quant-instantiations    270
;  :rlimit-count            222888
;  :time                    0.00)
; Chunk depleted?
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (=
    (-
      (-
        (ite
          (and (< (inv@33@02 r) V@11@02) (<= 0 (inv@33@02 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@36@02 r))
      (pTaken@42@02 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               993
;  :arith-add-rows          325
;  :arith-assert-diseq      36
;  :arith-assert-lower      173
;  :arith-assert-upper      125
;  :arith-bound-prop        58
;  :arith-conflicts         24
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         53
;  :arith-offset-eqs        57
;  :arith-pivots            117
;  :conflicts               50
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   124
;  :datatype-splits         46
;  :decisions               158
;  :del-clause              746
;  :final-checks            64
;  :max-generation          4
;  :max-memory              4.78
;  :memory                  4.77
;  :minimized-lits          2
;  :mk-bool-var             1644
;  :mk-clause               780
;  :num-allocs              181565
;  :num-checks              69
;  :propagations            348
;  :quant-instantiations    347
;  :rlimit-count            227637
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@39@02 r) V@11@02) (<= 0 (inv@39@02 r)))
    (= (- (- $Perm.Write (pTaken@41@02 r)) (pTaken@42@02 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1138
;  :arith-add-rows          390
;  :arith-assert-diseq      43
;  :arith-assert-lower      199
;  :arith-assert-upper      149
;  :arith-bound-prop        69
;  :arith-conflicts         29
;  :arith-eq-adapter        151
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        74
;  :arith-pivots            135
;  :conflicts               64
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 79
;  :datatype-occurs-check   124
;  :datatype-splits         46
;  :decisions               171
;  :del-clause              899
;  :final-checks            64
;  :max-generation          4
;  :max-memory              4.78
;  :memory                  4.77
;  :minimized-lits          3
;  :mk-bool-var             1835
;  :mk-clause               933
;  :num-allocs              182548
;  :num-checks              70
;  :propagations            401
;  :quant-instantiations    374
;  :rlimit-count            230575
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null ==> (forall k: Int :: { aloc(opt_get1(visited), k) } 0 <= k && k < V && k != s ==> aloc(opt_get1(visited), k).bool == false)
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1155
;  :arith-add-rows          390
;  :arith-assert-diseq      43
;  :arith-assert-lower      199
;  :arith-assert-upper      149
;  :arith-bound-prop        69
;  :arith-conflicts         29
;  :arith-eq-adapter        151
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        74
;  :arith-pivots            135
;  :conflicts               64
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 83
;  :datatype-occurs-check   130
;  :datatype-splits         49
;  :decisions               179
;  :del-clause              915
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.78
;  :minimized-lits          3
;  :mk-bool-var             1850
;  :mk-clause               949
;  :num-allocs              183286
;  :num-checks              71
;  :propagations            409
;  :quant-instantiations    376
;  :rlimit-count            231288)
; [then-branch: 38 | exc@29@02 == Null | live]
; [else-branch: 38 | exc@29@02 != Null | dead]
(push) ; 7
; [then-branch: 38 | exc@29@02 == Null]
; [eval] (forall k: Int :: { aloc(opt_get1(visited), k) } 0 <= k && k < V && k != s ==> aloc(opt_get1(visited), k).bool == false)
(declare-const k@43@02 Int)
(push) ; 8
; [eval] 0 <= k && k < V && k != s ==> aloc(opt_get1(visited), k).bool == false
; [eval] 0 <= k && k < V && k != s
; [eval] 0 <= k
(push) ; 9
; [then-branch: 39 | 0 <= k@43@02 | live]
; [else-branch: 39 | !(0 <= k@43@02) | live]
(push) ; 10
; [then-branch: 39 | 0 <= k@43@02]
(assert (<= 0 k@43@02))
; [eval] k < V
(push) ; 11
; [then-branch: 40 | k@43@02 < V@11@02 | live]
; [else-branch: 40 | !(k@43@02 < V@11@02) | live]
(push) ; 12
; [then-branch: 40 | k@43@02 < V@11@02]
(assert (< k@43@02 V@11@02))
; [eval] k != s
(pop) ; 12
(push) ; 12
; [else-branch: 40 | !(k@43@02 < V@11@02)]
(assert (not (< k@43@02 V@11@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 39 | !(0 <= k@43@02)]
(assert (not (<= 0 k@43@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 41 | k@43@02 != s@10@02 && k@43@02 < V@11@02 && 0 <= k@43@02 | live]
; [else-branch: 41 | !(k@43@02 != s@10@02 && k@43@02 < V@11@02 && 0 <= k@43@02) | live]
(push) ; 10
; [then-branch: 41 | k@43@02 != s@10@02 && k@43@02 < V@11@02 && 0 <= k@43@02]
(assert (and (and (not (= k@43@02 s@10@02)) (< k@43@02 V@11@02)) (<= 0 k@43@02)))
; [eval] aloc(opt_get1(visited), k).bool == false
; [eval] aloc(opt_get1(visited), k)
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
(assert (not (< k@43@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1156
;  :arith-add-rows          391
;  :arith-assert-diseq      46
;  :arith-assert-lower      202
;  :arith-assert-upper      149
;  :arith-bound-prop        69
;  :arith-conflicts         29
;  :arith-eq-adapter        152
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        74
;  :arith-pivots            135
;  :conflicts               64
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 83
;  :datatype-occurs-check   130
;  :datatype-splits         49
;  :decisions               179
;  :del-clause              915
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.78
;  :minimized-lits          3
;  :mk-bool-var             1857
;  :mk-clause               953
;  :num-allocs              183477
;  :num-checks              72
;  :propagations            409
;  :quant-instantiations    376
;  :rlimit-count            231605)
(assert (< k@43@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(pop) ; 11
; Joined path conditions
(assert (< k@43@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
      $Perm.Write
      $Perm.No)
    (-
      (ite
        (and
          (<
            (inv@33@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))
            V@11@02)
          (<=
            0
            (inv@33@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))))
        $Perm.Write
        $Perm.No)
      (pTaken@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1252
;  :arith-add-rows          406
;  :arith-assert-diseq      46
;  :arith-assert-lower      215
;  :arith-assert-upper      158
;  :arith-bound-prop        75
;  :arith-conflicts         31
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         67
;  :arith-offset-eqs        82
;  :arith-pivots            141
;  :conflicts               75
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 84
;  :datatype-occurs-check   130
;  :datatype-splits         49
;  :decisions               192
;  :del-clause              964
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.77
;  :minimized-lits          3
;  :mk-bool-var             1954
;  :mk-clause               1040
;  :num-allocs              184046
;  :num-checks              73
;  :propagations            492
;  :quant-instantiations    405
;  :rlimit-count            233617)
(pop) ; 10
(push) ; 10
; [else-branch: 41 | !(k@43@02 != s@10@02 && k@43@02 < V@11@02 && 0 <= k@43@02)]
(assert (not (and (and (not (= k@43@02 s@10@02)) (< k@43@02 V@11@02)) (<= 0 k@43@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (and (not (= k@43@02 s@10@02)) (< k@43@02 V@11@02)) (<= 0 k@43@02))
  (and
    (not (= k@43@02 s@10@02))
    (< k@43@02 V@11@02)
    (<= 0 k@43@02)
    (< k@43@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((k@43@02 Int)) (!
  (implies
    (and (and (not (= k@43@02 s@10@02)) (< k@43@02 V@11@02)) (<= 0 k@43@02))
    (and
      (not (= k@43@02 s@10@02))
      (< k@43@02 V@11@02)
      (<= 0 k@43@02)
      (< k@43@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (= exc@29@02 $Ref.null)
  (forall ((k@43@02 Int)) (!
    (implies
      (and (and (not (= k@43@02 s@10@02)) (< k@43@02 V@11@02)) (<= 0 k@43@02))
      (and
        (not (= k@43@02 s@10@02))
        (< k@43@02 V@11@02)
        (<= 0 k@43@02)
        (< k@43@02 (alen<Int> (opt_get1 $Snap.unit visited@9@02)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (= exc@29@02 $Ref.null)
  (forall ((k@43@02 Int)) (!
    (implies
      (and (and (not (= k@43@02 s@10@02)) (< k@43@02 V@11@02)) (<= 0 k@43@02))
      (=
        ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1321
;  :arith-add-rows          443
;  :arith-assert-diseq      49
;  :arith-assert-lower      232
;  :arith-assert-upper      167
;  :arith-bound-prop        84
;  :arith-conflicts         33
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        94
;  :arith-pivots            157
;  :conflicts               87
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 85
;  :datatype-occurs-check   130
;  :datatype-splits         49
;  :decisions               203
;  :del-clause              1101
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.79
;  :memory                  4.79
;  :minimized-lits          3
;  :mk-bool-var             2058
;  :mk-clause               1135
;  :num-allocs              184821
;  :num-checks              74
;  :propagations            566
;  :quant-instantiations    436
;  :rlimit-count            236465)
(assert (implies
  (= exc@29@02 $Ref.null)
  (forall ((k@43@02 Int)) (!
    (implies
      (and (and (not (= k@43@02 s@10@02)) (< k@43@02 V@11@02)) (<= 0 k@43@02))
      (=
        ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) k@43@02))
    :qid |prog.l<no position>|))))
; [eval] exc == null ==> aloc(opt_get1(visited), s).bool == true
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@29@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1338
;  :arith-add-rows          443
;  :arith-assert-diseq      49
;  :arith-assert-lower      232
;  :arith-assert-upper      167
;  :arith-bound-prop        84
;  :arith-conflicts         33
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        94
;  :arith-pivots            157
;  :conflicts               87
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   136
;  :datatype-splits         52
;  :decisions               211
;  :del-clause              1117
;  :final-checks            70
;  :max-generation          4
;  :max-memory              4.81
;  :memory                  4.80
;  :minimized-lits          3
;  :mk-bool-var             2074
;  :mk-clause               1151
;  :num-allocs              185754
;  :num-checks              75
;  :propagations            574
;  :quant-instantiations    438
;  :rlimit-count            237508)
; [then-branch: 42 | exc@29@02 == Null | live]
; [else-branch: 42 | exc@29@02 != Null | dead]
(push) ; 7
; [then-branch: 42 | exc@29@02 == Null]
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
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)))
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  $Perm.No
  (+
    (ite
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
      $Perm.Write
      $Perm.No)
    (-
      (ite
        (and
          (<
            (inv@33@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
            V@11@02)
          (<=
            0
            (inv@33@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))))
        $Perm.Write
        $Perm.No)
      (pTaken@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1338
;  :arith-add-rows          443
;  :arith-assert-diseq      49
;  :arith-assert-lower      233
;  :arith-assert-upper      167
;  :arith-bound-prop        84
;  :arith-conflicts         34
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        94
;  :arith-pivots            157
;  :conflicts               88
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   136
;  :datatype-splits         52
;  :decisions               211
;  :del-clause              1117
;  :final-checks            70
;  :max-generation          4
;  :max-memory              4.81
;  :memory                  4.79
;  :minimized-lits          3
;  :mk-bool-var             2075
;  :mk-clause               1151
;  :num-allocs              185996
;  :num-checks              76
;  :propagations            574
;  :quant-instantiations    438
;  :rlimit-count            237892)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (= exc@29@02 $Ref.null)
  ($FVF.loc_bool ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))))
(push) ; 6
(assert (not (implies
  (= exc@29@02 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
    true))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1338
;  :arith-add-rows          443
;  :arith-assert-diseq      49
;  :arith-assert-lower      233
;  :arith-assert-upper      167
;  :arith-bound-prop        84
;  :arith-conflicts         34
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        94
;  :arith-pivots            157
;  :conflicts               89
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   136
;  :datatype-splits         52
;  :decisions               211
;  :del-clause              1117
;  :final-checks            70
;  :max-generation          4
;  :max-memory              4.81
;  :memory                  4.79
;  :minimized-lits          3
;  :mk-bool-var             2075
;  :mk-clause               1151
;  :num-allocs              186130
;  :num-checks              77
;  :propagations            574
;  :quant-instantiations    438
;  :rlimit-count            238059)
(assert (implies
  (= exc@29@02 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@40@02  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@9@02) s@10@02))
    true)))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
