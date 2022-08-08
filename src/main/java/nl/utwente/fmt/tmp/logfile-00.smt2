(get-info :version)
; (:version "4.8.6")
; Started: 2022-06-14 20:18:16
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
(declare-sort Set<Seq<Seq<Int>>>)
(declare-sort Set<option<array>>)
(declare-sort Set<Seq<Int>>)
(declare-sort Set<Int>)
(declare-sort Set<Bool>)
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
(declare-sort $FVF<Seq<Seq<Int>>>)
(declare-sort $FVF<Seq<Int>>)
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
(declare-fun $SortWrappers.Set<Seq<Seq<Int>>>To$Snap (Set<Seq<Seq<Int>>>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Seq<Seq<Int>>> ($Snap) Set<Seq<Seq<Int>>>)
(assert (forall ((x Set<Seq<Seq<Int>>>)) (!
    (= x ($SortWrappers.$SnapToSet<Seq<Seq<Int>>>($SortWrappers.Set<Seq<Seq<Int>>>To$Snap x)))
    :pattern (($SortWrappers.Set<Seq<Seq<Int>>>To$Snap x))
    :qid |$Snap.$SnapToSet<Seq<Seq<Int>>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Seq<Seq<Int>>>To$Snap($SortWrappers.$SnapToSet<Seq<Seq<Int>>> x)))
    :pattern (($SortWrappers.$SnapToSet<Seq<Seq<Int>>> x))
    :qid |$Snap.Set<Seq<Seq<Int>>>To$SnapToSet<Seq<Seq<Int>>>|
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
(declare-fun $SortWrappers.Set<Seq<Int>>To$Snap (Set<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Seq<Int>> ($Snap) Set<Seq<Int>>)
(assert (forall ((x Set<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapToSet<Seq<Int>>($SortWrappers.Set<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.Set<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapToSet<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Seq<Int>>To$Snap($SortWrappers.$SnapToSet<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapToSet<Seq<Int>> x))
    :qid |$Snap.Set<Seq<Int>>To$SnapToSet<Seq<Int>>|
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
(declare-fun $SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap ($FVF<Seq<Seq<Int>>>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>> ($Snap) $FVF<Seq<Seq<Int>>>)
(assert (forall ((x $FVF<Seq<Seq<Int>>>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>>($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Seq<Seq<Int>>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap($SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>> x))
    :qid |$Snap.$FVF<Seq<Seq<Int>>>To$SnapTo$FVF<Seq<Seq<Int>>>|
    )))
(declare-fun $SortWrappers.$FVF<Seq<Int>>To$Snap ($FVF<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Seq<Int>> ($Snap) $FVF<Seq<Int>>)
(assert (forall ((x $FVF<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Seq<Int>>($SortWrappers.$FVF<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Seq<Int>>To$Snap($SortWrappers.$SnapTo$FVF<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Seq<Int>> x))
    :qid |$Snap.$FVF<Seq<Int>>To$SnapTo$FVF<Seq<Int>>|
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
(declare-fun Set_in (Seq<Seq<Int>> Set<Seq<Seq<Int>>>) Bool)
(declare-fun Set_card (Set<Seq<Seq<Int>>>) Int)
(declare-const Set_empty Set<Seq<Seq<Int>>>)
(declare-fun Set_singleton (Seq<Seq<Int>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_unionone (Set<Seq<Seq<Int>>> Seq<Seq<Int>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_union (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_disjoint (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Bool)
(declare-fun Set_difference (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_intersection (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_subset (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Bool)
(declare-fun Set_equal (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Bool)
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
(declare-fun Set_in (Seq<Int> Set<Seq<Int>>) Bool)
(declare-fun Set_card (Set<Seq<Int>>) Int)
(declare-const Set_empty Set<Seq<Int>>)
(declare-fun Set_singleton (Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_unionone (Set<Seq<Int>> Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_union (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_disjoint (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_difference (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_intersection (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_subset (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_equal (Set<Seq<Int>> Set<Seq<Int>>) Bool)
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
; /field_value_functions_declarations.smt2 [Gf_seq: Seq[Seq[Int]]]
(declare-fun $FVF.domain_Gf_seq ($FVF<Seq<Seq<Int>>>) Set<$Ref>)
(declare-fun $FVF.lookup_Gf_seq ($FVF<Seq<Seq<Int>>> $Ref) Seq<Seq<Int>>)
(declare-fun $FVF.after_Gf_seq ($FVF<Seq<Seq<Int>>> $FVF<Seq<Seq<Int>>>) Bool)
(declare-fun $FVF.loc_Gf_seq (Seq<Seq<Int>> $Ref) Bool)
(declare-fun $FVF.perm_Gf_seq ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Gf_seq $FVF<Seq<Seq<Int>>>)
; /field_value_functions_declarations.smt2 [P_seq: Seq[Int]]
(declare-fun $FVF.domain_P_seq ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_P_seq ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_P_seq ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_P_seq (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_P_seq ($FPM $Ref) $Perm)
(declare-const $fvfTOP_P_seq $FVF<Seq<Int>>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun valid_graph_vertices1 ($Snap $Ref Seq<Int> Int) Bool)
(declare-fun valid_graph_vertices1%limited ($Snap $Ref Seq<Int> Int) Bool)
(declare-fun valid_graph_vertices1%stateless ($Ref Seq<Int> Int) Bool)
(declare-fun SquareIntMatrix ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SquareIntMatrix%limited ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SquareIntMatrix%stateless ($Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SumOutgoingFlow ($Snap $Ref Seq<Seq<Int>> Int Int) Int)
(declare-fun SumOutgoingFlow%limited ($Snap $Ref Seq<Seq<Int>> Int Int) Int)
(declare-fun SumOutgoingFlow%stateless ($Ref Seq<Seq<Int>> Int Int) Bool)
(declare-fun SumIncomingFlow ($Snap $Ref Seq<Seq<Int>> Int Int) Int)
(declare-fun SumIncomingFlow%limited ($Snap $Ref Seq<Seq<Int>> Int Int) Int)
(declare-fun SumIncomingFlow%stateless ($Ref Seq<Seq<Int>> Int Int) Bool)
(declare-fun AugPath ($Snap $Ref Seq<Seq<Int>> Int Int Int Seq<Int>) Bool)
(declare-fun AugPath%limited ($Snap $Ref Seq<Seq<Int>> Int Int Int Seq<Int>) Bool)
(declare-fun AugPath%stateless ($Ref Seq<Seq<Int>> Int Int Int Seq<Int>) Bool)
(declare-fun aloc ($Snap array Int) $Ref)
(declare-fun aloc%limited ($Snap array Int) $Ref)
(declare-fun aloc%stateless (array Int) Bool)
(declare-fun opt_get1 ($Snap option<array>) array)
(declare-fun opt_get1%limited ($Snap option<array>) array)
(declare-fun opt_get1%stateless (option<array>) Bool)
(declare-fun NonNegativeCapacities ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun NonNegativeCapacities%limited ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun NonNegativeCapacities%stateless ($Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SkewSymetry ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SkewSymetry%limited ($Snap $Ref Seq<Seq<Int>> Int) Bool)
(declare-fun SkewSymetry%stateless ($Ref Seq<Seq<Int>> Int) Bool)
(declare-fun CapacityConstraint ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
(declare-fun CapacityConstraint%limited ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
(declare-fun CapacityConstraint%stateless ($Ref Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
(declare-fun FlowConservation ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowConservation%limited ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowConservation%stateless ($Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun any_as ($Snap any) any)
(declare-fun any_as%limited ($Snap any) any)
(declare-fun any_as%stateless (any) Bool)
(declare-fun opt_get ($Snap option<any>) any)
(declare-fun opt_get%limited ($Snap option<any>) any)
(declare-fun opt_get%stateless (option<any>) Bool)
(declare-fun ExAugPath ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun ExAugPath%limited ($Snap $Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun ExAugPath%stateless ($Ref Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun initializeSeqWithZeros ($Snap $Ref Seq<Int> Int) Seq<Int>)
(declare-fun initializeSeqWithZeros%limited ($Snap $Ref Seq<Int> Int) Seq<Int>)
(declare-fun initializeSeqWithZeros%stateless ($Ref Seq<Int> Int) Bool)
(declare-fun valid_graph_vertices ($Snap $Ref option<array> Int) Bool)
(declare-fun valid_graph_vertices%limited ($Snap $Ref option<array> Int) Bool)
(declare-fun valid_graph_vertices%stateless ($Ref option<array> Int) Bool)
(declare-fun FlowNetwork ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowNetwork%limited ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun FlowNetwork%stateless ($Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun scale ($Snap $Perm) $Perm)
(declare-fun scale%limited ($Snap $Perm) $Perm)
(declare-fun scale%stateless ($Perm) Bool)
(declare-fun Flow ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun Flow%limited ($Snap $Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun Flow%stateless ($Ref Seq<Seq<Int>> Seq<Seq<Int>> Int Int Int) Bool)
(declare-fun as_any ($Snap any) any)
(declare-fun as_any%limited ($Snap any) any)
(declare-fun as_any%stateless (any) Bool)
(declare-fun type ($Snap $Ref) Int)
(declare-fun type%limited ($Snap $Ref) Int)
(declare-fun type%stateless ($Ref) Bool)
(declare-fun opt_or_else ($Snap option<any> any) any)
(declare-fun opt_or_else%limited ($Snap option<any> any) any)
(declare-fun opt_or_else%stateless (option<any> any) Bool)
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
(assert (forall ((s Set<Seq<Seq<Int>>>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Seq[Int]]]_prog.card_non_negative|)))
(assert (forall ((e Seq<Seq<Int>>)) (!
  (not (Set_in e (as Set_empty  Set<Seq<Seq<Int>>>)))
  :pattern ((Set_in e (as Set_empty  Set<Seq<Seq<Int>>>)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_empty_set|)))
(assert (forall ((s Set<Seq<Seq<Int>>>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Seq<Seq<Int>>>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Seq<Seq<Int>>)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Seq[Int]]]_prog.empty_set_cardinality|)))
(assert (forall ((e Seq<Seq<Int>>)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_singleton_set|)))
(assert (forall ((e1 Seq<Seq<Int>>) (e2 Seq<Seq<Int>>)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_singleton_set_equality|)))
(assert (forall ((e Seq<Seq<Int>>)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Seq[Seq[Int]]]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_unionone_same|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e1 Seq<Seq<Int>>) (e2 Seq<Seq<Int>>)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_unionone_other|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e1 Seq<Seq<Int>>) (e2 Seq<Seq<Int>>)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Seq[Seq[Int]]]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Seq[Int]]]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Seq[Int]]]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_difference|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Seq<Seq<Int>>)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.subset_definition|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Seq<Seq<Int>>)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.equality_definition|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.native_equality|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Seq<Seq<Int>>)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
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
  :qid |$Set[Seq[Seq[Int]]]_prog.cardinality_difference|)))
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
(assert (forall ((s Set<Seq<Int>>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.card_non_negative|)))
(assert (forall ((e Seq<Int>)) (!
  (not (Set_in e (as Set_empty  Set<Seq<Int>>)))
  :pattern ((Set_in e (as Set_empty  Set<Seq<Int>>)))
  :qid |$Set[Seq[Int]]_prog.in_empty_set|)))
(assert (forall ((s Set<Seq<Int>>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Seq<Int>>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Seq<Int>)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.empty_set_cardinality|)))
(assert (forall ((e Seq<Int>)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set|)))
(assert (forall ((e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set_equality|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Seq[Int]]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Seq[Int]]_prog.in_unionone_same|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Seq[Int]]_prog.in_unionone_other|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Seq[Int]]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Seq<Int>)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Seq[Int]]_prog.subset_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Seq<Int>)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.equality_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.native_equality|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Seq<Int>)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Seq[Int]]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
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
  :qid |$Set[Seq[Int]]_prog.cardinality_difference|)))
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
; /field_value_functions_axioms.smt2 [Gf_seq: Seq[Seq[Int]]]
(assert (forall ((vs $FVF<Seq<Seq<Int>>>) (ws $FVF<Seq<Seq<Int>>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Gf_seq vs) ($FVF.domain_Gf_seq ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Gf_seq vs))
            (= ($FVF.lookup_Gf_seq vs x) ($FVF.lookup_Gf_seq ws x)))
          :pattern (($FVF.lookup_Gf_seq vs x) ($FVF.lookup_Gf_seq ws x))
          :qid |qp.$FVF<Seq<Seq<Int>>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Seq<Int>>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Gf_seq pm r))
    :pattern ($FVF.perm_Gf_seq pm r))))
(assert (forall ((r $Ref) (f Seq<Seq<Int>>)) (!
    (= ($FVF.loc_Gf_seq f r) true)
    :pattern ($FVF.loc_Gf_seq f r))))
; /field_value_functions_axioms.smt2 [P_seq: Seq[Int]]
(assert (forall ((vs $FVF<Seq<Int>>) (ws $FVF<Seq<Int>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_P_seq vs) ($FVF.domain_P_seq ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_P_seq vs))
            (= ($FVF.lookup_P_seq vs x) ($FVF.lookup_P_seq ws x)))
          :pattern (($FVF.lookup_P_seq vs x) ($FVF.lookup_P_seq ws x))
          :qid |qp.$FVF<Seq<Int>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Int>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Int>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_P_seq pm r))
    :pattern ($FVF.perm_P_seq pm r))))
(assert (forall ((r $Ref) (f Seq<Int>)) (!
    (= ($FVF.loc_P_seq f r) true)
    :pattern ($FVF.loc_P_seq f r))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ---------- FUNCTION valid_graph_vertices1----------
(declare-fun this@0@00 () $Ref)
(declare-fun p@1@00 () Seq<Int>)
(declare-fun V@2@00 () Int)
(declare-fun result@3@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] this != null
(assert (not (= this@0@00 $Ref.null)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@0@00 $Ref) (p@1@00 Seq<Int>) (V@2@00 Int)) (!
  (=
    (valid_graph_vertices1%limited s@$ this@0@00 p@1@00 V@2@00)
    (valid_graph_vertices1 s@$ this@0@00 p@1@00 V@2@00))
  :pattern ((valid_graph_vertices1 s@$ this@0@00 p@1@00 V@2@00))
  )))
(assert (forall ((s@$ $Snap) (this@0@00 $Ref) (p@1@00 Seq<Int>) (V@2@00 Int)) (!
  (valid_graph_vertices1%stateless this@0@00 p@1@00 V@2@00)
  :pattern ((valid_graph_vertices1%limited s@$ this@0@00 p@1@00 V@2@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ $Snap.unit))
(assert (not (= this@0@00 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (forall unknown: Int :: { p[unknown] } 0 <= unknown && unknown < |p| ==> 0 <= p[unknown]) && (forall unknown: Int :: { p[unknown] } 0 <= unknown && unknown < |p| ==> p[unknown] < V)
; [eval] (forall unknown: Int :: { p[unknown] } 0 <= unknown && unknown < |p| ==> 0 <= p[unknown])
(declare-const unknown@93@00 Int)
(push) ; 2
; [eval] 0 <= unknown && unknown < |p| ==> 0 <= p[unknown]
; [eval] 0 <= unknown && unknown < |p|
; [eval] 0 <= unknown
(push) ; 3
; [then-branch: 0 | 0 <= unknown@93@00 | live]
; [else-branch: 0 | !(0 <= unknown@93@00) | live]
(push) ; 4
; [then-branch: 0 | 0 <= unknown@93@00]
(assert (<= 0 unknown@93@00))
; [eval] unknown < |p|
; [eval] |p|
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= unknown@93@00)]
(assert (not (<= 0 unknown@93@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | unknown@93@00 < |p@1@00| && 0 <= unknown@93@00 | live]
; [else-branch: 1 | !(unknown@93@00 < |p@1@00| && 0 <= unknown@93@00) | live]
(push) ; 4
; [then-branch: 1 | unknown@93@00 < |p@1@00| && 0 <= unknown@93@00]
(assert (and (< unknown@93@00 (Seq_length p@1@00)) (<= 0 unknown@93@00)))
; [eval] 0 <= p[unknown]
; [eval] p[unknown]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= unknown@93@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             3
;  :arith-assert-diseq    1
;  :arith-assert-lower    5
;  :arith-assert-upper    3
;  :arith-bound-prop      1
;  :arith-eq-adapter      3
;  :arith-pivots          1
;  :datatype-accessor-ax  1
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.07
;  :mk-bool-var           352
;  :mk-clause             4
;  :num-allocs            148362
;  :num-checks            2
;  :propagations          1
;  :quant-instantiations  4
;  :rlimit-count          164739)
(pop) ; 4
(push) ; 4
; [else-branch: 1 | !(unknown@93@00 < |p@1@00| && 0 <= unknown@93@00)]
(assert (not (and (< unknown@93@00 (Seq_length p@1@00)) (<= 0 unknown@93@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 2
; [then-branch: 2 | QA unknown@93@00 :: unknown@93@00 < |p@1@00| && 0 <= unknown@93@00 ==> 0 <= p@1@00[unknown@93@00] | live]
; [else-branch: 2 | !(QA unknown@93@00 :: unknown@93@00 < |p@1@00| && 0 <= unknown@93@00 ==> 0 <= p@1@00[unknown@93@00]) | live]
(push) ; 3
; [then-branch: 2 | QA unknown@93@00 :: unknown@93@00 < |p@1@00| && 0 <= unknown@93@00 ==> 0 <= p@1@00[unknown@93@00]]
(assert (forall ((unknown@93@00 Int)) (!
  (implies
    (and (< unknown@93@00 (Seq_length p@1@00)) (<= 0 unknown@93@00))
    (<= 0 (Seq_index p@1@00 unknown@93@00)))
  :pattern ((Seq_index p@1@00 unknown@93@00))
  :qid |prog.l<no position>|)))
; [eval] (forall unknown: Int :: { p[unknown] } 0 <= unknown && unknown < |p| ==> p[unknown] < V)
(declare-const unknown@94@00 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < |p| ==> p[unknown] < V
; [eval] 0 <= unknown && unknown < |p|
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 3 | 0 <= unknown@94@00 | live]
; [else-branch: 3 | !(0 <= unknown@94@00) | live]
(push) ; 6
; [then-branch: 3 | 0 <= unknown@94@00]
(assert (<= 0 unknown@94@00))
; [eval] unknown < |p|
; [eval] |p|
(pop) ; 6
(push) ; 6
; [else-branch: 3 | !(0 <= unknown@94@00)]
(assert (not (<= 0 unknown@94@00)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 4 | unknown@94@00 < |p@1@00| && 0 <= unknown@94@00 | live]
; [else-branch: 4 | !(unknown@94@00 < |p@1@00| && 0 <= unknown@94@00) | live]
(push) ; 6
; [then-branch: 4 | unknown@94@00 < |p@1@00| && 0 <= unknown@94@00]
(assert (and (< unknown@94@00 (Seq_length p@1@00)) (<= 0 unknown@94@00)))
; [eval] p[unknown] < V
; [eval] p[unknown]
(push) ; 7
(assert (not (>= unknown@94@00 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             3
;  :arith-assert-diseq    2
;  :arith-assert-lower    9
;  :arith-assert-upper    3
;  :arith-bound-prop      2
;  :arith-eq-adapter      4
;  :arith-pivots          3
;  :datatype-accessor-ax  1
;  :datatype-occurs-check 1
;  :del-clause            4
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.07
;  :mk-bool-var           359
;  :mk-clause             8
;  :num-allocs            148724
;  :num-checks            3
;  :propagations          2
;  :quant-instantiations  6
;  :rlimit-count          165215)
(pop) ; 6
(push) ; 6
; [else-branch: 4 | !(unknown@94@00 < |p@1@00| && 0 <= unknown@94@00)]
(assert (not (and (< unknown@94@00 (Seq_length p@1@00)) (<= 0 unknown@94@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 3
(push) ; 3
; [else-branch: 2 | !(QA unknown@93@00 :: unknown@93@00 < |p@1@00| && 0 <= unknown@93@00 ==> 0 <= p@1@00[unknown@93@00])]
(assert (not
  (forall ((unknown@93@00 Int)) (!
    (implies
      (and (< unknown@93@00 (Seq_length p@1@00)) (<= 0 unknown@93@00))
      (<= 0 (Seq_index p@1@00 unknown@93@00)))
    :pattern ((Seq_index p@1@00 unknown@93@00))
    :qid |prog.l<no position>|))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (=
  result@3@00
  (and
    (forall ((unknown@94@00 Int)) (!
      (implies
        (and (< unknown@94@00 (Seq_length p@1@00)) (<= 0 unknown@94@00))
        (< (Seq_index p@1@00 unknown@94@00) V@2@00))
      :pattern ((Seq_index p@1@00 unknown@94@00))
      :qid |prog.l<no position>|))
    (forall ((unknown@93@00 Int)) (!
      (implies
        (and (< unknown@93@00 (Seq_length p@1@00)) (<= 0 unknown@93@00))
        (<= 0 (Seq_index p@1@00 unknown@93@00)))
      :pattern ((Seq_index p@1@00 unknown@93@00))
      :qid |prog.l<no position>|)))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@0@00 $Ref) (p@1@00 Seq<Int>) (V@2@00 Int)) (!
  (implies
    (not (= this@0@00 $Ref.null))
    (=
      (valid_graph_vertices1 s@$ this@0@00 p@1@00 V@2@00)
      (and
        (forall ((unknown_ Int)) (!
          (implies
            (and (<= 0 unknown_) (< unknown_ (Seq_length p@1@00)))
            (<= 0 (Seq_index p@1@00 unknown_)))
          :pattern ((Seq_index p@1@00 unknown_))
          ))
        (forall ((unknown_ Int)) (!
          (implies
            (and (<= 0 unknown_) (< unknown_ (Seq_length p@1@00)))
            (< (Seq_index p@1@00 unknown_) V@2@00))
          :pattern ((Seq_index p@1@00 unknown_))
          )))))
  :pattern ((valid_graph_vertices1 s@$ this@0@00 p@1@00 V@2@00))
  )))
; ---------- FUNCTION SquareIntMatrix----------
(declare-fun this@4@00 () $Ref)
(declare-fun G@5@00 () Seq<Seq<Int>>)
(declare-fun V@6@00 () Int)
(declare-fun result@7@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] this != null
(assert (not (= this@4@00 $Ref.null)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@4@00 $Ref) (G@5@00 Seq<Seq<Int>>) (V@6@00 Int)) (!
  (=
    (SquareIntMatrix%limited s@$ this@4@00 G@5@00 V@6@00)
    (SquareIntMatrix s@$ this@4@00 G@5@00 V@6@00))
  :pattern ((SquareIntMatrix s@$ this@4@00 G@5@00 V@6@00))
  )))
(assert (forall ((s@$ $Snap) (this@4@00 $Ref) (G@5@00 Seq<Seq<Int>>) (V@6@00 Int)) (!
  (SquareIntMatrix%stateless this@4@00 G@5@00 V@6@00)
  :pattern ((SquareIntMatrix%limited s@$ this@4@00 G@5@00 V@6@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ $Snap.unit))
(assert (not (= this@4@00 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] |G| == V && (forall e: Seq[Int] :: { (e in G) } { |e| } (e in G) ==> |e| == V)
; [eval] |G| == V
; [eval] |G|
(push) ; 2
; [then-branch: 5 | |G@5@00| == V@6@00 | live]
; [else-branch: 5 | |G@5@00| != V@6@00 | live]
(push) ; 3
; [then-branch: 5 | |G@5@00| == V@6@00]
(assert (= (Seq_length G@5@00) V@6@00))
; [eval] (forall e: Seq[Int] :: { (e in G) } { |e| } (e in G) ==> |e| == V)
(declare-const e@95@00 Seq<Int>)
(push) ; 4
; [eval] (e in G) ==> |e| == V
; [eval] (e in G)
(push) ; 5
; [then-branch: 6 | e@95@00 in G@5@00 | live]
; [else-branch: 6 | !(e@95@00 in G@5@00) | live]
(push) ; 6
; [then-branch: 6 | e@95@00 in G@5@00]
(assert (Seq_contains G@5@00 e@95@00))
; [eval] |e| == V
; [eval] |e|
(pop) ; 6
(push) ; 6
; [else-branch: 6 | !(e@95@00 in G@5@00)]
(assert (not (Seq_contains G@5@00 e@95@00)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 3
(push) ; 3
; [else-branch: 5 | |G@5@00| != V@6@00]
(assert (not (= (Seq_length G@5@00) V@6@00)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (=
  result@7@00
  (and
    (forall ((e@95@00 Seq<Int>)) (!
      (implies (Seq_contains G@5@00 e@95@00) (= (Seq_length e@95@00) V@6@00))
      :pattern ((Seq_contains G@5@00 e@95@00))
      :pattern ((Seq_length e@95@00))
      :qid |prog.l<no position>|))
    (= (Seq_length G@5@00) V@6@00))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@4@00 $Ref) (G@5@00 Seq<Seq<Int>>) (V@6@00 Int)) (!
  (implies
    (not (= this@4@00 $Ref.null))
    (=
      (SquareIntMatrix s@$ this@4@00 G@5@00 V@6@00)
      (and
        (= (Seq_length G@5@00) V@6@00)
        (forall ((e Seq<Int>)) (!
          (implies (Seq_contains G@5@00 e) (= (Seq_length e) V@6@00))
          :pattern ((Seq_contains G@5@00 e))
          :pattern ((Seq_length e))
          )))))
  :pattern ((SquareIntMatrix s@$ this@4@00 G@5@00 V@6@00))
  )))
; ---------- FUNCTION SumOutgoingFlow----------
(declare-fun this@8@00 () $Ref)
(declare-fun G@9@00 () Seq<Seq<Int>>)
(declare-fun n@10@00 () Int)
(declare-fun v@11@00 () Int)
(declare-fun result@12@00 () Int)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@8@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] 0 <= n
(assert (<= 0 n@10@00))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] n < |G| + 1
; [eval] |G| + 1
; [eval] |G|
(assert (< n@10@00 (+ (Seq_length G@9@00) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second s@$)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
; [eval] 0 <= v
(assert (<= 0 v@11@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
; [eval] v < |G| + 1
; [eval] |G| + 1
; [eval] |G|
(assert (< v@11@00 (+ (Seq_length G@9@00) 1)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@8@00 $Ref) (G@9@00 Seq<Seq<Int>>) (n@10@00 Int) (v@11@00 Int)) (!
  (=
    (SumOutgoingFlow%limited s@$ this@8@00 G@9@00 n@10@00 v@11@00)
    (SumOutgoingFlow s@$ this@8@00 G@9@00 n@10@00 v@11@00))
  :pattern ((SumOutgoingFlow s@$ this@8@00 G@9@00 n@10@00 v@11@00))
  )))
(assert (forall ((s@$ $Snap) (this@8@00 $Ref) (G@9@00 Seq<Seq<Int>>) (n@10@00 Int) (v@11@00 Int)) (!
  (SumOutgoingFlow%stateless this@8@00 G@9@00 n@10@00 v@11@00)
  :pattern ((SumOutgoingFlow%limited s@$ this@8@00 G@9@00 n@10@00 v@11@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@8@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (<= 0 n@10@00))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (< n@10@00 (+ (Seq_length G@9@00) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second s@$)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
(assert (<= 0 v@11@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
(assert (< v@11@00 (+ (Seq_length G@9@00) 1)))
; State saturation: after contract
(check-sat)
; unknown
; [eval] (0 < n ? G[v][n] + SumOutgoingFlow(this, G, n - 1, v) : 0)
; [eval] 0 < n
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 n@10@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             30
;  :arith-add-rows        2
;  :arith-assert-diseq    4
;  :arith-assert-lower    17
;  :arith-assert-upper    4
;  :arith-bound-prop      3
;  :arith-eq-adapter      6
;  :arith-pivots          7
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 4
;  :decisions             1
;  :del-clause            12
;  :final-checks          4
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           391
;  :mk-clause             15
;  :num-allocs            152069
;  :num-checks            6
;  :propagations          4
;  :quant-instantiations  10
;  :rlimit-count          169828)
(push) ; 3
(assert (not (< 0 n@10@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             32
;  :arith-add-rows        2
;  :arith-assert-diseq    5
;  :arith-assert-lower    18
;  :arith-assert-upper    5
;  :arith-bound-prop      3
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :arith-offset-eqs      1
;  :arith-pivots          8
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 5
;  :decisions             2
;  :del-clause            12
;  :final-checks          5
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           392
;  :mk-clause             15
;  :num-allocs            152509
;  :num-checks            7
;  :propagations          5
;  :quant-instantiations  10
;  :rlimit-count          170277)
; [then-branch: 7 | 0 < n@10@00 | live]
; [else-branch: 7 | !(0 < n@10@00) | live]
(push) ; 3
; [then-branch: 7 | 0 < n@10@00]
(assert (< 0 n@10@00))
; [eval] G[v][n] + SumOutgoingFlow(this, G, n - 1, v)
; [eval] G[v][n]
; [eval] G[v]
(set-option :timeout 0)
(push) ; 4
(assert (not (>= v@11@00 0)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             32
;  :arith-add-rows        2
;  :arith-assert-diseq    6
;  :arith-assert-lower    20
;  :arith-assert-upper    5
;  :arith-bound-prop      4
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :arith-offset-eqs      1
;  :arith-pivots          8
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 5
;  :decisions             2
;  :del-clause            12
;  :final-checks          5
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           393
;  :mk-clause             16
;  :num-allocs            152591
;  :num-checks            8
;  :propagations          6
;  :quant-instantiations  10
;  :rlimit-count          170357)
(push) ; 4
(assert (not (< v@11@00 (Seq_length G@9@00))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             34
;  :arith-add-rows        2
;  :arith-assert-diseq    6
;  :arith-assert-lower    21
;  :arith-assert-upper    5
;  :arith-bound-prop      4
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       2
;  :arith-offset-eqs      2
;  :arith-pivots          9
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 6
;  :decisions             2
;  :del-clause            12
;  :final-checks          6
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           394
;  :mk-clause             16
;  :num-allocs            153034
;  :num-checks            9
;  :propagations          6
;  :quant-instantiations  10
;  :rlimit-count          170828)
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- FUNCTION SumIncomingFlow----------
(declare-fun this@13@00 () $Ref)
(declare-fun G@14@00 () Seq<Seq<Int>>)
(declare-fun n@15@00 () Int)
(declare-fun v@16@00 () Int)
(declare-fun result@17@00 () Int)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@13@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] 0 <= n
(assert (<= 0 n@15@00))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] n < |G| + 1
; [eval] |G| + 1
; [eval] |G|
(assert (< n@15@00 (+ (Seq_length G@14@00) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second s@$)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
; [eval] 0 <= v
(assert (<= 0 v@16@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
; [eval] v < |G| + 1
; [eval] |G| + 1
; [eval] |G|
(assert (< v@16@00 (+ (Seq_length G@14@00) 1)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@13@00 $Ref) (G@14@00 Seq<Seq<Int>>) (n@15@00 Int) (v@16@00 Int)) (!
  (=
    (SumIncomingFlow%limited s@$ this@13@00 G@14@00 n@15@00 v@16@00)
    (SumIncomingFlow s@$ this@13@00 G@14@00 n@15@00 v@16@00))
  :pattern ((SumIncomingFlow s@$ this@13@00 G@14@00 n@15@00 v@16@00))
  )))
(assert (forall ((s@$ $Snap) (this@13@00 $Ref) (G@14@00 Seq<Seq<Int>>) (n@15@00 Int) (v@16@00 Int)) (!
  (SumIncomingFlow%stateless this@13@00 G@14@00 n@15@00 v@16@00)
  :pattern ((SumIncomingFlow%limited s@$ this@13@00 G@14@00 n@15@00 v@16@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@13@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (<= 0 n@15@00))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (< n@15@00 (+ (Seq_length G@14@00) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second s@$)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
(assert (<= 0 v@16@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
(assert (< v@16@00 (+ (Seq_length G@14@00) 1)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (0 < n ? G[n][v] + SumIncomingFlow(this, G, n - 1, v) : 0)
; [eval] 0 < n
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 n@15@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             59
;  :arith-add-rows        4
;  :arith-assert-diseq    8
;  :arith-assert-lower    28
;  :arith-assert-upper    6
;  :arith-bound-prop      5
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       2
;  :arith-offset-eqs      2
;  :arith-pivots          13
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 8
;  :decisions             3
;  :del-clause            17
;  :final-checks          8
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           415
;  :mk-clause             20
;  :num-allocs            154444
;  :num-checks            11
;  :propagations          8
;  :quant-instantiations  12
;  :rlimit-count          172819)
(push) ; 3
(assert (not (< 0 n@15@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             61
;  :arith-add-rows        4
;  :arith-assert-diseq    9
;  :arith-assert-lower    29
;  :arith-assert-upper    7
;  :arith-bound-prop      5
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       3
;  :arith-offset-eqs      3
;  :arith-pivots          14
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 9
;  :decisions             4
;  :del-clause            17
;  :final-checks          9
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           416
;  :mk-clause             20
;  :num-allocs            154880
;  :num-checks            12
;  :propagations          9
;  :quant-instantiations  12
;  :rlimit-count          173270)
; [then-branch: 8 | 0 < n@15@00 | live]
; [else-branch: 8 | !(0 < n@15@00) | live]
(push) ; 3
; [then-branch: 8 | 0 < n@15@00]
(assert (< 0 n@15@00))
; [eval] G[n][v] + SumIncomingFlow(this, G, n - 1, v)
; [eval] G[n][v]
; [eval] G[n]
(set-option :timeout 0)
(push) ; 4
(assert (not (>= n@15@00 0)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             61
;  :arith-add-rows        4
;  :arith-assert-diseq    10
;  :arith-assert-lower    31
;  :arith-assert-upper    7
;  :arith-bound-prop      6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       3
;  :arith-offset-eqs      3
;  :arith-pivots          14
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 9
;  :decisions             4
;  :del-clause            17
;  :final-checks          9
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           417
;  :mk-clause             21
;  :num-allocs            154962
;  :num-checks            13
;  :propagations          10
;  :quant-instantiations  12
;  :rlimit-count          173350)
(push) ; 4
(assert (not (< n@15@00 (Seq_length G@14@00))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             63
;  :arith-add-rows        5
;  :arith-assert-diseq    10
;  :arith-assert-lower    31
;  :arith-assert-upper    8
;  :arith-bound-prop      6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       4
;  :arith-offset-eqs      4
;  :arith-pivots          15
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 10
;  :decisions             4
;  :del-clause            17
;  :final-checks          10
;  :max-generation        1
;  :max-memory            4.38
;  :memory                4.12
;  :mk-bool-var           418
;  :mk-clause             21
;  :num-allocs            155401
;  :num-checks            14
;  :propagations          10
;  :quant-instantiations  12
;  :rlimit-count          173834)
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- FUNCTION AugPath----------
(declare-fun this@18@00 () $Ref)
(declare-fun G@19@00 () Seq<Seq<Int>>)
(declare-fun V@20@00 () Int)
(declare-fun s@21@00 () Int)
(declare-fun t@22@00 () Int)
(declare-fun P@23@00 () Seq<Int>)
(declare-fun result@24@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@18@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] SquareIntMatrix(this, G, V)
(push) ; 2
; [eval] this != null
(pop) ; 2
; Joined path conditions
(assert (SquareIntMatrix $Snap.unit this@18@00 G@19@00 V@20@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@18@00 $Ref) (G@19@00 Seq<Seq<Int>>) (V@20@00 Int) (s@21@00 Int) (t@22@00 Int) (P@23@00 Seq<Int>)) (!
  (=
    (AugPath%limited s@$ this@18@00 G@19@00 V@20@00 s@21@00 t@22@00 P@23@00)
    (AugPath s@$ this@18@00 G@19@00 V@20@00 s@21@00 t@22@00 P@23@00))
  :pattern ((AugPath s@$ this@18@00 G@19@00 V@20@00 s@21@00 t@22@00 P@23@00))
  )))
(assert (forall ((s@$ $Snap) (this@18@00 $Ref) (G@19@00 Seq<Seq<Int>>) (V@20@00 Int) (s@21@00 Int) (t@22@00 Int) (P@23@00 Seq<Int>)) (!
  (AugPath%stateless this@18@00 G@19@00 V@20@00 s@21@00 t@22@00 P@23@00)
  :pattern ((AugPath%limited s@$ this@18@00 G@19@00 V@20@00 s@21@00 t@22@00 P@23@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@18@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (SquareIntMatrix $Snap.unit this@18@00 G@19@00 V@20@00))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> P[0] != P[|P| - 1]) && (0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> valid_graph_vertices1(this, P, V)) && ((0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> (forall unknown: Int :: { P[unknown] } 0 <= unknown && unknown < |P| ==> 0 <= P[unknown])) && (0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> (forall unknown: Int :: { P[unknown] } 0 <= unknown && unknown < |P| ==> P[unknown] < V))) && (0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> (forall j: Int :: { G[P[j]] } 0 <= j && j < |P| - 1 ==> 0 < G[P[j]][P[j + 1]]))
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> P[0] != P[|P| - 1]
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P|
; [eval] 0 <= s
(push) ; 2
; [then-branch: 9 | 0 <= s@21@00 | live]
; [else-branch: 9 | !(0 <= s@21@00) | live]
(push) ; 3
; [then-branch: 9 | 0 <= s@21@00]
(assert (<= 0 s@21@00))
; [eval] s < V
(push) ; 4
; [then-branch: 10 | s@21@00 < V@20@00 | live]
; [else-branch: 10 | !(s@21@00 < V@20@00) | live]
(push) ; 5
; [then-branch: 10 | s@21@00 < V@20@00]
(assert (< s@21@00 V@20@00))
; [eval] 0 <= t
(push) ; 6
; [then-branch: 11 | 0 <= t@22@00 | live]
; [else-branch: 11 | !(0 <= t@22@00) | live]
(push) ; 7
; [then-branch: 11 | 0 <= t@22@00]
(assert (<= 0 t@22@00))
; [eval] t < V
(push) ; 8
; [then-branch: 12 | t@22@00 < V@20@00 | live]
; [else-branch: 12 | !(t@22@00 < V@20@00) | live]
(push) ; 9
; [then-branch: 12 | t@22@00 < V@20@00]
(assert (< t@22@00 V@20@00))
; [eval] 1 < |P|
; [eval] |P|
(pop) ; 9
(push) ; 9
; [else-branch: 12 | !(t@22@00 < V@20@00)]
(assert (not (< t@22@00 V@20@00)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 11 | !(0 <= t@22@00)]
(assert (not (<= 0 t@22@00)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 10 | !(s@21@00 < V@20@00)]
(assert (not (< s@21@00 V@20@00)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 9 | !(0 <= s@21@00)]
(assert (not (<= 0 s@21@00)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             84
;  :arith-add-rows        20
;  :arith-assert-diseq    22
;  :arith-assert-lower    52
;  :arith-assert-upper    9
;  :arith-bound-prop      10
;  :arith-eq-adapter      12
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          20
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 12
;  :decisions             7
;  :del-clause            73
;  :final-checks          12
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.15
;  :mk-bool-var           502
;  :mk-clause             83
;  :num-allocs            157660
;  :num-checks            16
;  :propagations          35
;  :quant-instantiations  25
;  :rlimit-count          176871)
(push) ; 3
(assert (not (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             85
;  :arith-add-rows        24
;  :arith-assert-diseq    28
;  :arith-assert-lower    58
;  :arith-assert-upper    10
;  :arith-bound-prop      11
;  :arith-eq-adapter      14
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          20
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 13
;  :decisions             11
;  :del-clause            99
;  :final-checks          13
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.15
;  :mk-bool-var           533
;  :mk-clause             109
;  :num-allocs            158298
;  :num-checks            17
;  :propagations          46
;  :quant-instantiations  30
;  :rlimit-count          177893)
; [then-branch: 13 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 | live]
; [else-branch: 13 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00) | live]
(push) ; 3
; [then-branch: 13 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00]
(assert (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00)))
; [eval] P[0] != P[|P| - 1]
; [eval] P[0]
(set-option :timeout 0)
(push) ; 4
(assert (not (< 0 (Seq_length P@23@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             86
;  :arith-add-rows        27
;  :arith-assert-diseq    32
;  :arith-assert-lower    67
;  :arith-assert-upper    10
;  :arith-bound-prop      12
;  :arith-eq-adapter      16
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          20
;  :conflicts             1
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 13
;  :decisions             11
;  :del-clause            99
;  :final-checks          13
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.15
;  :mk-bool-var           555
;  :mk-clause             126
;  :num-allocs            158568
;  :num-checks            18
;  :propagations          53
;  :quant-instantiations  34
;  :rlimit-count          178365)
; [eval] P[|P| - 1]
; [eval] |P| - 1
; [eval] |P|
(push) ; 4
(assert (not (>= (- (Seq_length P@23@00) 1) 0)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             86
;  :arith-add-rows        27
;  :arith-assert-diseq    32
;  :arith-assert-lower    67
;  :arith-assert-upper    11
;  :arith-bound-prop      12
;  :arith-conflicts       1
;  :arith-eq-adapter      16
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          20
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 13
;  :decisions             11
;  :del-clause            99
;  :final-checks          13
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.15
;  :mk-bool-var           556
;  :mk-clause             126
;  :num-allocs            158659
;  :num-checks            19
;  :propagations          53
;  :quant-instantiations  34
;  :rlimit-count          178443)
(push) ; 4
(assert (not (< (- (Seq_length P@23@00) 1) (Seq_length P@23@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             86
;  :arith-add-rows        27
;  :arith-assert-diseq    32
;  :arith-assert-lower    67
;  :arith-assert-upper    11
;  :arith-bound-prop      12
;  :arith-conflicts       1
;  :arith-eq-adapter      16
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          20
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 13
;  :decisions             11
;  :del-clause            99
;  :final-checks          13
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.15
;  :mk-bool-var           556
;  :mk-clause             126
;  :num-allocs            158691
;  :num-checks            20
;  :propagations          53
;  :quant-instantiations  34
;  :rlimit-count          178466)
(pop) ; 3
(push) ; 3
; [else-branch: 13 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00)]
(assert (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))
  (and
    (< 1 (Seq_length P@23@00))
    (< t@22@00 V@20@00)
    (<= 0 t@22@00)
    (< s@21@00 V@20@00)
    (<= 0 s@21@00))))
; Joined path conditions
(push) ; 2
; [then-branch: 14 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> P@23@00[0] != P@23@00[|P@23@00| - 1] | live]
; [else-branch: 14 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> P@23@00[0] != P@23@00[|P@23@00| - 1]) | live]
(push) ; 3
; [then-branch: 14 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> P@23@00[0] != P@23@00[|P@23@00| - 1]]
(assert (implies
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))
  (not (= (Seq_index P@23@00 0) (Seq_index P@23@00 (- (Seq_length P@23@00) 1))))))
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> valid_graph_vertices1(this, P, V)
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P|
; [eval] 0 <= s
(push) ; 4
; [then-branch: 15 | 0 <= s@21@00 | live]
; [else-branch: 15 | !(0 <= s@21@00) | live]
(push) ; 5
; [then-branch: 15 | 0 <= s@21@00]
(assert (<= 0 s@21@00))
; [eval] s < V
(push) ; 6
; [then-branch: 16 | s@21@00 < V@20@00 | live]
; [else-branch: 16 | !(s@21@00 < V@20@00) | live]
(push) ; 7
; [then-branch: 16 | s@21@00 < V@20@00]
(assert (< s@21@00 V@20@00))
; [eval] 0 <= t
(push) ; 8
; [then-branch: 17 | 0 <= t@22@00 | live]
; [else-branch: 17 | !(0 <= t@22@00) | live]
(push) ; 9
; [then-branch: 17 | 0 <= t@22@00]
(assert (<= 0 t@22@00))
; [eval] t < V
(push) ; 10
; [then-branch: 18 | t@22@00 < V@20@00 | live]
; [else-branch: 18 | !(t@22@00 < V@20@00) | live]
(push) ; 11
; [then-branch: 18 | t@22@00 < V@20@00]
(assert (< t@22@00 V@20@00))
; [eval] 1 < |P|
; [eval] |P|
(pop) ; 11
(push) ; 11
; [else-branch: 18 | !(t@22@00 < V@20@00)]
(assert (not (< t@22@00 V@20@00)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 17 | !(0 <= t@22@00)]
(assert (not (<= 0 t@22@00)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 16 | !(s@21@00 < V@20@00)]
(assert (not (< s@21@00 V@20@00)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 15 | !(0 <= s@21@00)]
(assert (not (<= 0 s@21@00)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             87
;  :arith-add-rows        32
;  :arith-assert-diseq    41
;  :arith-assert-lower    83
;  :arith-assert-upper    11
;  :arith-bound-prop      14
;  :arith-conflicts       1
;  :arith-eq-adapter      18
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          23
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 14
;  :decisions             13
;  :del-clause            147
;  :final-checks          14
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.16
;  :mk-bool-var           595
;  :mk-clause             158
;  :num-allocs            159733
;  :num-checks            21
;  :propagations          70
;  :quant-instantiations  40
;  :rlimit-count          180341)
(push) ; 5
(assert (not (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             87
;  :arith-add-rows        32
;  :arith-assert-diseq    44
;  :arith-assert-lower    85
;  :arith-assert-upper    12
;  :arith-bound-prop      15
;  :arith-conflicts       1
;  :arith-eq-adapter      18
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          24
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 15
;  :decisions             15
;  :del-clause            157
;  :final-checks          15
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.15
;  :mk-bool-var           603
;  :mk-clause             168
;  :num-allocs            160238
;  :num-checks            22
;  :propagations          76
;  :quant-instantiations  41
;  :rlimit-count          181105)
; [then-branch: 19 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 | live]
; [else-branch: 19 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00) | live]
(push) ; 5
; [then-branch: 19 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00]
(assert (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00)))
; [eval] valid_graph_vertices1(this, P, V)
(push) ; 6
; [eval] this != null
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 19 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00)]
(assert (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 20 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> valid_graph_vertices1(_, this@18@00, P@23@00, V@20@00) | live]
; [else-branch: 20 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> valid_graph_vertices1(_, this@18@00, P@23@00, V@20@00)) | live]
(push) ; 5
; [then-branch: 20 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> valid_graph_vertices1(_, this@18@00, P@23@00, V@20@00)]
(assert (implies
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))
  (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00)))
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> (forall unknown: Int :: { P[unknown] } 0 <= unknown && unknown < |P| ==> 0 <= P[unknown])
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P|
; [eval] 0 <= s
(push) ; 6
; [then-branch: 21 | 0 <= s@21@00 | live]
; [else-branch: 21 | !(0 <= s@21@00) | live]
(push) ; 7
; [then-branch: 21 | 0 <= s@21@00]
(assert (<= 0 s@21@00))
; [eval] s < V
(push) ; 8
; [then-branch: 22 | s@21@00 < V@20@00 | live]
; [else-branch: 22 | !(s@21@00 < V@20@00) | live]
(push) ; 9
; [then-branch: 22 | s@21@00 < V@20@00]
(assert (< s@21@00 V@20@00))
; [eval] 0 <= t
(push) ; 10
; [then-branch: 23 | 0 <= t@22@00 | live]
; [else-branch: 23 | !(0 <= t@22@00) | live]
(push) ; 11
; [then-branch: 23 | 0 <= t@22@00]
(assert (<= 0 t@22@00))
; [eval] t < V
(push) ; 12
; [then-branch: 24 | t@22@00 < V@20@00 | live]
; [else-branch: 24 | !(t@22@00 < V@20@00) | live]
(push) ; 13
; [then-branch: 24 | t@22@00 < V@20@00]
(assert (< t@22@00 V@20@00))
; [eval] 1 < |P|
; [eval] |P|
(pop) ; 13
(push) ; 13
; [else-branch: 24 | !(t@22@00 < V@20@00)]
(assert (not (< t@22@00 V@20@00)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 23 | !(0 <= t@22@00)]
(assert (not (<= 0 t@22@00)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 22 | !(s@21@00 < V@20@00)]
(assert (not (< s@21@00 V@20@00)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 21 | !(0 <= s@21@00)]
(assert (not (<= 0 s@21@00)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(push) ; 7
(assert (not (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             89
;  :arith-add-rows        41
;  :arith-assert-diseq    58
;  :arith-assert-lower    116
;  :arith-assert-upper    12
;  :arith-bound-prop      18
;  :arith-conflicts       1
;  :arith-eq-adapter      23
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          30
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 16
;  :decisions             18
;  :del-clause            226
;  :final-checks          16
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           678
;  :mk-clause             238
;  :num-allocs            161684
;  :num-checks            23
;  :propagations          108
;  :quant-instantiations  58
;  :rlimit-count          183609)
(push) ; 7
(assert (not (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             89
;  :arith-add-rows        41
;  :arith-assert-diseq    61
;  :arith-assert-lower    118
;  :arith-assert-upper    13
;  :arith-bound-prop      19
;  :arith-conflicts       1
;  :arith-eq-adapter      23
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          30
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 17
;  :decisions             20
;  :del-clause            236
;  :final-checks          17
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           686
;  :mk-clause             248
;  :num-allocs            162190
;  :num-checks            24
;  :propagations          114
;  :quant-instantiations  59
;  :rlimit-count          184353)
; [then-branch: 25 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 | live]
; [else-branch: 25 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00) | live]
(push) ; 7
; [then-branch: 25 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00]
(assert (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00)))
; [eval] (forall unknown: Int :: { P[unknown] } 0 <= unknown && unknown < |P| ==> 0 <= P[unknown])
(declare-const unknown@96@00 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < |P| ==> 0 <= P[unknown]
; [eval] 0 <= unknown && unknown < |P|
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 26 | 0 <= unknown@96@00 | live]
; [else-branch: 26 | !(0 <= unknown@96@00) | live]
(push) ; 10
; [then-branch: 26 | 0 <= unknown@96@00]
(assert (<= 0 unknown@96@00))
; [eval] unknown < |P|
; [eval] |P|
(pop) ; 10
(push) ; 10
; [else-branch: 26 | !(0 <= unknown@96@00)]
(assert (not (<= 0 unknown@96@00)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 27 | unknown@96@00 < |P@23@00| && 0 <= unknown@96@00 | live]
; [else-branch: 27 | !(unknown@96@00 < |P@23@00| && 0 <= unknown@96@00) | live]
(push) ; 10
; [then-branch: 27 | unknown@96@00 < |P@23@00| && 0 <= unknown@96@00]
(assert (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00)))
; [eval] 0 <= P[unknown]
; [eval] P[unknown]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= unknown@96@00 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             90
;  :arith-add-rows        45
;  :arith-assert-diseq    66
;  :arith-assert-lower    133
;  :arith-assert-upper    13
;  :arith-bound-prop      20
;  :arith-conflicts       1
;  :arith-eq-adapter      26
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          31
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 17
;  :decisions             20
;  :del-clause            236
;  :final-checks          17
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           729
;  :mk-clause             288
;  :num-allocs            162610
;  :num-checks            25
;  :propagations          130
;  :quant-instantiations  70
;  :rlimit-count          185258)
(pop) ; 10
(push) ; 10
; [else-branch: 27 | !(unknown@96@00 < |P@23@00| && 0 <= unknown@96@00)]
(assert (not (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(push) ; 7
; [else-branch: 25 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00)]
(assert (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 28 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@96@00 :: unknown@96@00 < |P@23@00| && 0 <= unknown@96@00 ==> 0 <= P@23@00[unknown@96@00] | live]
; [else-branch: 28 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@96@00 :: unknown@96@00 < |P@23@00| && 0 <= unknown@96@00 ==> 0 <= P@23@00[unknown@96@00]) | live]
(push) ; 7
; [then-branch: 28 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@96@00 :: unknown@96@00 < |P@23@00| && 0 <= unknown@96@00 ==> 0 <= P@23@00[unknown@96@00]]
(assert (implies
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))
  (forall ((unknown@96@00 Int)) (!
    (implies
      (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
      (<= 0 (Seq_index P@23@00 unknown@96@00)))
    :pattern ((Seq_index P@23@00 unknown@96@00))
    :qid |prog.l<no position>|))))
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> (forall unknown: Int :: { P[unknown] } 0 <= unknown && unknown < |P| ==> P[unknown] < V)
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P|
; [eval] 0 <= s
(push) ; 8
; [then-branch: 29 | 0 <= s@21@00 | live]
; [else-branch: 29 | !(0 <= s@21@00) | live]
(push) ; 9
; [then-branch: 29 | 0 <= s@21@00]
(assert (<= 0 s@21@00))
; [eval] s < V
(push) ; 10
; [then-branch: 30 | s@21@00 < V@20@00 | live]
; [else-branch: 30 | !(s@21@00 < V@20@00) | live]
(push) ; 11
; [then-branch: 30 | s@21@00 < V@20@00]
(assert (< s@21@00 V@20@00))
; [eval] 0 <= t
(push) ; 12
; [then-branch: 31 | 0 <= t@22@00 | live]
; [else-branch: 31 | !(0 <= t@22@00) | live]
(push) ; 13
; [then-branch: 31 | 0 <= t@22@00]
(assert (<= 0 t@22@00))
; [eval] t < V
(push) ; 14
; [then-branch: 32 | t@22@00 < V@20@00 | live]
; [else-branch: 32 | !(t@22@00 < V@20@00) | live]
(push) ; 15
; [then-branch: 32 | t@22@00 < V@20@00]
(assert (< t@22@00 V@20@00))
; [eval] 1 < |P|
; [eval] |P|
(pop) ; 15
(push) ; 15
; [else-branch: 32 | !(t@22@00 < V@20@00)]
(assert (not (< t@22@00 V@20@00)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 31 | !(0 <= t@22@00)]
(assert (not (<= 0 t@22@00)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 30 | !(s@21@00 < V@20@00)]
(assert (not (< s@21@00 V@20@00)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 29 | !(0 <= s@21@00)]
(assert (not (<= 0 s@21@00)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             91
;  :arith-add-rows        54
;  :arith-assert-diseq    76
;  :arith-assert-lower    155
;  :arith-assert-upper    13
;  :arith-bound-prop      22
;  :arith-conflicts       1
;  :arith-eq-adapter      29
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          37
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 18
;  :decisions             23
;  :del-clause            328
;  :final-checks          18
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           787
;  :mk-clause             341
;  :num-allocs            163865
;  :num-checks            26
;  :propagations          155
;  :quant-instantiations  85
;  :rlimit-count          187576)
(push) ; 9
(assert (not (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             91
;  :arith-add-rows        54
;  :arith-assert-diseq    79
;  :arith-assert-lower    157
;  :arith-assert-upper    14
;  :arith-bound-prop      23
;  :arith-conflicts       1
;  :arith-eq-adapter      29
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          37
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 19
;  :decisions             25
;  :del-clause            338
;  :final-checks          19
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           795
;  :mk-clause             351
;  :num-allocs            164370
;  :num-checks            27
;  :propagations          161
;  :quant-instantiations  86
;  :rlimit-count          188321)
; [then-branch: 33 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 | live]
; [else-branch: 33 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00) | live]
(push) ; 9
; [then-branch: 33 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00]
(assert (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00)))
; [eval] (forall unknown: Int :: { P[unknown] } 0 <= unknown && unknown < |P| ==> P[unknown] < V)
(declare-const unknown@97@00 Int)
(push) ; 10
; [eval] 0 <= unknown && unknown < |P| ==> P[unknown] < V
; [eval] 0 <= unknown && unknown < |P|
; [eval] 0 <= unknown
(push) ; 11
; [then-branch: 34 | 0 <= unknown@97@00 | live]
; [else-branch: 34 | !(0 <= unknown@97@00) | live]
(push) ; 12
; [then-branch: 34 | 0 <= unknown@97@00]
(assert (<= 0 unknown@97@00))
; [eval] unknown < |P|
; [eval] |P|
(pop) ; 12
(push) ; 12
; [else-branch: 34 | !(0 <= unknown@97@00)]
(assert (not (<= 0 unknown@97@00)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 35 | unknown@97@00 < |P@23@00| && 0 <= unknown@97@00 | live]
; [else-branch: 35 | !(unknown@97@00 < |P@23@00| && 0 <= unknown@97@00) | live]
(push) ; 12
; [then-branch: 35 | unknown@97@00 < |P@23@00| && 0 <= unknown@97@00]
(assert (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00)))
; [eval] P[unknown] < V
; [eval] P[unknown]
(set-option :timeout 0)
(push) ; 13
(assert (not (>= unknown@97@00 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             92
;  :arith-add-rows        59
;  :arith-assert-diseq    84
;  :arith-assert-lower    172
;  :arith-assert-upper    14
;  :arith-bound-prop      24
;  :arith-conflicts       1
;  :arith-eq-adapter      32
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          38
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 19
;  :decisions             25
;  :del-clause            338
;  :final-checks          19
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           838
;  :mk-clause             393
;  :num-allocs            164798
;  :num-checks            28
;  :propagations          176
;  :quant-instantiations  99
;  :rlimit-count          189284)
(pop) ; 12
(push) ; 12
; [else-branch: 35 | !(unknown@97@00 < |P@23@00| && 0 <= unknown@97@00)]
(assert (not (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 9
(push) ; 9
; [else-branch: 33 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00)]
(assert (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 36 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@97@00 :: unknown@97@00 < |P@23@00| && 0 <= unknown@97@00 ==> P@23@00[unknown@97@00] < V@20@00 | live]
; [else-branch: 36 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@97@00 :: unknown@97@00 < |P@23@00| && 0 <= unknown@97@00 ==> P@23@00[unknown@97@00] < V@20@00) | live]
(push) ; 9
; [then-branch: 36 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@97@00 :: unknown@97@00 < |P@23@00| && 0 <= unknown@97@00 ==> P@23@00[unknown@97@00] < V@20@00]
(assert (implies
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))
  (forall ((unknown@97@00 Int)) (!
    (implies
      (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
      (< (Seq_index P@23@00 unknown@97@00) V@20@00))
    :pattern ((Seq_index P@23@00 unknown@97@00))
    :qid |prog.l<no position>|))))
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P| ==> (forall j: Int :: { G[P[j]] } 0 <= j && j < |P| - 1 ==> 0 < G[P[j]][P[j + 1]])
; [eval] 0 <= s && s < V && 0 <= t && t < V && 1 < |P|
; [eval] 0 <= s
(push) ; 10
; [then-branch: 37 | 0 <= s@21@00 | live]
; [else-branch: 37 | !(0 <= s@21@00) | live]
(push) ; 11
; [then-branch: 37 | 0 <= s@21@00]
(assert (<= 0 s@21@00))
; [eval] s < V
(push) ; 12
; [then-branch: 38 | s@21@00 < V@20@00 | live]
; [else-branch: 38 | !(s@21@00 < V@20@00) | live]
(push) ; 13
; [then-branch: 38 | s@21@00 < V@20@00]
(assert (< s@21@00 V@20@00))
; [eval] 0 <= t
(push) ; 14
; [then-branch: 39 | 0 <= t@22@00 | live]
; [else-branch: 39 | !(0 <= t@22@00) | live]
(push) ; 15
; [then-branch: 39 | 0 <= t@22@00]
(assert (<= 0 t@22@00))
; [eval] t < V
(push) ; 16
; [then-branch: 40 | t@22@00 < V@20@00 | live]
; [else-branch: 40 | !(t@22@00 < V@20@00) | live]
(push) ; 17
; [then-branch: 40 | t@22@00 < V@20@00]
(assert (< t@22@00 V@20@00))
; [eval] 1 < |P|
; [eval] |P|
(pop) ; 17
(push) ; 17
; [else-branch: 40 | !(t@22@00 < V@20@00)]
(assert (not (< t@22@00 V@20@00)))
(pop) ; 17
(pop) ; 16
; Joined path conditions
; Joined path conditions
(pop) ; 15
(push) ; 15
; [else-branch: 39 | !(0 <= t@22@00)]
(assert (not (<= 0 t@22@00)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 38 | !(s@21@00 < V@20@00)]
(assert (not (< s@21@00 V@20@00)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 37 | !(0 <= s@21@00)]
(assert (not (<= 0 s@21@00)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
(set-option :timeout 10)
(push) ; 11
(assert (not (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00)))))
(check-sat)
; unknown
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             93
;  :arith-add-rows        69
;  :arith-assert-diseq    94
;  :arith-assert-lower    194
;  :arith-assert-upper    14
;  :arith-bound-prop      26
;  :arith-conflicts       1
;  :arith-eq-adapter      35
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          45
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 20
;  :decisions             28
;  :del-clause            432
;  :final-checks          20
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           896
;  :mk-clause             446
;  :num-allocs            166056
;  :num-checks            29
;  :propagations          202
;  :quant-instantiations  116
;  :rlimit-count          191723)
(push) ; 11
(assert (not (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00))))
(check-sat)
; unknown
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             93
;  :arith-add-rows        69
;  :arith-assert-diseq    97
;  :arith-assert-lower    196
;  :arith-assert-upper    15
;  :arith-bound-prop      27
;  :arith-conflicts       1
;  :arith-eq-adapter      35
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          45
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           904
;  :mk-clause             456
;  :num-allocs            166563
;  :num-checks            30
;  :propagations          208
;  :quant-instantiations  117
;  :rlimit-count          192469)
; [then-branch: 41 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 | live]
; [else-branch: 41 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00) | live]
(push) ; 11
; [then-branch: 41 | 1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00]
(assert (and
  (and
    (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
    (< s@21@00 V@20@00))
  (<= 0 s@21@00)))
; [eval] (forall j: Int :: { G[P[j]] } 0 <= j && j < |P| - 1 ==> 0 < G[P[j]][P[j + 1]])
(declare-const j@98@00 Int)
(push) ; 12
; [eval] 0 <= j && j < |P| - 1 ==> 0 < G[P[j]][P[j + 1]]
; [eval] 0 <= j && j < |P| - 1
; [eval] 0 <= j
(push) ; 13
; [then-branch: 42 | 0 <= j@98@00 | live]
; [else-branch: 42 | !(0 <= j@98@00) | live]
(push) ; 14
; [then-branch: 42 | 0 <= j@98@00]
(assert (<= 0 j@98@00))
; [eval] j < |P| - 1
; [eval] |P| - 1
; [eval] |P|
(pop) ; 14
(push) ; 14
; [else-branch: 42 | !(0 <= j@98@00)]
(assert (not (<= 0 j@98@00)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(push) ; 13
; [then-branch: 43 | j@98@00 < |P@23@00| - 1 && 0 <= j@98@00 | live]
; [else-branch: 43 | !(j@98@00 < |P@23@00| - 1 && 0 <= j@98@00) | live]
(push) ; 14
; [then-branch: 43 | j@98@00 < |P@23@00| - 1 && 0 <= j@98@00]
(assert (and (< j@98@00 (- (Seq_length P@23@00) 1)) (<= 0 j@98@00)))
; [eval] 0 < G[P[j]][P[j + 1]]
; [eval] G[P[j]][P[j + 1]]
; [eval] G[P[j]]
; [eval] P[j]
(set-option :timeout 0)
(push) ; 15
(assert (not (>= j@98@00 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             94
;  :arith-add-rows        75
;  :arith-assert-diseq    102
;  :arith-assert-lower    210
;  :arith-assert-upper    16
;  :arith-bound-prop      28
;  :arith-conflicts       1
;  :arith-eq-adapter      38
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          48
;  :conflicts             2
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.21
;  :mk-bool-var           947
;  :mk-clause             500
;  :num-allocs            167014
;  :num-checks            31
;  :propagations          224
;  :quant-instantiations  132
;  :rlimit-count          193508)
(push) ; 15
(assert (not (< j@98@00 (Seq_length P@23@00))))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             94
;  :arith-add-rows        75
;  :arith-assert-diseq    102
;  :arith-assert-lower    211
;  :arith-assert-upper    16
;  :arith-bound-prop      28
;  :arith-conflicts       2
;  :arith-eq-adapter      38
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          48
;  :conflicts             3
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.22
;  :mk-bool-var           948
;  :mk-clause             500
;  :num-allocs            167096
;  :num-checks            32
;  :propagations          224
;  :quant-instantiations  132
;  :rlimit-count          193588)
(push) ; 15
(assert (not (>= (Seq_index P@23@00 j@98@00) 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             94
;  :arith-add-rows        76
;  :arith-assert-diseq    102
;  :arith-assert-lower    211
;  :arith-assert-upper    17
;  :arith-bound-prop      28
;  :arith-conflicts       2
;  :arith-eq-adapter      38
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          48
;  :conflicts             4
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.22
;  :mk-bool-var           951
;  :mk-clause             500
;  :num-allocs            167203
;  :num-checks            33
;  :propagations          224
;  :quant-instantiations  136
;  :rlimit-count          193773)
(push) ; 15
(assert (not (< (Seq_index P@23@00 j@98@00) (Seq_length G@19@00))))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             94
;  :arith-add-rows        78
;  :arith-assert-diseq    102
;  :arith-assert-lower    213
;  :arith-assert-upper    18
;  :arith-bound-prop      28
;  :arith-conflicts       3
;  :arith-eq-adapter      38
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          50
;  :conflicts             5
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.22
;  :mk-bool-var           955
;  :mk-clause             500
;  :num-allocs            167319
;  :num-checks            34
;  :propagations          224
;  :quant-instantiations  140
;  :rlimit-count          193981)
; [eval] P[j + 1]
; [eval] j + 1
(push) ; 15
(assert (not (>= (+ j@98@00 1) 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             94
;  :arith-add-rows        78
;  :arith-assert-diseq    102
;  :arith-assert-lower    213
;  :arith-assert-upper    19
;  :arith-bound-prop      28
;  :arith-conflicts       4
;  :arith-eq-adapter      38
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          50
;  :conflicts             6
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.22
;  :mk-bool-var           956
;  :mk-clause             500
;  :num-allocs            167395
;  :num-checks            35
;  :propagations          224
;  :quant-instantiations  140
;  :rlimit-count          194045)
(push) ; 15
(assert (not (< (+ j@98@00 1) (Seq_length P@23@00))))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             94
;  :arith-add-rows        78
;  :arith-assert-diseq    102
;  :arith-assert-lower    213
;  :arith-assert-upper    19
;  :arith-bound-prop      28
;  :arith-conflicts       4
;  :arith-eq-adapter      38
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          50
;  :conflicts             6
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.22
;  :mk-bool-var           956
;  :mk-clause             500
;  :num-allocs            167428
;  :num-checks            36
;  :propagations          224
;  :quant-instantiations  140
;  :rlimit-count          194069)
(push) ; 15
(assert (not (>= (Seq_index P@23@00 (+ j@98@00 1)) 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             94
;  :arith-add-rows        80
;  :arith-assert-diseq    102
;  :arith-assert-lower    213
;  :arith-assert-upper    20
;  :arith-bound-prop      28
;  :arith-conflicts       4
;  :arith-eq-adapter      38
;  :arith-fixed-eqs       5
;  :arith-offset-eqs      5
;  :arith-pivots          50
;  :conflicts             7
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             30
;  :del-clause            442
;  :final-checks          21
;  :max-generation        3
;  :max-memory            4.38
;  :memory                4.22
;  :mk-bool-var           959
;  :mk-clause             500
;  :num-allocs            167535
;  :num-checks            37
;  :propagations          224
;  :quant-instantiations  144
;  :rlimit-count          194276)
(push) ; 15
(assert (not (<
  (Seq_index P@23@00 (+ j@98@00 1))
  (Seq_length (Seq_index G@19@00 (Seq_index P@23@00 j@98@00))))))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             99
;  :arith-add-rows        93
;  :arith-assert-diseq    111
;  :arith-assert-lower    225
;  :arith-assert-upper    23
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      40
;  :arith-fixed-eqs       6
;  :arith-offset-eqs      6
;  :arith-pivots          58
;  :conflicts             14
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 21
;  :decisions             36
;  :del-clause            532
;  :final-checks          21
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.24
;  :mk-bool-var           1040
;  :mk-clause             590
;  :num-allocs            168070
;  :num-checks            38
;  :propagations          265
;  :quant-instantiations  163
;  :rlimit-count          195511)
(pop) ; 14
(push) ; 14
; [else-branch: 43 | !(j@98@00 < |P@23@00| - 1 && 0 <= j@98@00)]
(assert (not (and (< j@98@00 (- (Seq_length P@23@00) 1)) (<= 0 j@98@00))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 11
(push) ; 11
; [else-branch: 41 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00)]
(assert (not
  (and
    (and
      (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
      (< s@21@00 V@20@00))
    (<= 0 s@21@00))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 36 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@97@00 :: unknown@97@00 < |P@23@00| && 0 <= unknown@97@00 ==> P@23@00[unknown@97@00] < V@20@00)]
(assert (not
  (implies
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00))
    (forall ((unknown@97@00 Int)) (!
      (implies
        (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
        (< (Seq_index P@23@00 unknown@97@00) V@20@00))
      :pattern ((Seq_index P@23@00 unknown@97@00))
      :qid |prog.l<no position>|)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (and
    (implies
      (and
        (and
          (and
            (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
            (<= 0 t@22@00))
          (< s@21@00 V@20@00))
        (<= 0 s@21@00))
      (forall ((unknown@97@00 Int)) (!
        (implies
          (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
          (< (Seq_index P@23@00 unknown@97@00) V@20@00))
        :pattern ((Seq_index P@23@00 unknown@97@00))
        :qid |prog.l<no position>|)))
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00)))
  (forall ((unknown@97@00 Int)) (!
    (implies
      (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
      (< (Seq_index P@23@00 unknown@97@00) V@20@00))
    :pattern ((Seq_index P@23@00 unknown@97@00))
    :qid |prog.l<no position>|))))
; Joined path conditions
(pop) ; 7
(push) ; 7
; [else-branch: 28 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> QA unknown@96@00 :: unknown@96@00 < |P@23@00| && 0 <= unknown@96@00 ==> 0 <= P@23@00[unknown@96@00])]
(assert (not
  (implies
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00))
    (forall ((unknown@96@00 Int)) (!
      (implies
        (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
        (<= 0 (Seq_index P@23@00 unknown@96@00)))
      :pattern ((Seq_index P@23@00 unknown@96@00))
      :qid |prog.l<no position>|)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (implies
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00))
    (forall ((unknown@96@00 Int)) (!
      (implies
        (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
        (<= 0 (Seq_index P@23@00 unknown@96@00)))
      :pattern ((Seq_index P@23@00 unknown@96@00))
      :qid |prog.l<no position>|)))
  (and
    (implies
      (and
        (and
          (and
            (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
            (<= 0 t@22@00))
          (< s@21@00 V@20@00))
        (<= 0 s@21@00))
      (forall ((unknown@96@00 Int)) (!
        (implies
          (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
          (<= 0 (Seq_index P@23@00 unknown@96@00)))
        :pattern ((Seq_index P@23@00 unknown@96@00))
        :qid |prog.l<no position>|)))
    (implies
      (and
        (implies
          (and
            (and
              (and
                (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                (<= 0 t@22@00))
              (< s@21@00 V@20@00))
            (<= 0 s@21@00))
          (forall ((unknown@97@00 Int)) (!
            (implies
              (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
              (< (Seq_index P@23@00 unknown@97@00) V@20@00))
            :pattern ((Seq_index P@23@00 unknown@97@00))
            :qid |prog.l<no position>|)))
        (and
          (and
            (and
              (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
              (<= 0 t@22@00))
            (< s@21@00 V@20@00))
          (<= 0 s@21@00)))
      (forall ((unknown@97@00 Int)) (!
        (implies
          (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
          (< (Seq_index P@23@00 unknown@97@00) V@20@00))
        :pattern ((Seq_index P@23@00 unknown@97@00))
        :qid |prog.l<no position>|))))))
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 20 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> valid_graph_vertices1(_, this@18@00, P@23@00, V@20@00))]
(assert (not
  (implies
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00))
    (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (implies
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00))
    (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00))
  (and
    (implies
      (and
        (and
          (and
            (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
            (<= 0 t@22@00))
          (< s@21@00 V@20@00))
        (<= 0 s@21@00))
      (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00))
    (implies
      (implies
        (and
          (and
            (and
              (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
              (<= 0 t@22@00))
            (< s@21@00 V@20@00))
          (<= 0 s@21@00))
        (forall ((unknown@96@00 Int)) (!
          (implies
            (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
            (<= 0 (Seq_index P@23@00 unknown@96@00)))
          :pattern ((Seq_index P@23@00 unknown@96@00))
          :qid |prog.l<no position>|)))
      (and
        (implies
          (and
            (and
              (and
                (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                (<= 0 t@22@00))
              (< s@21@00 V@20@00))
            (<= 0 s@21@00))
          (forall ((unknown@96@00 Int)) (!
            (implies
              (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
              (<= 0 (Seq_index P@23@00 unknown@96@00)))
            :pattern ((Seq_index P@23@00 unknown@96@00))
            :qid |prog.l<no position>|)))
        (implies
          (and
            (implies
              (and
                (and
                  (and
                    (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                    (<= 0 t@22@00))
                  (< s@21@00 V@20@00))
                (<= 0 s@21@00))
              (forall ((unknown@97@00 Int)) (!
                (implies
                  (and
                    (< unknown@97@00 (Seq_length P@23@00))
                    (<= 0 unknown@97@00))
                  (< (Seq_index P@23@00 unknown@97@00) V@20@00))
                :pattern ((Seq_index P@23@00 unknown@97@00))
                :qid |prog.l<no position>|)))
            (and
              (and
                (and
                  (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                  (<= 0 t@22@00))
                (< s@21@00 V@20@00))
              (<= 0 s@21@00)))
          (forall ((unknown@97@00 Int)) (!
            (implies
              (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
              (< (Seq_index P@23@00 unknown@97@00) V@20@00))
            :pattern ((Seq_index P@23@00 unknown@97@00))
            :qid |prog.l<no position>|))))))))
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 14 | !(1 < |P@23@00| && t@22@00 < V@20@00 && 0 <= t@22@00 && s@21@00 < V@20@00 && 0 <= s@21@00 ==> P@23@00[0] != P@23@00[|P@23@00| - 1])]
(assert (not
  (implies
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00))
    (not
      (= (Seq_index P@23@00 0) (Seq_index P@23@00 (- (Seq_length P@23@00) 1)))))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (implies
    (and
      (and
        (and (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00)) (<= 0 t@22@00))
        (< s@21@00 V@20@00))
      (<= 0 s@21@00))
    (not
      (= (Seq_index P@23@00 0) (Seq_index P@23@00 (- (Seq_length P@23@00) 1)))))
  (and
    (implies
      (and
        (and
          (and
            (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
            (<= 0 t@22@00))
          (< s@21@00 V@20@00))
        (<= 0 s@21@00))
      (not
        (= (Seq_index P@23@00 0) (Seq_index P@23@00 (- (Seq_length P@23@00) 1)))))
    (implies
      (implies
        (and
          (and
            (and
              (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
              (<= 0 t@22@00))
            (< s@21@00 V@20@00))
          (<= 0 s@21@00))
        (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00))
      (and
        (implies
          (and
            (and
              (and
                (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                (<= 0 t@22@00))
              (< s@21@00 V@20@00))
            (<= 0 s@21@00))
          (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00))
        (implies
          (implies
            (and
              (and
                (and
                  (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                  (<= 0 t@22@00))
                (< s@21@00 V@20@00))
              (<= 0 s@21@00))
            (forall ((unknown@96@00 Int)) (!
              (implies
                (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
                (<= 0 (Seq_index P@23@00 unknown@96@00)))
              :pattern ((Seq_index P@23@00 unknown@96@00))
              :qid |prog.l<no position>|)))
          (and
            (implies
              (and
                (and
                  (and
                    (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                    (<= 0 t@22@00))
                  (< s@21@00 V@20@00))
                (<= 0 s@21@00))
              (forall ((unknown@96@00 Int)) (!
                (implies
                  (and
                    (< unknown@96@00 (Seq_length P@23@00))
                    (<= 0 unknown@96@00))
                  (<= 0 (Seq_index P@23@00 unknown@96@00)))
                :pattern ((Seq_index P@23@00 unknown@96@00))
                :qid |prog.l<no position>|)))
            (implies
              (and
                (implies
                  (and
                    (and
                      (and
                        (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                        (<= 0 t@22@00))
                      (< s@21@00 V@20@00))
                    (<= 0 s@21@00))
                  (forall ((unknown@97@00 Int)) (!
                    (implies
                      (and
                        (< unknown@97@00 (Seq_length P@23@00))
                        (<= 0 unknown@97@00))
                      (< (Seq_index P@23@00 unknown@97@00) V@20@00))
                    :pattern ((Seq_index P@23@00 unknown@97@00))
                    :qid |prog.l<no position>|)))
                (and
                  (and
                    (and
                      (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                      (<= 0 t@22@00))
                    (< s@21@00 V@20@00))
                  (<= 0 s@21@00)))
              (forall ((unknown@97@00 Int)) (!
                (implies
                  (and
                    (< unknown@97@00 (Seq_length P@23@00))
                    (<= 0 unknown@97@00))
                  (< (Seq_index P@23@00 unknown@97@00) V@20@00))
                :pattern ((Seq_index P@23@00 unknown@97@00))
                :qid |prog.l<no position>|))))))))))
; Joined path conditions
(assert (=
  result@24@00
  (and
    (and
      (and
        (and
          (implies
            (and
              (and
                (and
                  (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                  (<= 0 t@22@00))
                (< s@21@00 V@20@00))
              (<= 0 s@21@00))
            (forall ((j@98@00 Int)) (!
              (implies
                (and (< j@98@00 (- (Seq_length P@23@00) 1)) (<= 0 j@98@00))
                (<
                  0
                  (Seq_index
                    (Seq_index G@19@00 (Seq_index P@23@00 j@98@00))
                    (Seq_index P@23@00 (+ j@98@00 1)))))
              :pattern ((Seq_index G@19@00 (Seq_index P@23@00 j@98@00)))
              :qid |prog.l<no position>|)))
          (implies
            (and
              (and
                (and
                  (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                  (<= 0 t@22@00))
                (< s@21@00 V@20@00))
              (<= 0 s@21@00))
            (forall ((unknown@97@00 Int)) (!
              (implies
                (and (< unknown@97@00 (Seq_length P@23@00)) (<= 0 unknown@97@00))
                (< (Seq_index P@23@00 unknown@97@00) V@20@00))
              :pattern ((Seq_index P@23@00 unknown@97@00))
              :qid |prog.l<no position>|))))
        (implies
          (and
            (and
              (and
                (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
                (<= 0 t@22@00))
              (< s@21@00 V@20@00))
            (<= 0 s@21@00))
          (forall ((unknown@96@00 Int)) (!
            (implies
              (and (< unknown@96@00 (Seq_length P@23@00)) (<= 0 unknown@96@00))
              (<= 0 (Seq_index P@23@00 unknown@96@00)))
            :pattern ((Seq_index P@23@00 unknown@96@00))
            :qid |prog.l<no position>|))))
      (implies
        (and
          (and
            (and
              (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
              (<= 0 t@22@00))
            (< s@21@00 V@20@00))
          (<= 0 s@21@00))
        (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00)))
    (implies
      (and
        (and
          (and
            (and (< 1 (Seq_length P@23@00)) (< t@22@00 V@20@00))
            (<= 0 t@22@00))
          (< s@21@00 V@20@00))
        (<= 0 s@21@00))
      (not
        (= (Seq_index P@23@00 0) (Seq_index P@23@00 (- (Seq_length P@23@00) 1))))))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@18@00 $Ref) (G@19@00 Seq<Seq<Int>>) (V@20@00 Int) (s@21@00 Int) (t@22@00 Int) (P@23@00 Seq<Int>)) (!
  (implies
    (and
      (not (= this@18@00 $Ref.null))
      (SquareIntMatrix $Snap.unit this@18@00 G@19@00 V@20@00))
    (=
      (AugPath s@$ this@18@00 G@19@00 V@20@00 s@21@00 t@22@00 P@23@00)
      (and
        (and
          (and
            (implies
              (and
                (and
                  (and (and (<= 0 s@21@00) (< s@21@00 V@20@00)) (<= 0 t@22@00))
                  (< t@22@00 V@20@00))
                (< 1 (Seq_length P@23@00)))
              (not
                (=
                  (Seq_index P@23@00 0)
                  (Seq_index P@23@00 (- (Seq_length P@23@00) 1)))))
            (implies
              (and
                (and
                  (and (and (<= 0 s@21@00) (< s@21@00 V@20@00)) (<= 0 t@22@00))
                  (< t@22@00 V@20@00))
                (< 1 (Seq_length P@23@00)))
              (valid_graph_vertices1 $Snap.unit this@18@00 P@23@00 V@20@00)))
          (and
            (implies
              (and
                (and
                  (and (and (<= 0 s@21@00) (< s@21@00 V@20@00)) (<= 0 t@22@00))
                  (< t@22@00 V@20@00))
                (< 1 (Seq_length P@23@00)))
              (forall ((unknown_ Int)) (!
                (implies
                  (and (<= 0 unknown_) (< unknown_ (Seq_length P@23@00)))
                  (<= 0 (Seq_index P@23@00 unknown_)))
                :pattern ((Seq_index P@23@00 unknown_))
                )))
            (implies
              (and
                (and
                  (and (and (<= 0 s@21@00) (< s@21@00 V@20@00)) (<= 0 t@22@00))
                  (< t@22@00 V@20@00))
                (< 1 (Seq_length P@23@00)))
              (forall ((unknown_ Int)) (!
                (implies
                  (and (<= 0 unknown_) (< unknown_ (Seq_length P@23@00)))
                  (< (Seq_index P@23@00 unknown_) V@20@00))
                :pattern ((Seq_index P@23@00 unknown_))
                )))))
        (implies
          (and
            (and
              (and (and (<= 0 s@21@00) (< s@21@00 V@20@00)) (<= 0 t@22@00))
              (< t@22@00 V@20@00))
            (< 1 (Seq_length P@23@00)))
          (forall ((j Int)) (!
            (implies
              (and (<= 0 j) (< j (- (Seq_length P@23@00) 1)))
              (<
                0
                (Seq_index
                  (Seq_index G@19@00 (Seq_index P@23@00 j))
                  (Seq_index P@23@00 (+ j 1)))))
            :pattern ((Seq_index G@19@00 (Seq_index P@23@00 j)))
            ))))))
  :pattern ((AugPath s@$ this@18@00 G@19@00 V@20@00 s@21@00 t@22@00 P@23@00))
  )))
; ---------- FUNCTION aloc----------
(declare-fun a2@25@00 () array)
(declare-fun i1@26@00 () Int)
(declare-fun result@27@00 () $Ref)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@26@00))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(assert (< i1@26@00 (alen<Int> a2@25@00)))
(declare-const $t@99@00 $Snap)
(assert (= $t@99@00 ($Snap.combine ($Snap.first $t@99@00) ($Snap.second $t@99@00))))
(assert (= ($Snap.first $t@99@00) $Snap.unit))
; [eval] loc_inv_1(result) == a2
; [eval] loc_inv_1(result)
(assert (= (loc_inv_1<array> result@27@00) a2@25@00))
(assert (= ($Snap.second $t@99@00) $Snap.unit))
; [eval] loc_inv_2(result) == i1
; [eval] loc_inv_2(result)
(assert (= (loc_inv_2<Int> result@27@00) i1@26@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (a2@25@00 array) (i1@26@00 Int)) (!
  (= (aloc%limited s@$ a2@25@00 i1@26@00) (aloc s@$ a2@25@00 i1@26@00))
  :pattern ((aloc s@$ a2@25@00 i1@26@00))
  )))
(assert (forall ((s@$ $Snap) (a2@25@00 array) (i1@26@00 Int)) (!
  (aloc%stateless a2@25@00 i1@26@00)
  :pattern ((aloc%limited s@$ a2@25@00 i1@26@00))
  )))
(assert (forall ((s@$ $Snap) (a2@25@00 array) (i1@26@00 Int)) (!
  (let ((result@27@00 (aloc%limited s@$ a2@25@00 i1@26@00))) (implies
    (and (<= 0 i1@26@00) (< i1@26@00 (alen<Int> a2@25@00)))
    (and
      (= (loc_inv_1<array> result@27@00) a2@25@00)
      (= (loc_inv_2<Int> result@27@00) i1@26@00))))
  :pattern ((aloc%limited s@$ a2@25@00 i1@26@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (<= 0 i1@26@00))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (< i1@26@00 (alen<Int> a2@25@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] array_loc(a2, i1)
(assert (= result@27@00 (array_loc<Ref> a2@25@00 i1@26@00)))
; [eval] loc_inv_1(result) == a2
; [eval] loc_inv_1(result)
(set-option :timeout 0)
(push) ; 2
(assert (not (= (loc_inv_1<array> result@27@00) a2@25@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             110
;  :arith-add-rows        95
;  :arith-assert-diseq    111
;  :arith-assert-lower    227
;  :arith-assert-upper    24
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      40
;  :arith-fixed-eqs       6
;  :arith-offset-eqs      6
;  :arith-pivots          65
;  :conflicts             15
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 22
;  :decisions             36
;  :del-clause            590
;  :final-checks          22
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.23
;  :mk-bool-var           1055
;  :mk-clause             593
;  :num-allocs            170554
;  :num-checks            40
;  :propagations          267
;  :quant-instantiations  165
;  :rlimit-count          199926)
(assert (= (loc_inv_1<array> result@27@00) a2@25@00))
; [eval] loc_inv_2(result) == i1
; [eval] loc_inv_2(result)
(push) ; 2
(assert (not (= (loc_inv_2<Int> result@27@00) i1@26@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             113
;  :arith-add-rows        95
;  :arith-assert-diseq    111
;  :arith-assert-lower    227
;  :arith-assert-upper    24
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      40
;  :arith-fixed-eqs       6
;  :arith-offset-eqs      6
;  :arith-pivots          65
;  :conflicts             16
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 22
;  :decisions             36
;  :del-clause            590
;  :final-checks          22
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.23
;  :mk-bool-var           1057
;  :mk-clause             593
;  :num-allocs            170690
;  :num-checks            41
;  :propagations          267
;  :quant-instantiations  165
;  :rlimit-count          200059)
(assert (= (loc_inv_2<Int> result@27@00) i1@26@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (a2@25@00 array) (i1@26@00 Int)) (!
  (implies
    (and (<= 0 i1@26@00) (< i1@26@00 (alen<Int> a2@25@00)))
    (= (aloc s@$ a2@25@00 i1@26@00) (array_loc<Ref> a2@25@00 i1@26@00)))
  :pattern ((aloc s@$ a2@25@00 i1@26@00))
  )))
; ---------- FUNCTION opt_get1----------
(declare-fun opt1@28@00 () option<array>)
(declare-fun result@29@00 () array)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= opt1@28@00 (as None<option<array>>  option<array>))))
(declare-const $t@100@00 $Snap)
(assert (= $t@100@00 $Snap.unit))
; [eval] (some(result): option[array]) == opt1
; [eval] (some(result): option[array])
(assert (= (some<option<array>> result@29@00) opt1@28@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@28@00 option<array>)) (!
  (= (opt_get1%limited s@$ opt1@28@00) (opt_get1 s@$ opt1@28@00))
  :pattern ((opt_get1 s@$ opt1@28@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@28@00 option<array>)) (!
  (opt_get1%stateless opt1@28@00)
  :pattern ((opt_get1%limited s@$ opt1@28@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@28@00 option<array>)) (!
  (let ((result@29@00 (opt_get1%limited s@$ opt1@28@00))) (implies
    (not (= opt1@28@00 (as None<option<array>>  option<array>)))
    (= (some<option<array>> result@29@00) opt1@28@00)))
  :pattern ((opt_get1%limited s@$ opt1@28@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ $Snap.unit))
(assert (not (= opt1@28@00 (as None<option<array>>  option<array>))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (option_get(opt1): array)
(assert (= result@29@00 (option_get<array> opt1@28@00)))
; [eval] (some(result): option[array]) == opt1
; [eval] (some(result): option[array])
(set-option :timeout 0)
(push) ; 2
(assert (not (= (some<option<array>> result@29@00) opt1@28@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             117
;  :arith-add-rows        95
;  :arith-assert-diseq    111
;  :arith-assert-lower    227
;  :arith-assert-upper    24
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      40
;  :arith-fixed-eqs       6
;  :arith-offset-eqs      6
;  :arith-pivots          66
;  :conflicts             17
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 23
;  :decisions             36
;  :del-clause            593
;  :final-checks          23
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.23
;  :mk-bool-var           1067
;  :mk-clause             593
;  :num-allocs            171801
;  :num-checks            43
;  :propagations          267
;  :quant-instantiations  167
;  :rlimit-count          201320)
(assert (= (some<option<array>> result@29@00) opt1@28@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@28@00 option<array>)) (!
  (implies
    (not (= opt1@28@00 (as None<option<array>>  option<array>)))
    (= (opt_get1 s@$ opt1@28@00) (option_get<array> opt1@28@00)))
  :pattern ((opt_get1 s@$ opt1@28@00))
  )))
; ---------- FUNCTION NonNegativeCapacities----------
(declare-fun this@30@00 () $Ref)
(declare-fun G@31@00 () Seq<Seq<Int>>)
(declare-fun V@32@00 () Int)
(declare-fun result@33@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@30@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] V == |G|
; [eval] |G|
(assert (= V@32@00 (Seq_length G@31@00)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@30@00 $Ref) (G@31@00 Seq<Seq<Int>>) (V@32@00 Int)) (!
  (=
    (NonNegativeCapacities%limited s@$ this@30@00 G@31@00 V@32@00)
    (NonNegativeCapacities s@$ this@30@00 G@31@00 V@32@00))
  :pattern ((NonNegativeCapacities s@$ this@30@00 G@31@00 V@32@00))
  )))
(assert (forall ((s@$ $Snap) (this@30@00 $Ref) (G@31@00 Seq<Seq<Int>>) (V@32@00 Int)) (!
  (NonNegativeCapacities%stateless this@30@00 G@31@00 V@32@00)
  :pattern ((NonNegativeCapacities%limited s@$ this@30@00 G@31@00 V@32@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@30@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (= V@32@00 (Seq_length G@31@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (forall i1: Int :: { G[i1] } 0 <= i1 && i1 < V ==> (forall j: Int :: { G[i1][j] } 0 <= j && j < V ==> 0 < G[i1][j]))
(declare-const i1@101@00 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V ==> (forall j: Int :: { G[i1][j] } 0 <= j && j < V ==> 0 < G[i1][j])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 44 | 0 <= i1@101@00 | live]
; [else-branch: 44 | !(0 <= i1@101@00) | live]
(push) ; 4
; [then-branch: 44 | 0 <= i1@101@00]
(assert (<= 0 i1@101@00))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 44 | !(0 <= i1@101@00)]
(assert (not (<= 0 i1@101@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 45 | i1@101@00 < V@32@00 && 0 <= i1@101@00 | live]
; [else-branch: 45 | !(i1@101@00 < V@32@00 && 0 <= i1@101@00) | live]
(push) ; 4
; [then-branch: 45 | i1@101@00 < V@32@00 && 0 <= i1@101@00]
(assert (and (< i1@101@00 V@32@00) (<= 0 i1@101@00)))
; [eval] (forall j: Int :: { G[i1][j] } 0 <= j && j < V ==> 0 < G[i1][j])
(declare-const j@102@00 Int)
(push) ; 5
; [eval] 0 <= j && j < V ==> 0 < G[i1][j]
; [eval] 0 <= j && j < V
; [eval] 0 <= j
(push) ; 6
; [then-branch: 46 | 0 <= j@102@00 | live]
; [else-branch: 46 | !(0 <= j@102@00) | live]
(push) ; 7
; [then-branch: 46 | 0 <= j@102@00]
(assert (<= 0 j@102@00))
; [eval] j < V
(pop) ; 7
(push) ; 7
; [else-branch: 46 | !(0 <= j@102@00)]
(assert (not (<= 0 j@102@00)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 47 | j@102@00 < V@32@00 && 0 <= j@102@00 | live]
; [else-branch: 47 | !(j@102@00 < V@32@00 && 0 <= j@102@00) | live]
(push) ; 7
; [then-branch: 47 | j@102@00 < V@32@00 && 0 <= j@102@00]
(assert (and (< j@102@00 V@32@00) (<= 0 j@102@00)))
; [eval] 0 < G[i1][j]
; [eval] G[i1][j]
; [eval] G[i1]
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i1@101@00 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             126
;  :arith-add-rows        95
;  :arith-assert-diseq    112
;  :arith-assert-lower    232
;  :arith-assert-upper    27
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      42
;  :arith-fixed-eqs       7
;  :arith-offset-eqs      6
;  :arith-pivots          67
;  :conflicts             17
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 24
;  :decisions             37
;  :del-clause            593
;  :final-checks          24
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1085
;  :mk-clause             596
;  :num-allocs            172914
;  :num-checks            45
;  :propagations          268
;  :quant-instantiations  169
;  :rlimit-count          202726)
(push) ; 8
(assert (not (< i1@101@00 (Seq_length G@31@00))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             126
;  :arith-add-rows        95
;  :arith-assert-diseq    112
;  :arith-assert-lower    232
;  :arith-assert-upper    27
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      42
;  :arith-fixed-eqs       7
;  :arith-offset-eqs      6
;  :arith-pivots          67
;  :conflicts             17
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 24
;  :decisions             37
;  :del-clause            593
;  :final-checks          24
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1085
;  :mk-clause             596
;  :num-allocs            172938
;  :num-checks            46
;  :propagations          268
;  :quant-instantiations  169
;  :rlimit-count          202746)
(push) ; 8
(assert (not (>= j@102@00 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             126
;  :arith-add-rows        95
;  :arith-assert-diseq    112
;  :arith-assert-lower    232
;  :arith-assert-upper    27
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      42
;  :arith-fixed-eqs       7
;  :arith-offset-eqs      6
;  :arith-pivots          67
;  :conflicts             17
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 24
;  :decisions             37
;  :del-clause            593
;  :final-checks          24
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1085
;  :mk-clause             596
;  :num-allocs            172951
;  :num-checks            47
;  :propagations          268
;  :quant-instantiations  169
;  :rlimit-count          202755)
(push) ; 8
(assert (not (< j@102@00 (Seq_length (Seq_index G@31@00 i1@101@00)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             126
;  :arith-add-rows        97
;  :arith-assert-diseq    114
;  :arith-assert-lower    236
;  :arith-assert-upper    27
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      43
;  :arith-fixed-eqs       7
;  :arith-offset-eqs      6
;  :arith-pivots          69
;  :conflicts             17
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 25
;  :decisions             39
;  :del-clause            596
;  :final-checks          25
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1090
;  :mk-clause             599
;  :num-allocs            173445
;  :num-checks            48
;  :propagations          270
;  :quant-instantiations  171
;  :rlimit-count          203360)
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- FUNCTION SkewSymetry----------
(declare-fun this@34@00 () $Ref)
(declare-fun G@35@00 () Seq<Seq<Int>>)
(declare-fun V@36@00 () Int)
(declare-fun result@37@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@34@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] V == |G|
; [eval] |G|
(assert (= V@36@00 (Seq_length G@35@00)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@34@00 $Ref) (G@35@00 Seq<Seq<Int>>) (V@36@00 Int)) (!
  (=
    (SkewSymetry%limited s@$ this@34@00 G@35@00 V@36@00)
    (SkewSymetry s@$ this@34@00 G@35@00 V@36@00))
  :pattern ((SkewSymetry s@$ this@34@00 G@35@00 V@36@00))
  )))
(assert (forall ((s@$ $Snap) (this@34@00 $Ref) (G@35@00 Seq<Seq<Int>>) (V@36@00 Int)) (!
  (SkewSymetry%stateless this@34@00 G@35@00 V@36@00)
  :pattern ((SkewSymetry%limited s@$ this@34@00 G@35@00 V@36@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@34@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (= V@36@00 (Seq_length G@35@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (forall i1: Int :: { G[i1] } 0 <= i1 && i1 < V ==> (forall j: Int :: { G[i1][j] } { G[j][i1] } 0 <= j && j < V ==> G[i1][j] == -G[j][i1]))
(declare-const i1@103@00 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V ==> (forall j: Int :: { G[i1][j] } { G[j][i1] } 0 <= j && j < V ==> G[i1][j] == -G[j][i1])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 48 | 0 <= i1@103@00 | live]
; [else-branch: 48 | !(0 <= i1@103@00) | live]
(push) ; 4
; [then-branch: 48 | 0 <= i1@103@00]
(assert (<= 0 i1@103@00))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 48 | !(0 <= i1@103@00)]
(assert (not (<= 0 i1@103@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 49 | i1@103@00 < V@36@00 && 0 <= i1@103@00 | live]
; [else-branch: 49 | !(i1@103@00 < V@36@00 && 0 <= i1@103@00) | live]
(push) ; 4
; [then-branch: 49 | i1@103@00 < V@36@00 && 0 <= i1@103@00]
(assert (and (< i1@103@00 V@36@00) (<= 0 i1@103@00)))
; [eval] (forall j: Int :: { G[i1][j] } { G[j][i1] } 0 <= j && j < V ==> G[i1][j] == -G[j][i1])
(declare-const j@104@00 Int)
(push) ; 5
; [eval] 0 <= j && j < V ==> G[i1][j] == -G[j][i1]
; [eval] 0 <= j && j < V
; [eval] 0 <= j
(push) ; 6
; [then-branch: 50 | 0 <= j@104@00 | live]
; [else-branch: 50 | !(0 <= j@104@00) | live]
(push) ; 7
; [then-branch: 50 | 0 <= j@104@00]
(assert (<= 0 j@104@00))
; [eval] j < V
(pop) ; 7
(push) ; 7
; [else-branch: 50 | !(0 <= j@104@00)]
(assert (not (<= 0 j@104@00)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 51 | j@104@00 < V@36@00 && 0 <= j@104@00 | live]
; [else-branch: 51 | !(j@104@00 < V@36@00 && 0 <= j@104@00) | live]
(push) ; 7
; [then-branch: 51 | j@104@00 < V@36@00 && 0 <= j@104@00]
(assert (and (< j@104@00 V@36@00) (<= 0 j@104@00)))
; [eval] G[i1][j] == -G[j][i1]
; [eval] G[i1][j]
; [eval] G[i1]
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i1@103@00 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             136
;  :arith-add-rows        97
;  :arith-assert-diseq    115
;  :arith-assert-lower    241
;  :arith-assert-upper    30
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      45
;  :arith-fixed-eqs       8
;  :arith-offset-eqs      6
;  :arith-pivots          71
;  :conflicts             17
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 26
;  :decisions             40
;  :del-clause            599
;  :final-checks          26
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1108
;  :mk-clause             602
;  :num-allocs            174404
;  :num-checks            50
;  :propagations          271
;  :quant-instantiations  173
;  :rlimit-count          204617)
(push) ; 8
(assert (not (< i1@103@00 (Seq_length G@35@00))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             136
;  :arith-add-rows        97
;  :arith-assert-diseq    115
;  :arith-assert-lower    241
;  :arith-assert-upper    30
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      45
;  :arith-fixed-eqs       8
;  :arith-offset-eqs      6
;  :arith-pivots          71
;  :conflicts             17
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 26
;  :decisions             40
;  :del-clause            599
;  :final-checks          26
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1108
;  :mk-clause             602
;  :num-allocs            174428
;  :num-checks            51
;  :propagations          271
;  :quant-instantiations  173
;  :rlimit-count          204637)
(push) ; 8
(assert (not (>= j@104@00 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             136
;  :arith-add-rows        97
;  :arith-assert-diseq    115
;  :arith-assert-lower    241
;  :arith-assert-upper    30
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      45
;  :arith-fixed-eqs       8
;  :arith-offset-eqs      6
;  :arith-pivots          71
;  :conflicts             17
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 26
;  :decisions             40
;  :del-clause            599
;  :final-checks          26
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1108
;  :mk-clause             602
;  :num-allocs            174441
;  :num-checks            52
;  :propagations          271
;  :quant-instantiations  173
;  :rlimit-count          204646)
(push) ; 8
(assert (not (< j@104@00 (Seq_length (Seq_index G@35@00 i1@103@00)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             136
;  :arith-add-rows        99
;  :arith-assert-diseq    117
;  :arith-assert-lower    245
;  :arith-assert-upper    30
;  :arith-bound-prop      28
;  :arith-conflicts       6
;  :arith-eq-adapter      46
;  :arith-fixed-eqs       8
;  :arith-offset-eqs      6
;  :arith-pivots          73
;  :conflicts             17
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 27
;  :decisions             42
;  :del-clause            602
;  :final-checks          27
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.25
;  :mk-bool-var           1113
;  :mk-clause             605
;  :num-allocs            174931
;  :num-checks            53
;  :propagations          273
;  :quant-instantiations  175
;  :rlimit-count          205253)
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- FUNCTION CapacityConstraint----------
(declare-fun this@38@00 () $Ref)
(declare-fun G@39@00 () Seq<Seq<Int>>)
(declare-fun Gf@40@00 () Seq<Seq<Int>>)
(declare-fun V@41@00 () Int)
(declare-fun result@42@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@38@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] V == |G|
; [eval] |G|
(assert (= V@41@00 (Seq_length G@39@00)))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
; [eval] V == |Gf|
; [eval] |Gf|
(assert (= V@41@00 (Seq_length Gf@40@00)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@38@00 $Ref) (G@39@00 Seq<Seq<Int>>) (Gf@40@00 Seq<Seq<Int>>) (V@41@00 Int)) (!
  (=
    (CapacityConstraint%limited s@$ this@38@00 G@39@00 Gf@40@00 V@41@00)
    (CapacityConstraint s@$ this@38@00 G@39@00 Gf@40@00 V@41@00))
  :pattern ((CapacityConstraint s@$ this@38@00 G@39@00 Gf@40@00 V@41@00))
  )))
(assert (forall ((s@$ $Snap) (this@38@00 $Ref) (G@39@00 Seq<Seq<Int>>) (Gf@40@00 Seq<Seq<Int>>) (V@41@00 Int)) (!
  (CapacityConstraint%stateless this@38@00 G@39@00 Gf@40@00 V@41@00)
  :pattern ((CapacityConstraint%limited s@$ this@38@00 G@39@00 Gf@40@00 V@41@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@38@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (= V@41@00 (Seq_length G@39@00)))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
(assert (= V@41@00 (Seq_length Gf@40@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (forall i1: Int :: { Gf[i1] } { G[i1] } 0 <= i1 && i1 < V ==> (forall j: Int :: { Gf[i1][j] } { G[i1][j] } 0 <= j && j < V ==> Gf[i1][j] <= G[i1][j]))
(declare-const i1@105@00 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V ==> (forall j: Int :: { Gf[i1][j] } { G[i1][j] } 0 <= j && j < V ==> Gf[i1][j] <= G[i1][j])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 52 | 0 <= i1@105@00 | live]
; [else-branch: 52 | !(0 <= i1@105@00) | live]
(push) ; 4
; [then-branch: 52 | 0 <= i1@105@00]
(assert (<= 0 i1@105@00))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 52 | !(0 <= i1@105@00)]
(assert (not (<= 0 i1@105@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 53 | i1@105@00 < V@41@00 && 0 <= i1@105@00 | live]
; [else-branch: 53 | !(i1@105@00 < V@41@00 && 0 <= i1@105@00) | live]
(push) ; 4
; [then-branch: 53 | i1@105@00 < V@41@00 && 0 <= i1@105@00]
(assert (and (< i1@105@00 V@41@00) (<= 0 i1@105@00)))
; [eval] (forall j: Int :: { Gf[i1][j] } { G[i1][j] } 0 <= j && j < V ==> Gf[i1][j] <= G[i1][j])
(declare-const j@106@00 Int)
(push) ; 5
; [eval] 0 <= j && j < V ==> Gf[i1][j] <= G[i1][j]
; [eval] 0 <= j && j < V
; [eval] 0 <= j
(push) ; 6
; [then-branch: 54 | 0 <= j@106@00 | live]
; [else-branch: 54 | !(0 <= j@106@00) | live]
(push) ; 7
; [then-branch: 54 | 0 <= j@106@00]
(assert (<= 0 j@106@00))
; [eval] j < V
(pop) ; 7
(push) ; 7
; [else-branch: 54 | !(0 <= j@106@00)]
(assert (not (<= 0 j@106@00)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 55 | j@106@00 < V@41@00 && 0 <= j@106@00 | live]
; [else-branch: 55 | !(j@106@00 < V@41@00 && 0 <= j@106@00) | live]
(push) ; 7
; [then-branch: 55 | j@106@00 < V@41@00 && 0 <= j@106@00]
(assert (and (< j@106@00 V@41@00) (<= 0 j@106@00)))
; [eval] Gf[i1][j] <= G[i1][j]
; [eval] Gf[i1][j]
; [eval] Gf[i1]
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i1@105@00 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             156
;  :arith-add-rows        103
;  :arith-assert-diseq    121
;  :arith-assert-lower    257
;  :arith-assert-upper    32
;  :arith-bound-prop      31
;  :arith-conflicts       6
;  :arith-eq-adapter      50
;  :arith-fixed-eqs       10
;  :arith-offset-eqs      6
;  :arith-pivots          77
;  :conflicts             17
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 28
;  :decisions             43
;  :del-clause            606
;  :final-checks          28
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.26
;  :mk-bool-var           1141
;  :mk-clause             615
;  :num-allocs            175990
;  :num-checks            55
;  :propagations          275
;  :quant-instantiations  179
;  :rlimit-count          206810)
(push) ; 8
(assert (not (< i1@105@00 (Seq_length Gf@40@00))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             156
;  :arith-add-rows        103
;  :arith-assert-diseq    121
;  :arith-assert-lower    257
;  :arith-assert-upper    32
;  :arith-bound-prop      31
;  :arith-conflicts       6
;  :arith-eq-adapter      50
;  :arith-fixed-eqs       10
;  :arith-offset-eqs      6
;  :arith-pivots          77
;  :conflicts             17
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 28
;  :decisions             43
;  :del-clause            606
;  :final-checks          28
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.26
;  :mk-bool-var           1141
;  :mk-clause             615
;  :num-allocs            176008
;  :num-checks            56
;  :propagations          275
;  :quant-instantiations  179
;  :rlimit-count          206830)
(push) ; 8
(assert (not (>= j@106@00 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             156
;  :arith-add-rows        103
;  :arith-assert-diseq    121
;  :arith-assert-lower    257
;  :arith-assert-upper    32
;  :arith-bound-prop      31
;  :arith-conflicts       6
;  :arith-eq-adapter      50
;  :arith-fixed-eqs       10
;  :arith-offset-eqs      6
;  :arith-pivots          77
;  :conflicts             17
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 28
;  :decisions             43
;  :del-clause            606
;  :final-checks          28
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.26
;  :mk-bool-var           1141
;  :mk-clause             615
;  :num-allocs            176021
;  :num-checks            57
;  :propagations          275
;  :quant-instantiations  179
;  :rlimit-count          206839)
(push) ; 8
(assert (not (< j@106@00 (Seq_length (Seq_index Gf@40@00 i1@105@00)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             156
;  :arith-add-rows        105
;  :arith-assert-diseq    122
;  :arith-assert-lower    260
;  :arith-assert-upper    32
;  :arith-bound-prop      31
;  :arith-conflicts       6
;  :arith-eq-adapter      51
;  :arith-fixed-eqs       10
;  :arith-offset-eqs      6
;  :arith-pivots          80
;  :conflicts             17
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 29
;  :decisions             44
;  :del-clause            609
;  :final-checks          29
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.27
;  :mk-bool-var           1146
;  :mk-clause             618
;  :num-allocs            176535
;  :num-checks            58
;  :propagations          276
;  :quant-instantiations  181
;  :rlimit-count          207448)
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- FUNCTION FlowConservation----------
(declare-fun this@43@00 () $Ref)
(declare-fun G@44@00 () Seq<Seq<Int>>)
(declare-fun V@45@00 () Int)
(declare-fun s@46@00 () Int)
(declare-fun t@47@00 () Int)
(declare-fun result@48@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@43@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] V == |G|
; [eval] |G|
(assert (= V@45@00 (Seq_length G@44@00)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@43@00 $Ref) (G@44@00 Seq<Seq<Int>>) (V@45@00 Int) (s@46@00 Int) (t@47@00 Int)) (!
  (=
    (FlowConservation%limited s@$ this@43@00 G@44@00 V@45@00 s@46@00 t@47@00)
    (FlowConservation s@$ this@43@00 G@44@00 V@45@00 s@46@00 t@47@00))
  :pattern ((FlowConservation s@$ this@43@00 G@44@00 V@45@00 s@46@00 t@47@00))
  )))
(assert (forall ((s@$ $Snap) (this@43@00 $Ref) (G@44@00 Seq<Seq<Int>>) (V@45@00 Int) (s@46@00 Int) (t@47@00 Int)) (!
  (FlowConservation%stateless this@43@00 G@44@00 V@45@00 s@46@00 t@47@00)
  :pattern ((FlowConservation%limited s@$ this@43@00 G@44@00 V@45@00 s@46@00 t@47@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@43@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (= V@45@00 (Seq_length G@44@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] SumIncomingFlow(this, G, V, s) <= SumOutgoingFlow(this, G, V, s) && SumOutgoingFlow(this, G, V, t) <= SumIncomingFlow(this, G, V, t) && (forall v: Int :: { SumIncomingFlow(this, G, V, v) } { SumOutgoingFlow(this, G, V, v) } 0 <= v && v < V && v != s && v != t ==> SumIncomingFlow(this, G, V, v) == SumOutgoingFlow(this, G, V, v))
; [eval] SumIncomingFlow(this, G, V, s) <= SumOutgoingFlow(this, G, V, s)
; [eval] SumIncomingFlow(this, G, V, s)
(push) ; 2
; [eval] this != null
; [eval] 0 <= n
(set-option :timeout 0)
(push) ; 3
(assert (not (<= 0 V@45@00)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             164
;  :arith-add-rows        106
;  :arith-assert-diseq    123
;  :arith-assert-lower    263
;  :arith-assert-upper    34
;  :arith-bound-prop      31
;  :arith-conflicts       7
;  :arith-eq-adapter      53
;  :arith-fixed-eqs       11
;  :arith-offset-eqs      6
;  :arith-pivots          86
;  :conflicts             18
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 30
;  :decisions             45
;  :del-clause            619
;  :final-checks          30
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.26
;  :mk-bool-var           1160
;  :mk-clause             622
;  :num-allocs            177373
;  :num-checks            60
;  :propagations          277
;  :quant-instantiations  183
;  :rlimit-count          208479)
(assert (<= 0 V@45@00))
; [eval] n < |G| + 1
; [eval] |G| + 1
; [eval] |G|
(push) ; 3
(assert (not (< V@45@00 (+ (Seq_length G@44@00) 1))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             165
;  :arith-add-rows        106
;  :arith-assert-diseq    123
;  :arith-assert-lower    265
;  :arith-assert-upper    35
;  :arith-bound-prop      31
;  :arith-conflicts       7
;  :arith-eq-adapter      54
;  :arith-fixed-eqs       12
;  :arith-offset-eqs      6
;  :arith-pivots          87
;  :conflicts             18
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 30
;  :decisions             45
;  :del-clause            619
;  :final-checks          30
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.27
;  :mk-bool-var           1163
;  :mk-clause             622
;  :num-allocs            177475
;  :num-checks            61
;  :propagations          277
;  :quant-instantiations  183
;  :rlimit-count          208552)
(assert (< V@45@00 (+ (Seq_length G@44@00) 1)))
; [eval] 0 <= v
(push) ; 3
(assert (not (<= 0 s@46@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             165
;  :arith-add-rows        106
;  :arith-assert-diseq    124
;  :arith-assert-lower    266
;  :arith-assert-upper    36
;  :arith-bound-prop      31
;  :arith-conflicts       7
;  :arith-eq-adapter      54
;  :arith-fixed-eqs       12
;  :arith-offset-eqs      6
;  :arith-pivots          88
;  :conflicts             18
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 31
;  :decisions             46
;  :del-clause            619
;  :final-checks          31
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.27
;  :mk-bool-var           1164
;  :mk-clause             622
;  :num-allocs            177890
;  :num-checks            62
;  :propagations          278
;  :quant-instantiations  183
;  :rlimit-count          209030)
; [state consolidation]
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; [eval] 0 <= v
(set-option :timeout 0)
(push) ; 3
(assert (not (<= 0 s@46@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             165
;  :arith-add-rows        106
;  :arith-assert-diseq    126
;  :arith-assert-lower    268
;  :arith-assert-upper    37
;  :arith-bound-prop      31
;  :arith-conflicts       7
;  :arith-eq-adapter      54
;  :arith-fixed-eqs       12
;  :arith-offset-eqs      6
;  :arith-pivots          88
;  :conflicts             18
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 33
;  :decisions             48
;  :del-clause            619
;  :final-checks          33
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.27
;  :mk-bool-var           1165
;  :mk-clause             622
;  :num-allocs            178649
;  :num-checks            64
;  :propagations          280
;  :quant-instantiations  183
;  :rlimit-count          209894)
; [state consolidation]
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; [eval] 0 <= v
(set-option :timeout 0)
(push) ; 3
(assert (not (<= 0 s@46@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             165
;  :arith-add-rows        106
;  :arith-assert-diseq    128
;  :arith-assert-lower    270
;  :arith-assert-upper    38
;  :arith-bound-prop      31
;  :arith-conflicts       7
;  :arith-eq-adapter      54
;  :arith-fixed-eqs       12
;  :arith-offset-eqs      6
;  :arith-pivots          88
;  :conflicts             18
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 35
;  :decisions             50
;  :del-clause            619
;  :final-checks          35
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.27
;  :mk-bool-var           1166
;  :mk-clause             622
;  :num-allocs            179408
;  :num-checks            66
;  :propagations          282
;  :quant-instantiations  183
;  :rlimit-count          210758)
; [state consolidation]
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; [eval] 0 <= v
(set-option :timeout 0)
(push) ; 3
(assert (not (<= 0 s@46@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             165
;  :arith-add-rows        106
;  :arith-assert-diseq    130
;  :arith-assert-lower    272
;  :arith-assert-upper    39
;  :arith-bound-prop      31
;  :arith-conflicts       7
;  :arith-eq-adapter      54
;  :arith-fixed-eqs       12
;  :arith-offset-eqs      6
;  :arith-pivots          88
;  :conflicts             18
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 37
;  :decisions             52
;  :del-clause            619
;  :final-checks          37
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.27
;  :mk-bool-var           1167
;  :mk-clause             622
;  :num-allocs            180167
;  :num-checks            68
;  :propagations          284
;  :quant-instantiations  183
;  :rlimit-count          211622)
(pop) ; 2
(pop) ; 1
; ---------- FUNCTION any_as----------
(declare-fun t@49@00 () any)
(declare-fun result@50@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(pop) ; 1
(assert (forall ((s@$ $Snap) (t@49@00 any)) (!
  (= (any_as%limited s@$ t@49@00) (any_as s@$ t@49@00))
  :pattern ((any_as s@$ t@49@00))
  )))
(assert (forall ((s@$ $Snap) (t@49@00 any)) (!
  (any_as%stateless t@49@00)
  :pattern ((any_as%limited s@$ t@49@00))
  )))
; ---------- FUNCTION opt_get----------
(declare-fun opt1@51@00 () option<any>)
(declare-fun result@52@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(assert (not (= opt1@51@00 (as None<option<any>>  option<any>))))
(declare-const $t@107@00 $Snap)
(assert (= $t@107@00 $Snap.unit))
; [eval] (some(result): option[any]) == opt1
; [eval] (some(result): option[any])
(assert (= (some<option<any>> result@52@00) opt1@51@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@51@00 option<any>)) (!
  (= (opt_get%limited s@$ opt1@51@00) (opt_get s@$ opt1@51@00))
  :pattern ((opt_get s@$ opt1@51@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@51@00 option<any>)) (!
  (opt_get%stateless opt1@51@00)
  :pattern ((opt_get%limited s@$ opt1@51@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@51@00 option<any>)) (!
  (let ((result@52@00 (opt_get%limited s@$ opt1@51@00))) (implies
    (not (= opt1@51@00 (as None<option<any>>  option<any>)))
    (= (some<option<any>> result@52@00) opt1@51@00)))
  :pattern ((opt_get%limited s@$ opt1@51@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ $Snap.unit))
(assert (not (= opt1@51@00 (as None<option<any>>  option<any>))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (option_get(opt1): any)
(assert (= result@52@00 (option_get<any> opt1@51@00)))
; [eval] (some(result): option[any]) == opt1
; [eval] (some(result): option[any])
(set-option :timeout 0)
(push) ; 2
(assert (not (= (some<option<any>> result@52@00) opt1@51@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             169
;  :arith-add-rows        106
;  :arith-assert-diseq    130
;  :arith-assert-lower    272
;  :arith-assert-upper    39
;  :arith-bound-prop      31
;  :arith-conflicts       7
;  :arith-eq-adapter      54
;  :arith-fixed-eqs       12
;  :arith-offset-eqs      6
;  :arith-pivots          89
;  :conflicts             19
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 38
;  :decisions             52
;  :del-clause            622
;  :final-checks          38
;  :max-generation        4
;  :max-memory            4.38
;  :memory                4.26
;  :mk-bool-var           1178
;  :mk-clause             622
;  :num-allocs            181332
;  :num-checks            70
;  :propagations          284
;  :quant-instantiations  185
;  :rlimit-count          212839)
(assert (= (some<option<any>> result@52@00) opt1@51@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@51@00 option<any>)) (!
  (implies
    (not (= opt1@51@00 (as None<option<any>>  option<any>)))
    (= (opt_get s@$ opt1@51@00) (option_get<any> opt1@51@00)))
  :pattern ((opt_get s@$ opt1@51@00))
  )))
; ---------- FUNCTION ExAugPath----------
(declare-fun this@53@00 () $Ref)
(declare-fun G@54@00 () Seq<Seq<Int>>)
(declare-fun V@55@00 () Int)
(declare-fun s@56@00 () Int)
(declare-fun t@57@00 () Int)
(declare-fun result@58@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@53@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] SquareIntMatrix(this, G, V)
(push) ; 2
; [eval] this != null
(pop) ; 2
; Joined path conditions
(assert (SquareIntMatrix $Snap.unit this@53@00 G@54@00 V@55@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 Seq<Seq<Int>>) (V@55@00 Int) (s@56@00 Int) (t@57@00 Int)) (!
  (=
    (ExAugPath%limited s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00)
    (ExAugPath s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  :pattern ((ExAugPath s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  )))
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 Seq<Seq<Int>>) (V@55@00 Int) (s@56@00 Int) (t@57@00 Int)) (!
  (ExAugPath%stateless this@53@00 G@54@00 V@55@00 s@56@00 t@57@00)
  :pattern ((ExAugPath%limited s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@53@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (SquareIntMatrix $Snap.unit this@53@00 G@54@00 V@55@00))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (exists P: Seq[Int] :: { AugPath(this, G, V, s, t, P) } { |P| } AugPath(this, G, V, s, t, P) && |P| <= V)
(declare-const P@108@00 Seq<Int>)
(push) ; 2
; [eval] AugPath(this, G, V, s, t, P) && |P| <= V
; [eval] AugPath(this, G, V, s, t, P)
(push) ; 3
; [eval] this != null
; [eval] SquareIntMatrix(this, G, V)
(push) ; 4
; [eval] this != null
(pop) ; 4
; Joined path conditions
(pop) ; 3
; Joined path conditions
(push) ; 3
; [then-branch: 56 | AugPath((_, _), this@53@00, G@54@00, V@55@00, s@56@00, t@57@00, P@108@00) | live]
; [else-branch: 56 | !(AugPath((_, _), this@53@00, G@54@00, V@55@00, s@56@00, t@57@00, P@108@00)) | live]
(push) ; 4
; [then-branch: 56 | AugPath((_, _), this@53@00, G@54@00, V@55@00, s@56@00, t@57@00, P@108@00)]
(assert (AugPath ($Snap.combine $Snap.unit $Snap.unit) this@53@00 G@54@00 V@55@00 s@56@00 t@57@00 P@108@00))
; [eval] |P| <= V
; [eval] |P|
(pop) ; 4
(push) ; 4
; [else-branch: 56 | !(AugPath((_, _), this@53@00, G@54@00, V@55@00, s@56@00, t@57@00, P@108@00))]
(assert (not
  (AugPath ($Snap.combine $Snap.unit $Snap.unit) this@53@00 G@54@00 V@55@00 s@56@00 t@57@00 P@108@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (=
  result@58@00
  (exists ((P@108@00 Seq<Int>)) (!
    (and
      (<= (Seq_length P@108@00) V@55@00)
      (AugPath ($Snap.combine $Snap.unit $Snap.unit) this@53@00 G@54@00 V@55@00 s@56@00 t@57@00 P@108@00))
    :pattern ((AugPath%limited ($Snap.combine $Snap.unit $Snap.unit) this@53@00 G@54@00 V@55@00 s@56@00 t@57@00 P@108@00))
    :pattern ((Seq_length P@108@00))
    :qid |prog.l<no position>|))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@53@00 $Ref) (G@54@00 Seq<Seq<Int>>) (V@55@00 Int) (s@56@00 Int) (t@57@00 Int)) (!
  (implies
    (and
      (not (= this@53@00 $Ref.null))
      (SquareIntMatrix $Snap.unit this@53@00 G@54@00 V@55@00))
    (=
      (ExAugPath s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00)
      (exists ((P Seq<Int>)) (!
        (and
          (AugPath ($Snap.combine $Snap.unit $Snap.unit) this@53@00 G@54@00 V@55@00 s@56@00 t@57@00 P)
          (<= (Seq_length P) V@55@00))
        :pattern ((AugPath%limited ($Snap.combine $Snap.unit $Snap.unit) this@53@00 G@54@00 V@55@00 s@56@00 t@57@00 P))
        :pattern ((Seq_length P))
        ))))
  :pattern ((ExAugPath s@$ this@53@00 G@54@00 V@55@00 s@56@00 t@57@00))
  )))
; ---------- FUNCTION initializeSeqWithZeros----------
(declare-fun this@59@00 () $Ref)
(declare-fun p@60@00 () Seq<Int>)
(declare-fun n@61@00 () Int)
(declare-fun result@62@00 () Seq<Int>)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@59@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] n <= |p|
; [eval] |p|
(assert (<= n@61@00 (Seq_length p@60@00)))
(declare-const $t@109@00 $Snap)
(assert (= $t@109@00 ($Snap.combine ($Snap.first $t@109@00) ($Snap.second $t@109@00))))
(assert (= ($Snap.first $t@109@00) $Snap.unit))
; [eval] n < 0 ==> |initializeSeqWithZeros(this, p, n)| == 0
; [eval] n < 0
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< n@61@00 0))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               203
;  :arith-add-rows          108
;  :arith-assert-diseq      133
;  :arith-assert-lower      277
;  :arith-assert-upper      44
;  :arith-bound-prop        33
;  :arith-conflicts         7
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        6
;  :arith-pivots            91
;  :conflicts               19
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   43
;  :datatype-splits         1
;  :decisions               55
;  :del-clause              653
;  :final-checks            41
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             1235
;  :mk-clause               656
;  :num-allocs              183588
;  :num-checks              72
;  :propagations            294
;  :quant-instantiations    194
;  :rlimit-count            216060)
(push) ; 3
(assert (not (< n@61@00 0)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               206
;  :arith-add-rows          108
;  :arith-assert-diseq      134
;  :arith-assert-lower      279
;  :arith-assert-upper      44
;  :arith-bound-prop        33
;  :arith-conflicts         7
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        6
;  :arith-pivots            91
;  :conflicts               19
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   47
;  :datatype-splits         2
;  :decisions               57
;  :del-clause              653
;  :final-checks            43
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             1237
;  :mk-clause               656
;  :num-allocs              184021
;  :num-checks              73
;  :propagations            295
;  :quant-instantiations    194
;  :rlimit-count            216548)
; [then-branch: 57 | n@61@00 < 0 | live]
; [else-branch: 57 | !(n@61@00 < 0) | live]
(push) ; 3
; [then-branch: 57 | n@61@00 < 0]
(assert (< n@61@00 0))
; [eval] |initializeSeqWithZeros(this, p, n)| == 0
; [eval] |initializeSeqWithZeros(this, p, n)|
; [eval] initializeSeqWithZeros(this, p, n)
(push) ; 4
; [eval] this != null
; [eval] n <= |p|
; [eval] |p|
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 57 | !(n@61@00 < 0)]
(assert (not (< n@61@00 0)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (< n@61@00 0)
  (=
    (Seq_length
      (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
    0)))
(assert (=
  ($Snap.second $t@109@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@109@00))
    ($Snap.second ($Snap.second $t@109@00)))))
(assert (= ($Snap.first ($Snap.second $t@109@00)) $Snap.unit))
; [eval] 0 <= n ==> |initializeSeqWithZeros(this, p, n)| == n
; [eval] 0 <= n
(push) ; 2
(push) ; 3
(assert (not (not (<= 0 n@61@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               215
;  :arith-add-rows          108
;  :arith-assert-diseq      135
;  :arith-assert-lower      281
;  :arith-assert-upper      45
;  :arith-bound-prop        33
;  :arith-conflicts         7
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        6
;  :arith-pivots            91
;  :conflicts               19
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   51
;  :datatype-splits         3
;  :decisions               59
;  :del-clause              653
;  :final-checks            45
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             1243
;  :mk-clause               657
;  :num-allocs              184642
;  :num-checks              74
;  :propagations            296
;  :quant-instantiations    194
;  :rlimit-count            217374)
(push) ; 3
(assert (not (<= 0 n@61@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               220
;  :arith-add-rows          108
;  :arith-assert-diseq      136
;  :arith-assert-lower      283
;  :arith-assert-upper      47
;  :arith-bound-prop        33
;  :arith-conflicts         7
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        6
;  :arith-pivots            91
;  :conflicts               19
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   55
;  :datatype-splits         4
;  :decisions               61
;  :del-clause              653
;  :final-checks            47
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             1247
;  :mk-clause               657
;  :num-allocs              185105
;  :num-checks              75
;  :propagations            298
;  :quant-instantiations    196
;  :rlimit-count            217926)
; [then-branch: 58 | 0 <= n@61@00 | live]
; [else-branch: 58 | !(0 <= n@61@00) | live]
(push) ; 3
; [then-branch: 58 | 0 <= n@61@00]
(assert (<= 0 n@61@00))
; [eval] |initializeSeqWithZeros(this, p, n)| == n
; [eval] |initializeSeqWithZeros(this, p, n)|
; [eval] initializeSeqWithZeros(this, p, n)
(push) ; 4
; [eval] this != null
; [eval] n <= |p|
; [eval] |p|
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 58 | !(0 <= n@61@00)]
(assert (not (<= 0 n@61@00)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (<= 0 n@61@00)
  (=
    (Seq_length
      (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
    n@61@00)))
(assert (= ($Snap.second ($Snap.second $t@109@00)) $Snap.unit))
; [eval] (forall i1: Int :: { p[i1] } 0 <= i1 && i1 < n ==> p[i1] == 0)
(declare-const i1@110@00 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < n ==> p[i1] == 0
; [eval] 0 <= i1 && i1 < n
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 59 | 0 <= i1@110@00 | live]
; [else-branch: 59 | !(0 <= i1@110@00) | live]
(push) ; 4
; [then-branch: 59 | 0 <= i1@110@00]
(assert (<= 0 i1@110@00))
; [eval] i1 < n
(pop) ; 4
(push) ; 4
; [else-branch: 59 | !(0 <= i1@110@00)]
(assert (not (<= 0 i1@110@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 60 | i1@110@00 < n@61@00 && 0 <= i1@110@00 | live]
; [else-branch: 60 | !(i1@110@00 < n@61@00 && 0 <= i1@110@00) | live]
(push) ; 4
; [then-branch: 60 | i1@110@00 < n@61@00 && 0 <= i1@110@00]
(assert (and (< i1@110@00 n@61@00) (<= 0 i1@110@00)))
; [eval] p[i1] == 0
; [eval] p[i1]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i1@110@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               225
;  :arith-add-rows          110
;  :arith-assert-diseq      137
;  :arith-assert-lower      290
;  :arith-assert-upper      48
;  :arith-bound-prop        35
;  :arith-conflicts         7
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :conflicts               19
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   55
;  :datatype-splits         4
;  :decisions               61
;  :del-clause              653
;  :final-checks            47
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             1256
;  :mk-clause               661
;  :num-allocs              185373
;  :num-checks              76
;  :propagations            300
;  :quant-instantiations    198
;  :rlimit-count            218389)
(push) ; 5
(assert (not (< i1@110@00 (Seq_length p@60@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               225
;  :arith-add-rows          116
;  :arith-assert-diseq      137
;  :arith-assert-lower      290
;  :arith-assert-upper      49
;  :arith-bound-prop        35
;  :arith-conflicts         8
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        6
;  :arith-pivots            97
;  :conflicts               20
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   55
;  :datatype-splits         4
;  :decisions               61
;  :del-clause              653
;  :final-checks            47
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             1257
;  :mk-clause               661
;  :num-allocs              185455
;  :num-checks              77
;  :propagations            300
;  :quant-instantiations    198
;  :rlimit-count            218577)
(pop) ; 4
(push) ; 4
; [else-branch: 60 | !(i1@110@00 < n@61@00 && 0 <= i1@110@00)]
(assert (not (and (< i1@110@00 n@61@00) (<= 0 i1@110@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i1@110@00 Int)) (!
  (implies
    (and (< i1@110@00 n@61@00) (<= 0 i1@110@00))
    (= (Seq_index p@60@00 i1@110@00) 0))
  :pattern ((Seq_index p@60@00 i1@110@00))
  :qid |prog.l<no position>|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@59@00 $Ref) (p@60@00 Seq<Int>) (n@61@00 Int)) (!
  (Seq_equal
    (initializeSeqWithZeros%limited s@$ this@59@00 p@60@00 n@61@00)
    (initializeSeqWithZeros s@$ this@59@00 p@60@00 n@61@00))
  :pattern ((initializeSeqWithZeros s@$ this@59@00 p@60@00 n@61@00))
  )))
(assert (forall ((s@$ $Snap) (this@59@00 $Ref) (p@60@00 Seq<Int>) (n@61@00 Int)) (!
  (initializeSeqWithZeros%stateless this@59@00 p@60@00 n@61@00)
  :pattern ((initializeSeqWithZeros%limited s@$ this@59@00 p@60@00 n@61@00))
  )))
(assert (forall ((s@$ $Snap) (this@59@00 $Ref) (p@60@00 Seq<Int>) (n@61@00 Int)) (!
  (let ((result@62@00 (initializeSeqWithZeros%limited s@$ this@59@00 p@60@00 n@61@00))) (implies
    (and (not (= this@59@00 $Ref.null)) (<= n@61@00 (Seq_length p@60@00)))
    (and
      (implies
        (< n@61@00 0)
        (=
          (Seq_length
            (initializeSeqWithZeros%limited ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
          0))
      (implies
        (<= 0 n@61@00)
        (=
          (Seq_length
            (initializeSeqWithZeros%limited ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
          n@61@00))
      (forall ((i1 Int)) (!
        (implies (and (<= 0 i1) (< i1 n@61@00)) (= (Seq_index p@60@00 i1) 0))
        :pattern ((Seq_index p@60@00 i1))
        )))))
  :pattern ((initializeSeqWithZeros%limited s@$ this@59@00 p@60@00 n@61@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@59@00 $Ref.null)))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (<= n@61@00 (Seq_length p@60@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (0 < n ? Seq(0) ++ initializeSeqWithZeros(this, p, n - 1) : Seq[Int]())
; [eval] 0 < n
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 n@61@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               232
;  :arith-add-rows          117
;  :arith-assert-diseq      139
;  :arith-assert-lower      294
;  :arith-assert-upper      50
;  :arith-bound-prop        36
;  :arith-conflicts         8
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        6
;  :arith-pivots            100
;  :conflicts               20
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   57
;  :datatype-splits         4
;  :decisions               62
;  :del-clause              662
;  :final-checks            49
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             1270
;  :mk-clause               665
;  :num-allocs              186958
;  :num-checks              79
;  :propagations            302
;  :quant-instantiations    200
;  :rlimit-count            220670)
(push) ; 3
(assert (not (< 0 n@61@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               232
;  :arith-add-rows          117
;  :arith-assert-diseq      140
;  :arith-assert-lower      295
;  :arith-assert-upper      51
;  :arith-bound-prop        36
;  :arith-conflicts         8
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        6
;  :arith-pivots            101
;  :conflicts               20
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   58
;  :datatype-splits         4
;  :decisions               63
;  :del-clause              662
;  :final-checks            50
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             1271
;  :mk-clause               665
;  :num-allocs              187374
;  :num-checks              80
;  :propagations            303
;  :quant-instantiations    200
;  :rlimit-count            221137)
; [then-branch: 61 | 0 < n@61@00 | live]
; [else-branch: 61 | !(0 < n@61@00) | live]
(push) ; 3
; [then-branch: 61 | 0 < n@61@00]
(assert (< 0 n@61@00))
; [eval] Seq(0) ++ initializeSeqWithZeros(this, p, n - 1)
; [eval] Seq(0)
(assert (= (Seq_length (Seq_singleton 0)) 1))
; [eval] initializeSeqWithZeros(this, p, n - 1)
; [eval] n - 1
(push) ; 4
; [eval] this != null
; [eval] n <= |p|
; [eval] |p|
(set-option :timeout 0)
(push) ; 5
(assert (not (<= (- n@61@00 1) (Seq_length p@60@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               233
;  :arith-add-rows          117
;  :arith-assert-diseq      142
;  :arith-assert-lower      301
;  :arith-assert-upper      52
;  :arith-bound-prop        37
;  :arith-conflicts         9
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        6
;  :arith-pivots            101
;  :conflicts               21
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   58
;  :datatype-splits         4
;  :decisions               63
;  :del-clause              662
;  :final-checks            50
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             1280
;  :mk-clause               669
;  :num-allocs              187571
;  :num-checks              81
;  :propagations            305
;  :quant-instantiations    202
;  :rlimit-count            221427)
(assert (<= (- n@61@00 1) (Seq_length p@60@00)))
(pop) ; 4
; Joined path conditions
(assert (<= (- n@61@00 1) (Seq_length p@60@00)))
(pop) ; 3
(push) ; 3
; [else-branch: 61 | !(0 < n@61@00)]
(assert (not (< 0 n@61@00)))
; [eval] Seq[Int]()
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 n@61@00)
  (and
    (< 0 n@61@00)
    (= (Seq_length (Seq_singleton 0)) 1)
    (<= (- n@61@00 1) (Seq_length p@60@00)))))
; Joined path conditions
(assert (Seq_equal
  result@62@00
  (ite
    (< 0 n@61@00)
    (Seq_append
      (Seq_singleton 0)
      (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 (-
        n@61@00
        1)))
    (as Seq_empty  Seq<Int>))))
; [eval] n < 0 ==> |initializeSeqWithZeros(this, p, n)| == 0
; [eval] n < 0
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< n@61@00 0))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               245
;  :arith-add-rows          118
;  :arith-assert-diseq      143
;  :arith-assert-lower      305
;  :arith-assert-upper      57
;  :arith-bound-prop        37
;  :arith-conflicts         9
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :conflicts               21
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   59
;  :datatype-splits         4
;  :decisions               64
;  :del-clause              667
;  :final-checks            51
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             1308
;  :mk-clause               691
;  :num-allocs              188275
;  :num-checks              82
;  :propagations            314
;  :quant-instantiations    206
;  :rlimit-count            222567)
(push) ; 3
(assert (not (< n@61@00 0)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               253
;  :arith-add-rows          118
;  :arith-assert-diseq      144
;  :arith-assert-lower      308
;  :arith-assert-upper      60
;  :arith-bound-prop        37
;  :arith-conflicts         9
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         19
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :conflicts               21
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   60
;  :datatype-splits         4
;  :decisions               66
;  :del-clause              668
;  :final-checks            52
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             1312
;  :mk-clause               692
;  :num-allocs              188722
;  :num-checks              83
;  :propagations            318
;  :quant-instantiations    206
;  :rlimit-count            223074)
; [then-branch: 62 | n@61@00 < 0 | live]
; [else-branch: 62 | !(n@61@00 < 0) | live]
(push) ; 3
; [then-branch: 62 | n@61@00 < 0]
(assert (< n@61@00 0))
; [eval] |initializeSeqWithZeros(this, p, n)| == 0
; [eval] |initializeSeqWithZeros(this, p, n)|
; [eval] initializeSeqWithZeros(this, p, n)
(push) ; 4
; [eval] this != null
; [eval] n <= |p|
; [eval] |p|
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 62 | !(n@61@00 < 0)]
(assert (not (< n@61@00 0)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (implies
  (< n@61@00 0)
  (=
    (Seq_length
      (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
    0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               267
;  :arith-add-rows          118
;  :arith-assert-diseq      145
;  :arith-assert-lower      310
;  :arith-assert-upper      66
;  :arith-bound-prop        37
;  :arith-conflicts         9
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :conflicts               22
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   60
;  :datatype-splits         4
;  :decisions               66
;  :del-clause              693
;  :final-checks            52
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             1347
;  :mk-clause               717
;  :num-allocs              189038
;  :num-checks              84
;  :propagations            333
;  :quant-instantiations    212
;  :rlimit-count            223689)
(assert (implies
  (< n@61@00 0)
  (=
    (Seq_length
      (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
    0)))
; [eval] 0 <= n ==> |initializeSeqWithZeros(this, p, n)| == n
; [eval] 0 <= n
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (<= 0 n@61@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               275
;  :arith-add-rows          118
;  :arith-assert-diseq      146
;  :arith-assert-lower      313
;  :arith-assert-upper      69
;  :arith-bound-prop        37
;  :arith-conflicts         9
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        6
;  :arith-pivots            102
;  :conflicts               22
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   61
;  :datatype-splits         4
;  :decisions               68
;  :del-clause              694
;  :final-checks            53
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             1352
;  :mk-clause               720
;  :num-allocs              189550
;  :num-checks              85
;  :propagations            337
;  :quant-instantiations    212
;  :rlimit-count            224289)
(push) ; 3
(assert (not (<= 0 n@61@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               296
;  :arith-add-rows          118
;  :arith-assert-diseq      149
;  :arith-assert-lower      317
;  :arith-assert-upper      77
;  :arith-bound-prop        39
;  :arith-conflicts         9
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        7
;  :arith-pivots            102
;  :conflicts               22
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               69
;  :del-clause              729
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             1387
;  :mk-clause               755
;  :num-allocs              190168
;  :num-checks              86
;  :propagations            355
;  :quant-instantiations    221
;  :rlimit-count            225209)
; [then-branch: 63 | 0 <= n@61@00 | live]
; [else-branch: 63 | !(0 <= n@61@00) | live]
(push) ; 3
; [then-branch: 63 | 0 <= n@61@00]
(assert (<= 0 n@61@00))
; [eval] |initializeSeqWithZeros(this, p, n)| == n
; [eval] |initializeSeqWithZeros(this, p, n)|
; [eval] initializeSeqWithZeros(this, p, n)
(push) ; 4
; [eval] this != null
; [eval] n <= |p|
; [eval] |p|
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 63 | !(0 <= n@61@00)]
(assert (not (<= 0 n@61@00)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (implies
  (<= 0 n@61@00)
  (=
    (Seq_length
      (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
    n@61@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               299
;  :arith-add-rows          118
;  :arith-assert-diseq      150
;  :arith-assert-lower      320
;  :arith-assert-upper      77
;  :arith-bound-prop        39
;  :arith-conflicts         9
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        7
;  :arith-pivots            102
;  :conflicts               23
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               69
;  :del-clause              758
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             1417
;  :mk-clause               784
;  :num-allocs              190432
;  :num-checks              87
;  :propagations            362
;  :quant-instantiations    228
;  :rlimit-count            225711)
(assert (implies
  (<= 0 n@61@00)
  (=
    (Seq_length
      (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 n@61@00))
    n@61@00)))
; [eval] (forall i1: Int :: { p[i1] } 0 <= i1 && i1 < n ==> p[i1] == 0)
(declare-const i1@111@00 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < n ==> p[i1] == 0
; [eval] 0 <= i1 && i1 < n
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 64 | 0 <= i1@111@00 | live]
; [else-branch: 64 | !(0 <= i1@111@00) | live]
(push) ; 4
; [then-branch: 64 | 0 <= i1@111@00]
(assert (<= 0 i1@111@00))
; [eval] i1 < n
(pop) ; 4
(push) ; 4
; [else-branch: 64 | !(0 <= i1@111@00)]
(assert (not (<= 0 i1@111@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 65 | i1@111@00 < n@61@00 && 0 <= i1@111@00 | live]
; [else-branch: 65 | !(i1@111@00 < n@61@00 && 0 <= i1@111@00) | live]
(push) ; 4
; [then-branch: 65 | i1@111@00 < n@61@00 && 0 <= i1@111@00]
(assert (and (< i1@111@00 n@61@00) (<= 0 i1@111@00)))
; [eval] p[i1] == 0
; [eval] p[i1]
(push) ; 5
(assert (not (>= i1@111@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               325
;  :arith-add-rows          128
;  :arith-assert-diseq      154
;  :arith-assert-lower      340
;  :arith-assert-upper      84
;  :arith-bound-prop        45
;  :arith-conflicts         9
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        7
;  :arith-pivots            108
;  :conflicts               23
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               69
;  :del-clause              758
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             1493
;  :mk-clause               856
;  :num-allocs              191033
;  :num-checks              88
;  :propagations            390
;  :quant-instantiations    245
;  :rlimit-count            226829)
(push) ; 5
(assert (not (< i1@111@00 (Seq_length p@60@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               325
;  :arith-add-rows          148
;  :arith-assert-diseq      154
;  :arith-assert-lower      340
;  :arith-assert-upper      85
;  :arith-bound-prop        45
;  :arith-conflicts         10
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        7
;  :arith-pivots            110
;  :conflicts               24
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               69
;  :del-clause              758
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             1494
;  :mk-clause               856
;  :num-allocs              191122
;  :num-checks              89
;  :propagations            390
;  :quant-instantiations    245
;  :rlimit-count            227256)
(pop) ; 4
(push) ; 4
; [else-branch: 65 | !(i1@111@00 < n@61@00 && 0 <= i1@111@00)]
(assert (not (and (< i1@111@00 n@61@00) (<= 0 i1@111@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 2
(assert (not (forall ((i1@111@00 Int)) (!
  (implies
    (and (< i1@111@00 n@61@00) (<= 0 i1@111@00))
    (= (Seq_index p@60@00 i1@111@00) 0))
  :pattern ((Seq_index p@60@00 i1@111@00))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :arith-add-rows          159
;  :arith-assert-diseq      156
;  :arith-assert-lower      353
;  :arith-assert-upper      90
;  :arith-bound-prop        49
;  :arith-conflicts         10
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        8
;  :arith-pivots            124
;  :conflicts               25
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               69
;  :del-clause              900
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.34
;  :mk-bool-var             1570
;  :mk-clause               927
;  :num-allocs              191652
;  :num-checks              90
;  :propagations            413
;  :quant-instantiations    264
;  :rlimit-count            228556)
(assert (forall ((i1@111@00 Int)) (!
  (implies
    (and (< i1@111@00 n@61@00) (<= 0 i1@111@00))
    (= (Seq_index p@60@00 i1@111@00) 0))
  :pattern ((Seq_index p@60@00 i1@111@00))
  :qid |prog.l<no position>|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@59@00 $Ref) (p@60@00 Seq<Int>) (n@61@00 Int)) (!
  (implies
    (and (not (= this@59@00 $Ref.null)) (<= n@61@00 (Seq_length p@60@00)))
    (Seq_equal
      (initializeSeqWithZeros s@$ this@59@00 p@60@00 n@61@00)
      (ite
        (< 0 n@61@00)
        (Seq_append
          (Seq_singleton 0)
          (initializeSeqWithZeros%limited ($Snap.combine $Snap.unit $Snap.unit) this@59@00 p@60@00 (-
            n@61@00
            1)))
        (as Seq_empty  Seq<Int>))))
  :pattern ((initializeSeqWithZeros s@$ this@59@00 p@60@00 n@61@00))
  )))
; ---------- FUNCTION valid_graph_vertices----------
(declare-fun this@63@00 () $Ref)
(declare-fun p@64@00 () option<array>)
(declare-fun V@65@00 () Int)
(declare-fun result@66@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@63@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] p != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= p@64@00 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] alen(opt_get1(p)) == V
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (opt_get1 $Snap.unit p@64@00)) V@65@00))
(declare-const i1@112@00 Int)
(push) ; 2
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 3
; [then-branch: 66 | 0 <= i1@112@00 | live]
; [else-branch: 66 | !(0 <= i1@112@00) | live]
(push) ; 4
; [then-branch: 66 | 0 <= i1@112@00]
(assert (<= 0 i1@112@00))
; [eval] i1 < V
(pop) ; 4
(push) ; 4
; [else-branch: 66 | !(0 <= i1@112@00)]
(assert (not (<= 0 i1@112@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< i1@112@00 V@65@00) (<= 0 i1@112@00)))
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
(push) ; 4
(assert (not (< i1@112@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               367
;  :arith-add-rows          161
;  :arith-assert-diseq      156
;  :arith-assert-lower      357
;  :arith-assert-upper      91
;  :arith-bound-prop        49
;  :arith-conflicts         10
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        8
;  :arith-pivots            127
;  :conflicts               25
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               69
;  :del-clause              927
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.35
;  :mk-bool-var             1589
;  :mk-clause               927
;  :num-allocs              192301
;  :num-checks              91
;  :propagations            413
;  :quant-instantiations    269
;  :rlimit-count            229796)
(assert (< i1@112@00 (alen<Int> (opt_get1 $Snap.unit p@64@00))))
(pop) ; 3
; Joined path conditions
(assert (< i1@112@00 (alen<Int> (opt_get1 $Snap.unit p@64@00))))
(declare-const $k@113@00 $Perm)
(assert ($Perm.isReadVar $k@113@00 $Perm.Write))
(pop) ; 2
(declare-fun inv@114@00 ($Snap $Ref option<array> Int $Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@113@00 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@112@00 Int)) (!
  (< i1@112@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-aux|)))
(push) ; 2
(assert (not (forall ((i1@112@00 Int)) (!
  (implies
    (and (< i1@112@00 V@65@00) (<= 0 i1@112@00))
    (or (= $k@113@00 $Perm.No) (< $Perm.No $k@113@00)))
  
  ))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               369
;  :arith-add-rows          161
;  :arith-assert-diseq      157
;  :arith-assert-lower      359
;  :arith-assert-upper      92
;  :arith-bound-prop        49
;  :arith-conflicts         10
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        8
;  :arith-pivots            129
;  :conflicts               26
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               69
;  :del-clause              927
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.35
;  :mk-bool-var             1596
;  :mk-clause               929
;  :num-allocs              192781
;  :num-checks              92
;  :propagations            414
;  :quant-instantiations    269
;  :rlimit-count            230376)
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((i11@112@00 Int) (i12@112@00 Int)) (!
  (implies
    (and
      (and (and (< i11@112@00 V@65@00) (<= 0 i11@112@00)) (< $Perm.No $k@113@00))
      (and (and (< i12@112@00 V@65@00) (<= 0 i12@112@00)) (< $Perm.No $k@113@00))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i11@112@00)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i12@112@00)))
    (= i11@112@00 i12@112@00))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               388
;  :arith-add-rows          183
;  :arith-assert-diseq      160
;  :arith-assert-lower      368
;  :arith-assert-upper      98
;  :arith-bound-prop        49
;  :arith-conflicts         13
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        10
;  :arith-pivots            139
;  :conflicts               29
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   62
;  :datatype-splits         4
;  :decisions               71
;  :del-clause              943
;  :final-checks            54
;  :max-generation          4
;  :max-memory              4.38
;  :memory                  4.35
;  :mk-bool-var             1620
;  :mk-clause               945
;  :num-allocs              193185
;  :num-checks              93
;  :propagations            429
;  :quant-instantiations    279
;  :rlimit-count            231586)
; Definitional axioms for inverse functions
(assert (forall ((i1@112@00 Int)) (!
  (implies
    (and (and (< i1@112@00 V@65@00) (<= 0 i1@112@00)) (< $Perm.No $k@113@00))
    (=
      (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
      i1@112@00))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
        (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
      (< $Perm.No $k@113@00))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
      r))
  :pattern ((inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@112@00 Int)) (!
  (<= $Perm.No $k@113@00)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@112@00 Int)) (!
  (<= $k@113@00 $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@112@00 Int)) (!
  (implies
    (and (and (< i1@112@00 V@65@00) (<= 0 i1@112@00)) (< $Perm.No $k@113@00))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-permImpliesNonNull|)))
(declare-fun sm@115@00 ($Snap $Ref option<array> Int) $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and
        (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
        (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
      (< $Perm.No $k@113@00)
      false)
    (=
      ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r)))
  :pattern (($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r) r)
  :pattern (($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
      (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
    ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r) r))
  :pattern ((inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
  )))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@63@00 $Ref) (p@64@00 option<array>) (V@65@00 Int)) (!
  (=
    (valid_graph_vertices%limited s@$ this@63@00 p@64@00 V@65@00)
    (valid_graph_vertices s@$ this@63@00 p@64@00 V@65@00))
  :pattern ((valid_graph_vertices s@$ this@63@00 p@64@00 V@65@00))
  )))
(assert (forall ((s@$ $Snap) (this@63@00 $Ref) (p@64@00 option<array>) (V@65@00 Int)) (!
  (valid_graph_vertices%stateless this@63@00 p@64@00 V@65@00)
  :pattern ((valid_graph_vertices%limited s@$ this@63@00 p@64@00 V@65@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
        (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
      (< $Perm.No $k@113@00))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
      r))
  :pattern ((inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and
        (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
        (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
      (< $Perm.No $k@113@00)
      false)
    (=
      ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r)))
  :pattern (($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r) r)
  :pattern (($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((i1@112@00 Int)) (!
  (implies
    (and (and (< i1@112@00 V@65@00) (<= 0 i1@112@00)) (< $Perm.No $k@113@00))
    (=
      (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
      i1@112@00))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  )))
(assert (forall ((i1@112@00 Int)) (!
  (<= $Perm.No $k@113@00)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-permAtLeastZero|)))
(assert (forall ((i1@112@00 Int)) (!
  (<= $k@113@00 $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-permAtMostOne|)))
(assert (forall ((i1@112@00 Int)) (!
  (implies
    (and (and (< i1@112@00 V@65@00) (<= 0 i1@112@00)) (< $Perm.No $k@113@00))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-permImpliesNonNull|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
      (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
    ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r) r))
  :pattern ((inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
  )))
(assert ($Perm.isReadVar $k@113@00 $Perm.Write))
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@63@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (not (= p@64@00 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (= (alen<Int> (opt_get1 $Snap.unit p@64@00)) V@65@00))
(assert (forall ((i1@112@00 Int)) (!
  (< i1@112@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
  :qid |int-aux|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < alen(opt_get1(p)) ==> 0 <= aloc(opt_get1(p), unknown).int) && (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < alen(opt_get1(p)) ==> aloc(opt_get1(p), unknown).int < V)
; [eval] (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < alen(opt_get1(p)) ==> 0 <= aloc(opt_get1(p), unknown).int)
(declare-const unknown@116@00 Int)
(push) ; 2
; [eval] 0 <= unknown && unknown < alen(opt_get1(p)) ==> 0 <= aloc(opt_get1(p), unknown).int
; [eval] 0 <= unknown && unknown < alen(opt_get1(p))
; [eval] 0 <= unknown
(push) ; 3
; [then-branch: 67 | 0 <= unknown@116@00 | live]
; [else-branch: 67 | !(0 <= unknown@116@00) | live]
(push) ; 4
; [then-branch: 67 | 0 <= unknown@116@00]
(assert (<= 0 unknown@116@00))
; [eval] unknown < alen(opt_get1(p))
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 67 | !(0 <= unknown@116@00)]
(assert (not (<= 0 unknown@116@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 68 | unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00 | live]
; [else-branch: 68 | !(unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00) | live]
(push) ; 4
; [then-branch: 68 | unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00]
(assert (and
  (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
  (<= 0 unknown@116@00)))
; [eval] 0 <= aloc(opt_get1(p), unknown).int
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
(pop) ; 5
; Joined path conditions
(assert ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00)))
(set-option :timeout 0)
(push) ; 5
(assert (not (ite
  (and
    (<
      (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))
      V@65@00)
    (<=
      0
      (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))))
  (< $Perm.No $k@113@00)
  false)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               429
;  :arith-add-rows          187
;  :arith-assert-diseq      161
;  :arith-assert-lower      376
;  :arith-assert-upper      102
;  :arith-bound-prop        52
;  :arith-conflicts         13
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        13
;  :arith-pivots            142
;  :conflicts               30
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   65
;  :datatype-splits         5
;  :decisions               72
;  :del-clause              947
;  :final-checks            56
;  :max-generation          4
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             1672
;  :mk-clause               955
;  :num-allocs              196034
;  :num-checks              95
;  :propagations            434
;  :quant-instantiations    294
;  :rlimit-count            236247)
(pop) ; 4
(push) ; 4
; [else-branch: 68 | !(unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00)]
(assert (not
  (and
    (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
    (<= 0 unknown@116@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and
    (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
    (<= 0 unknown@116@00))
  (and
    (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
    (<= 0 unknown@116@00)
    ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00)))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@116@00 Int)) (!
  (implies
    (and
      (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
      (<= 0 unknown@116@00))
    (and
      (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
      (<= 0 unknown@116@00)
      ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(push) ; 2
; [then-branch: 69 | QA unknown@116@00 :: unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00 ==> 0 <= Lookup(int,sm@115@00(s@$, this@63@00, p@64@00, V@65@00),aloc((_, _), opt_get1(_, p@64@00), unknown@116@00)) | live]
; [else-branch: 69 | !(QA unknown@116@00 :: unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00 ==> 0 <= Lookup(int,sm@115@00(s@$, this@63@00, p@64@00, V@65@00),aloc((_, _), opt_get1(_, p@64@00), unknown@116@00))) | live]
(push) ; 3
; [then-branch: 69 | QA unknown@116@00 :: unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00 ==> 0 <= Lookup(int,sm@115@00(s@$, this@63@00, p@64@00, V@65@00),aloc((_, _), opt_get1(_, p@64@00), unknown@116@00))]
(assert (forall ((unknown@116@00 Int)) (!
  (implies
    (and
      (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
      (<= 0 unknown@116@00))
    (<=
      0
      ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))
  :qid |prog.l<no position>|)))
; [eval] (forall unknown: Int :: { aloc(opt_get1(p), unknown) } 0 <= unknown && unknown < alen(opt_get1(p)) ==> aloc(opt_get1(p), unknown).int < V)
(declare-const unknown@117@00 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < alen(opt_get1(p)) ==> aloc(opt_get1(p), unknown).int < V
; [eval] 0 <= unknown && unknown < alen(opt_get1(p))
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 70 | 0 <= unknown@117@00 | live]
; [else-branch: 70 | !(0 <= unknown@117@00) | live]
(push) ; 6
; [then-branch: 70 | 0 <= unknown@117@00]
(assert (<= 0 unknown@117@00))
; [eval] unknown < alen(opt_get1(p))
; [eval] alen(opt_get1(p))
; [eval] opt_get1(p)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 70 | !(0 <= unknown@117@00)]
(assert (not (<= 0 unknown@117@00)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 71 | unknown@117@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@117@00 | live]
; [else-branch: 71 | !(unknown@117@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@117@00) | live]
(push) ; 6
; [then-branch: 71 | unknown@117@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@117@00]
(assert (and
  (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
  (<= 0 unknown@117@00)))
; [eval] aloc(opt_get1(p), unknown).int < V
; [eval] aloc(opt_get1(p), unknown)
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
(pop) ; 7
; Joined path conditions
(assert ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00)))
(push) ; 7
(assert (not (ite
  (and
    (<
      (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))
      V@65@00)
    (<=
      0
      (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))))
  (< $Perm.No $k@113@00)
  false)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               435
;  :arith-add-rows          193
;  :arith-assert-diseq      161
;  :arith-assert-lower      382
;  :arith-assert-upper      105
;  :arith-bound-prop        53
;  :arith-conflicts         14
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        13
;  :arith-pivots            148
;  :conflicts               31
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   65
;  :datatype-splits         5
;  :decisions               72
;  :del-clause              955
;  :final-checks            56
;  :max-generation          4
;  :max-memory              4.41
;  :memory                  4.39
;  :mk-bool-var             1699
;  :mk-clause               962
;  :num-allocs              196863
;  :num-checks              96
;  :propagations            434
;  :quant-instantiations    306
;  :rlimit-count            237893)
(pop) ; 6
(push) ; 6
; [else-branch: 71 | !(unknown@117@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@117@00)]
(assert (not
  (and
    (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
    (<= 0 unknown@117@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and
    (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
    (<= 0 unknown@117@00))
  (and
    (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
    (<= 0 unknown@117@00)
    ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00)))))
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@117@00 Int)) (!
  (implies
    (and
      (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
      (<= 0 unknown@117@00))
    (and
      (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
      (<= 0 unknown@117@00)
      ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 3
(push) ; 3
; [else-branch: 69 | !(QA unknown@116@00 :: unknown@116@00 < alen[Int](opt_get1(_, p@64@00)) && 0 <= unknown@116@00 ==> 0 <= Lookup(int,sm@115@00(s@$, this@63@00, p@64@00, V@65@00),aloc((_, _), opt_get1(_, p@64@00), unknown@116@00)))]
(assert (not
  (forall ((unknown@116@00 Int)) (!
    (implies
      (and
        (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
        (<= 0 unknown@116@00))
      (<=
        0
        ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))
    :qid |prog.l<no position>|))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (forall ((unknown@116@00 Int)) (!
    (implies
      (and
        (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
        (<= 0 unknown@116@00))
      (<=
        0
        ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))
    :qid |prog.l<no position>|))
  (and
    (forall ((unknown@116@00 Int)) (!
      (implies
        (and
          (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
          (<= 0 unknown@116@00))
        (<=
          0
          ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))
      :qid |prog.l<no position>|))
    (forall ((unknown@117@00 Int)) (!
      (implies
        (and
          (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
          (<= 0 unknown@117@00))
        (and
          (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
          (<= 0 unknown@117@00)
          ($FVF.loc_int ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))
      :qid |prog.l<no position>-aux|)))))
; Joined path conditions
(assert (=
  result@66@00
  (and
    (forall ((unknown@117@00 Int)) (!
      (implies
        (and
          (< unknown@117@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
          (<= 0 unknown@117@00))
        (<
          ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))
          V@65@00))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@117@00))
      :qid |prog.l<no position>|))
    (forall ((unknown@116@00 Int)) (!
      (implies
        (and
          (< unknown@116@00 (alen<Int> (opt_get1 $Snap.unit p@64@00)))
          (<= 0 unknown@116@00))
        (<=
          0
          ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown@116@00))
      :qid |prog.l<no position>|)))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@63@00 $Ref) (p@64@00 option<array>) (V@65@00 Int)) (!
  (and
    (forall ((i1@112@00 Int)) (!
      (implies
        (and (and (< i1@112@00 V@65@00) (<= 0 i1@112@00)) (< $Perm.No $k@113@00))
        (=
          (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
          i1@112@00))
      :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) i1@112@00))
      ))
    (forall ((r $Ref)) (!
      (implies
        (and
          (and
            (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
            (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
          (< $Perm.No $k@113@00))
        (=
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
          r))
      :pattern ((inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r))
      :qid |int-fctOfInv|))
    (forall ((r $Ref)) (!
      (implies
        (ite
          (and
            (< (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r) V@65@00)
            (<= 0 (inv@114@00 s@$ this@63@00 p@64@00 V@65@00 r)))
          (< $Perm.No $k@113@00)
          false)
        (=
          ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r)
          ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r)))
      :pattern (($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r))
      :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r))
      :qid |qp.fvfValDef0|))
    (forall ((r $Ref)) (!
      ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second s@$)))) r) r)
      :pattern (($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) r))
      :qid |qp.fvfResTrgDef1|))
    ($Perm.isReadVar $k@113@00 $Perm.Write)
    (implies
      (and
        (not (= this@63@00 $Ref.null))
        (not (= p@64@00 (as None<option<array>>  option<array>)))
        (= (alen<Int> (opt_get1 $Snap.unit p@64@00)) V@65@00))
      (=
        (valid_graph_vertices s@$ this@63@00 p@64@00 V@65@00)
        (and
          (forall ((unknown_ Int)) (!
            (implies
              (and
                (<= 0 unknown_)
                (< unknown_ (alen<Int> (opt_get1 $Snap.unit p@64@00))))
              (<=
                0
                ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown_))))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown_))
            ))
          (forall ((unknown_ Int)) (!
            (implies
              (and
                (<= 0 unknown_)
                (< unknown_ (alen<Int> (opt_get1 $Snap.unit p@64@00))))
              (<
                ($FVF.lookup_int (sm@115@00 s@$ this@63@00 p@64@00 V@65@00) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown_))
                V@65@00))
            :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit p@64@00) unknown_))
            ))))))
  :pattern ((valid_graph_vertices s@$ this@63@00 p@64@00 V@65@00))
  )))
; ---------- FUNCTION FlowNetwork----------
(declare-fun this@67@00 () $Ref)
(declare-fun G@68@00 () Seq<Seq<Int>>)
(declare-fun Gf@69@00 () Seq<Seq<Int>>)
(declare-fun V@70@00 () Int)
(declare-fun s@71@00 () Int)
(declare-fun t@72@00 () Int)
(declare-fun result@73@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@67@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] V == |G|
; [eval] |G|
(assert (= V@70@00 (Seq_length G@68@00)))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] V == |Gf|
; [eval] |Gf|
(assert (= V@70@00 (Seq_length Gf@69@00)))
(assert (= ($Snap.second ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] NonNegativeCapacities(this, G, V)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(assert (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@67@00 G@68@00 V@70@00))
(declare-const $t@118@00 $Snap)
(assert (= $t@118@00 $Snap.unit))
; [eval] NonNegativeCapacities(this, G, V)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@67@00 $Ref) (G@68@00 Seq<Seq<Int>>) (Gf@69@00 Seq<Seq<Int>>) (V@70@00 Int) (s@71@00 Int) (t@72@00 Int)) (!
  (=
    (FlowNetwork%limited s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00)
    (FlowNetwork s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00))
  :pattern ((FlowNetwork s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00))
  )))
(assert (forall ((s@$ $Snap) (this@67@00 $Ref) (G@68@00 Seq<Seq<Int>>) (Gf@69@00 Seq<Seq<Int>>) (V@70@00 Int) (s@71@00 Int) (t@72@00 Int)) (!
  (FlowNetwork%stateless this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00)
  :pattern ((FlowNetwork%limited s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00))
  )))
(assert (forall ((s@$ $Snap) (this@67@00 $Ref) (G@68@00 Seq<Seq<Int>>) (Gf@69@00 Seq<Seq<Int>>) (V@70@00 Int) (s@71@00 Int) (t@72@00 Int)) (!
  (let ((result@73@00 (FlowNetwork%limited s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00))) (implies
    (and
      (not (= this@67@00 $Ref.null))
      (= V@70@00 (Seq_length G@68@00))
      (= V@70@00 (Seq_length Gf@69@00))
      (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@67@00 G@68@00 V@70@00))
    (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@67@00 G@68@00 V@70@00)))
  :pattern ((FlowNetwork%limited s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@67@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (= V@70@00 (Seq_length G@68@00)))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (= V@70@00 (Seq_length Gf@69@00)))
(assert (= ($Snap.second ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@67@00 G@68@00 V@70@00))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] SquareIntMatrix(this, G, V) && SquareIntMatrix(this, Gf, V) && NonNegativeCapacities(this, G, V)
; [eval] SquareIntMatrix(this, G, V)
(push) ; 2
; [eval] this != null
(pop) ; 2
; Joined path conditions
(push) ; 2
; [then-branch: 72 | SquareIntMatrix(_, this@67@00, G@68@00, V@70@00) | live]
; [else-branch: 72 | !(SquareIntMatrix(_, this@67@00, G@68@00, V@70@00)) | live]
(push) ; 3
; [then-branch: 72 | SquareIntMatrix(_, this@67@00, G@68@00, V@70@00)]
(assert (SquareIntMatrix $Snap.unit this@67@00 G@68@00 V@70@00))
; [eval] SquareIntMatrix(this, Gf, V)
(push) ; 4
; [eval] this != null
(pop) ; 4
; Joined path conditions
(push) ; 4
; [then-branch: 73 | SquareIntMatrix(_, this@67@00, Gf@69@00, V@70@00) | live]
; [else-branch: 73 | !(SquareIntMatrix(_, this@67@00, Gf@69@00, V@70@00)) | live]
(push) ; 5
; [then-branch: 73 | SquareIntMatrix(_, this@67@00, Gf@69@00, V@70@00)]
(assert (SquareIntMatrix $Snap.unit this@67@00 Gf@69@00 V@70@00))
; [eval] NonNegativeCapacities(this, G, V)
(push) ; 6
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 73 | !(SquareIntMatrix(_, this@67@00, Gf@69@00, V@70@00))]
(assert (not (SquareIntMatrix $Snap.unit this@67@00 Gf@69@00 V@70@00)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 72 | !(SquareIntMatrix(_, this@67@00, G@68@00, V@70@00))]
(assert (not (SquareIntMatrix $Snap.unit this@67@00 G@68@00 V@70@00)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (=
  result@73@00
  (and
    (and
      (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@67@00 G@68@00 V@70@00)
      (SquareIntMatrix $Snap.unit this@67@00 Gf@69@00 V@70@00))
    (SquareIntMatrix $Snap.unit this@67@00 G@68@00 V@70@00))))
; [eval] NonNegativeCapacities(this, G, V)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@67@00 $Ref) (G@68@00 Seq<Seq<Int>>) (Gf@69@00 Seq<Seq<Int>>) (V@70@00 Int) (s@71@00 Int) (t@72@00 Int)) (!
  (implies
    (and
      (not (= this@67@00 $Ref.null))
      (= V@70@00 (Seq_length G@68@00))
      (= V@70@00 (Seq_length Gf@69@00))
      (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@67@00 G@68@00 V@70@00))
    (=
      (FlowNetwork s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00)
      (and
        (and
          (SquareIntMatrix $Snap.unit this@67@00 G@68@00 V@70@00)
          (SquareIntMatrix $Snap.unit this@67@00 Gf@69@00 V@70@00))
        (NonNegativeCapacities ($Snap.combine $Snap.unit $Snap.unit) this@67@00 G@68@00 V@70@00))))
  :pattern ((FlowNetwork s@$ this@67@00 G@68@00 Gf@69@00 V@70@00 s@71@00 t@72@00))
  )))
; ---------- FUNCTION scale----------
(declare-fun amount@74@00 () $Perm)
(declare-fun result@75@00 () $Perm)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ $Snap.unit))
; [eval] amount >= 0 * write
; [eval] 0 * write
(assert (>= amount@74@00 $Perm.No))
(pop) ; 1
(assert (forall ((s@$ $Snap) (amount@74@00 $Perm)) (!
  (= (scale%limited s@$ amount@74@00) (scale s@$ amount@74@00))
  :pattern ((scale s@$ amount@74@00))
  )))
(assert (forall ((s@$ $Snap) (amount@74@00 $Perm)) (!
  (scale%stateless amount@74@00)
  :pattern ((scale%limited s@$ amount@74@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ $Snap.unit))
(assert (>= amount@74@00 $Perm.No))
; State saturation: after contract
(check-sat)
; unknown
(assert (= result@75@00 amount@74@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (amount@74@00 $Perm)) (!
  (implies (>= amount@74@00 $Perm.No) (= (scale s@$ amount@74@00) amount@74@00))
  :pattern ((scale s@$ amount@74@00))
  )))
; ---------- FUNCTION Flow----------
(declare-fun this@76@00 () $Ref)
(declare-fun G@77@00 () Seq<Seq<Int>>)
(declare-fun Gf@78@00 () Seq<Seq<Int>>)
(declare-fun V@79@00 () Int)
(declare-fun s@80@00 () Int)
(declare-fun t@81@00 () Int)
(declare-fun result@82@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] this != null
(assert (not (= this@76@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] V == |G|
; [eval] |G|
(assert (= V@79@00 (Seq_length G@77@00)))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
; [eval] V == |Gf|
; [eval] |Gf|
(assert (= V@79@00 (Seq_length Gf@78@00)))
(declare-const $t@119@00 $Snap)
(assert (= $t@119@00 ($Snap.combine ($Snap.first $t@119@00) ($Snap.second $t@119@00))))
(assert (= ($Snap.first $t@119@00) $Snap.unit))
; [eval] FlowConservation(this, G, V, s, t)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(assert (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00))
(assert (= ($Snap.second $t@119@00) $Snap.unit))
; [eval] CapacityConstraint(this, G, Gf, V)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
; [eval] V == |Gf|
; [eval] |Gf|
(pop) ; 2
; Joined path conditions
(assert (CapacityConstraint ($Snap.combine
  $Snap.unit
  ($Snap.combine $Snap.unit $Snap.unit)) this@76@00 G@77@00 Gf@78@00 V@79@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (this@76@00 $Ref) (G@77@00 Seq<Seq<Int>>) (Gf@78@00 Seq<Seq<Int>>) (V@79@00 Int) (s@80@00 Int) (t@81@00 Int)) (!
  (=
    (Flow%limited s@$ this@76@00 G@77@00 Gf@78@00 V@79@00 s@80@00 t@81@00)
    (Flow s@$ this@76@00 G@77@00 Gf@78@00 V@79@00 s@80@00 t@81@00))
  :pattern ((Flow s@$ this@76@00 G@77@00 Gf@78@00 V@79@00 s@80@00 t@81@00))
  )))
(assert (forall ((s@$ $Snap) (this@76@00 $Ref) (G@77@00 Seq<Seq<Int>>) (Gf@78@00 Seq<Seq<Int>>) (V@79@00 Int) (s@80@00 Int) (t@81@00 Int)) (!
  (Flow%stateless this@76@00 G@77@00 Gf@78@00 V@79@00 s@80@00 t@81@00)
  :pattern ((Flow%limited s@$ this@76@00 G@77@00 Gf@78@00 V@79@00 s@80@00 t@81@00))
  )))
(assert (forall ((s@$ $Snap) (this@76@00 $Ref) (G@77@00 Seq<Seq<Int>>) (Gf@78@00 Seq<Seq<Int>>) (V@79@00 Int) (s@80@00 Int) (t@81@00 Int)) (!
  (let ((result@82@00 (Flow%limited s@$ this@76@00 G@77@00 Gf@78@00 V@79@00 s@80@00 t@81@00))) (implies
    (and
      (not (= this@76@00 $Ref.null))
      (= V@79@00 (Seq_length G@77@00))
      (= V@79@00 (Seq_length Gf@78@00)))
    (and
      (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00)
      (CapacityConstraint ($Snap.combine
        $Snap.unit
        ($Snap.combine $Snap.unit $Snap.unit)) this@76@00 G@77@00 Gf@78@00 V@79@00))))
  :pattern ((Flow%limited s@$ this@76@00 G@77@00 Gf@78@00 V@79@00 s@80@00 t@81@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= this@76@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (= V@79@00 (Seq_length G@77@00)))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
(assert (= V@79@00 (Seq_length Gf@78@00)))
; State saturation: after contract
(check-sat)
; unknown
; [eval] FlowConservation(this, G, V, s, t) && CapacityConstraint(this, G, Gf, V) && SkewSymetry(this, Gf, V)
; [eval] FlowConservation(this, G, V, s, t)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(push) ; 2
; [then-branch: 74 | FlowConservation((_, _), this@76@00, G@77@00, V@79@00, s@80@00, t@81@00) | live]
; [else-branch: 74 | !(FlowConservation((_, _), this@76@00, G@77@00, V@79@00, s@80@00, t@81@00)) | live]
(push) ; 3
; [then-branch: 74 | FlowConservation((_, _), this@76@00, G@77@00, V@79@00, s@80@00, t@81@00)]
(assert (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00))
; [eval] CapacityConstraint(this, G, Gf, V)
(push) ; 4
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
; [eval] V == |Gf|
; [eval] |Gf|
(pop) ; 4
; Joined path conditions
(push) ; 4
; [then-branch: 75 | CapacityConstraint((_, (_, _)), this@76@00, G@77@00, Gf@78@00, V@79@00) | live]
; [else-branch: 75 | !(CapacityConstraint((_, (_, _)), this@76@00, G@77@00, Gf@78@00, V@79@00)) | live]
(push) ; 5
; [then-branch: 75 | CapacityConstraint((_, (_, _)), this@76@00, G@77@00, Gf@78@00, V@79@00)]
(assert (CapacityConstraint ($Snap.combine
  $Snap.unit
  ($Snap.combine $Snap.unit $Snap.unit)) this@76@00 G@77@00 Gf@78@00 V@79@00))
; [eval] SkewSymetry(this, Gf, V)
(push) ; 6
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 6
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 75 | !(CapacityConstraint((_, (_, _)), this@76@00, G@77@00, Gf@78@00, V@79@00))]
(assert (not
  (CapacityConstraint ($Snap.combine
    $Snap.unit
    ($Snap.combine $Snap.unit $Snap.unit)) this@76@00 G@77@00 Gf@78@00 V@79@00)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 74 | !(FlowConservation((_, _), this@76@00, G@77@00, V@79@00, s@80@00, t@81@00))]
(assert (not
  (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (=
  result@82@00
  (and
    (and
      (SkewSymetry ($Snap.combine $Snap.unit $Snap.unit) this@76@00 Gf@78@00 V@79@00)
      (CapacityConstraint ($Snap.combine
        $Snap.unit
        ($Snap.combine $Snap.unit $Snap.unit)) this@76@00 G@77@00 Gf@78@00 V@79@00))
    (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00))))
; [eval] FlowConservation(this, G, V, s, t)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               538
;  :arith-add-rows          195
;  :arith-assert-diseq      167
;  :arith-assert-lower      401
;  :arith-assert-upper      110
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            157
;  :conflicts               31
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   69
;  :datatype-splits         5
;  :decisions               75
;  :del-clause              1053
;  :final-checks            60
;  :max-generation          4
;  :max-memory              4.42
;  :memory                  4.41
;  :mk-bool-var             1863
;  :mk-clause               1066
;  :num-allocs              202972
;  :num-checks              100
;  :propagations            456
;  :quant-instantiations    342
;  :rlimit-count            247957)
; [state consolidation]
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; [eval] FlowConservation(this, G, V, s, t)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               540
;  :arith-add-rows          195
;  :arith-assert-diseq      171
;  :arith-assert-lower      405
;  :arith-assert-upper      110
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            157
;  :conflicts               31
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   71
;  :datatype-splits         5
;  :decisions               79
;  :del-clause              1061
;  :final-checks            62
;  :max-generation          4
;  :max-memory              4.42
;  :memory                  4.41
;  :mk-bool-var             1871
;  :mk-clause               1074
;  :num-allocs              203839
;  :num-checks              102
;  :propagations            467
;  :quant-instantiations    346
;  :rlimit-count            248987)
; [state consolidation]
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; [eval] FlowConservation(this, G, V, s, t)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               542
;  :arith-add-rows          195
;  :arith-assert-diseq      175
;  :arith-assert-lower      409
;  :arith-assert-upper      110
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            157
;  :conflicts               31
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   73
;  :datatype-splits         5
;  :decisions               83
;  :del-clause              1069
;  :final-checks            64
;  :max-generation          4
;  :max-memory              4.42
;  :memory                  4.41
;  :mk-bool-var             1879
;  :mk-clause               1082
;  :num-allocs              204698
;  :num-checks              104
;  :propagations            478
;  :quant-instantiations    350
;  :rlimit-count            250013)
; [state consolidation]
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; [eval] FlowConservation(this, G, V, s, t)
(push) ; 2
; [eval] this != null
; [eval] V == |G|
; [eval] |G|
(pop) ; 2
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (FlowConservation ($Snap.combine $Snap.unit $Snap.unit) this@76@00 G@77@00 V@79@00 s@80@00 t@81@00)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               544
;  :arith-add-rows          195
;  :arith-assert-diseq      179
;  :arith-assert-lower      413
;  :arith-assert-upper      110
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            157
;  :conflicts               31
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   75
;  :datatype-splits         5
;  :decisions               87
;  :del-clause              1077
;  :final-checks            66
;  :max-generation          4
;  :max-memory              4.42
;  :memory                  4.41
;  :mk-bool-var             1887
;  :mk-clause               1090
;  :num-allocs              205557
;  :num-checks              106
;  :propagations            489
;  :quant-instantiations    354
;  :rlimit-count            251039)
(pop) ; 1
; ---------- FUNCTION as_any----------
(declare-fun t@83@00 () any)
(declare-fun result@84@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@120@00 $Snap)
(assert (= $t@120@00 $Snap.unit))
; [eval] any_as(result) == t
; [eval] any_as(result)
(push) ; 2
(pop) ; 2
; Joined path conditions
(assert (= (any_as $Snap.unit result@84@00) t@83@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (t@83@00 any)) (!
  (= (as_any%limited s@$ t@83@00) (as_any s@$ t@83@00))
  :pattern ((as_any s@$ t@83@00))
  )))
(assert (forall ((s@$ $Snap) (t@83@00 any)) (!
  (as_any%stateless t@83@00)
  :pattern ((as_any%limited s@$ t@83@00))
  )))
(assert (forall ((s@$ $Snap) (t@83@00 any)) (!
  (let ((result@84@00 (as_any%limited s@$ t@83@00))) (=
    (any_as $Snap.unit result@84@00)
    t@83@00))
  :pattern ((as_any%limited s@$ t@83@00))
  )))
; ---------- FUNCTION type----------
(declare-fun type1@85@00 () $Ref)
(declare-fun result@86@00 () Int)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@121@00 $Snap)
(assert (= $t@121@00 ($Snap.combine ($Snap.first $t@121@00) ($Snap.second $t@121@00))))
(assert (= ($Snap.first $t@121@00) $Snap.unit))
; [eval] 0 <= result
(assert (<= 0 result@86@00))
(assert (=
  ($Snap.second $t@121@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@121@00))
    ($Snap.second ($Snap.second $t@121@00)))))
(assert (= ($Snap.first ($Snap.second $t@121@00)) $Snap.unit))
; [eval] result < 2 + 1
; [eval] 2 + 1
(assert (< result@86@00 3))
(assert (=
  ($Snap.second ($Snap.second $t@121@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@121@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@121@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@121@00))) $Snap.unit))
; [eval] type1 == null ==> result == 0
; [eval] type1 == null
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= type1@85@00 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               566
;  :arith-add-rows          195
;  :arith-assert-diseq      179
;  :arith-assert-lower      414
;  :arith-assert-upper      111
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   77
;  :datatype-splits         6
;  :decisions               88
;  :del-clause              1090
;  :final-checks            68
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1901
;  :mk-clause               1090
;  :num-allocs              206623
;  :num-checks              107
;  :propagations            489
;  :quant-instantiations    354
;  :rlimit-count            252355)
(push) ; 3
(assert (not (= type1@85@00 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               568
;  :arith-add-rows          195
;  :arith-assert-diseq      179
;  :arith-assert-lower      414
;  :arith-assert-upper      111
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   79
;  :datatype-splits         7
;  :decisions               89
;  :del-clause              1090
;  :final-checks            70
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1903
;  :mk-clause               1090
;  :num-allocs              207024
;  :num-checks              108
;  :propagations            489
;  :quant-instantiations    354
;  :rlimit-count            252859)
; [then-branch: 76 | type1@85@00 == Null | live]
; [else-branch: 76 | type1@85@00 != Null | live]
(push) ; 3
; [then-branch: 76 | type1@85@00 == Null]
(assert (= type1@85@00 $Ref.null))
; [eval] result == 0
(pop) ; 3
(push) ; 3
; [else-branch: 76 | type1@85@00 != Null]
(assert (not (= type1@85@00 $Ref.null)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (= type1@85@00 $Ref.null) (= result@86@00 0)))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@121@00))) $Snap.unit))
; [eval] type1 != null ==> result != 0
; [eval] type1 != null
(push) ; 2
(push) ; 3
(assert (not (= type1@85@00 $Ref.null)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               569
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      111
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   80
;  :datatype-splits         7
;  :decisions               90
;  :del-clause              1090
;  :final-checks            71
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1907
;  :mk-clause               1093
;  :num-allocs              207512
;  :num-checks              109
;  :propagations            490
;  :quant-instantiations    354
;  :rlimit-count            253507)
(push) ; 3
(assert (not (not (= type1@85@00 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               571
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   81
;  :datatype-splits         7
;  :decisions               90
;  :del-clause              1090
;  :final-checks            72
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1907
;  :mk-clause               1093
;  :num-allocs              207912
;  :num-checks              110
;  :propagations            492
;  :quant-instantiations    354
;  :rlimit-count            253979)
; [then-branch: 77 | type1@85@00 != Null | live]
; [else-branch: 77 | type1@85@00 == Null | live]
(push) ; 3
; [then-branch: 77 | type1@85@00 != Null]
(assert (not (= type1@85@00 $Ref.null)))
; [eval] result != 0
(pop) ; 3
(push) ; 3
; [else-branch: 77 | type1@85@00 == Null]
(assert (= type1@85@00 $Ref.null))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (not (= type1@85@00 $Ref.null)) (not (= result@86@00 0))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (type1@85@00 $Ref)) (!
  (= (type%limited s@$ type1@85@00) (type s@$ type1@85@00))
  :pattern ((type s@$ type1@85@00))
  )))
(assert (forall ((s@$ $Snap) (type1@85@00 $Ref)) (!
  (type%stateless type1@85@00)
  :pattern ((type%limited s@$ type1@85@00))
  )))
(assert (forall ((s@$ $Snap) (type1@85@00 $Ref)) (!
  (let ((result@86@00 (type%limited s@$ type1@85@00))) (and
    (<= 0 result@86@00)
    (< result@86@00 3)
    (implies (= type1@85@00 $Ref.null) (= result@86@00 0))
    (implies (not (= type1@85@00 $Ref.null)) (not (= result@86@00 0)))))
  :pattern ((type%limited s@$ type1@85@00))
  )))
; ---------- FUNCTION opt_or_else----------
(declare-fun opt1@87@00 () option<any>)
(declare-fun alt@88@00 () any)
(declare-fun result@89@00 () any)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@122@00 $Snap)
(assert (= $t@122@00 ($Snap.combine ($Snap.first $t@122@00) ($Snap.second $t@122@00))))
(assert (= ($Snap.first $t@122@00) $Snap.unit))
; [eval] opt1 == (None(): option[any]) ==> result == alt
; [eval] opt1 == (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(push) ; 3
(assert (not (not (= opt1@87@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               580
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   83
;  :datatype-splits         8
;  :decisions               91
;  :del-clause              1093
;  :final-checks            74
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1914
;  :mk-clause               1093
;  :num-allocs              208810
;  :num-checks              111
;  :propagations            492
;  :quant-instantiations    354
;  :rlimit-count            255107)
(push) ; 3
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               582
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   85
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1093
;  :final-checks            76
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1916
;  :mk-clause               1093
;  :num-allocs              209194
;  :num-checks              112
;  :propagations            492
;  :quant-instantiations    354
;  :rlimit-count            255608)
; [then-branch: 78 | opt1@87@00 == None[option[any]] | live]
; [else-branch: 78 | opt1@87@00 != None[option[any]] | live]
(push) ; 3
; [then-branch: 78 | opt1@87@00 == None[option[any]]]
(assert (= opt1@87@00 (as None<option<any>>  option<any>)))
; [eval] result == alt
(pop) ; 3
(push) ; 3
; [else-branch: 78 | opt1@87@00 != None[option[any]]]
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (= opt1@87@00 (as None<option<any>>  option<any>))
  (= result@89@00 alt@88@00)))
(assert (= ($Snap.second $t@122@00) $Snap.unit))
; [eval] opt1 != (None(): option[any]) ==> result == opt_get(opt1)
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(push) ; 3
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               583
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   86
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1093
;  :final-checks            77
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1919
;  :mk-clause               1094
;  :num-allocs              209648
;  :num-checks              113
;  :propagations            492
;  :quant-instantiations    354
;  :rlimit-count            256220)
(push) ; 3
(assert (not (not (= opt1@87@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               585
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   87
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1093
;  :final-checks            78
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1919
;  :mk-clause               1094
;  :num-allocs              210049
;  :num-checks              114
;  :propagations            493
;  :quant-instantiations    354
;  :rlimit-count            256686)
; [then-branch: 79 | opt1@87@00 != None[option[any]] | live]
; [else-branch: 79 | opt1@87@00 == None[option[any]] | live]
(push) ; 3
; [then-branch: 79 | opt1@87@00 != None[option[any]]]
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
; [eval] result == opt_get(opt1)
; [eval] opt_get(opt1)
(push) ; 4
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 79 | opt1@87@00 == None[option[any]]]
(assert (= opt1@87@00 (as None<option<any>>  option<any>)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (not (= opt1@87@00 (as None<option<any>>  option<any>)))
  (= result@89@00 (opt_get $Snap.unit opt1@87@00))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@87@00 option<any>) (alt@88@00 any)) (!
  (=
    (opt_or_else%limited s@$ opt1@87@00 alt@88@00)
    (opt_or_else s@$ opt1@87@00 alt@88@00))
  :pattern ((opt_or_else s@$ opt1@87@00 alt@88@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@87@00 option<any>) (alt@88@00 any)) (!
  (opt_or_else%stateless opt1@87@00 alt@88@00)
  :pattern ((opt_or_else%limited s@$ opt1@87@00 alt@88@00))
  )))
(assert (forall ((s@$ $Snap) (opt1@87@00 option<any>) (alt@88@00 any)) (!
  (let ((result@89@00 (opt_or_else%limited s@$ opt1@87@00 alt@88@00))) (and
    (implies
      (= opt1@87@00 (as None<option<any>>  option<any>))
      (= result@89@00 alt@88@00))
    (implies
      (not (= opt1@87@00 (as None<option<any>>  option<any>)))
      (= result@89@00 (opt_get $Snap.unit opt1@87@00)))))
  :pattern ((opt_or_else%limited s@$ opt1@87@00 alt@88@00))
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
(assert (not (not (= opt1@87@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               586
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   87
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            80
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1923
;  :mk-clause               1094
;  :num-allocs              211135
;  :num-checks              116
;  :propagations            493
;  :quant-instantiations    354
;  :rlimit-count            258084)
(push) ; 3
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               586
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   87
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            81
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1924
;  :mk-clause               1094
;  :num-allocs              211503
;  :num-checks              117
;  :propagations            493
;  :quant-instantiations    354
;  :rlimit-count            258553)
; [then-branch: 80 | opt1@87@00 == None[option[any]] | live]
; [else-branch: 80 | opt1@87@00 != None[option[any]] | live]
(push) ; 3
; [then-branch: 80 | opt1@87@00 == None[option[any]]]
(assert (= opt1@87@00 (as None<option<any>>  option<any>)))
(pop) ; 3
(push) ; 3
; [else-branch: 80 | opt1@87@00 != None[option[any]]]
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
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
  result@89@00
  (ite
    (= opt1@87@00 (as None<option<any>>  option<any>))
    alt@88@00
    (opt_get $Snap.unit opt1@87@00))))
; [eval] opt1 == (None(): option[any]) ==> result == alt
; [eval] opt1 == (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(push) ; 3
(assert (not (not (= opt1@87@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               589
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   88
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            82
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1929
;  :mk-clause               1096
;  :num-allocs              212035
;  :num-checks              118
;  :propagations            494
;  :quant-instantiations    354
;  :rlimit-count            259172)
(push) ; 3
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               593
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               31
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   89
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            83
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1933
;  :mk-clause               1096
;  :num-allocs              212483
;  :num-checks              119
;  :propagations            495
;  :quant-instantiations    358
;  :rlimit-count            259728)
; [then-branch: 81 | opt1@87@00 == None[option[any]] | live]
; [else-branch: 81 | opt1@87@00 != None[option[any]] | live]
(push) ; 3
; [then-branch: 81 | opt1@87@00 == None[option[any]]]
(assert (= opt1@87@00 (as None<option<any>>  option<any>)))
; [eval] result == alt
(pop) ; 3
(push) ; 3
; [else-branch: 81 | opt1@87@00 != None[option[any]]]
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (implies
  (= opt1@87@00 (as None<option<any>>  option<any>))
  (= result@89@00 alt@88@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               596
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               32
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   89
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            83
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.41
;  :mk-bool-var             1934
;  :mk-clause               1096
;  :num-allocs              212566
;  :num-checks              120
;  :propagations            496
;  :quant-instantiations    358
;  :rlimit-count            259834)
(assert (implies
  (= opt1@87@00 (as None<option<any>>  option<any>))
  (= result@89@00 alt@88@00)))
; [eval] opt1 != (None(): option[any]) ==> result == opt_get(opt1)
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               601
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               32
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   90
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            84
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1939
;  :mk-clause               1097
;  :num-allocs              213062
;  :num-checks              121
;  :propagations            497
;  :quant-instantiations    362
;  :rlimit-count            260454)
(push) ; 3
(assert (not (not (= opt1@87@00 (as None<option<any>>  option<any>)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               604
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               32
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   91
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            85
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1939
;  :mk-clause               1097
;  :num-allocs              213444
;  :num-checks              122
;  :propagations            499
;  :quant-instantiations    362
;  :rlimit-count            260923)
; [then-branch: 82 | opt1@87@00 != None[option[any]] | live]
; [else-branch: 82 | opt1@87@00 == None[option[any]] | live]
(push) ; 3
; [then-branch: 82 | opt1@87@00 != None[option[any]]]
(assert (not (= opt1@87@00 (as None<option<any>>  option<any>))))
; [eval] result == opt_get(opt1)
; [eval] opt_get(opt1)
(push) ; 4
; [eval] opt1 != (None(): option[any])
; [eval] (None(): option[any])
(pop) ; 4
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 82 | opt1@87@00 == None[option[any]]]
(assert (= opt1@87@00 (as None<option<any>>  option<any>)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 2
(assert (not (implies
  (not (= opt1@87@00 (as None<option<any>>  option<any>)))
  (= result@89@00 (opt_get $Snap.unit opt1@87@00)))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               610
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      415
;  :arith-assert-upper      112
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               33
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   91
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1094
;  :final-checks            85
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.41
;  :mk-bool-var             1944
;  :mk-clause               1097
;  :num-allocs              213589
;  :num-checks              123
;  :propagations            501
;  :quant-instantiations    366
;  :rlimit-count            261169)
(assert (implies
  (not (= opt1@87@00 (as None<option<any>>  option<any>)))
  (= result@89@00 (opt_get $Snap.unit opt1@87@00))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (opt1@87@00 option<any>) (alt@88@00 any)) (!
  (=
    (opt_or_else s@$ opt1@87@00 alt@88@00)
    (ite
      (= opt1@87@00 (as None<option<any>>  option<any>))
      alt@88@00
      (opt_get $Snap.unit opt1@87@00)))
  :pattern ((opt_or_else s@$ opt1@87@00 alt@88@00))
  )))
; ---------- FUNCTION subtype----------
(declare-fun subtype1@90@00 () Int)
(declare-fun subtype2@91@00 () Int)
(declare-fun result@92@00 () Bool)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 <= subtype1
(assert (<= 0 subtype1@90@00))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] subtype1 < 2 + 1
; [eval] 2 + 1
(assert (< subtype1@90@00 3))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] 0 <= subtype2
(assert (<= 0 subtype2@91@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] subtype2 <= 2
(assert (<= subtype2@91@00 2))
(pop) ; 1
(assert (forall ((s@$ $Snap) (subtype1@90@00 Int) (subtype2@91@00 Int)) (!
  (=
    (subtype%limited s@$ subtype1@90@00 subtype2@91@00)
    (subtype s@$ subtype1@90@00 subtype2@91@00))
  :pattern ((subtype s@$ subtype1@90@00 subtype2@91@00))
  )))
(assert (forall ((s@$ $Snap) (subtype1@90@00 Int) (subtype2@91@00 Int)) (!
  (subtype%stateless subtype1@90@00 subtype2@91@00)
  :pattern ((subtype%limited s@$ subtype1@90@00 subtype2@91@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (<= 0 subtype1@90@00))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (< subtype1@90@00 3))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (<= 0 subtype2@91@00))
(assert (= ($Snap.second ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (<= subtype2@91@00 2))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (subtype1 == 2 ==> subtype2 == 2) && (subtype1 == 1 ==> subtype2 == 1)
; [eval] subtype1 == 2 ==> subtype2 == 2
; [eval] subtype1 == 2
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= subtype1@90@00 2))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               630
;  :arith-add-rows          195
;  :arith-assert-diseq      180
;  :arith-assert-lower      418
;  :arith-assert-upper      115
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               33
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   93
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1100
;  :final-checks            87
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1961
;  :mk-clause               1100
;  :num-allocs              214975
;  :num-checks              125
;  :propagations            503
;  :quant-instantiations    366
;  :rlimit-count            263002)
(push) ; 3
(assert (not (= subtype1@90@00 2)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               630
;  :arith-add-rows          195
;  :arith-assert-diseq      181
;  :arith-assert-lower      418
;  :arith-assert-upper      117
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               33
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   94
;  :datatype-splits         9
;  :decisions               92
;  :del-clause              1104
;  :final-checks            88
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1964
;  :mk-clause               1104
;  :num-allocs              215372
;  :num-checks              126
;  :propagations            504
;  :quant-instantiations    366
;  :rlimit-count            263502)
; [then-branch: 83 | subtype1@90@00 == 2 | live]
; [else-branch: 83 | subtype1@90@00 != 2 | live]
(push) ; 3
; [then-branch: 83 | subtype1@90@00 == 2]
(assert (= subtype1@90@00 2))
; [eval] subtype2 == 2
(pop) ; 3
(push) ; 3
; [else-branch: 83 | subtype1@90@00 != 2]
(assert (not (= subtype1@90@00 2)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(push) ; 2
; [then-branch: 84 | subtype1@90@00 == 2 ==> subtype2@91@00 == 2 | live]
; [else-branch: 84 | !(subtype1@90@00 == 2 ==> subtype2@91@00 == 2) | live]
(push) ; 3
; [then-branch: 84 | subtype1@90@00 == 2 ==> subtype2@91@00 == 2]
(assert (implies (= subtype1@90@00 2) (= subtype2@91@00 2)))
; [eval] subtype1 == 1 ==> subtype2 == 1
; [eval] subtype1 == 1
(push) ; 4
(push) ; 5
(assert (not (not (= subtype1@90@00 1))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               631
;  :arith-add-rows          195
;  :arith-assert-diseq      183
;  :arith-assert-lower      419
;  :arith-assert-upper      121
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        132
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               33
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   95
;  :datatype-splits         9
;  :decisions               93
;  :del-clause              1107
;  :final-checks            89
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1972
;  :mk-clause               1114
;  :num-allocs              215866
;  :num-checks              127
;  :propagations            508
;  :quant-instantiations    366
;  :rlimit-count            264123)
(push) ; 5
(assert (not (= subtype1@90@00 1)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               632
;  :arith-add-rows          195
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      125
;  :arith-bound-prop        56
;  :arith-conflicts         14
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         41
;  :arith-offset-eqs        13
;  :arith-pivots            158
;  :conflicts               33
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   96
;  :datatype-splits         9
;  :decisions               95
;  :del-clause              1114
;  :final-checks            90
;  :max-generation          4
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             1975
;  :mk-clause               1121
;  :num-allocs              216269
;  :num-checks              128
;  :propagations            512
;  :quant-instantiations    366
;  :rlimit-count            264651)
; [then-branch: 85 | subtype1@90@00 == 1 | live]
; [else-branch: 85 | subtype1@90@00 != 1 | live]
(push) ; 5
; [then-branch: 85 | subtype1@90@00 == 1]
(assert (= subtype1@90@00 1))
; [eval] subtype2 == 1
(pop) ; 5
(push) ; 5
; [else-branch: 85 | subtype1@90@00 != 1]
(assert (not (= subtype1@90@00 1)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
(push) ; 3
; [else-branch: 84 | !(subtype1@90@00 == 2 ==> subtype2@91@00 == 2)]
(assert (not (implies (= subtype1@90@00 2) (= subtype2@91@00 2))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (and (implies (= subtype1@90@00 2) (= subtype2@91@00 2)) (= subtype1@90@00 2))
  (= subtype2@91@00 2)))
; Joined path conditions
(assert (=
  result@92@00
  (and
    (implies (= subtype1@90@00 1) (= subtype2@91@00 1))
    (implies (= subtype1@90@00 2) (= subtype2@91@00 2)))))
(pop) ; 1
(assert (forall ((s@$ $Snap) (subtype1@90@00 Int) (subtype2@91@00 Int)) (!
  (implies
    (and
      (<= 0 subtype1@90@00)
      (< subtype1@90@00 3)
      (<= 0 subtype2@91@00)
      (<= subtype2@91@00 2))
    (=
      (subtype s@$ subtype1@90@00 subtype2@91@00)
      (and
        (implies (= subtype1@90@00 2) (= subtype2@91@00 2))
        (implies (= subtype1@90@00 1) (= subtype2@91@00 1)))))
  :pattern ((subtype s@$ subtype1@90@00 subtype2@91@00))
  )))
; ---------- lock_inv_FordFulkerson ----------
(declare-const this@123@00 $Ref)
(push) ; 1
(declare-const $t@124@00 $Snap)
(assert (= $t@124@00 $Snap.unit))
(pop) ; 1
; ---------- lock_held_FordFulkerson ----------
(declare-const this@125@00 $Ref)
; ---------- lock_inv_Object ----------
(declare-const this@126@00 $Ref)
(push) ; 1
(declare-const $t@127@00 $Snap)
(assert (= $t@127@00 $Snap.unit))
(pop) ; 1
; ---------- lock_held_Object ----------
(declare-const this@128@00 $Ref)
