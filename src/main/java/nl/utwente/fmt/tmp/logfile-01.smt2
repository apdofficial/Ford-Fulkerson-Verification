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
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
(declare-fun $k@113@00 () $Perm)
(declare-fun inv@114@00 ($Snap $Ref option<array> Int $Ref) Int)
(declare-fun sm@115@00 ($Snap $Ref option<array> Int) $FVF<Int>)
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
(assert (forall ((s@$ $Snap) (a2@25@00 array) (i1@26@00 Int)) (!
  (implies
    (and (<= 0 i1@26@00) (< i1@26@00 (alen<Int> a2@25@00)))
    (= (aloc s@$ a2@25@00 i1@26@00) (array_loc<Ref> a2@25@00 i1@26@00)))
  :pattern ((aloc s@$ a2@25@00 i1@26@00))
  )))
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
(assert (forall ((s@$ $Snap) (opt1@28@00 option<array>)) (!
  (implies
    (not (= opt1@28@00 (as None<option<array>>  option<array>)))
    (= (opt_get1 s@$ opt1@28@00) (option_get<array> opt1@28@00)))
  :pattern ((opt_get1 s@$ opt1@28@00))
  )))
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
(assert (forall ((s@$ $Snap) (t@49@00 any)) (!
  (= (any_as%limited s@$ t@49@00) (any_as s@$ t@49@00))
  :pattern ((any_as s@$ t@49@00))
  )))
(assert (forall ((s@$ $Snap) (t@49@00 any)) (!
  (any_as%stateless t@49@00)
  :pattern ((any_as%limited s@$ t@49@00))
  )))
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
(assert (forall ((s@$ $Snap) (opt1@51@00 option<any>)) (!
  (implies
    (not (= opt1@51@00 (as None<option<any>>  option<any>)))
    (= (opt_get s@$ opt1@51@00) (option_get<any> opt1@51@00)))
  :pattern ((opt_get s@$ opt1@51@00))
  )))
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
(assert (forall ((s@$ $Snap) (amount@74@00 $Perm)) (!
  (= (scale%limited s@$ amount@74@00) (scale s@$ amount@74@00))
  :pattern ((scale s@$ amount@74@00))
  )))
(assert (forall ((s@$ $Snap) (amount@74@00 $Perm)) (!
  (scale%stateless amount@74@00)
  :pattern ((scale%limited s@$ amount@74@00))
  )))
(assert (forall ((s@$ $Snap) (amount@74@00 $Perm)) (!
  (implies (>= amount@74@00 $Perm.No) (= (scale s@$ amount@74@00) amount@74@00))
  :pattern ((scale s@$ amount@74@00))
  )))
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
(assert (forall ((s@$ $Snap) (opt1@87@00 option<any>) (alt@88@00 any)) (!
  (=
    (opt_or_else s@$ opt1@87@00 alt@88@00)
    (ite
      (= opt1@87@00 (as None<option<any>>  option<any>))
      alt@88@00
      (opt_get $Snap.unit opt1@87@00)))
  :pattern ((opt_or_else s@$ opt1@87@00 alt@88@00))
  )))
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
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- check_unknown1 ----------
(declare-const i1@0@01 Int)
(declare-const target@1@01 option<array>)
(declare-const source@2@01 option<array>)
(declare-const j@3@01 Int)
(declare-const V@4@01 Int)
(declare-const exc@5@01 $Ref)
(declare-const res@6@01 void)
(declare-const i1@7@01 Int)
(declare-const target@8@01 option<array>)
(declare-const source@9@01 option<array>)
(declare-const j@10@01 Int)
(declare-const V@11@01 Int)
(declare-const exc@12@01 $Ref)
(declare-const res@13@01 void)
(push) ; 1
(declare-const $t@14@01 $Snap)
(assert (= $t@14@01 ($Snap.combine ($Snap.first $t@14@01) ($Snap.second $t@14@01))))
(assert (= ($Snap.first $t@14@01) $Snap.unit))
; [eval] 0 < V ==> source != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10
;  :arith-assert-lower      3
;  :arith-assert-upper      2
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    2
;  :datatype-constructor-ax 1
;  :datatype-occurs-check   2
;  :datatype-splits         1
;  :decisions               1
;  :final-checks            2
;  :max-generation          1
;  :max-memory              4.38
;  :memory                  4.19
;  :mk-bool-var             413
;  :num-allocs              158064
;  :num-checks              1
;  :quant-instantiations    2
;  :rlimit-count            180175)
(push) ; 3
(assert (not (< 0 V@11@01)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    2
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.38
;  :memory                  4.19
;  :mk-bool-var             415
;  :num-allocs              158434
;  :num-checks              2
;  :quant-instantiations    2
;  :rlimit-count            180671)
; [then-branch: 0 | 0 < V@11@01 | live]
; [else-branch: 0 | !(0 < V@11@01) | live]
(push) ; 3
; [then-branch: 0 | 0 < V@11@01]
(assert (< 0 V@11@01))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(0 < V@11@01)]
(assert (not (< 0 V@11@01)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (not (= source@9@01 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@14@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@14@01))
    ($Snap.second ($Snap.second $t@14@01)))))
(assert (= ($Snap.first ($Snap.second $t@14@01)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(source)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20
;  :arith-assert-lower      4
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   6
;  :datatype-splits         3
;  :decisions               3
;  :final-checks            6
;  :max-generation          1
;  :max-memory              4.38
;  :memory                  4.21
;  :mk-bool-var             420
;  :mk-clause               1
;  :num-allocs              158977
;  :num-checks              3
;  :propagations            1
;  :quant-instantiations    2
;  :rlimit-count            181437)
(push) ; 3
(assert (not (< 0 V@11@01)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22
;  :arith-assert-lower      4
;  :arith-assert-upper      4
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          1
;  :max-memory              4.38
;  :memory                  4.21
;  :mk-bool-var             421
;  :mk-clause               1
;  :num-allocs              159346
;  :num-checks              4
;  :propagations            1
;  :quant-instantiations    2
;  :rlimit-count            181937)
; [then-branch: 1 | 0 < V@11@01 | live]
; [else-branch: 1 | !(0 < V@11@01) | live]
(push) ; 3
; [then-branch: 1 | 0 < V@11@01]
(assert (< 0 V@11@01))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@9@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        2
;  :conflicts               1
;  :datatype-accessor-ax    3
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   8
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            8
;  :max-generation          1
;  :max-memory              4.38
;  :memory                  4.21
;  :mk-bool-var             421
;  :mk-clause               1
;  :num-allocs              159488
;  :num-checks              5
;  :propagations            2
;  :quant-instantiations    2
;  :rlimit-count            182045)
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(0 < V@11@01)]
(assert (not (< 0 V@11@01)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (and
    (< 0 V@11@01)
    (not (= source@9@01 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies (< 0 V@11@01) (= (alen<Int> (opt_get1 $Snap.unit source@9@01)) V@11@01)))
(assert (=
  ($Snap.second ($Snap.second $t@14@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@14@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 2
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               37
;  :arith-assert-lower      8
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
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
;  :max-memory              4.38
;  :memory                  4.22
;  :mk-bool-var             434
;  :mk-clause               7
;  :num-allocs              160226
;  :num-checks              6
;  :propagations            5
;  :quant-instantiations    7
;  :rlimit-count            183002)
(push) ; 2
(assert (not (< 0 V@11@01)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               41
;  :arith-assert-lower      8
;  :arith-assert-upper      6
;  :arith-eq-adapter        3
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
;  :max-memory              4.38
;  :memory                  4.22
;  :mk-bool-var             436
;  :mk-clause               7
;  :num-allocs              160602
;  :num-checks              7
;  :propagations            6
;  :quant-instantiations    7
;  :rlimit-count            183518)
; [then-branch: 2 | 0 < V@11@01 | live]
; [else-branch: 2 | !(0 < V@11@01) | live]
(push) ; 2
; [then-branch: 2 | 0 < V@11@01]
(assert (< 0 V@11@01))
(declare-const i2@15@01 Int)
(push) ; 3
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 4
; [then-branch: 3 | 0 <= i2@15@01 | live]
; [else-branch: 3 | !(0 <= i2@15@01) | live]
(push) ; 5
; [then-branch: 3 | 0 <= i2@15@01]
(assert (<= 0 i2@15@01))
; [eval] i2 < V
(pop) ; 5
(push) ; 5
; [else-branch: 3 | !(0 <= i2@15@01)]
(assert (not (<= 0 i2@15@01)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i2@15@01 V@11@01) (<= 0 i2@15@01)))
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@9@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-assert-lower      13
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
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
;  :max-memory              4.38
;  :memory                  4.22
;  :mk-bool-var             446
;  :mk-clause               7
;  :num-allocs              160872
;  :num-checks              8
;  :propagations            9
;  :quant-instantiations    12
;  :rlimit-count            183874)
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i2@15@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               47
;  :arith-add-rows          2
;  :arith-assert-lower      13
;  :arith-assert-upper      8
;  :arith-conflicts         1
;  :arith-eq-adapter        4
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
;  :max-memory              4.38
;  :memory                  4.21
;  :mk-bool-var             447
;  :mk-clause               7
;  :num-allocs              161025
;  :num-checks              9
;  :propagations            9
;  :quant-instantiations    12
;  :rlimit-count            184037)
(assert (< i2@15@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 4
; Joined path conditions
(assert (< i2@15@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 4
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 5
(assert (not (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               48
;  :arith-add-rows          4
;  :arith-assert-lower      16
;  :arith-assert-upper      9
;  :arith-conflicts         2
;  :arith-eq-adapter        4
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
;  :max-memory              4.38
;  :memory                  4.22
;  :mk-bool-var             449
;  :mk-clause               7
;  :num-allocs              161221
;  :num-checks              10
;  :propagations            9
;  :quant-instantiations    12
;  :rlimit-count            184283)
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(pop) ; 4
; Joined path conditions
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(declare-const $k@16@01 $Perm)
(assert ($Perm.isReadVar $k@16@01 $Perm.Write))
(pop) ; 3
(declare-fun inv@17@01 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@16@01 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@15@01 Int)) (!
  (and
    (not (= source@9@01 (as None<option<array>>  option<array>)))
    (< i2@15@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@15@01))
  :qid |option$array$-aux|)))
(push) ; 3
(assert (not (forall ((i2@15@01 Int)) (!
  (implies
    (and (< i2@15@01 V@11@01) (<= 0 i2@15@01))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01))))
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               58
;  :arith-add-rows          4
;  :arith-assert-diseq      2
;  :arith-assert-lower      30
;  :arith-assert-upper      16
;  :arith-conflicts         4
;  :arith-eq-adapter        7
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
;  :max-memory              4.38
;  :memory                  4.23
;  :mk-bool-var             467
;  :mk-clause               17
;  :num-allocs              162006
;  :num-checks              11
;  :propagations            14
;  :quant-instantiations    15
;  :rlimit-count            185327)
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i21@15@01 Int) (i22@15@01 Int)) (!
  (implies
    (and
      (and
        (and (< i21@15@01 V@11@01) (<= 0 i21@15@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@16@01)))
      (and
        (and (< i22@15@01 V@11@01) (<= 0 i22@15@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@16@01)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i21@15@01)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i22@15@01)))
    (= i21@15@01 i22@15@01))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               78
;  :arith-add-rows          8
;  :arith-assert-diseq      4
;  :arith-assert-lower      35
;  :arith-assert-upper      21
;  :arith-conflicts         4
;  :arith-eq-adapter        9
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
;  :max-memory              4.38
;  :memory                  4.25
;  :mk-bool-var             505
;  :mk-clause               46
;  :num-allocs              162549
;  :num-checks              12
;  :propagations            30
;  :quant-instantiations    30
;  :rlimit-count            186289)
; Definitional axioms for inverse functions
(assert (forall ((i2@15@01 Int)) (!
  (implies
    (and
      (and (< i2@15@01 V@11@01) (<= 0 i2@15@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01)))
    (=
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@15@01))
      i2@15@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@15@01))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) (inv@17@01 r))
      r))
  :pattern ((inv@17@01 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@15@01 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@16@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@15@01))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@15@01 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@16@01)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@15@01))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@15@01 Int)) (!
  (implies
    (and
      (and (< i2@15@01 V@11@01) (<= 0 i2@15@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@15@01)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@15@01))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@18@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) r) r))
  :pattern ((inv@17@01 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@14@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@01))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               92
;  :arith-add-rows          8
;  :arith-assert-diseq      4
;  :arith-assert-lower      51
;  :arith-assert-upper      29
;  :arith-conflicts         5
;  :arith-eq-adapter        10
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
;  :max-memory              4.38
;  :memory                  4.27
;  :mk-bool-var             523
;  :mk-clause               51
;  :num-allocs              164434
;  :num-checks              13
;  :propagations            33
;  :quant-instantiations    33
;  :rlimit-count            189756)
; [then-branch: 4 | 0 < V@11@01 | live]
; [else-branch: 4 | !(0 < V@11@01) | dead]
(push) ; 4
; [then-branch: 4 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
(declare-const i2@19@01 Int)
(push) ; 5
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 6
; [then-branch: 5 | 0 <= i2@19@01 | live]
; [else-branch: 5 | !(0 <= i2@19@01) | live]
(push) ; 7
; [then-branch: 5 | 0 <= i2@19@01]
(assert (<= 0 i2@19@01))
; [eval] i2 < V
(pop) ; 7
(push) ; 7
; [else-branch: 5 | !(0 <= i2@19@01)]
(assert (not (<= 0 i2@19@01)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 6 | i2@19@01 < V@11@01 && 0 <= i2@19@01 | live]
; [else-branch: 6 | !(i2@19@01 < V@11@01 && 0 <= i2@19@01) | live]
(push) ; 7
; [then-branch: 6 | i2@19@01 < V@11@01 && 0 <= i2@19@01]
(assert (and (< i2@19@01 V@11@01) (<= 0 i2@19@01)))
; [eval] aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= source@9@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               92
;  :arith-add-rows          8
;  :arith-assert-diseq      4
;  :arith-assert-lower      53
;  :arith-assert-upper      29
;  :arith-conflicts         5
;  :arith-eq-adapter        10
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
;  :max-memory              4.38
;  :memory                  4.27
;  :mk-bool-var             525
;  :mk-clause               51
;  :num-allocs              164645
;  :num-checks              14
;  :propagations            33
;  :quant-instantiations    33
;  :rlimit-count            189976)
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i2@19@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               92
;  :arith-add-rows          10
;  :arith-assert-diseq      4
;  :arith-assert-lower      53
;  :arith-assert-upper      30
;  :arith-conflicts         6
;  :arith-eq-adapter        10
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
;  :max-memory              4.38
;  :memory                  4.26
;  :mk-bool-var             526
;  :mk-clause               51
;  :num-allocs              164789
;  :num-checks              15
;  :propagations            33
;  :quant-instantiations    33
;  :rlimit-count            190131)
(assert (< i2@19@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 8
; Joined path conditions
(assert (< i2@19@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))
      V@11@01)
    (<=
      0
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@16@01))
  false)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               114
;  :arith-add-rows          21
;  :arith-assert-diseq      4
;  :arith-assert-lower      63
;  :arith-assert-upper      37
;  :arith-bound-prop        1
;  :arith-conflicts         8
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         5
;  :arith-grobner           4
;  :arith-max-min           51
;  :arith-nonlinear-bounds  4
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        7
;  :arith-pivots            16
;  :conflicts               14
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   20
;  :datatype-splits         14
;  :decisions               20
;  :del-clause              46
;  :final-checks            24
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             556
;  :mk-clause               70
;  :num-allocs              165286
;  :num-checks              16
;  :propagations            47
;  :quant-instantiations    44
;  :rlimit-count            191192)
; [eval] (None(): option[array])
(pop) ; 7
(push) ; 7
; [else-branch: 6 | !(i2@19@01 < V@11@01 && 0 <= i2@19@01)]
(assert (not (and (< i2@19@01 V@11@01) (<= 0 i2@19@01))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i2@19@01 V@11@01) (<= 0 i2@19@01))
  (and
    (< i2@19@01 V@11@01)
    (<= 0 i2@19@01)
    (not (= source@9@01 (as None<option<array>>  option<array>)))
    (< i2@19@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01)))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@19@01 Int)) (!
  (implies
    (and (< i2@19@01 V@11@01) (<= 0 i2@19@01))
    (and
      (< i2@19@01 V@11@01)
      (<= 0 i2@19@01)
      (not (= source@9@01 (as None<option<array>>  option<array>)))
      (< i2@19@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@19@01 Int)) (!
    (implies
      (and (< i2@19@01 V@11@01) (<= 0 i2@19@01))
      (and
        (< i2@19@01 V@11@01)
        (<= 0 i2@19@01)
        (not (= source@9@01 (as None<option<array>>  option<array>)))
        (< i2@19@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@19@01 Int)) (!
    (implies
      (and (< i2@19@01 V@11@01) (<= 0 i2@19@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@19@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               127
;  :arith-add-rows          21
;  :arith-assert-diseq      4
;  :arith-assert-lower      78
;  :arith-assert-upper      45
;  :arith-bound-prop        1
;  :arith-conflicts         9
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        8
;  :arith-pivots            17
;  :conflicts               15
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               23
;  :del-clause              57
;  :final-checks            29
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             562
;  :mk-clause               70
;  :num-allocs              166426
;  :num-checks              17
;  :propagations            50
;  :quant-instantiations    44
;  :rlimit-count            193210)
; [then-branch: 7 | 0 < V@11@01 | live]
; [else-branch: 7 | !(0 < V@11@01) | dead]
(push) ; 4
; [then-branch: 7 | 0 < V@11@01]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
(declare-const i2@20@01 Int)
(push) ; 5
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 6
; [then-branch: 8 | 0 <= i2@20@01 | live]
; [else-branch: 8 | !(0 <= i2@20@01) | live]
(push) ; 7
; [then-branch: 8 | 0 <= i2@20@01]
(assert (<= 0 i2@20@01))
; [eval] i2 < V
(pop) ; 7
(push) ; 7
; [else-branch: 8 | !(0 <= i2@20@01)]
(assert (not (<= 0 i2@20@01)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 9 | i2@20@01 < V@11@01 && 0 <= i2@20@01 | live]
; [else-branch: 9 | !(i2@20@01 < V@11@01 && 0 <= i2@20@01) | live]
(push) ; 7
; [then-branch: 9 | i2@20@01 < V@11@01 && 0 <= i2@20@01]
(assert (and (< i2@20@01 V@11@01) (<= 0 i2@20@01)))
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
(assert (not (not (= source@9@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               127
;  :arith-add-rows          21
;  :arith-assert-diseq      4
;  :arith-assert-lower      79
;  :arith-assert-upper      46
;  :arith-bound-prop        1
;  :arith-conflicts         9
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        8
;  :arith-pivots            17
;  :conflicts               16
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               23
;  :del-clause              57
;  :final-checks            29
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             564
;  :mk-clause               70
;  :num-allocs              166591
;  :num-checks              18
;  :propagations            50
;  :quant-instantiations    44
;  :rlimit-count            193418)
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i2@20@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               127
;  :arith-add-rows          24
;  :arith-assert-diseq      4
;  :arith-assert-lower      80
;  :arith-assert-upper      46
;  :arith-bound-prop        1
;  :arith-conflicts         10
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         5
;  :arith-grobner           8
;  :arith-max-min           77
;  :arith-nonlinear-bounds  5
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        8
;  :arith-pivots            19
;  :conflicts               17
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               23
;  :del-clause              57
;  :final-checks            29
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             565
;  :mk-clause               70
;  :num-allocs              166742
;  :num-checks              19
;  :propagations            50
;  :quant-instantiations    44
;  :rlimit-count            193612)
(assert (< i2@20@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 8
; Joined path conditions
(assert (< i2@20@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
      V@11@01)
    (<=
      0
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@16@01))
  false)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               145
;  :arith-add-rows          33
;  :arith-assert-diseq      4
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-bound-prop        2
;  :arith-conflicts         12
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :arith-grobner           8
;  :arith-max-min           84
;  :arith-nonlinear-bounds  6
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        12
;  :arith-pivots            22
;  :conflicts               21
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               26
;  :del-clause              63
;  :final-checks            30
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             593
;  :mk-clause               87
;  :num-allocs              167112
;  :num-checks              20
;  :propagations            62
;  :quant-instantiations    57
;  :rlimit-count            194668)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 9
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               145
;  :arith-add-rows          33
;  :arith-assert-diseq      4
;  :arith-assert-lower      89
;  :arith-assert-upper      53
;  :arith-bound-prop        2
;  :arith-conflicts         12
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :arith-grobner           8
;  :arith-max-min           84
;  :arith-nonlinear-bounds  6
;  :arith-nonlinear-horner  6
;  :arith-offset-eqs        12
;  :arith-pivots            22
;  :conflicts               22
;  :datatype-accessor-ax    7
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   24
;  :datatype-splits         16
;  :decisions               26
;  :del-clause              63
;  :final-checks            30
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             593
;  :mk-clause               87
;  :num-allocs              167203
;  :num-checks              21
;  :propagations            62
;  :quant-instantiations    57
;  :rlimit-count            194763)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
    (as None<option<array>>  option<array>))))
(pop) ; 7
(push) ; 7
; [else-branch: 9 | !(i2@20@01 < V@11@01 && 0 <= i2@20@01)]
(assert (not (and (< i2@20@01 V@11@01) (<= 0 i2@20@01))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i2@20@01 V@11@01) (<= 0 i2@20@01))
  (and
    (< i2@20@01 V@11@01)
    (<= 0 i2@20@01)
    (not (= source@9@01 (as None<option<array>>  option<array>)))
    (< i2@20@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@20@01 Int)) (!
  (implies
    (and (< i2@20@01 V@11@01) (<= 0 i2@20@01))
    (and
      (< i2@20@01 V@11@01)
      (<= 0 i2@20@01)
      (not (= source@9@01 (as None<option<array>>  option<array>)))
      (< i2@20@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@20@01 Int)) (!
    (implies
      (and (< i2@20@01 V@11@01) (<= 0 i2@20@01))
      (and
        (< i2@20@01 V@11@01)
        (<= 0 i2@20@01)
        (not (= source@9@01 (as None<option<array>>  option<array>)))
        (< i2@20@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@20@01 Int)) (!
    (implies
      (and (< i2@20@01 V@11@01) (<= 0 i2@20@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@20@01)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :arith-add-rows          33
;  :arith-assert-diseq      4
;  :arith-assert-lower      104
;  :arith-assert-upper      61
;  :arith-bound-prop        2
;  :arith-conflicts         13
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        13
;  :arith-pivots            23
;  :conflicts               23
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               29
;  :del-clause              74
;  :final-checks            35
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.34
;  :mk-bool-var             599
;  :mk-clause               87
;  :num-allocs              168388
;  :num-checks              22
;  :propagations            65
;  :quant-instantiations    57
;  :rlimit-count            196885)
; [then-branch: 10 | 0 < V@11@01 | live]
; [else-branch: 10 | !(0 < V@11@01) | dead]
(push) ; 4
; [then-branch: 10 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
(declare-const i2@21@01 Int)
(push) ; 5
; [eval] (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3)
(declare-const i3@22@01 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 11 | 0 <= i2@21@01 | live]
; [else-branch: 11 | !(0 <= i2@21@01) | live]
(push) ; 8
; [then-branch: 11 | 0 <= i2@21@01]
(assert (<= 0 i2@21@01))
; [eval] i2 < V
(push) ; 9
; [then-branch: 12 | i2@21@01 < V@11@01 | live]
; [else-branch: 12 | !(i2@21@01 < V@11@01) | live]
(push) ; 10
; [then-branch: 12 | i2@21@01 < V@11@01]
(assert (< i2@21@01 V@11@01))
; [eval] 0 <= i3
(push) ; 11
; [then-branch: 13 | 0 <= i3@22@01 | live]
; [else-branch: 13 | !(0 <= i3@22@01) | live]
(push) ; 12
; [then-branch: 13 | 0 <= i3@22@01]
(assert (<= 0 i3@22@01))
; [eval] i3 < V
(push) ; 13
; [then-branch: 14 | i3@22@01 < V@11@01 | live]
; [else-branch: 14 | !(i3@22@01 < V@11@01) | live]
(push) ; 14
; [then-branch: 14 | i3@22@01 < V@11@01]
(assert (< i3@22@01 V@11@01))
; [eval] aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] aloc(opt_get1(source), i2)
; [eval] opt_get1(source)
(push) ; 15
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 16
(assert (not (not (= source@9@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :arith-add-rows          33
;  :arith-assert-diseq      4
;  :arith-assert-lower      106
;  :arith-assert-upper      63
;  :arith-bound-prop        2
;  :arith-conflicts         13
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        13
;  :arith-pivots            24
;  :conflicts               24
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               29
;  :del-clause              74
;  :final-checks            35
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.34
;  :mk-bool-var             603
;  :mk-clause               87
;  :num-allocs              168747
;  :num-checks              23
;  :propagations            65
;  :quant-instantiations    57
;  :rlimit-count            197234)
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 15
; Joined path conditions
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(push) ; 15
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 16
(assert (not (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :arith-add-rows          35
;  :arith-assert-diseq      4
;  :arith-assert-lower      107
;  :arith-assert-upper      63
;  :arith-bound-prop        2
;  :arith-conflicts         14
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         8
;  :arith-grobner           12
;  :arith-max-min           110
;  :arith-nonlinear-bounds  7
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        13
;  :arith-pivots            24
;  :conflicts               25
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               29
;  :del-clause              74
;  :final-checks            35
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             604
;  :mk-clause               87
;  :num-allocs              168899
;  :num-checks              24
;  :propagations            65
;  :quant-instantiations    57
;  :rlimit-count            197385)
(assert (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 15
; Joined path conditions
(assert (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
      V@11@01)
    (<=
      0
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@16@01))
  false)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               176
;  :arith-add-rows          44
;  :arith-assert-diseq      4
;  :arith-assert-lower      115
;  :arith-assert-upper      70
;  :arith-bound-prop        3
;  :arith-conflicts         16
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-grobner           12
;  :arith-max-min           117
;  :arith-nonlinear-bounds  8
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        17
;  :arith-pivots            27
;  :conflicts               27
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               30
;  :del-clause              77
;  :final-checks            36
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             629
;  :mk-clause               101
;  :num-allocs              169253
;  :num-checks              25
;  :propagations            76
;  :quant-instantiations    70
;  :rlimit-count            198405)
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
(assert (not (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               176
;  :arith-add-rows          47
;  :arith-assert-diseq      4
;  :arith-assert-lower      116
;  :arith-assert-upper      70
;  :arith-bound-prop        3
;  :arith-conflicts         17
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         11
;  :arith-grobner           12
;  :arith-max-min           117
;  :arith-nonlinear-bounds  8
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        17
;  :arith-pivots            29
;  :conflicts               28
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               30
;  :del-clause              77
;  :final-checks            36
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             630
;  :mk-clause               101
;  :num-allocs              169344
;  :num-checks              26
;  :propagations            76
;  :quant-instantiations    70
;  :rlimit-count            198550)
(assert (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 15
; Joined path conditions
(assert (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))
      V@11@01)
    (<=
      0
      (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@16@01))
  false)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               190
;  :arith-add-rows          55
;  :arith-assert-diseq      4
;  :arith-assert-lower      124
;  :arith-assert-upper      76
;  :arith-bound-prop        4
;  :arith-conflicts         19
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         15
;  :arith-grobner           12
;  :arith-max-min           124
;  :arith-nonlinear-bounds  9
;  :arith-nonlinear-horner  9
;  :arith-offset-eqs        17
;  :arith-pivots            32
;  :conflicts               30
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   28
;  :datatype-splits         18
;  :decisions               31
;  :del-clause              81
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.35
;  :mk-bool-var             655
;  :mk-clause               114
;  :num-allocs              169736
;  :num-checks              27
;  :propagations            85
;  :quant-instantiations    82
;  :rlimit-count            199561)
(pop) ; 14
(push) ; 14
; [else-branch: 14 | !(i3@22@01 < V@11@01)]
(assert (not (< i3@22@01 V@11@01)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i3@22@01 V@11@01)
  (and
    (< i3@22@01 V@11@01)
    (not (= source@9@01 (as None<option<array>>  option<array>)))
    (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
    (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 13 | !(0 <= i3@22@01)]
(assert (not (<= 0 i3@22@01)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i3@22@01)
  (and
    (<= 0 i3@22@01)
    (implies
      (< i3@22@01 V@11@01)
      (and
        (< i3@22@01 V@11@01)
        (not (= source@9@01 (as None<option<array>>  option<array>)))
        (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
        (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))))))
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 12 | !(i2@21@01 < V@11@01)]
(assert (not (< i2@21@01 V@11@01)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (< i2@21@01 V@11@01)
  (and
    (< i2@21@01 V@11@01)
    (implies
      (<= 0 i3@22@01)
      (and
        (<= 0 i3@22@01)
        (implies
          (< i3@22@01 V@11@01)
          (and
            (< i3@22@01 V@11@01)
            (not (= source@9@01 (as None<option<array>>  option<array>)))
            (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
            (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))))))))
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= i2@21@01)]
(assert (not (<= 0 i2@21@01)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (<= 0 i2@21@01)
  (and
    (<= 0 i2@21@01)
    (implies
      (< i2@21@01 V@11@01)
      (and
        (< i2@21@01 V@11@01)
        (implies
          (<= 0 i3@22@01)
          (and
            (<= 0 i3@22@01)
            (implies
              (< i3@22@01 V@11@01)
              (and
                (< i3@22@01 V@11@01)
                (not (= source@9@01 (as None<option<array>>  option<array>)))
                (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))))))))))
; Joined path conditions
(push) ; 7
; [then-branch: 15 | Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i2@21@01)) == Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i3@22@01)) && i3@22@01 < V@11@01 && 0 <= i3@22@01 && i2@21@01 < V@11@01 && 0 <= i2@21@01 | live]
; [else-branch: 15 | !(Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i2@21@01)) == Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i3@22@01)) && i3@22@01 < V@11@01 && 0 <= i3@22@01 && i2@21@01 < V@11@01 && 0 <= i2@21@01) | live]
(push) ; 8
; [then-branch: 15 | Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i2@21@01)) == Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i3@22@01)) && i3@22@01 < V@11@01 && 0 <= i3@22@01 && i2@21@01 < V@11@01 && 0 <= i2@21@01]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
          ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
        (< i3@22@01 V@11@01))
      (<= 0 i3@22@01))
    (< i2@21@01 V@11@01))
  (<= 0 i2@21@01)))
; [eval] i2 == i3
(pop) ; 8
(push) ; 8
; [else-branch: 15 | !(Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i2@21@01)) == Lookup(option$array$,sm@18@01,aloc((_, _), opt_get1(_, source@9@01), i3@22@01)) && i3@22@01 < V@11@01 && 0 <= i3@22@01 && i2@21@01 < V@11@01 && 0 <= i2@21@01)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
            ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
          (< i3@22@01 V@11@01))
        (<= 0 i3@22@01))
      (< i2@21@01 V@11@01))
    (<= 0 i2@21@01))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
            ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
          (< i3@22@01 V@11@01))
        (<= 0 i3@22@01))
      (< i2@21@01 V@11@01))
    (<= 0 i2@21@01))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
      ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
    (< i3@22@01 V@11@01)
    (<= 0 i3@22@01)
    (< i2@21@01 V@11@01)
    (<= 0 i2@21@01))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@22@01 Int)) (!
  (and
    (implies
      (<= 0 i2@21@01)
      (and
        (<= 0 i2@21@01)
        (implies
          (< i2@21@01 V@11@01)
          (and
            (< i2@21@01 V@11@01)
            (implies
              (<= 0 i3@22@01)
              (and
                (<= 0 i3@22@01)
                (implies
                  (< i3@22@01 V@11@01)
                  (and
                    (< i3@22@01 V@11@01)
                    (not (= source@9@01 (as None<option<array>>  option<array>)))
                    (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                    (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
              (< i3@22@01 V@11@01))
            (<= 0 i3@22@01))
          (< i2@21@01 V@11@01))
        (<= 0 i2@21@01))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
          ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
        (< i3@22@01 V@11@01)
        (<= 0 i3@22@01)
        (< i2@21@01 V@11@01)
        (<= 0 i2@21@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@21@01 Int)) (!
  (forall ((i3@22@01 Int)) (!
    (and
      (implies
        (<= 0 i2@21@01)
        (and
          (<= 0 i2@21@01)
          (implies
            (< i2@21@01 V@11@01)
            (and
              (< i2@21@01 V@11@01)
              (implies
                (<= 0 i3@22@01)
                (and
                  (<= 0 i3@22@01)
                  (implies
                    (< i3@22@01 V@11@01)
                    (and
                      (< i3@22@01 V@11@01)
                      (not
                        (= source@9@01 (as None<option<array>>  option<array>)))
                      (< i2@21@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                      (< i3@22@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                  ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
                (< i3@22@01 V@11@01))
              (<= 0 i3@22@01))
            (< i2@21@01 V@11@01))
          (<= 0 i2@21@01))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
            ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
          (< i3@22@01 V@11@01)
          (<= 0 i3@22@01)
          (< i2@21@01 V@11@01)
          (<= 0 i2@21@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@21@01 Int)) (!
    (forall ((i3@22@01 Int)) (!
      (and
        (implies
          (<= 0 i2@21@01)
          (and
            (<= 0 i2@21@01)
            (implies
              (< i2@21@01 V@11@01)
              (and
                (< i2@21@01 V@11@01)
                (implies
                  (<= 0 i3@22@01)
                  (and
                    (<= 0 i3@22@01)
                    (implies
                      (< i3@22@01 V@11@01)
                      (and
                        (< i3@22@01 V@11@01)
                        (not
                          (= source@9@01 (as None<option<array>>  option<array>)))
                        (<
                          i2@21@01
                          (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                        (<
                          i3@22@01
                          (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                    ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
                  (< i3@22@01 V@11@01))
                (<= 0 i3@22@01))
              (< i2@21@01 V@11@01))
            (<= 0 i2@21@01))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
              ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
            (< i3@22@01 V@11@01)
            (<= 0 i3@22@01)
            (< i2@21@01 V@11@01)
            (<= 0 i2@21@01))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@21@01 Int)) (!
    (forall ((i3@22@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
                  ($FVF.lookup_option$array$ (as sm@18@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01)))
                (< i3@22@01 V@11@01))
              (<= 0 i3@22@01))
            (< i2@21@01 V@11@01))
          (<= 0 i2@21@01))
        (= i2@21@01 i3@22@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@22@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@21@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               203
;  :arith-add-rows          57
;  :arith-assert-diseq      4
;  :arith-assert-lower      139
;  :arith-assert-upper      84
;  :arith-bound-prop        4
;  :arith-conflicts         20
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         15
;  :arith-grobner           16
;  :arith-max-min           150
;  :arith-nonlinear-bounds  10
;  :arith-nonlinear-horner  12
;  :arith-offset-eqs        18
;  :arith-pivots            34
;  :conflicts               31
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   32
;  :datatype-splits         20
;  :decisions               34
;  :del-clause              126
;  :final-checks            42
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             676
;  :mk-clause               139
;  :num-allocs              171672
;  :num-checks              28
;  :propagations            88
;  :quant-instantiations    82
;  :rlimit-count            203354)
; [then-branch: 16 | 0 < V@11@01 | live]
; [else-branch: 16 | !(0 < V@11@01) | dead]
(push) ; 4
; [then-branch: 16 | 0 < V@11@01]
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (not (= target@8@01 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               216
;  :arith-add-rows          57
;  :arith-assert-diseq      4
;  :arith-assert-lower      154
;  :arith-assert-upper      92
;  :arith-bound-prop        4
;  :arith-conflicts         21
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         15
;  :arith-grobner           20
;  :arith-max-min           176
;  :arith-nonlinear-bounds  11
;  :arith-nonlinear-horner  15
;  :arith-offset-eqs        19
;  :arith-pivots            34
;  :conflicts               32
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   36
;  :datatype-splits         22
;  :decisions               37
;  :del-clause              126
;  :final-checks            47
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             681
;  :mk-clause               139
;  :num-allocs              172442
;  :num-checks              29
;  :propagations            91
;  :quant-instantiations    82
;  :rlimit-count            204550)
; [then-branch: 17 | 0 < V@11@01 | live]
; [else-branch: 17 | !(0 < V@11@01) | dead]
(push) ; 4
; [then-branch: 17 | 0 < V@11@01]
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@8@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               216
;  :arith-add-rows          57
;  :arith-assert-diseq      4
;  :arith-assert-lower      154
;  :arith-assert-upper      92
;  :arith-bound-prop        4
;  :arith-conflicts         21
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         15
;  :arith-grobner           20
;  :arith-max-min           176
;  :arith-nonlinear-bounds  11
;  :arith-nonlinear-horner  15
;  :arith-offset-eqs        19
;  :arith-pivots            34
;  :conflicts               32
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   36
;  :datatype-splits         22
;  :decisions               37
;  :del-clause              126
;  :final-checks            47
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             681
;  :mk-clause               139
;  :num-allocs              172467
;  :num-checks              30
;  :propagations            91
;  :quant-instantiations    82
;  :rlimit-count            204571)
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (< 0 V@11@01) (= (alen<Int> (opt_get1 $Snap.unit target@8@01)) V@11@01)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               236
;  :arith-add-rows          57
;  :arith-assert-diseq      4
;  :arith-assert-lower      171
;  :arith-assert-upper      101
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        20
;  :arith-pivots            35
;  :conflicts               33
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               41
;  :del-clause              126
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.37
;  :mk-bool-var             694
;  :mk-clause               139
;  :num-allocs              173367
;  :num-checks              31
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206098)
; [then-branch: 18 | 0 < V@11@01 | live]
; [else-branch: 18 | !(0 < V@11@01) | dead]
(push) ; 3
; [then-branch: 18 | 0 < V@11@01]
(declare-const i2@23@01 Int)
(push) ; 4
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 5
; [then-branch: 19 | 0 <= i2@23@01 | live]
; [else-branch: 19 | !(0 <= i2@23@01) | live]
(push) ; 6
; [then-branch: 19 | 0 <= i2@23@01]
(assert (<= 0 i2@23@01))
; [eval] i2 < V
(pop) ; 6
(push) ; 6
; [else-branch: 19 | !(0 <= i2@23@01)]
(assert (not (<= 0 i2@23@01)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< i2@23@01 V@11@01) (<= 0 i2@23@01)))
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@8@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               236
;  :arith-add-rows          57
;  :arith-assert-diseq      4
;  :arith-assert-lower      173
;  :arith-assert-upper      101
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        20
;  :arith-pivots            36
;  :conflicts               33
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               41
;  :del-clause              126
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.38
;  :mk-bool-var             696
;  :mk-clause               139
;  :num-allocs              173468
;  :num-checks              32
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206273)
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i2@23@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               236
;  :arith-add-rows          57
;  :arith-assert-diseq      4
;  :arith-assert-lower      173
;  :arith-assert-upper      101
;  :arith-bound-prop        4
;  :arith-conflicts         22
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           202
;  :arith-nonlinear-bounds  12
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        20
;  :arith-pivots            36
;  :conflicts               33
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               41
;  :del-clause              126
;  :final-checks            52
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.38
;  :mk-bool-var             696
;  :mk-clause               139
;  :num-allocs              173489
;  :num-checks              33
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206304)
(assert (< i2@23@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 5
; Joined path conditions
(assert (< i2@23@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 5
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 6
(assert (not (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               236
;  :arith-add-rows          57
;  :arith-assert-diseq      4
;  :arith-assert-lower      177
;  :arith-assert-upper      104
;  :arith-bound-prop        4
;  :arith-conflicts         23
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           211
;  :arith-nonlinear-bounds  13
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        20
;  :arith-pivots            36
;  :conflicts               34
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   40
;  :datatype-splits         25
;  :decisions               41
;  :del-clause              126
;  :final-checks            53
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             696
;  :mk-clause               139
;  :num-allocs              173663
;  :num-checks              34
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206469)
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(pop) ; 5
; Joined path conditions
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(declare-const $k@24@01 $Perm)
(assert ($Perm.isReadVar $k@24@01 $Perm.Write))
(pop) ; 4
(declare-fun inv@25@01 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@24@01 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@23@01 Int)) (!
  (and
    (not (= target@8@01 (as None<option<array>>  option<array>)))
    (< i2@23@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@23@01))
  :qid |option$array$-aux|)))
(push) ; 4
(assert (not (forall ((i2@23@01 Int)) (!
  (implies
    (and (< i2@23@01 V@11@01) (<= 0 i2@23@01))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01))))
  
  ))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               245
;  :arith-add-rows          57
;  :arith-assert-diseq      6
;  :arith-assert-lower      195
;  :arith-assert-upper      114
;  :arith-bound-prop        4
;  :arith-conflicts         25
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           234
;  :arith-nonlinear-bounds  16
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        21
;  :arith-pivots            39
;  :conflicts               36
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   42
;  :datatype-splits         28
;  :decisions               45
;  :del-clause              129
;  :final-checks            56
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             709
;  :mk-clause               144
;  :num-allocs              174334
;  :num-checks              35
;  :propagations            99
;  :quant-instantiations    87
;  :rlimit-count            207448)
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((i21@23@01 Int) (i22@23@01 Int)) (!
  (implies
    (and
      (and
        (and (< i21@23@01 V@11@01) (<= 0 i21@23@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@24@01)))
      (and
        (and (< i22@23@01 V@11@01) (<= 0 i22@23@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@24@01)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i21@23@01)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i22@23@01)))
    (= i21@23@01 i22@23@01))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               257
;  :arith-add-rows          65
;  :arith-assert-diseq      8
;  :arith-assert-lower      202
;  :arith-assert-upper      116
;  :arith-bound-prop        5
;  :arith-conflicts         26
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         16
;  :arith-grobner           25
;  :arith-max-min           234
;  :arith-nonlinear-bounds  16
;  :arith-nonlinear-horner  19
;  :arith-offset-eqs        23
;  :arith-pivots            43
;  :conflicts               37
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   42
;  :datatype-splits         28
;  :decisions               45
;  :del-clause              147
;  :final-checks            56
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             734
;  :mk-clause               162
;  :num-allocs              174738
;  :num-checks              36
;  :propagations            108
;  :quant-instantiations    97
;  :rlimit-count            208373)
; Definitional axioms for inverse functions
(assert (forall ((i2@23@01 Int)) (!
  (implies
    (and
      (and (< i2@23@01 V@11@01) (<= 0 i2@23@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01)))
    (=
      (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@23@01))
      i2@23@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@23@01))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) (inv@25@01 r))
      r))
  :pattern ((inv@25@01 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@23@01 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@24@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@23@01))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@23@01 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@24@01)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@23@01))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@23@01 Int)) (!
  (implies
    (and
      (and (< i2@23@01 V@11@01) (<= 0 i2@23@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@23@01)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@23@01))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@26@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r))
  :qid |qp.fvfValDef2|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r))
  :qid |qp.fvfValDef3|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef4|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) r) r))
  :pattern ((inv@25@01 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               273
;  :arith-add-rows          65
;  :arith-assert-diseq      8
;  :arith-assert-lower      225
;  :arith-assert-upper      131
;  :arith-bound-prop        5
;  :arith-conflicts         27
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           272
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        24
;  :arith-pivots            43
;  :conflicts               38
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   46
;  :datatype-splits         31
;  :decisions               49
;  :del-clause              147
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             748
;  :mk-clause               162
;  :num-allocs              176905
;  :num-checks              37
;  :propagations            111
;  :quant-instantiations    97
;  :rlimit-count            213078)
; [then-branch: 20 | 0 < V@11@01 | live]
; [else-branch: 20 | !(0 < V@11@01) | dead]
(push) ; 5
; [then-branch: 20 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
(declare-const i2@27@01 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 21 | 0 <= i2@27@01 | live]
; [else-branch: 21 | !(0 <= i2@27@01) | live]
(push) ; 8
; [then-branch: 21 | 0 <= i2@27@01]
(assert (<= 0 i2@27@01))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 21 | !(0 <= i2@27@01)]
(assert (not (<= 0 i2@27@01)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 22 | i2@27@01 < V@11@01 && 0 <= i2@27@01 | live]
; [else-branch: 22 | !(i2@27@01 < V@11@01 && 0 <= i2@27@01) | live]
(push) ; 8
; [then-branch: 22 | i2@27@01 < V@11@01 && 0 <= i2@27@01]
(assert (and (< i2@27@01 V@11@01) (<= 0 i2@27@01)))
; [eval] aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@8@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               273
;  :arith-add-rows          65
;  :arith-assert-diseq      8
;  :arith-assert-lower      227
;  :arith-assert-upper      131
;  :arith-bound-prop        5
;  :arith-conflicts         27
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           272
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        24
;  :arith-pivots            43
;  :conflicts               38
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   46
;  :datatype-splits         31
;  :decisions               49
;  :del-clause              147
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             750
;  :mk-clause               162
;  :num-allocs              177005
;  :num-checks              38
;  :propagations            111
;  :quant-instantiations    97
;  :rlimit-count            213259)
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i2@27@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               273
;  :arith-add-rows          65
;  :arith-assert-diseq      8
;  :arith-assert-lower      227
;  :arith-assert-upper      131
;  :arith-bound-prop        5
;  :arith-conflicts         27
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         16
;  :arith-grobner           30
;  :arith-max-min           272
;  :arith-nonlinear-bounds  18
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        24
;  :arith-pivots            43
;  :conflicts               38
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   46
;  :datatype-splits         31
;  :decisions               49
;  :del-clause              147
;  :final-checks            61
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.43
;  :memory                  4.42
;  :mk-bool-var             750
;  :mk-clause               162
;  :num-allocs              177026
;  :num-checks              39
;  :propagations            111
;  :quant-instantiations    97
;  :rlimit-count            213290)
(assert (< i2@27@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 9
; Joined path conditions
(assert (< i2@27@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               380
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      261
;  :arith-assert-upper      158
;  :arith-bound-prop        9
;  :arith-conflicts         32
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         25
;  :arith-grobner           30
;  :arith-max-min           292
;  :arith-nonlinear-bounds  22
;  :arith-nonlinear-horner  23
;  :arith-offset-eqs        38
;  :arith-pivots            60
;  :conflicts               47
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   51
;  :datatype-splits         39
;  :decisions               77
;  :del-clause              216
;  :final-checks            68
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.50
;  :memory                  4.50
;  :mk-bool-var             881
;  :mk-clause               254
;  :num-allocs              177998
;  :num-checks              40
;  :propagations            177
;  :quant-instantiations    124
;  :rlimit-count            215889
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 8
(push) ; 8
; [else-branch: 22 | !(i2@27@01 < V@11@01 && 0 <= i2@27@01)]
(assert (not (and (< i2@27@01 V@11@01) (<= 0 i2@27@01))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i2@27@01 V@11@01) (<= 0 i2@27@01))
  (and
    (< i2@27@01 V@11@01)
    (<= 0 i2@27@01)
    (not (= target@8@01 (as None<option<array>>  option<array>)))
    (< i2@27@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@27@01 Int)) (!
  (implies
    (and (< i2@27@01 V@11@01) (<= 0 i2@27@01))
    (and
      (< i2@27@01 V@11@01)
      (<= 0 i2@27@01)
      (not (= target@8@01 (as None<option<array>>  option<array>)))
      (< i2@27@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@27@01 Int)) (!
    (implies
      (and (< i2@27@01 V@11@01) (<= 0 i2@27@01))
      (and
        (< i2@27@01 V@11@01)
        (<= 0 i2@27@01)
        (not (= target@8@01 (as None<option<array>>  option<array>)))
        (< i2@27@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@27@01 Int)) (!
    (implies
      (and (< i2@27@01 V@11@01) (<= 0 i2@27@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@27@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      283
;  :arith-assert-upper      172
;  :arith-bound-prop        9
;  :arith-conflicts         33
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         25
;  :arith-grobner           35
;  :arith-max-min           330
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        39
;  :arith-pivots            61
;  :conflicts               48
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   55
;  :datatype-splits         42
;  :decisions               81
;  :del-clause              239
;  :final-checks            73
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.52
;  :memory                  4.50
;  :mk-bool-var             888
;  :mk-clause               254
;  :num-allocs              179273
;  :num-checks              41
;  :propagations            180
;  :quant-instantiations    124
;  :rlimit-count            218163)
; [then-branch: 23 | 0 < V@11@01 | live]
; [else-branch: 23 | !(0 < V@11@01) | dead]
(push) ; 5
; [then-branch: 23 | 0 < V@11@01]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
(declare-const i2@28@01 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 24 | 0 <= i2@28@01 | live]
; [else-branch: 24 | !(0 <= i2@28@01) | live]
(push) ; 8
; [then-branch: 24 | 0 <= i2@28@01]
(assert (<= 0 i2@28@01))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(0 <= i2@28@01)]
(assert (not (<= 0 i2@28@01)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 25 | i2@28@01 < V@11@01 && 0 <= i2@28@01 | live]
; [else-branch: 25 | !(i2@28@01 < V@11@01 && 0 <= i2@28@01) | live]
(push) ; 8
; [then-branch: 25 | i2@28@01 < V@11@01 && 0 <= i2@28@01]
(assert (and (< i2@28@01 V@11@01) (<= 0 i2@28@01)))
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
(assert (not (not (= target@8@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      285
;  :arith-assert-upper      172
;  :arith-bound-prop        9
;  :arith-conflicts         33
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         25
;  :arith-grobner           35
;  :arith-max-min           330
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        39
;  :arith-pivots            62
;  :conflicts               48
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   55
;  :datatype-splits         42
;  :decisions               81
;  :del-clause              239
;  :final-checks            73
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.52
;  :memory                  4.51
;  :mk-bool-var             890
;  :mk-clause               254
;  :num-allocs              179373
;  :num-checks              42
;  :propagations            180
;  :quant-instantiations    124
;  :rlimit-count            218348)
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i2@28@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-add-rows          80
;  :arith-assert-diseq      9
;  :arith-assert-lower      285
;  :arith-assert-upper      172
;  :arith-bound-prop        9
;  :arith-conflicts         33
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         25
;  :arith-grobner           35
;  :arith-max-min           330
;  :arith-nonlinear-bounds  24
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        39
;  :arith-pivots            62
;  :conflicts               48
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 43
;  :datatype-occurs-check   55
;  :datatype-splits         42
;  :decisions               81
;  :del-clause              239
;  :final-checks            73
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.52
;  :memory                  4.51
;  :mk-bool-var             890
;  :mk-clause               254
;  :num-allocs              179394
;  :num-checks              43
;  :propagations            180
;  :quant-instantiations    124
;  :rlimit-count            218379)
(assert (< i2@28@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 9
; Joined path conditions
(assert (< i2@28@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-add-rows          101
;  :arith-assert-diseq      11
;  :arith-assert-lower      322
;  :arith-assert-upper      199
;  :arith-bound-prop        11
;  :arith-conflicts         39
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         35
;  :arith-grobner           35
;  :arith-max-min           350
;  :arith-nonlinear-bounds  28
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        45
;  :arith-pivots            84
;  :conflicts               58
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   57
;  :datatype-splits         45
;  :decisions               108
;  :del-clause              328
;  :final-checks            76
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.52
;  :memory                  4.51
;  :mk-bool-var             1031
;  :mk-clause               366
;  :num-allocs              180070
;  :num-checks              44
;  :propagations            250
;  :quant-instantiations    155
;  :rlimit-count            220978)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               464
;  :arith-add-rows          101
;  :arith-assert-diseq      11
;  :arith-assert-lower      322
;  :arith-assert-upper      199
;  :arith-bound-prop        11
;  :arith-conflicts         39
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         35
;  :arith-grobner           35
;  :arith-max-min           350
;  :arith-nonlinear-bounds  28
;  :arith-nonlinear-horner  27
;  :arith-offset-eqs        45
;  :arith-pivots            84
;  :conflicts               59
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   57
;  :datatype-splits         45
;  :decisions               108
;  :del-clause              328
;  :final-checks            76
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.52
;  :memory                  4.51
;  :mk-bool-var             1031
;  :mk-clause               366
;  :num-allocs              180161
;  :num-checks              45
;  :propagations            250
;  :quant-instantiations    155
;  :rlimit-count            221073)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
    (as None<option<array>>  option<array>))))
(pop) ; 8
(push) ; 8
; [else-branch: 25 | !(i2@28@01 < V@11@01 && 0 <= i2@28@01)]
(assert (not (and (< i2@28@01 V@11@01) (<= 0 i2@28@01))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i2@28@01 V@11@01) (<= 0 i2@28@01))
  (and
    (< i2@28@01 V@11@01)
    (<= 0 i2@28@01)
    (not (= target@8@01 (as None<option<array>>  option<array>)))
    (< i2@28@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@28@01 Int)) (!
  (implies
    (and (< i2@28@01 V@11@01) (<= 0 i2@28@01))
    (and
      (< i2@28@01 V@11@01)
      (<= 0 i2@28@01)
      (not (= target@8@01 (as None<option<array>>  option<array>)))
      (< i2@28@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@28@01 Int)) (!
    (implies
      (and (< i2@28@01 V@11@01) (<= 0 i2@28@01))
      (and
        (< i2@28@01 V@11@01)
        (<= 0 i2@28@01)
        (not (= target@8@01 (as None<option<array>>  option<array>)))
        (< i2@28@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@28@01 Int)) (!
    (implies
      (and (< i2@28@01 V@11@01) (<= 0 i2@28@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@28@01)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               480
;  :arith-add-rows          101
;  :arith-assert-diseq      11
;  :arith-assert-lower      344
;  :arith-assert-upper      213
;  :arith-bound-prop        11
;  :arith-conflicts         40
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         35
;  :arith-grobner           40
;  :arith-max-min           388
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        46
;  :arith-pivots            85
;  :conflicts               60
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   61
;  :datatype-splits         48
;  :decisions               112
;  :del-clause              351
;  :final-checks            81
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.53
;  :mk-bool-var             1038
;  :mk-clause               366
;  :num-allocs              181464
;  :num-checks              46
;  :propagations            253
;  :quant-instantiations    155
;  :rlimit-count            223451)
; [then-branch: 26 | 0 < V@11@01 | live]
; [else-branch: 26 | !(0 < V@11@01) | dead]
(push) ; 5
; [then-branch: 26 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
(declare-const i2@29@01 Int)
(push) ; 6
; [eval] (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3)
(declare-const i3@30@01 Int)
(push) ; 7
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] 0 <= i2
(push) ; 8
; [then-branch: 27 | 0 <= i2@29@01 | live]
; [else-branch: 27 | !(0 <= i2@29@01) | live]
(push) ; 9
; [then-branch: 27 | 0 <= i2@29@01]
(assert (<= 0 i2@29@01))
; [eval] i2 < V
(push) ; 10
; [then-branch: 28 | i2@29@01 < V@11@01 | live]
; [else-branch: 28 | !(i2@29@01 < V@11@01) | live]
(push) ; 11
; [then-branch: 28 | i2@29@01 < V@11@01]
(assert (< i2@29@01 V@11@01))
; [eval] 0 <= i3
(push) ; 12
; [then-branch: 29 | 0 <= i3@30@01 | live]
; [else-branch: 29 | !(0 <= i3@30@01) | live]
(push) ; 13
; [then-branch: 29 | 0 <= i3@30@01]
(assert (<= 0 i3@30@01))
; [eval] i3 < V
(push) ; 14
; [then-branch: 30 | i3@30@01 < V@11@01 | live]
; [else-branch: 30 | !(i3@30@01 < V@11@01) | live]
(push) ; 15
; [then-branch: 30 | i3@30@01 < V@11@01]
(assert (< i3@30@01 V@11@01))
; [eval] aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] aloc(opt_get1(target), i2)
; [eval] opt_get1(target)
(push) ; 16
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 17
(assert (not (not (= target@8@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               480
;  :arith-add-rows          101
;  :arith-assert-diseq      11
;  :arith-assert-lower      348
;  :arith-assert-upper      213
;  :arith-bound-prop        11
;  :arith-conflicts         40
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         35
;  :arith-grobner           40
;  :arith-max-min           388
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        46
;  :arith-pivots            87
;  :conflicts               60
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   61
;  :datatype-splits         48
;  :decisions               112
;  :del-clause              351
;  :final-checks            81
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.53
;  :mk-bool-var             1042
;  :mk-clause               366
;  :num-allocs              181741
;  :num-checks              47
;  :propagations            253
;  :quant-instantiations    155
;  :rlimit-count            223786)
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 16
; Joined path conditions
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(push) ; 16
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 17
(assert (not (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               480
;  :arith-add-rows          101
;  :arith-assert-diseq      11
;  :arith-assert-lower      348
;  :arith-assert-upper      213
;  :arith-bound-prop        11
;  :arith-conflicts         40
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         35
;  :arith-grobner           40
;  :arith-max-min           388
;  :arith-nonlinear-bounds  30
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        46
;  :arith-pivots            87
;  :conflicts               60
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 50
;  :datatype-occurs-check   61
;  :datatype-splits         48
;  :decisions               112
;  :del-clause              351
;  :final-checks            81
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.53
;  :mk-bool-var             1042
;  :mk-clause               366
;  :num-allocs              181762
;  :num-checks              48
;  :propagations            253
;  :quant-instantiations    155
;  :rlimit-count            223817)
(assert (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 16
; Joined path conditions
(assert (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               549
;  :arith-add-rows          122
;  :arith-assert-diseq      13
;  :arith-assert-lower      385
;  :arith-assert-upper      240
;  :arith-bound-prop        13
;  :arith-conflicts         46
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         45
;  :arith-grobner           40
;  :arith-max-min           408
;  :arith-nonlinear-bounds  34
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        52
;  :arith-pivots            107
;  :conflicts               71
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   63
;  :datatype-splits         51
;  :decisions               141
;  :del-clause              440
;  :final-checks            84
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.53
;  :mk-bool-var             1185
;  :mk-clause               478
;  :num-allocs              182446
;  :num-checks              49
;  :propagations            321
;  :quant-instantiations    186
;  :rlimit-count            226432
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
(assert (not (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               549
;  :arith-add-rows          122
;  :arith-assert-diseq      13
;  :arith-assert-lower      385
;  :arith-assert-upper      240
;  :arith-bound-prop        13
;  :arith-conflicts         46
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         45
;  :arith-grobner           40
;  :arith-max-min           408
;  :arith-nonlinear-bounds  34
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        52
;  :arith-pivots            107
;  :conflicts               71
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   63
;  :datatype-splits         51
;  :decisions               141
;  :del-clause              440
;  :final-checks            84
;  :interface-eqs           3
;  :max-generation          3
;  :max-memory              4.55
;  :memory                  4.53
;  :mk-bool-var             1185
;  :mk-clause               478
;  :num-allocs              182473
;  :num-checks              50
;  :propagations            321
;  :quant-instantiations    186
;  :rlimit-count            226462)
(assert (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 16
; Joined path conditions
(assert (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               692
;  :arith-add-rows          169
;  :arith-assert-diseq      15
;  :arith-assert-lower      429
;  :arith-assert-upper      275
;  :arith-bound-prop        19
;  :arith-conflicts         52
;  :arith-eq-adapter        87
;  :arith-fixed-eqs         62
;  :arith-grobner           40
;  :arith-max-min           428
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        64
;  :arith-pivots            131
;  :conflicts               86
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   68
;  :datatype-splits         59
;  :decisions               177
;  :del-clause              529
;  :final-checks            91
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.73
;  :mk-bool-var             1341
;  :mk-clause               580
;  :num-allocs              183411
;  :num-checks              51
;  :propagations            392
;  :quant-instantiations    215
;  :rlimit-count            229380
;  :time                    0.00)
(pop) ; 15
(push) ; 15
; [else-branch: 30 | !(i3@30@01 < V@11@01)]
(assert (not (< i3@30@01 V@11@01)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (< i3@30@01 V@11@01)
  (and
    (< i3@30@01 V@11@01)
    (not (= target@8@01 (as None<option<array>>  option<array>)))
    (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
    (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 29 | !(0 <= i3@30@01)]
(assert (not (<= 0 i3@30@01)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (<= 0 i3@30@01)
  (and
    (<= 0 i3@30@01)
    (implies
      (< i3@30@01 V@11@01)
      (and
        (< i3@30@01 V@11@01)
        (not (= target@8@01 (as None<option<array>>  option<array>)))
        (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
        (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 28 | !(i2@29@01 < V@11@01)]
(assert (not (< i2@29@01 V@11@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (< i2@29@01 V@11@01)
  (and
    (< i2@29@01 V@11@01)
    (implies
      (<= 0 i3@30@01)
      (and
        (<= 0 i3@30@01)
        (implies
          (< i3@30@01 V@11@01)
          (and
            (< i3@30@01 V@11@01)
            (not (= target@8@01 (as None<option<array>>  option<array>)))
            (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
            (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))))))))
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 27 | !(0 <= i2@29@01)]
(assert (not (<= 0 i2@29@01)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (<= 0 i2@29@01)
  (and
    (<= 0 i2@29@01)
    (implies
      (< i2@29@01 V@11@01)
      (and
        (< i2@29@01 V@11@01)
        (implies
          (<= 0 i3@30@01)
          (and
            (<= 0 i3@30@01)
            (implies
              (< i3@30@01 V@11@01)
              (and
                (< i3@30@01 V@11@01)
                (not (= target@8@01 (as None<option<array>>  option<array>)))
                (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))))))))))
; Joined path conditions
(push) ; 8
; [then-branch: 31 | Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i2@29@01)) == Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i3@30@01)) && i3@30@01 < V@11@01 && 0 <= i3@30@01 && i2@29@01 < V@11@01 && 0 <= i2@29@01 | live]
; [else-branch: 31 | !(Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i2@29@01)) == Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i3@30@01)) && i3@30@01 < V@11@01 && 0 <= i3@30@01 && i2@29@01 < V@11@01 && 0 <= i2@29@01) | live]
(push) ; 9
; [then-branch: 31 | Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i2@29@01)) == Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i3@30@01)) && i3@30@01 < V@11@01 && 0 <= i3@30@01 && i2@29@01 < V@11@01 && 0 <= i2@29@01]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
          ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
        (< i3@30@01 V@11@01))
      (<= 0 i3@30@01))
    (< i2@29@01 V@11@01))
  (<= 0 i2@29@01)))
; [eval] i2 == i3
(pop) ; 9
(push) ; 9
; [else-branch: 31 | !(Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i2@29@01)) == Lookup(option$array$,sm@26@01,aloc((_, _), opt_get1(_, target@8@01), i3@30@01)) && i3@30@01 < V@11@01 && 0 <= i3@30@01 && i2@29@01 < V@11@01 && 0 <= i2@29@01)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
            ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
          (< i3@30@01 V@11@01))
        (<= 0 i3@30@01))
      (< i2@29@01 V@11@01))
    (<= 0 i2@29@01))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
            ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
          (< i3@30@01 V@11@01))
        (<= 0 i3@30@01))
      (< i2@29@01 V@11@01))
    (<= 0 i2@29@01))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
      ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
    (< i3@30@01 V@11@01)
    (<= 0 i3@30@01)
    (< i2@29@01 V@11@01)
    (<= 0 i2@29@01))))
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@30@01 Int)) (!
  (and
    (implies
      (<= 0 i2@29@01)
      (and
        (<= 0 i2@29@01)
        (implies
          (< i2@29@01 V@11@01)
          (and
            (< i2@29@01 V@11@01)
            (implies
              (<= 0 i3@30@01)
              (and
                (<= 0 i3@30@01)
                (implies
                  (< i3@30@01 V@11@01)
                  (and
                    (< i3@30@01 V@11@01)
                    (not (= target@8@01 (as None<option<array>>  option<array>)))
                    (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                    (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
              (< i3@30@01 V@11@01))
            (<= 0 i3@30@01))
          (< i2@29@01 V@11@01))
        (<= 0 i2@29@01))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
          ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
        (< i3@30@01 V@11@01)
        (<= 0 i3@30@01)
        (< i2@29@01 V@11@01)
        (<= 0 i2@29@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@29@01 Int)) (!
  (forall ((i3@30@01 Int)) (!
    (and
      (implies
        (<= 0 i2@29@01)
        (and
          (<= 0 i2@29@01)
          (implies
            (< i2@29@01 V@11@01)
            (and
              (< i2@29@01 V@11@01)
              (implies
                (<= 0 i3@30@01)
                (and
                  (<= 0 i3@30@01)
                  (implies
                    (< i3@30@01 V@11@01)
                    (and
                      (< i3@30@01 V@11@01)
                      (not
                        (= target@8@01 (as None<option<array>>  option<array>)))
                      (< i2@29@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                      (< i3@30@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                  ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
                (< i3@30@01 V@11@01))
              (<= 0 i3@30@01))
            (< i2@29@01 V@11@01))
          (<= 0 i2@29@01))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
            ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
          (< i3@30@01 V@11@01)
          (<= 0 i3@30@01)
          (< i2@29@01 V@11@01)
          (<= 0 i2@29@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@29@01 Int)) (!
    (forall ((i3@30@01 Int)) (!
      (and
        (implies
          (<= 0 i2@29@01)
          (and
            (<= 0 i2@29@01)
            (implies
              (< i2@29@01 V@11@01)
              (and
                (< i2@29@01 V@11@01)
                (implies
                  (<= 0 i3@30@01)
                  (and
                    (<= 0 i3@30@01)
                    (implies
                      (< i3@30@01 V@11@01)
                      (and
                        (< i3@30@01 V@11@01)
                        (not
                          (= target@8@01 (as None<option<array>>  option<array>)))
                        (<
                          i2@29@01
                          (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                        (<
                          i3@30@01
                          (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
                  (< i3@30@01 V@11@01))
                (<= 0 i3@30@01))
              (< i2@29@01 V@11@01))
            (<= 0 i2@29@01))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
              ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
            (< i3@30@01 V@11@01)
            (<= 0 i3@30@01)
            (< i2@29@01 V@11@01)
            (<= 0 i2@29@01))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@29@01 Int)) (!
    (forall ((i3@30@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
                  ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01)))
                (< i3@30@01 V@11@01))
              (<= 0 i3@30@01))
            (< i2@29@01 V@11@01))
          (<= 0 i2@29@01))
        (= i2@29@01 i3@30@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@30@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@29@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
  $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@7@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
  $Snap.unit))
; [eval] i1 < V
(assert (< i1@7@01 V@11@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
  $Snap.unit))
; [eval] 0 <= j
(assert (<= 0 j@10@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
  $Snap.unit))
; [eval] j < V
(assert (< j@10@01 V@11@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))))))
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not (= target@8@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               721
;  :arith-add-rows          169
;  :arith-assert-diseq      15
;  :arith-assert-lower      433
;  :arith-assert-upper      275
;  :arith-bound-prop        19
;  :arith-conflicts         52
;  :arith-eq-adapter        87
;  :arith-fixed-eqs         62
;  :arith-grobner           40
;  :arith-max-min           428
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        64
;  :arith-pivots            135
;  :conflicts               86
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   68
;  :datatype-splits         59
;  :decisions               177
;  :del-clause              589
;  :final-checks            91
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.73
;  :mk-bool-var             1369
;  :mk-clause               604
;  :num-allocs              184653
;  :num-checks              52
;  :propagations            392
;  :quant-instantiations    215
;  :rlimit-count            232719)
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               721
;  :arith-add-rows          169
;  :arith-assert-diseq      15
;  :arith-assert-lower      433
;  :arith-assert-upper      275
;  :arith-bound-prop        19
;  :arith-conflicts         52
;  :arith-eq-adapter        87
;  :arith-fixed-eqs         62
;  :arith-grobner           40
;  :arith-max-min           428
;  :arith-nonlinear-bounds  38
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        64
;  :arith-pivots            135
;  :conflicts               86
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   68
;  :datatype-splits         59
;  :decisions               177
;  :del-clause              589
;  :final-checks            91
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.73
;  :mk-bool-var             1369
;  :mk-clause               604
;  :num-allocs              184674
;  :num-checks              53
;  :propagations            392
;  :quant-instantiations    215
;  :rlimit-count            232750)
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 4
; Joined path conditions
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))
(push) ; 4
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               830
;  :arith-add-rows          189
;  :arith-assert-diseq      17
;  :arith-assert-lower      470
;  :arith-assert-upper      304
;  :arith-bound-prop        22
;  :arith-conflicts         58
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         72
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        79
;  :arith-pivots            153
;  :conflicts               98
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   73
;  :datatype-splits         69
;  :decisions               214
;  :del-clause              691
;  :final-checks            98
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.79
;  :mk-bool-var             1545
;  :mk-clause               729
;  :num-allocs              185479
;  :num-checks              54
;  :propagations            469
;  :quant-instantiations    251
;  :rlimit-count            235905
;  :time                    0.00)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               830
;  :arith-add-rows          189
;  :arith-assert-diseq      17
;  :arith-assert-lower      470
;  :arith-assert-upper      304
;  :arith-bound-prop        22
;  :arith-conflicts         58
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         72
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        79
;  :arith-pivots            153
;  :conflicts               99
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   73
;  :datatype-splits         69
;  :decisions               214
;  :del-clause              691
;  :final-checks            98
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.80
;  :mk-bool-var             1545
;  :mk-clause               729
;  :num-allocs              185573
;  :num-checks              55
;  :propagations            469
;  :quant-instantiations    251
;  :rlimit-count            236000)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               834
;  :arith-add-rows          191
;  :arith-assert-diseq      17
;  :arith-assert-lower      472
;  :arith-assert-upper      304
;  :arith-bound-prop        24
;  :arith-conflicts         58
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         72
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        79
;  :arith-pivots            155
;  :conflicts               100
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   73
;  :datatype-splits         69
;  :decisions               214
;  :del-clause              697
;  :final-checks            98
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.80
;  :mk-bool-var             1556
;  :mk-clause               735
;  :num-allocs              185772
;  :num-checks              56
;  :propagations            469
;  :quant-instantiations    258
;  :rlimit-count            236415)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
    $Ref.null)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not (= source@9@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               849
;  :arith-add-rows          193
;  :arith-assert-diseq      17
;  :arith-assert-lower      474
;  :arith-assert-upper      306
;  :arith-bound-prop        24
;  :arith-conflicts         58
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         73
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        79
;  :arith-pivots            156
;  :conflicts               101
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   73
;  :datatype-splits         69
;  :decisions               214
;  :del-clause              697
;  :final-checks            98
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.80
;  :mk-bool-var             1577
;  :mk-clause               745
;  :num-allocs              186000
;  :num-checks              57
;  :propagations            475
;  :quant-instantiations    270
;  :rlimit-count            236944)
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               849
;  :arith-add-rows          198
;  :arith-assert-diseq      17
;  :arith-assert-lower      474
;  :arith-assert-upper      307
;  :arith-bound-prop        24
;  :arith-conflicts         59
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         73
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        79
;  :arith-pivots            158
;  :conflicts               102
;  :datatype-accessor-ax    27
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   73
;  :datatype-splits         69
;  :decisions               214
;  :del-clause              697
;  :final-checks            98
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.80
;  :mk-bool-var             1578
;  :mk-clause               745
;  :num-allocs              186146
;  :num-checks              58
;  :propagations            475
;  :quant-instantiations    270
;  :rlimit-count            237171)
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 4
; Joined path conditions
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(declare-const sm@31@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r))
  :qid |qp.fvfValDef5|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r))
  :qid |qp.fvfValDef6|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef7|)))
(declare-const pm@32@01 $FPM)
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_option$array$ (as pm@32@01  $FPM) r)
    (+
      (ite
        (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01)
        $Perm.No)
      (ite
        (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01)
        $Perm.No)))
  :pattern (($FVF.perm_option$array$ (as pm@32@01  $FPM) r))
  :qid |qp.resPrmSumDef8|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r) r))
  :pattern (($FVF.perm_option$array$ (as pm@32@01  $FPM) r))
  :qid |qp.resTrgDef9|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))
(push) ; 4
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@32@01  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               988
;  :arith-add-rows          236
;  :arith-assert-diseq      17
;  :arith-assert-lower      512
;  :arith-assert-upper      339
;  :arith-bound-prop        29
;  :arith-conflicts         65
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         87
;  :arith-grobner           40
;  :arith-max-min           469
;  :arith-nonlinear-bounds  46
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        106
;  :arith-pivots            179
;  :conflicts               112
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 85
;  :datatype-occurs-check   78
;  :datatype-splits         79
;  :decisions               257
;  :del-clause              838
;  :final-checks            105
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.86
;  :minimized-lits          1
;  :mk-bool-var             1782
;  :mk-clause               906
;  :num-allocs              187858
;  :num-checks              59
;  :propagations            573
;  :quant-instantiations    318
;  :rlimit-count            243191
;  :time                    0.00)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1036
;  :arith-add-rows          247
;  :arith-assert-diseq      17
;  :arith-assert-lower      520
;  :arith-assert-upper      351
;  :arith-bound-prop        31
;  :arith-conflicts         68
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         91
;  :arith-grobner           40
;  :arith-max-min           478
;  :arith-nonlinear-bounds  48
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        112
;  :arith-pivots            183
;  :conflicts               119
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 90
;  :datatype-occurs-check   80
;  :datatype-splits         83
;  :decisions               277
;  :del-clause              899
;  :final-checks            108
;  :interface-eqs           10
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.86
;  :minimized-lits          1
;  :mk-bool-var             1857
;  :mk-clause               967
;  :num-allocs              188094
;  :num-checks              60
;  :propagations            597
;  :quant-instantiations    329
;  :rlimit-count            244258
;  :time                    0.00)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1116
;  :arith-add-rows          261
;  :arith-assert-diseq      17
;  :arith-assert-lower      534
;  :arith-assert-upper      365
;  :arith-bound-prop        34
;  :arith-conflicts         72
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         97
;  :arith-grobner           40
;  :arith-max-min           487
;  :arith-nonlinear-bounds  50
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        123
;  :arith-pivots            189
;  :conflicts               126
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   82
;  :datatype-splits         87
;  :decisions               297
;  :del-clause              962
;  :final-checks            111
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.86
;  :minimized-lits          1
;  :mk-bool-var             1950
;  :mk-clause               1030
;  :num-allocs              188450
;  :num-checks              61
;  :propagations            633
;  :quant-instantiations    349
;  :rlimit-count            245830
;  :time                    0.00)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(declare-const $k@33@01 $Perm)
(assert ($Perm.isReadVar $k@33@01 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@33@01 $Perm.No) (< $Perm.No $k@33@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1119
;  :arith-add-rows          262
;  :arith-assert-diseq      18
;  :arith-assert-lower      537
;  :arith-assert-upper      367
;  :arith-bound-prop        34
;  :arith-conflicts         72
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         97
;  :arith-grobner           40
;  :arith-max-min           487
;  :arith-nonlinear-bounds  50
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        123
;  :arith-pivots            190
;  :conflicts               127
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   82
;  :datatype-splits         87
;  :decisions               297
;  :del-clause              962
;  :final-checks            111
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.86
;  :minimized-lits          1
;  :mk-bool-var             1960
;  :mk-clause               1032
;  :num-allocs              188711
;  :num-checks              62
;  :propagations            634
;  :quant-instantiations    354
;  :rlimit-count            246241)
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1252
;  :arith-add-rows          310
;  :arith-assert-diseq      18
;  :arith-assert-lower      578
;  :arith-assert-upper      406
;  :arith-bound-prop        38
;  :arith-conflicts         78
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         105
;  :arith-grobner           56
;  :arith-max-min           543
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  44
;  :arith-offset-eqs        141
;  :arith-pivots            205
;  :conflicts               135
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   92
;  :datatype-splits         101
;  :decisions               341
;  :del-clause              1071
;  :final-checks            123
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.94
;  :memory                  4.91
;  :minimized-lits          1
;  :mk-bool-var             2098
;  :mk-clause               1141
;  :num-allocs              191538
;  :num-checks              63
;  :propagations            695
;  :quant-instantiations    383
;  :rlimit-count            256190
;  :time                    0.00)
(assert (<= $Perm.No $k@33@01))
(assert (<= $k@33@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@33@01)
  (not
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
      $Ref.null))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 4
(declare-const $t@34@01 $Snap)
(assert (= $t@34@01 ($Snap.combine ($Snap.first $t@34@01) ($Snap.second $t@34@01))))
(assert (= ($Snap.first $t@34@01) $Snap.unit))
; [eval] exc == null
(assert (= exc@12@01 $Ref.null))
(assert (=
  ($Snap.second $t@34@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@01))
    ($Snap.second ($Snap.second $t@34@01)))))
(assert (= ($Snap.first ($Snap.second $t@34@01)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 32 | exc@12@01 == Null | live]
; [else-branch: 32 | exc@12@01 != Null | live]
(push) ; 6
; [then-branch: 32 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 32 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1415
;  :arith-add-rows          370
;  :arith-assert-diseq      18
;  :arith-assert-lower      636
;  :arith-assert-upper      461
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        146
;  :arith-fixed-eqs         113
;  :arith-grobner           86
;  :arith-max-min           635
;  :arith-nonlinear-bounds  61
;  :arith-nonlinear-horner  68
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               142
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   108
;  :datatype-splits         122
;  :decisions               397
;  :del-clause              1240
;  :final-checks            142
;  :interface-eqs           19
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.92
;  :minimized-lits          1
;  :mk-bool-var             2266
;  :mk-clause               1271
;  :num-allocs              196076
;  :num-checks              65
;  :propagations            768
;  :quant-instantiations    417
;  :rlimit-count            270886
;  :time                    0.00)
(push) ; 6
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1415
;  :arith-add-rows          370
;  :arith-assert-diseq      18
;  :arith-assert-lower      636
;  :arith-assert-upper      461
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        146
;  :arith-fixed-eqs         113
;  :arith-grobner           86
;  :arith-max-min           635
;  :arith-nonlinear-bounds  61
;  :arith-nonlinear-horner  68
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               142
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 132
;  :datatype-occurs-check   108
;  :datatype-splits         122
;  :decisions               397
;  :del-clause              1240
;  :final-checks            142
;  :interface-eqs           19
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.92
;  :minimized-lits          1
;  :mk-bool-var             2266
;  :mk-clause               1271
;  :num-allocs              196094
;  :num-checks              66
;  :propagations            768
;  :quant-instantiations    417
;  :rlimit-count            270903)
; [then-branch: 33 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 33 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 6
; [then-branch: 33 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (not (= source@9@01 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@34@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@34@01))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 34 | exc@12@01 == Null | live]
; [else-branch: 34 | exc@12@01 != Null | live]
(push) ; 6
; [then-branch: 34 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 34 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1445
;  :arith-add-rows          370
;  :arith-assert-diseq      18
;  :arith-assert-lower      654
;  :arith-assert-upper      477
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         113
;  :arith-grobner           101
;  :arith-max-min           671
;  :arith-nonlinear-bounds  62
;  :arith-nonlinear-horner  80
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               142
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 139
;  :datatype-occurs-check   114
;  :datatype-splits         129
;  :decisions               411
;  :del-clause              1260
;  :final-checks            149
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.93
;  :minimized-lits          1
;  :mk-bool-var             2292
;  :mk-clause               1291
;  :num-allocs              198185
;  :num-checks              67
;  :propagations            779
;  :quant-instantiations    422
;  :rlimit-count            277000
;  :time                    0.00)
(push) ; 6
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1445
;  :arith-add-rows          370
;  :arith-assert-diseq      18
;  :arith-assert-lower      654
;  :arith-assert-upper      477
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         113
;  :arith-grobner           101
;  :arith-max-min           671
;  :arith-nonlinear-bounds  62
;  :arith-nonlinear-horner  80
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               142
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 139
;  :datatype-occurs-check   114
;  :datatype-splits         129
;  :decisions               411
;  :del-clause              1260
;  :final-checks            149
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.93
;  :minimized-lits          1
;  :mk-bool-var             2292
;  :mk-clause               1291
;  :num-allocs              198203
;  :num-checks              68
;  :propagations            779
;  :quant-instantiations    422
;  :rlimit-count            277017)
; [then-branch: 35 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 35 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 6
; [then-branch: 35 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
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
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit source@9@01)) V@11@01)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@34@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 36 | exc@12@01 == Null | live]
; [else-branch: 36 | exc@12@01 != Null | live]
(push) ; 6
; [then-branch: 36 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 36 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1477
;  :arith-add-rows          370
;  :arith-assert-diseq      18
;  :arith-assert-lower      672
;  :arith-assert-upper      493
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        150
;  :arith-fixed-eqs         113
;  :arith-grobner           116
;  :arith-max-min           707
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  92
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               142
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   120
;  :datatype-splits         137
;  :decisions               426
;  :del-clause              1280
;  :final-checks            156
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.94
;  :minimized-lits          1
;  :mk-bool-var             2318
;  :mk-clause               1311
;  :num-allocs              200314
;  :num-checks              69
;  :propagations            790
;  :quant-instantiations    427
;  :rlimit-count            283152
;  :time                    0.00)
(push) ; 5
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1477
;  :arith-add-rows          370
;  :arith-assert-diseq      18
;  :arith-assert-lower      672
;  :arith-assert-upper      493
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        150
;  :arith-fixed-eqs         113
;  :arith-grobner           116
;  :arith-max-min           707
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  92
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               142
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   120
;  :datatype-splits         137
;  :decisions               426
;  :del-clause              1280
;  :final-checks            156
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.94
;  :minimized-lits          1
;  :mk-bool-var             2318
;  :mk-clause               1311
;  :num-allocs              200332
;  :num-checks              70
;  :propagations            790
;  :quant-instantiations    427
;  :rlimit-count            283169)
; [then-branch: 37 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 37 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 5
; [then-branch: 37 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
(declare-const i2@35@01 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 38 | 0 <= i2@35@01 | live]
; [else-branch: 38 | !(0 <= i2@35@01) | live]
(push) ; 8
; [then-branch: 38 | 0 <= i2@35@01]
(assert (<= 0 i2@35@01))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 38 | !(0 <= i2@35@01)]
(assert (not (<= 0 i2@35@01)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< i2@35@01 V@11@01) (<= 0 i2@35@01)))
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
(assert (not (< i2@35@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1477
;  :arith-add-rows          371
;  :arith-assert-diseq      18
;  :arith-assert-lower      674
;  :arith-assert-upper      493
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        150
;  :arith-fixed-eqs         113
;  :arith-grobner           116
;  :arith-max-min           707
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  92
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               142
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   120
;  :datatype-splits         137
;  :decisions               426
;  :del-clause              1280
;  :final-checks            156
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.94
;  :minimized-lits          1
;  :mk-bool-var             2320
;  :mk-clause               1311
;  :num-allocs              200437
;  :num-checks              71
;  :propagations            790
;  :quant-instantiations    427
;  :rlimit-count            283364)
(assert (< i2@35@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 7
; Joined path conditions
(assert (< i2@35@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 7
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 8
(assert (not (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1477
;  :arith-add-rows          371
;  :arith-assert-diseq      18
;  :arith-assert-lower      674
;  :arith-assert-upper      493
;  :arith-bound-prop        43
;  :arith-conflicts         83
;  :arith-eq-adapter        150
;  :arith-fixed-eqs         113
;  :arith-grobner           116
;  :arith-max-min           707
;  :arith-nonlinear-bounds  63
;  :arith-nonlinear-horner  92
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               143
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   120
;  :datatype-splits         137
;  :decisions               426
;  :del-clause              1280
;  :final-checks            156
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.94
;  :minimized-lits          1
;  :mk-bool-var             2320
;  :mk-clause               1311
;  :num-allocs              200581
;  :num-checks              72
;  :propagations            790
;  :quant-instantiations    427
;  :rlimit-count            283476)
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(pop) ; 7
; Joined path conditions
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(declare-const $k@36@01 $Perm)
(assert ($Perm.isReadVar $k@36@01 $Perm.Write))
(pop) ; 6
(declare-fun inv@37@01 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@36@01 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@35@01 Int)) (!
  (and
    (< i2@35@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@35@01))
  :qid |option$array$-aux|)))
(push) ; 6
(assert (not (forall ((i2@35@01 Int)) (!
  (implies
    (and (< i2@35@01 V@11@01) (<= 0 i2@35@01))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01))))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1477
;  :arith-add-rows          372
;  :arith-assert-diseq      20
;  :arith-assert-lower      688
;  :arith-assert-upper      503
;  :arith-bound-prop        43
;  :arith-conflicts         84
;  :arith-eq-adapter        152
;  :arith-fixed-eqs         113
;  :arith-grobner           116
;  :arith-max-min           723
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  92
;  :arith-offset-eqs        154
;  :arith-pivots            216
;  :conflicts               144
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   120
;  :datatype-splits         137
;  :decisions               432
;  :del-clause              1299
;  :final-checks            157
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.93
;  :minimized-lits          1
;  :mk-bool-var             2345
;  :mk-clause               1332
;  :num-allocs              201257
;  :num-checks              73
;  :propagations            800
;  :quant-instantiations    433
;  :rlimit-count            284693)
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((i21@35@01 Int) (i22@35@01 Int)) (!
  (implies
    (and
      (and
        (and (< i21@35@01 V@11@01) (<= 0 i21@35@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@36@01)))
      (and
        (and (< i22@35@01 V@11@01) (<= 0 i22@35@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@36@01)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i21@35@01)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i22@35@01)))
    (= i21@35@01 i22@35@01))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1486
;  :arith-add-rows          380
;  :arith-assert-diseq      21
;  :arith-assert-lower      693
;  :arith-assert-upper      503
;  :arith-bound-prop        43
;  :arith-conflicts         84
;  :arith-eq-adapter        153
;  :arith-fixed-eqs         113
;  :arith-grobner           116
;  :arith-max-min           723
;  :arith-nonlinear-bounds  65
;  :arith-nonlinear-horner  92
;  :arith-offset-eqs        154
;  :arith-pivots            220
;  :conflicts               145
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 147
;  :datatype-occurs-check   120
;  :datatype-splits         137
;  :decisions               432
;  :del-clause              1309
;  :final-checks            157
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.97
;  :memory                  4.93
;  :minimized-lits          1
;  :mk-bool-var             2368
;  :mk-clause               1342
;  :num-allocs              201668
;  :num-checks              74
;  :propagations            804
;  :quant-instantiations    444
;  :rlimit-count            285541)
; Definitional axioms for inverse functions
(assert (forall ((i2@35@01 Int)) (!
  (implies
    (and
      (and (< i2@35@01 V@11@01) (<= 0 i2@35@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01)))
    (=
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@35@01))
      i2@35@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@35@01))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@37@01 r) V@11@01) (<= 0 (inv@37@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) (inv@37@01 r))
      r))
  :pattern ((inv@37@01 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@35@01 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@36@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@35@01))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@35@01 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@36@01)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@35@01))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@35@01 Int)) (!
  (implies
    (and
      (and (< i2@35@01 V@11@01) (<= 0 i2@35@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@35@01)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@35@01))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@38@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@37@01 r) V@11@01) (<= 0 (inv@37@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r))
  :qid |qp.fvfValDef10|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef11|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@37@01 r) V@11@01) (<= 0 (inv@37@01 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) r) r))
  :pattern ((inv@37@01 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 39 | exc@12@01 == Null | live]
; [else-branch: 39 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 39 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 39 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1585
;  :arith-add-rows          400
;  :arith-assert-diseq      21
;  :arith-assert-lower      731
;  :arith-assert-upper      535
;  :arith-bound-prop        44
;  :arith-conflicts         86
;  :arith-eq-adapter        156
;  :arith-fixed-eqs         115
;  :arith-grobner           132
;  :arith-max-min           786
;  :arith-nonlinear-bounds  69
;  :arith-nonlinear-horner  105
;  :arith-offset-eqs        159
;  :arith-pivots            225
;  :conflicts               149
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 163
;  :datatype-occurs-check   131
;  :datatype-splits         149
;  :decisions               473
;  :del-clause              1416
;  :final-checks            166
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  5.02
;  :minimized-lits          1
;  :mk-bool-var             2511
;  :mk-clause               1450
;  :num-allocs              205497
;  :num-checks              75
;  :propagations            842
;  :quant-instantiations    466
;  :rlimit-count            296839
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1585
;  :arith-add-rows          400
;  :arith-assert-diseq      21
;  :arith-assert-lower      731
;  :arith-assert-upper      535
;  :arith-bound-prop        44
;  :arith-conflicts         86
;  :arith-eq-adapter        156
;  :arith-fixed-eqs         115
;  :arith-grobner           132
;  :arith-max-min           786
;  :arith-nonlinear-bounds  69
;  :arith-nonlinear-horner  105
;  :arith-offset-eqs        159
;  :arith-pivots            225
;  :conflicts               149
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 163
;  :datatype-occurs-check   131
;  :datatype-splits         149
;  :decisions               473
;  :del-clause              1416
;  :final-checks            166
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  5.02
;  :minimized-lits          1
;  :mk-bool-var             2511
;  :mk-clause               1450
;  :num-allocs              205515
;  :num-checks              76
;  :propagations            842
;  :quant-instantiations    466
;  :rlimit-count            296856)
; [then-branch: 40 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 40 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 7
; [then-branch: 40 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
(declare-const i2@39@01 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 41 | 0 <= i2@39@01 | live]
; [else-branch: 41 | !(0 <= i2@39@01) | live]
(push) ; 10
; [then-branch: 41 | 0 <= i2@39@01]
(assert (<= 0 i2@39@01))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 41 | !(0 <= i2@39@01)]
(assert (not (<= 0 i2@39@01)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 42 | i2@39@01 < V@11@01 && 0 <= i2@39@01 | live]
; [else-branch: 42 | !(i2@39@01 < V@11@01 && 0 <= i2@39@01) | live]
(push) ; 10
; [then-branch: 42 | i2@39@01 < V@11@01 && 0 <= i2@39@01]
(assert (and (< i2@39@01 V@11@01) (<= 0 i2@39@01)))
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
(assert (not (< i2@39@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1585
;  :arith-add-rows          401
;  :arith-assert-diseq      21
;  :arith-assert-lower      733
;  :arith-assert-upper      535
;  :arith-bound-prop        44
;  :arith-conflicts         86
;  :arith-eq-adapter        156
;  :arith-fixed-eqs         115
;  :arith-grobner           132
;  :arith-max-min           786
;  :arith-nonlinear-bounds  69
;  :arith-nonlinear-horner  105
;  :arith-offset-eqs        159
;  :arith-pivots            226
;  :conflicts               149
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 163
;  :datatype-occurs-check   131
;  :datatype-splits         149
;  :decisions               473
;  :del-clause              1416
;  :final-checks            166
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  5.02
;  :minimized-lits          1
;  :mk-bool-var             2513
;  :mk-clause               1450
;  :num-allocs              205614
;  :num-checks              77
;  :propagations            842
;  :quant-instantiations    466
;  :rlimit-count            297067)
(assert (< i2@39@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 11
; Joined path conditions
(assert (< i2@39@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))
      V@11@01)
    (<=
      0
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@36@01))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1621
;  :arith-add-rows          488
;  :arith-assert-diseq      23
;  :arith-assert-lower      750
;  :arith-assert-upper      549
;  :arith-bound-prop        51
;  :arith-conflicts         88
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         119
;  :arith-grobner           132
;  :arith-max-min           801
;  :arith-nonlinear-bounds  71
;  :arith-nonlinear-horner  105
;  :arith-offset-eqs        166
;  :arith-pivots            236
;  :conflicts               158
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 163
;  :datatype-occurs-check   131
;  :datatype-splits         149
;  :decisions               493
;  :del-clause              1494
;  :final-checks            167
;  :interface-eqs           25
;  :max-generation          6
;  :max-memory              5.07
;  :memory                  5.06
;  :minimized-lits          1
;  :mk-bool-var             2711
;  :mk-clause               1583
;  :num-allocs              206675
;  :num-checks              78
;  :propagations            887
;  :quant-instantiations    516
;  :rlimit-count            301244
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 10
(push) ; 10
; [else-branch: 42 | !(i2@39@01 < V@11@01 && 0 <= i2@39@01)]
(assert (not (and (< i2@39@01 V@11@01) (<= 0 i2@39@01))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@39@01 V@11@01) (<= 0 i2@39@01))
  (and
    (< i2@39@01 V@11@01)
    (<= 0 i2@39@01)
    (< i2@39@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@39@01 Int)) (!
  (implies
    (and (< i2@39@01 V@11@01) (<= 0 i2@39@01))
    (and
      (< i2@39@01 V@11@01)
      (<= 0 i2@39@01)
      (< i2@39@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (and
    (< 0 V@11@01)
    (= exc@12@01 $Ref.null)
    (forall ((i2@39@01 Int)) (!
      (implies
        (and (< i2@39@01 V@11@01) (<= 0 i2@39@01))
        (and
          (< i2@39@01 V@11@01)
          (<= 0 i2@39@01)
          (< i2@39@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (forall ((i2@39@01 Int)) (!
    (implies
      (and (< i2@39@01 V@11@01) (<= 0 i2@39@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@39@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 43 | exc@12@01 == Null | live]
; [else-branch: 43 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 43 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 43 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1740
;  :arith-add-rows          524
;  :arith-assert-diseq      23
;  :arith-assert-lower      787
;  :arith-assert-upper      581
;  :arith-bound-prop        52
;  :arith-conflicts         90
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         121
;  :arith-grobner           148
;  :arith-max-min           864
;  :arith-nonlinear-bounds  75
;  :arith-nonlinear-horner  118
;  :arith-offset-eqs        168
;  :arith-pivots            244
;  :conflicts               162
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   145
;  :datatype-splits         167
;  :decisions               539
;  :del-clause              1640
;  :final-checks            178
;  :interface-eqs           28
;  :max-generation          6
;  :max-memory              5.11
;  :memory                  5.07
;  :minimized-lits          1
;  :mk-bool-var             2854
;  :mk-clause               1693
;  :num-allocs              210102
;  :num-checks              79
;  :propagations            928
;  :quant-instantiations    538
;  :rlimit-count            312051
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1740
;  :arith-add-rows          524
;  :arith-assert-diseq      23
;  :arith-assert-lower      787
;  :arith-assert-upper      581
;  :arith-bound-prop        52
;  :arith-conflicts         90
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         121
;  :arith-grobner           148
;  :arith-max-min           864
;  :arith-nonlinear-bounds  75
;  :arith-nonlinear-horner  118
;  :arith-offset-eqs        168
;  :arith-pivots            244
;  :conflicts               162
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   145
;  :datatype-splits         167
;  :decisions               539
;  :del-clause              1640
;  :final-checks            178
;  :interface-eqs           28
;  :max-generation          6
;  :max-memory              5.11
;  :memory                  5.07
;  :minimized-lits          1
;  :mk-bool-var             2854
;  :mk-clause               1693
;  :num-allocs              210120
;  :num-checks              80
;  :propagations            928
;  :quant-instantiations    538
;  :rlimit-count            312068)
; [then-branch: 44 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 44 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 7
; [then-branch: 44 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
(declare-const i2@40@01 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 45 | 0 <= i2@40@01 | live]
; [else-branch: 45 | !(0 <= i2@40@01) | live]
(push) ; 10
; [then-branch: 45 | 0 <= i2@40@01]
(assert (<= 0 i2@40@01))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 45 | !(0 <= i2@40@01)]
(assert (not (<= 0 i2@40@01)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 46 | i2@40@01 < V@11@01 && 0 <= i2@40@01 | live]
; [else-branch: 46 | !(i2@40@01 < V@11@01 && 0 <= i2@40@01) | live]
(push) ; 10
; [then-branch: 46 | i2@40@01 < V@11@01 && 0 <= i2@40@01]
(assert (and (< i2@40@01 V@11@01) (<= 0 i2@40@01)))
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
(assert (not (< i2@40@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1740
;  :arith-add-rows          524
;  :arith-assert-diseq      23
;  :arith-assert-lower      789
;  :arith-assert-upper      581
;  :arith-bound-prop        52
;  :arith-conflicts         90
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         121
;  :arith-grobner           148
;  :arith-max-min           864
;  :arith-nonlinear-bounds  75
;  :arith-nonlinear-horner  118
;  :arith-offset-eqs        168
;  :arith-pivots            245
;  :conflicts               162
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   145
;  :datatype-splits         167
;  :decisions               539
;  :del-clause              1640
;  :final-checks            178
;  :interface-eqs           28
;  :max-generation          6
;  :max-memory              5.11
;  :memory                  5.07
;  :minimized-lits          1
;  :mk-bool-var             2856
;  :mk-clause               1693
;  :num-allocs              210219
;  :num-checks              81
;  :propagations            928
;  :quant-instantiations    538
;  :rlimit-count            312276)
(assert (< i2@40@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 11
; Joined path conditions
(assert (< i2@40@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
      V@11@01)
    (<=
      0
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@36@01))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1779
;  :arith-add-rows          628
;  :arith-assert-diseq      25
;  :arith-assert-lower      805
;  :arith-assert-upper      594
;  :arith-bound-prop        58
;  :arith-conflicts         92
;  :arith-eq-adapter        169
;  :arith-fixed-eqs         125
;  :arith-grobner           148
;  :arith-max-min           879
;  :arith-nonlinear-bounds  77
;  :arith-nonlinear-horner  118
;  :arith-offset-eqs        173
;  :arith-pivots            255
;  :conflicts               170
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   145
;  :datatype-splits         167
;  :decisions               558
;  :del-clause              1710
;  :final-checks            179
;  :interface-eqs           28
;  :max-generation          6
;  :max-memory              5.11
;  :memory                  5.08
;  :minimized-lits          1
;  :mk-bool-var             2997
;  :mk-clause               1802
;  :num-allocs              210943
;  :num-checks              82
;  :propagations            974
;  :quant-instantiations    584
;  :rlimit-count            316455
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 12
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1779
;  :arith-add-rows          628
;  :arith-assert-diseq      25
;  :arith-assert-lower      805
;  :arith-assert-upper      594
;  :arith-bound-prop        58
;  :arith-conflicts         92
;  :arith-eq-adapter        169
;  :arith-fixed-eqs         125
;  :arith-grobner           148
;  :arith-max-min           879
;  :arith-nonlinear-bounds  77
;  :arith-nonlinear-horner  118
;  :arith-offset-eqs        173
;  :arith-pivots            255
;  :conflicts               171
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   145
;  :datatype-splits         167
;  :decisions               558
;  :del-clause              1710
;  :final-checks            179
;  :interface-eqs           28
;  :max-generation          6
;  :max-memory              5.11
;  :memory                  5.08
;  :minimized-lits          1
;  :mk-bool-var             2997
;  :mk-clause               1802
;  :num-allocs              211038
;  :num-checks              83
;  :propagations            974
;  :quant-instantiations    584
;  :rlimit-count            316550)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
    (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
    (as None<option<array>>  option<array>))))
(pop) ; 10
(push) ; 10
; [else-branch: 46 | !(i2@40@01 < V@11@01 && 0 <= i2@40@01)]
(assert (not (and (< i2@40@01 V@11@01) (<= 0 i2@40@01))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@40@01 V@11@01) (<= 0 i2@40@01))
  (and
    (< i2@40@01 V@11@01)
    (<= 0 i2@40@01)
    (< i2@40@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@40@01 Int)) (!
  (implies
    (and (< i2@40@01 V@11@01) (<= 0 i2@40@01))
    (and
      (< i2@40@01 V@11@01)
      (<= 0 i2@40@01)
      (< i2@40@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (and
    (< 0 V@11@01)
    (= exc@12@01 $Ref.null)
    (forall ((i2@40@01 Int)) (!
      (implies
        (and (< i2@40@01 V@11@01) (<= 0 i2@40@01))
        (and
          (< i2@40@01 V@11@01)
          (<= 0 i2@40@01)
          (< i2@40@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (forall ((i2@40@01 Int)) (!
    (implies
      (and (< i2@40@01 V@11@01) (<= 0 i2@40@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@40@01)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 47 | exc@12@01 == Null | live]
; [else-branch: 47 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 47 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 47 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1912
;  :arith-add-rows          652
;  :arith-assert-diseq      25
;  :arith-assert-lower      837
;  :arith-assert-upper      620
;  :arith-bound-prop        59
;  :arith-conflicts         94
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         128
;  :arith-grobner           161
;  :arith-max-min           927
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  130
;  :arith-offset-eqs        189
;  :arith-pivots            262
;  :conflicts               175
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   159
;  :datatype-splits         185
;  :decisions               604
;  :del-clause              1842
;  :final-checks            190
;  :interface-eqs           31
;  :max-generation          6
;  :max-memory              5.15
;  :memory                  5.12
;  :minimized-lits          1
;  :mk-bool-var             3113
;  :mk-clause               1895
;  :num-allocs              214991
;  :num-checks              84
;  :propagations            1015
;  :quant-instantiations    597
;  :rlimit-count            326794
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1912
;  :arith-add-rows          652
;  :arith-assert-diseq      25
;  :arith-assert-lower      837
;  :arith-assert-upper      620
;  :arith-bound-prop        59
;  :arith-conflicts         94
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         128
;  :arith-grobner           161
;  :arith-max-min           927
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  130
;  :arith-offset-eqs        189
;  :arith-pivots            262
;  :conflicts               175
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   159
;  :datatype-splits         185
;  :decisions               604
;  :del-clause              1842
;  :final-checks            190
;  :interface-eqs           31
;  :max-generation          6
;  :max-memory              5.15
;  :memory                  5.12
;  :minimized-lits          1
;  :mk-bool-var             3113
;  :mk-clause               1895
;  :num-allocs              215009
;  :num-checks              85
;  :propagations            1015
;  :quant-instantiations    597
;  :rlimit-count            326811)
; [then-branch: 48 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 48 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 7
; [then-branch: 48 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
(declare-const i2@41@01 Int)
(push) ; 8
; [eval] (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3)
(declare-const i3@42@01 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 49 | 0 <= i2@41@01 | live]
; [else-branch: 49 | !(0 <= i2@41@01) | live]
(push) ; 11
; [then-branch: 49 | 0 <= i2@41@01]
(assert (<= 0 i2@41@01))
; [eval] i2 < V
(push) ; 12
; [then-branch: 50 | i2@41@01 < V@11@01 | live]
; [else-branch: 50 | !(i2@41@01 < V@11@01) | live]
(push) ; 13
; [then-branch: 50 | i2@41@01 < V@11@01]
(assert (< i2@41@01 V@11@01))
; [eval] 0 <= i3
(push) ; 14
; [then-branch: 51 | 0 <= i3@42@01 | live]
; [else-branch: 51 | !(0 <= i3@42@01) | live]
(push) ; 15
; [then-branch: 51 | 0 <= i3@42@01]
(assert (<= 0 i3@42@01))
; [eval] i3 < V
(push) ; 16
; [then-branch: 52 | i3@42@01 < V@11@01 | live]
; [else-branch: 52 | !(i3@42@01 < V@11@01) | live]
(push) ; 17
; [then-branch: 52 | i3@42@01 < V@11@01]
(assert (< i3@42@01 V@11@01))
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
(assert (not (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1912
;  :arith-add-rows          652
;  :arith-assert-diseq      25
;  :arith-assert-lower      841
;  :arith-assert-upper      620
;  :arith-bound-prop        59
;  :arith-conflicts         94
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         128
;  :arith-grobner           161
;  :arith-max-min           927
;  :arith-nonlinear-bounds  81
;  :arith-nonlinear-horner  130
;  :arith-offset-eqs        189
;  :arith-pivots            263
;  :conflicts               175
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   159
;  :datatype-splits         185
;  :decisions               604
;  :del-clause              1842
;  :final-checks            190
;  :interface-eqs           31
;  :max-generation          6
;  :max-memory              5.15
;  :memory                  5.12
;  :minimized-lits          1
;  :mk-bool-var             3117
;  :mk-clause               1895
;  :num-allocs              215291
;  :num-checks              86
;  :propagations            1015
;  :quant-instantiations    597
;  :rlimit-count            327164)
(assert (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 18
; Joined path conditions
(assert (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
      V@11@01)
    (<=
      0
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@36@01))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1989
;  :arith-add-rows          767
;  :arith-assert-diseq      27
;  :arith-assert-lower      857
;  :arith-assert-upper      635
;  :arith-bound-prop        66
;  :arith-conflicts         96
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         132
;  :arith-grobner           161
;  :arith-max-min           942
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  130
;  :arith-offset-eqs        193
;  :arith-pivots            275
;  :conflicts               184
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 216
;  :datatype-occurs-check   162
;  :datatype-splits         191
;  :decisions               631
;  :del-clause              1920
;  :final-checks            193
;  :interface-eqs           32
;  :max-generation          6
;  :max-memory              5.15
;  :memory                  5.15
;  :minimized-lits          1
;  :mk-bool-var             3301
;  :mk-clause               2012
;  :num-allocs              216177
;  :num-checks              87
;  :propagations            1062
;  :quant-instantiations    644
;  :rlimit-count            331624
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
(assert (not (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1989
;  :arith-add-rows          767
;  :arith-assert-diseq      27
;  :arith-assert-lower      857
;  :arith-assert-upper      635
;  :arith-bound-prop        66
;  :arith-conflicts         96
;  :arith-eq-adapter        178
;  :arith-fixed-eqs         132
;  :arith-grobner           161
;  :arith-max-min           942
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  130
;  :arith-offset-eqs        193
;  :arith-pivots            275
;  :conflicts               184
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 216
;  :datatype-occurs-check   162
;  :datatype-splits         191
;  :decisions               631
;  :del-clause              1920
;  :final-checks            193
;  :interface-eqs           32
;  :max-generation          6
;  :max-memory              5.15
;  :memory                  5.15
;  :minimized-lits          1
;  :mk-bool-var             3301
;  :mk-clause               2012
;  :num-allocs              216204
;  :num-checks              88
;  :propagations            1062
;  :quant-instantiations    644
;  :rlimit-count            331654)
(assert (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 18
; Joined path conditions
(assert (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))
      V@11@01)
    (<=
      0
      (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@36@01))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2089
;  :arith-add-rows          1028
;  :arith-assert-diseq      41
;  :arith-assert-lower      888
;  :arith-assert-upper      660
;  :arith-bound-prop        73
;  :arith-conflicts         104
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         137
;  :arith-grobner           161
;  :arith-max-min           957
;  :arith-nonlinear-bounds  85
;  :arith-nonlinear-horner  130
;  :arith-offset-eqs        197
;  :arith-pivots            296
;  :conflicts               199
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 225
;  :datatype-occurs-check   165
;  :datatype-splits         197
;  :decisions               687
;  :del-clause              2120
;  :final-checks            196
;  :interface-eqs           33
;  :max-generation          6
;  :max-memory              5.25
;  :memory                  5.25
;  :minimized-lits          1
;  :mk-bool-var             3630
;  :mk-clause               2271
;  :num-allocs              217473
;  :num-checks              89
;  :propagations            1167
;  :quant-instantiations    716
;  :rlimit-count            340626
;  :time                    0.00)
(pop) ; 17
(push) ; 17
; [else-branch: 52 | !(i3@42@01 < V@11@01)]
(assert (not (< i3@42@01 V@11@01)))
(pop) ; 17
(pop) ; 16
; Joined path conditions
(assert (implies
  (< i3@42@01 V@11@01)
  (and
    (< i3@42@01 V@11@01)
    (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
    (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))))
; Joined path conditions
(pop) ; 15
(push) ; 15
; [else-branch: 51 | !(0 <= i3@42@01)]
(assert (not (<= 0 i3@42@01)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (<= 0 i3@42@01)
  (and
    (<= 0 i3@42@01)
    (implies
      (< i3@42@01 V@11@01)
      (and
        (< i3@42@01 V@11@01)
        (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
        (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 50 | !(i2@41@01 < V@11@01)]
(assert (not (< i2@41@01 V@11@01)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (< i2@41@01 V@11@01)
  (and
    (< i2@41@01 V@11@01)
    (implies
      (<= 0 i3@42@01)
      (and
        (<= 0 i3@42@01)
        (implies
          (< i3@42@01 V@11@01)
          (and
            (< i3@42@01 V@11@01)
            (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
            (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 49 | !(0 <= i2@41@01)]
(assert (not (<= 0 i2@41@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (<= 0 i2@41@01)
  (and
    (<= 0 i2@41@01)
    (implies
      (< i2@41@01 V@11@01)
      (and
        (< i2@41@01 V@11@01)
        (implies
          (<= 0 i3@42@01)
          (and
            (<= 0 i3@42@01)
            (implies
              (< i3@42@01 V@11@01)
              (and
                (< i3@42@01 V@11@01)
                (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))))))))))
; Joined path conditions
(push) ; 10
; [then-branch: 53 | Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i2@41@01)) == Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i3@42@01)) && i3@42@01 < V@11@01 && 0 <= i3@42@01 && i2@41@01 < V@11@01 && 0 <= i2@41@01 | live]
; [else-branch: 53 | !(Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i2@41@01)) == Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i3@42@01)) && i3@42@01 < V@11@01 && 0 <= i3@42@01 && i2@41@01 < V@11@01 && 0 <= i2@41@01) | live]
(push) ; 11
; [then-branch: 53 | Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i2@41@01)) == Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i3@42@01)) && i3@42@01 < V@11@01 && 0 <= i3@42@01 && i2@41@01 < V@11@01 && 0 <= i2@41@01]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
          ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
        (< i3@42@01 V@11@01))
      (<= 0 i3@42@01))
    (< i2@41@01 V@11@01))
  (<= 0 i2@41@01)))
; [eval] i2 == i3
(pop) ; 11
(push) ; 11
; [else-branch: 53 | !(Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i2@41@01)) == Lookup(option$array$,sm@38@01,aloc((_, _), opt_get1(_, source@9@01), i3@42@01)) && i3@42@01 < V@11@01 && 0 <= i3@42@01 && i2@41@01 < V@11@01 && 0 <= i2@41@01)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
            ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
          (< i3@42@01 V@11@01))
        (<= 0 i3@42@01))
      (< i2@41@01 V@11@01))
    (<= 0 i2@41@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
            ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
          (< i3@42@01 V@11@01))
        (<= 0 i3@42@01))
      (< i2@41@01 V@11@01))
    (<= 0 i2@41@01))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
      ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
    (< i3@42@01 V@11@01)
    (<= 0 i3@42@01)
    (< i2@41@01 V@11@01)
    (<= 0 i2@41@01))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@42@01 Int)) (!
  (and
    (implies
      (<= 0 i2@41@01)
      (and
        (<= 0 i2@41@01)
        (implies
          (< i2@41@01 V@11@01)
          (and
            (< i2@41@01 V@11@01)
            (implies
              (<= 0 i3@42@01)
              (and
                (<= 0 i3@42@01)
                (implies
                  (< i3@42@01 V@11@01)
                  (and
                    (< i3@42@01 V@11@01)
                    (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                    (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
              (< i3@42@01 V@11@01))
            (<= 0 i3@42@01))
          (< i2@41@01 V@11@01))
        (<= 0 i2@41@01))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
          ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
        (< i3@42@01 V@11@01)
        (<= 0 i3@42@01)
        (< i2@41@01 V@11@01)
        (<= 0 i2@41@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@41@01 Int)) (!
  (forall ((i3@42@01 Int)) (!
    (and
      (implies
        (<= 0 i2@41@01)
        (and
          (<= 0 i2@41@01)
          (implies
            (< i2@41@01 V@11@01)
            (and
              (< i2@41@01 V@11@01)
              (implies
                (<= 0 i3@42@01)
                (and
                  (<= 0 i3@42@01)
                  (implies
                    (< i3@42@01 V@11@01)
                    (and
                      (< i3@42@01 V@11@01)
                      (< i2@41@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                      (< i3@42@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                  ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
                (< i3@42@01 V@11@01))
              (<= 0 i3@42@01))
            (< i2@41@01 V@11@01))
          (<= 0 i2@41@01))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
            ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
          (< i3@42@01 V@11@01)
          (<= 0 i3@42@01)
          (< i2@41@01 V@11@01)
          (<= 0 i2@41@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (and
    (< 0 V@11@01)
    (= exc@12@01 $Ref.null)
    (forall ((i2@41@01 Int)) (!
      (forall ((i3@42@01 Int)) (!
        (and
          (implies
            (<= 0 i2@41@01)
            (and
              (<= 0 i2@41@01)
              (implies
                (< i2@41@01 V@11@01)
                (and
                  (< i2@41@01 V@11@01)
                  (implies
                    (<= 0 i3@42@01)
                    (and
                      (<= 0 i3@42@01)
                      (implies
                        (< i3@42@01 V@11@01)
                        (and
                          (< i3@42@01 V@11@01)
                          (<
                            i2@41@01
                            (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                          (<
                            i3@42@01
                            (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                      ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
                    (< i3@42@01 V@11@01))
                  (<= 0 i3@42@01))
                (< i2@41@01 V@11@01))
              (<= 0 i2@41@01))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
              (< i3@42@01 V@11@01)
              (<= 0 i3@42@01)
              (< i2@41@01 V@11@01)
              (<= 0 i2@41@01))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (forall ((i2@41@01 Int)) (!
    (forall ((i3@42@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
                  ($FVF.lookup_option$array$ (as sm@38@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01)))
                (< i3@42@01 V@11@01))
              (<= 0 i3@42@01))
            (< i2@41@01 V@11@01))
          (<= 0 i2@41@01))
        (= i2@41@01 i3@42@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@42@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@41@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 54 | exc@12@01 == Null | live]
; [else-branch: 54 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 54 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 54 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2198
;  :arith-add-rows          1061
;  :arith-assert-diseq      41
;  :arith-assert-lower      919
;  :arith-assert-upper      685
;  :arith-bound-prop        74
;  :arith-conflicts         106
;  :arith-eq-adapter        188
;  :arith-fixed-eqs         139
;  :arith-grobner           174
;  :arith-max-min           1005
;  :arith-nonlinear-bounds  89
;  :arith-nonlinear-horner  142
;  :arith-offset-eqs        212
;  :arith-pivots            308
;  :conflicts               203
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 241
;  :datatype-occurs-check   176
;  :datatype-splits         209
;  :decisions               728
;  :del-clause              2331
;  :final-checks            205
;  :interface-eqs           35
;  :max-generation          6
;  :max-memory              5.29
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3759
;  :mk-clause               2384
;  :num-allocs              222061
;  :num-checks              90
;  :propagations            1204
;  :quant-instantiations    732
;  :rlimit-count            352894
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2198
;  :arith-add-rows          1061
;  :arith-assert-diseq      41
;  :arith-assert-lower      919
;  :arith-assert-upper      685
;  :arith-bound-prop        74
;  :arith-conflicts         106
;  :arith-eq-adapter        188
;  :arith-fixed-eqs         139
;  :arith-grobner           174
;  :arith-max-min           1005
;  :arith-nonlinear-bounds  89
;  :arith-nonlinear-horner  142
;  :arith-offset-eqs        212
;  :arith-pivots            308
;  :conflicts               203
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 241
;  :datatype-occurs-check   176
;  :datatype-splits         209
;  :decisions               728
;  :del-clause              2331
;  :final-checks            205
;  :interface-eqs           35
;  :max-generation          6
;  :max-memory              5.29
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3759
;  :mk-clause               2384
;  :num-allocs              222079
;  :num-checks              91
;  :propagations            1204
;  :quant-instantiations    732
;  :rlimit-count            352911)
; [then-branch: 55 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 55 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 7
; [then-branch: 55 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (not (= target@8@01 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 56 | exc@12@01 == Null | live]
; [else-branch: 56 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 56 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 56 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(push) ; 7
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2303
;  :arith-add-rows          1095
;  :arith-assert-diseq      41
;  :arith-assert-lower      956
;  :arith-assert-upper      716
;  :arith-bound-prop        75
;  :arith-conflicts         108
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         141
;  :arith-grobner           190
;  :arith-max-min           1068
;  :arith-nonlinear-bounds  93
;  :arith-nonlinear-horner  155
;  :arith-offset-eqs        221
;  :arith-pivots            313
;  :conflicts               207
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 257
;  :datatype-occurs-check   187
;  :datatype-splits         221
;  :decisions               769
;  :del-clause              2420
;  :final-checks            214
;  :interface-eqs           37
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3864
;  :mk-clause               2473
;  :num-allocs              224491
;  :num-checks              92
;  :propagations            1241
;  :quant-instantiations    745
;  :rlimit-count            361509
;  :time                    0.00)
(push) ; 7
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2303
;  :arith-add-rows          1095
;  :arith-assert-diseq      41
;  :arith-assert-lower      956
;  :arith-assert-upper      716
;  :arith-bound-prop        75
;  :arith-conflicts         108
;  :arith-eq-adapter        191
;  :arith-fixed-eqs         141
;  :arith-grobner           190
;  :arith-max-min           1068
;  :arith-nonlinear-bounds  93
;  :arith-nonlinear-horner  155
;  :arith-offset-eqs        221
;  :arith-pivots            313
;  :conflicts               207
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 257
;  :datatype-occurs-check   187
;  :datatype-splits         221
;  :decisions               769
;  :del-clause              2420
;  :final-checks            214
;  :interface-eqs           37
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3864
;  :mk-clause               2473
;  :num-allocs              224509
;  :num-checks              93
;  :propagations            1241
;  :quant-instantiations    745
;  :rlimit-count            361526)
; [then-branch: 57 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 57 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 7
; [then-branch: 57 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
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
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit target@8@01)) V@11@01)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 58 | exc@12@01 == Null | live]
; [else-branch: 58 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 58 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 58 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2410
;  :arith-add-rows          1129
;  :arith-assert-diseq      41
;  :arith-assert-lower      993
;  :arith-assert-upper      747
;  :arith-bound-prop        76
;  :arith-conflicts         110
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         143
;  :arith-grobner           206
;  :arith-max-min           1131
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  168
;  :arith-offset-eqs        230
;  :arith-pivots            318
;  :conflicts               211
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   198
;  :datatype-splits         234
;  :decisions               811
;  :del-clause              2509
;  :final-checks            223
;  :interface-eqs           39
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3969
;  :mk-clause               2562
;  :num-allocs              226918
;  :num-checks              94
;  :propagations            1278
;  :quant-instantiations    758
;  :rlimit-count            370116
;  :time                    0.00)
(push) ; 6
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2410
;  :arith-add-rows          1129
;  :arith-assert-diseq      41
;  :arith-assert-lower      993
;  :arith-assert-upper      747
;  :arith-bound-prop        76
;  :arith-conflicts         110
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         143
;  :arith-grobner           206
;  :arith-max-min           1131
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  168
;  :arith-offset-eqs        230
;  :arith-pivots            318
;  :conflicts               211
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   198
;  :datatype-splits         234
;  :decisions               811
;  :del-clause              2509
;  :final-checks            223
;  :interface-eqs           39
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3969
;  :mk-clause               2562
;  :num-allocs              226936
;  :num-checks              95
;  :propagations            1278
;  :quant-instantiations    758
;  :rlimit-count            370133)
; [then-branch: 59 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 59 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 6
; [then-branch: 59 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
(declare-const i2@43@01 Int)
(push) ; 7
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 8
; [then-branch: 60 | 0 <= i2@43@01 | live]
; [else-branch: 60 | !(0 <= i2@43@01) | live]
(push) ; 9
; [then-branch: 60 | 0 <= i2@43@01]
(assert (<= 0 i2@43@01))
; [eval] i2 < V
(pop) ; 9
(push) ; 9
; [else-branch: 60 | !(0 <= i2@43@01)]
(assert (not (<= 0 i2@43@01)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< i2@43@01 V@11@01) (<= 0 i2@43@01)))
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
(assert (not (< i2@43@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2410
;  :arith-add-rows          1129
;  :arith-assert-diseq      41
;  :arith-assert-lower      995
;  :arith-assert-upper      747
;  :arith-bound-prop        76
;  :arith-conflicts         110
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         143
;  :arith-grobner           206
;  :arith-max-min           1131
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  168
;  :arith-offset-eqs        230
;  :arith-pivots            319
;  :conflicts               211
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   198
;  :datatype-splits         234
;  :decisions               811
;  :del-clause              2509
;  :final-checks            223
;  :interface-eqs           39
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3971
;  :mk-clause               2562
;  :num-allocs              227041
;  :num-checks              96
;  :propagations            1278
;  :quant-instantiations    758
;  :rlimit-count            370331)
(assert (< i2@43@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 8
; Joined path conditions
(assert (< i2@43@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 8
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 9
(assert (not (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2410
;  :arith-add-rows          1129
;  :arith-assert-diseq      41
;  :arith-assert-lower      995
;  :arith-assert-upper      747
;  :arith-bound-prop        76
;  :arith-conflicts         110
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         143
;  :arith-grobner           206
;  :arith-max-min           1131
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  168
;  :arith-offset-eqs        230
;  :arith-pivots            319
;  :conflicts               212
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   198
;  :datatype-splits         234
;  :decisions               811
;  :del-clause              2509
;  :final-checks            223
;  :interface-eqs           39
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.26
;  :minimized-lits          1
;  :mk-bool-var             3971
;  :mk-clause               2562
;  :num-allocs              227185
;  :num-checks              97
;  :propagations            1278
;  :quant-instantiations    758
;  :rlimit-count            370443)
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(pop) ; 8
; Joined path conditions
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(declare-const $k@44@01 $Perm)
(assert ($Perm.isReadVar $k@44@01 $Perm.Write))
(pop) ; 7
(declare-fun inv@45@01 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@44@01 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@43@01 Int)) (!
  (and
    (< i2@43@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@43@01))
  :qid |option$array$-aux|)))
(push) ; 7
(assert (not (forall ((i2@43@01 Int)) (!
  (implies
    (and (< i2@43@01 V@11@01) (<= 0 i2@43@01))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01))))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2470
;  :arith-add-rows          1161
;  :arith-assert-diseq      43
;  :arith-assert-lower      1025
;  :arith-assert-upper      768
;  :arith-bound-prop        77
;  :arith-conflicts         113
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         145
;  :arith-grobner           206
;  :arith-max-min           1168
;  :arith-nonlinear-bounds  103
;  :arith-nonlinear-horner  168
;  :arith-offset-eqs        235
;  :arith-pivots            324
;  :conflicts               216
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   201
;  :datatype-splits         241
;  :decisions               845
;  :del-clause              2596
;  :final-checks            226
;  :interface-eqs           39
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.25
;  :minimized-lits          1
;  :mk-bool-var             4067
;  :mk-clause               2651
;  :num-allocs              228013
;  :num-checks              98
;  :propagations            1315
;  :quant-instantiations    772
;  :rlimit-count            373279
;  :time                    0.00)
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((i21@43@01 Int) (i22@43@01 Int)) (!
  (implies
    (and
      (and
        (and (< i21@43@01 V@11@01) (<= 0 i21@43@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@44@01)))
      (and
        (and (< i22@43@01 V@11@01) (<= 0 i22@43@01))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@44@01)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i21@43@01)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i22@43@01)))
    (= i21@43@01 i22@43@01))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2477
;  :arith-add-rows          1163
;  :arith-assert-diseq      44
;  :arith-assert-lower      1030
;  :arith-assert-upper      768
;  :arith-bound-prop        77
;  :arith-conflicts         113
;  :arith-eq-adapter        198
;  :arith-fixed-eqs         145
;  :arith-grobner           206
;  :arith-max-min           1168
;  :arith-nonlinear-bounds  103
;  :arith-nonlinear-horner  168
;  :arith-offset-eqs        235
;  :arith-pivots            324
;  :conflicts               217
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   201
;  :datatype-splits         241
;  :decisions               845
;  :del-clause              2602
;  :final-checks            226
;  :interface-eqs           39
;  :max-generation          6
;  :max-memory              5.30
;  :memory                  5.25
;  :minimized-lits          1
;  :mk-bool-var             4088
;  :mk-clause               2657
;  :num-allocs              228399
;  :num-checks              99
;  :propagations            1315
;  :quant-instantiations    783
;  :rlimit-count            374053)
; Definitional axioms for inverse functions
(assert (forall ((i2@43@01 Int)) (!
  (implies
    (and
      (and (< i2@43@01 V@11@01) (<= 0 i2@43@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01)))
    (=
      (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@43@01))
      i2@43@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@43@01))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@45@01 r) V@11@01) (<= 0 (inv@45@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) (inv@45@01 r))
      r))
  :pattern ((inv@45@01 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i2@43@01 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@44@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@43@01))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i2@43@01 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write)) $k@44@01)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@43@01))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i2@43@01 Int)) (!
  (implies
    (and
      (and (< i2@43@01 V@11@01) (<= 0 i2@43@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@43@01)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@43@01))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@46@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@45@01 r) V@11@01) (<= 0 (inv@45@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@37@01 r) V@11@01) (<= 0 (inv@37@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r))
  :qid |qp.fvfValDef13|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef14|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@45@01 r) V@11@01) (<= 0 (inv@45@01 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) r) r))
  :pattern ((inv@45@01 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 61 | exc@12@01 == Null | live]
; [else-branch: 61 | exc@12@01 != Null | live]
(push) ; 8
; [then-branch: 61 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 61 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2751
;  :arith-add-rows          1259
;  :arith-assert-diseq      44
;  :arith-assert-lower      1085
;  :arith-assert-upper      817
;  :arith-bound-prop        81
;  :arith-conflicts         118
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         153
;  :arith-gcd-tests         1
;  :arith-grobner           220
;  :arith-ineq-splits       1
;  :arith-max-min           1246
;  :arith-nonlinear-bounds  112
;  :arith-nonlinear-horner  181
;  :arith-offset-eqs        261
;  :arith-patches           1
;  :arith-pivots            343
;  :conflicts               227
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 319
;  :datatype-occurs-check   221
;  :datatype-splits         267
;  :decisions               955
;  :del-clause              2890
;  :final-checks            241
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          1
;  :mk-bool-var             4443
;  :mk-clause               2947
;  :num-allocs              234541
;  :num-checks              100
;  :propagations            1432
;  :quant-instantiations    838
;  :rlimit-count            392733
;  :time                    0.01)
(push) ; 8
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2751
;  :arith-add-rows          1259
;  :arith-assert-diseq      44
;  :arith-assert-lower      1085
;  :arith-assert-upper      817
;  :arith-bound-prop        81
;  :arith-conflicts         118
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         153
;  :arith-gcd-tests         1
;  :arith-grobner           220
;  :arith-ineq-splits       1
;  :arith-max-min           1246
;  :arith-nonlinear-bounds  112
;  :arith-nonlinear-horner  181
;  :arith-offset-eqs        261
;  :arith-patches           1
;  :arith-pivots            343
;  :conflicts               227
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 319
;  :datatype-occurs-check   221
;  :datatype-splits         267
;  :decisions               955
;  :del-clause              2890
;  :final-checks            241
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          1
;  :mk-bool-var             4443
;  :mk-clause               2947
;  :num-allocs              234559
;  :num-checks              101
;  :propagations            1432
;  :quant-instantiations    838
;  :rlimit-count            392750)
; [then-branch: 62 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 62 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 8
; [then-branch: 62 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
(declare-const i2@47@01 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 63 | 0 <= i2@47@01 | live]
; [else-branch: 63 | !(0 <= i2@47@01) | live]
(push) ; 11
; [then-branch: 63 | 0 <= i2@47@01]
(assert (<= 0 i2@47@01))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 63 | !(0 <= i2@47@01)]
(assert (not (<= 0 i2@47@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 64 | i2@47@01 < V@11@01 && 0 <= i2@47@01 | live]
; [else-branch: 64 | !(i2@47@01 < V@11@01 && 0 <= i2@47@01) | live]
(push) ; 11
; [then-branch: 64 | i2@47@01 < V@11@01 && 0 <= i2@47@01]
(assert (and (< i2@47@01 V@11@01) (<= 0 i2@47@01)))
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
(assert (not (< i2@47@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2751
;  :arith-add-rows          1259
;  :arith-assert-diseq      44
;  :arith-assert-lower      1087
;  :arith-assert-upper      817
;  :arith-bound-prop        81
;  :arith-conflicts         118
;  :arith-eq-adapter        204
;  :arith-fixed-eqs         153
;  :arith-gcd-tests         1
;  :arith-grobner           220
;  :arith-ineq-splits       1
;  :arith-max-min           1246
;  :arith-nonlinear-bounds  112
;  :arith-nonlinear-horner  181
;  :arith-offset-eqs        261
;  :arith-patches           1
;  :arith-pivots            343
;  :conflicts               227
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 319
;  :datatype-occurs-check   221
;  :datatype-splits         267
;  :decisions               955
;  :del-clause              2890
;  :final-checks            241
;  :interface-eqs           43
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.31
;  :minimized-lits          1
;  :mk-bool-var             4445
;  :mk-clause               2947
;  :num-allocs              234658
;  :num-checks              102
;  :propagations            1432
;  :quant-instantiations    838
;  :rlimit-count            392954)
(assert (< i2@47@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 12
; Joined path conditions
(assert (< i2@47@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))
          V@11@01)
        (<=
          0
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@44@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))
          V@11@01)
        (<=
          0
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@36@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3020
;  :arith-add-rows          1392
;  :arith-assert-diseq      49
;  :arith-assert-lower      1136
;  :arith-assert-upper      858
;  :arith-bound-prop        94
;  :arith-conflicts         123
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         165
;  :arith-gcd-tests         1
;  :arith-grobner           220
;  :arith-ineq-splits       1
;  :arith-max-min           1282
;  :arith-nonlinear-bounds  118
;  :arith-nonlinear-horner  181
;  :arith-offset-eqs        272
;  :arith-patches           1
;  :arith-pivots            369
;  :conflicts               247
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 347
;  :datatype-occurs-check   229
;  :datatype-splits         287
;  :decisions               1044
;  :del-clause              3139
;  :final-checks            248
;  :interface-eqs           45
;  :max-generation          6
;  :max-memory              5.35
;  :memory                  5.33
;  :minimized-lits          2
;  :mk-bool-var             5024
;  :mk-clause               3265
;  :num-allocs              236290
;  :num-checks              103
;  :propagations            1577
;  :quant-instantiations    916
;  :rlimit-count            400219
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 11
(push) ; 11
; [else-branch: 64 | !(i2@47@01 < V@11@01 && 0 <= i2@47@01)]
(assert (not (and (< i2@47@01 V@11@01) (<= 0 i2@47@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@47@01 V@11@01) (<= 0 i2@47@01))
  (and
    (< i2@47@01 V@11@01)
    (<= 0 i2@47@01)
    (< i2@47@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01)))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@47@01 Int)) (!
  (implies
    (and (< i2@47@01 V@11@01) (<= 0 i2@47@01))
    (and
      (< i2@47@01 V@11@01)
      (<= 0 i2@47@01)
      (< i2@47@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (and
    (< 0 V@11@01)
    (= exc@12@01 $Ref.null)
    (forall ((i2@47@01 Int)) (!
      (implies
        (and (< i2@47@01 V@11@01) (<= 0 i2@47@01))
        (and
          (< i2@47@01 V@11@01)
          (<= 0 i2@47@01)
          (< i2@47@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (forall ((i2@47@01 Int)) (!
    (implies
      (and (< i2@47@01 V@11@01) (<= 0 i2@47@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@47@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 65 | exc@12@01 == Null | live]
; [else-branch: 65 | exc@12@01 != Null | live]
(push) ; 8
; [then-branch: 65 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 65 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3422
;  :arith-add-rows          1479
;  :arith-assert-diseq      49
;  :arith-assert-lower      1200
;  :arith-assert-upper      918
;  :arith-bound-prop        98
;  :arith-conflicts         128
;  :arith-eq-adapter        231
;  :arith-fixed-eqs         175
;  :arith-gcd-tests         2
;  :arith-grobner           237
;  :arith-ineq-splits       2
;  :arith-max-min           1379
;  :arith-nonlinear-bounds  127
;  :arith-nonlinear-horner  195
;  :arith-offset-eqs        290
;  :arith-patches           2
;  :arith-pivots            391
;  :conflicts               259
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 407
;  :datatype-occurs-check   268
;  :datatype-splits         336
;  :decisions               1169
;  :del-clause              3474
;  :final-checks            270
;  :interface-eqs           53
;  :max-generation          6
;  :max-memory              5.40
;  :memory                  5.35
;  :minimized-lits          2
;  :mk-bool-var             5402
;  :mk-clause               3563
;  :num-allocs              240299
;  :num-checks              104
;  :propagations            1698
;  :quant-instantiations    967
;  :rlimit-count            415637
;  :time                    0.01)
(push) ; 8
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3422
;  :arith-add-rows          1479
;  :arith-assert-diseq      49
;  :arith-assert-lower      1200
;  :arith-assert-upper      918
;  :arith-bound-prop        98
;  :arith-conflicts         128
;  :arith-eq-adapter        231
;  :arith-fixed-eqs         175
;  :arith-gcd-tests         2
;  :arith-grobner           237
;  :arith-ineq-splits       2
;  :arith-max-min           1379
;  :arith-nonlinear-bounds  127
;  :arith-nonlinear-horner  195
;  :arith-offset-eqs        290
;  :arith-patches           2
;  :arith-pivots            391
;  :conflicts               259
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 407
;  :datatype-occurs-check   268
;  :datatype-splits         336
;  :decisions               1169
;  :del-clause              3474
;  :final-checks            270
;  :interface-eqs           53
;  :max-generation          6
;  :max-memory              5.40
;  :memory                  5.35
;  :minimized-lits          2
;  :mk-bool-var             5402
;  :mk-clause               3563
;  :num-allocs              240317
;  :num-checks              105
;  :propagations            1698
;  :quant-instantiations    967
;  :rlimit-count            415654)
; [then-branch: 66 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 66 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 8
; [then-branch: 66 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
(declare-const i2@48@01 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 67 | 0 <= i2@48@01 | live]
; [else-branch: 67 | !(0 <= i2@48@01) | live]
(push) ; 11
; [then-branch: 67 | 0 <= i2@48@01]
(assert (<= 0 i2@48@01))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 67 | !(0 <= i2@48@01)]
(assert (not (<= 0 i2@48@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 68 | i2@48@01 < V@11@01 && 0 <= i2@48@01 | live]
; [else-branch: 68 | !(i2@48@01 < V@11@01 && 0 <= i2@48@01) | live]
(push) ; 11
; [then-branch: 68 | i2@48@01 < V@11@01 && 0 <= i2@48@01]
(assert (and (< i2@48@01 V@11@01) (<= 0 i2@48@01)))
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
(assert (not (< i2@48@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3422
;  :arith-add-rows          1479
;  :arith-assert-diseq      49
;  :arith-assert-lower      1202
;  :arith-assert-upper      918
;  :arith-bound-prop        98
;  :arith-conflicts         128
;  :arith-eq-adapter        231
;  :arith-fixed-eqs         175
;  :arith-gcd-tests         2
;  :arith-grobner           237
;  :arith-ineq-splits       2
;  :arith-max-min           1379
;  :arith-nonlinear-bounds  127
;  :arith-nonlinear-horner  195
;  :arith-offset-eqs        290
;  :arith-patches           2
;  :arith-pivots            392
;  :conflicts               259
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 407
;  :datatype-occurs-check   268
;  :datatype-splits         336
;  :decisions               1169
;  :del-clause              3474
;  :final-checks            270
;  :interface-eqs           53
;  :max-generation          6
;  :max-memory              5.40
;  :memory                  5.35
;  :minimized-lits          2
;  :mk-bool-var             5404
;  :mk-clause               3563
;  :num-allocs              240416
;  :num-checks              106
;  :propagations            1698
;  :quant-instantiations    967
;  :rlimit-count            415862)
(assert (< i2@48@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 12
; Joined path conditions
(assert (< i2@48@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
          V@11@01)
        (<=
          0
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@44@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
          V@11@01)
        (<=
          0
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@36@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3712
;  :arith-add-rows          1705
;  :arith-assert-diseq      56
;  :arith-assert-lower      1253
;  :arith-assert-upper      968
;  :arith-bound-prop        109
;  :arith-conflicts         135
;  :arith-eq-adapter        249
;  :arith-fixed-eqs         187
;  :arith-gcd-tests         2
;  :arith-grobner           237
;  :arith-ineq-splits       2
;  :arith-max-min           1415
;  :arith-nonlinear-bounds  133
;  :arith-nonlinear-horner  195
;  :arith-offset-eqs        305
;  :arith-patches           2
;  :arith-pivots            423
;  :conflicts               282
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 440
;  :datatype-occurs-check   278
;  :datatype-splits         360
;  :decisions               1284
;  :del-clause              3869
;  :final-checks            279
;  :interface-eqs           56
;  :max-generation          6
;  :max-memory              5.40
;  :memory                  5.38
;  :minimized-lits          3
;  :mk-bool-var             6173
;  :mk-clause               4003
;  :num-allocs              242161
;  :num-checks              107
;  :propagations            1875
;  :quant-instantiations    1062
;  :rlimit-count            425755
;  :time                    0.00)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 13
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3712
;  :arith-add-rows          1705
;  :arith-assert-diseq      56
;  :arith-assert-lower      1253
;  :arith-assert-upper      968
;  :arith-bound-prop        109
;  :arith-conflicts         135
;  :arith-eq-adapter        249
;  :arith-fixed-eqs         187
;  :arith-gcd-tests         2
;  :arith-grobner           237
;  :arith-ineq-splits       2
;  :arith-max-min           1415
;  :arith-nonlinear-bounds  133
;  :arith-nonlinear-horner  195
;  :arith-offset-eqs        305
;  :arith-patches           2
;  :arith-pivots            423
;  :conflicts               283
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 440
;  :datatype-occurs-check   278
;  :datatype-splits         360
;  :decisions               1284
;  :del-clause              3869
;  :final-checks            279
;  :interface-eqs           56
;  :max-generation          6
;  :max-memory              5.40
;  :memory                  5.38
;  :minimized-lits          3
;  :mk-bool-var             6173
;  :mk-clause               4003
;  :num-allocs              242251
;  :num-checks              108
;  :propagations            1875
;  :quant-instantiations    1062
;  :rlimit-count            425850)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
    (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
    (as None<option<array>>  option<array>))))
(pop) ; 11
(push) ; 11
; [else-branch: 68 | !(i2@48@01 < V@11@01 && 0 <= i2@48@01)]
(assert (not (and (< i2@48@01 V@11@01) (<= 0 i2@48@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@48@01 V@11@01) (<= 0 i2@48@01))
  (and
    (< i2@48@01 V@11@01)
    (<= 0 i2@48@01)
    (< i2@48@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@48@01 Int)) (!
  (implies
    (and (< i2@48@01 V@11@01) (<= 0 i2@48@01))
    (and
      (< i2@48@01 V@11@01)
      (<= 0 i2@48@01)
      (< i2@48@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (and
    (< 0 V@11@01)
    (= exc@12@01 $Ref.null)
    (forall ((i2@48@01 Int)) (!
      (implies
        (and (< i2@48@01 V@11@01) (<= 0 i2@48@01))
        (and
          (< i2@48@01 V@11@01)
          (<= 0 i2@48@01)
          (< i2@48@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (forall ((i2@48@01 Int)) (!
    (implies
      (and (< i2@48@01 V@11@01) (<= 0 i2@48@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@48@01)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 69 | exc@12@01 == Null | live]
; [else-branch: 69 | exc@12@01 != Null | live]
(push) ; 8
; [then-branch: 69 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 69 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4104
;  :arith-add-rows          1761
;  :arith-assert-diseq      56
;  :arith-assert-lower      1315
;  :arith-assert-upper      1026
;  :arith-bound-prop        113
;  :arith-conflicts         139
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         194
;  :arith-gcd-tests         2
;  :arith-grobner           254
;  :arith-ineq-splits       2
;  :arith-max-min           1511
;  :arith-nonlinear-bounds  142
;  :arith-nonlinear-horner  209
;  :arith-offset-eqs        324
;  :arith-patches           2
;  :arith-pivots            440
;  :conflicts               294
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 498
;  :datatype-occurs-check   313
;  :datatype-splits         407
;  :decisions               1405
;  :del-clause              4174
;  :final-checks            298
;  :interface-eqs           63
;  :max-generation          6
;  :max-memory              5.44
;  :memory                  5.40
;  :minimized-lits          3
;  :mk-bool-var             6499
;  :mk-clause               4263
;  :num-allocs              246259
;  :num-checks              109
;  :propagations            1990
;  :quant-instantiations    1100
;  :rlimit-count            440426
;  :time                    0.01)
(push) ; 8
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4104
;  :arith-add-rows          1761
;  :arith-assert-diseq      56
;  :arith-assert-lower      1315
;  :arith-assert-upper      1026
;  :arith-bound-prop        113
;  :arith-conflicts         139
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         194
;  :arith-gcd-tests         2
;  :arith-grobner           254
;  :arith-ineq-splits       2
;  :arith-max-min           1511
;  :arith-nonlinear-bounds  142
;  :arith-nonlinear-horner  209
;  :arith-offset-eqs        324
;  :arith-patches           2
;  :arith-pivots            440
;  :conflicts               294
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 498
;  :datatype-occurs-check   313
;  :datatype-splits         407
;  :decisions               1405
;  :del-clause              4174
;  :final-checks            298
;  :interface-eqs           63
;  :max-generation          6
;  :max-memory              5.44
;  :memory                  5.40
;  :minimized-lits          3
;  :mk-bool-var             6499
;  :mk-clause               4263
;  :num-allocs              246277
;  :num-checks              110
;  :propagations            1990
;  :quant-instantiations    1100
;  :rlimit-count            440443)
; [then-branch: 70 | 0 < V@11@01 && exc@12@01 == Null | live]
; [else-branch: 70 | !(0 < V@11@01 && exc@12@01 == Null) | dead]
(push) ; 8
; [then-branch: 70 | 0 < V@11@01 && exc@12@01 == Null]
(assert (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
(declare-const i2@49@01 Int)
(push) ; 9
; [eval] (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3)
(declare-const i3@50@01 Int)
(push) ; 10
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] 0 <= i2
(push) ; 11
; [then-branch: 71 | 0 <= i2@49@01 | live]
; [else-branch: 71 | !(0 <= i2@49@01) | live]
(push) ; 12
; [then-branch: 71 | 0 <= i2@49@01]
(assert (<= 0 i2@49@01))
; [eval] i2 < V
(push) ; 13
; [then-branch: 72 | i2@49@01 < V@11@01 | live]
; [else-branch: 72 | !(i2@49@01 < V@11@01) | live]
(push) ; 14
; [then-branch: 72 | i2@49@01 < V@11@01]
(assert (< i2@49@01 V@11@01))
; [eval] 0 <= i3
(push) ; 15
; [then-branch: 73 | 0 <= i3@50@01 | live]
; [else-branch: 73 | !(0 <= i3@50@01) | live]
(push) ; 16
; [then-branch: 73 | 0 <= i3@50@01]
(assert (<= 0 i3@50@01))
; [eval] i3 < V
(push) ; 17
; [then-branch: 74 | i3@50@01 < V@11@01 | live]
; [else-branch: 74 | !(i3@50@01 < V@11@01) | live]
(push) ; 18
; [then-branch: 74 | i3@50@01 < V@11@01]
(assert (< i3@50@01 V@11@01))
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
(assert (not (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4104
;  :arith-add-rows          1761
;  :arith-assert-diseq      56
;  :arith-assert-lower      1319
;  :arith-assert-upper      1026
;  :arith-bound-prop        113
;  :arith-conflicts         139
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         194
;  :arith-gcd-tests         2
;  :arith-grobner           254
;  :arith-ineq-splits       2
;  :arith-max-min           1511
;  :arith-nonlinear-bounds  142
;  :arith-nonlinear-horner  209
;  :arith-offset-eqs        324
;  :arith-patches           2
;  :arith-pivots            441
;  :conflicts               294
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 498
;  :datatype-occurs-check   313
;  :datatype-splits         407
;  :decisions               1405
;  :del-clause              4174
;  :final-checks            298
;  :interface-eqs           63
;  :max-generation          6
;  :max-memory              5.44
;  :memory                  5.40
;  :minimized-lits          3
;  :mk-bool-var             6503
;  :mk-clause               4263
;  :num-allocs              246553
;  :num-checks              111
;  :propagations            1990
;  :quant-instantiations    1100
;  :rlimit-count            440796)
(assert (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 19
; Joined path conditions
(assert (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
          V@11@01)
        (<=
          0
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@44@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
          V@11@01)
        (<=
          0
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@36@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4434
;  :arith-add-rows          1988
;  :arith-assert-diseq      68
;  :arith-assert-lower      1378
;  :arith-assert-upper      1078
;  :arith-bound-prop        126
;  :arith-conflicts         146
;  :arith-eq-adapter        279
;  :arith-fixed-eqs         207
;  :arith-gcd-tests         2
;  :arith-grobner           254
;  :arith-ineq-splits       2
;  :arith-max-min           1547
;  :arith-nonlinear-bounds  148
;  :arith-nonlinear-horner  209
;  :arith-offset-eqs        339
;  :arith-patches           2
;  :arith-pivots            471
;  :conflicts               318
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 531
;  :datatype-occurs-check   323
;  :datatype-splits         431
;  :decisions               1524
;  :del-clause              4534
;  :final-checks            307
;  :interface-eqs           66
;  :max-generation          6
;  :max-memory              5.44
;  :memory                  5.42
;  :minimized-lits          3
;  :mk-bool-var             7263
;  :mk-clause               4668
;  :num-allocs              248403
;  :num-checks              112
;  :propagations            2191
;  :quant-instantiations    1194
;  :rlimit-count            450746
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
(assert (not (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4434
;  :arith-add-rows          1988
;  :arith-assert-diseq      68
;  :arith-assert-lower      1378
;  :arith-assert-upper      1078
;  :arith-bound-prop        126
;  :arith-conflicts         146
;  :arith-eq-adapter        279
;  :arith-fixed-eqs         207
;  :arith-gcd-tests         2
;  :arith-grobner           254
;  :arith-ineq-splits       2
;  :arith-max-min           1547
;  :arith-nonlinear-bounds  148
;  :arith-nonlinear-horner  209
;  :arith-offset-eqs        339
;  :arith-patches           2
;  :arith-pivots            471
;  :conflicts               318
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 531
;  :datatype-occurs-check   323
;  :datatype-splits         431
;  :decisions               1524
;  :del-clause              4534
;  :final-checks            307
;  :interface-eqs           66
;  :max-generation          6
;  :max-memory              5.44
;  :memory                  5.42
;  :minimized-lits          3
;  :mk-bool-var             7263
;  :mk-clause               4668
;  :num-allocs              248430
;  :num-checks              113
;  :propagations            2191
;  :quant-instantiations    1194
;  :rlimit-count            450776)
(assert (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 19
; Joined path conditions
(assert (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))
          V@11@01)
        (<=
          0
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@44@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))
          V@11@01)
        (<=
          0
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@36@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4806
;  :arith-add-rows          2367
;  :arith-assert-diseq      97
;  :arith-assert-lower      1456
;  :arith-assert-upper      1140
;  :arith-bound-prop        141
;  :arith-conflicts         155
;  :arith-eq-adapter        299
;  :arith-fixed-eqs         221
;  :arith-gcd-tests         2
;  :arith-grobner           254
;  :arith-ineq-splits       2
;  :arith-max-min           1583
;  :arith-nonlinear-bounds  154
;  :arith-nonlinear-horner  209
;  :arith-offset-eqs        367
;  :arith-patches           2
;  :arith-pivots            507
;  :conflicts               343
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   330
;  :datatype-splits         448
;  :decisions               1691
;  :del-clause              5003
;  :final-checks            314
;  :interface-eqs           68
;  :max-generation          6
;  :max-memory              5.57
;  :memory                  5.56
;  :minimized-lits          4
;  :mk-bool-var             8158
;  :mk-clause               5202
;  :num-allocs              250536
;  :num-checks              114
;  :propagations            2463
;  :quant-instantiations    1329
;  :rlimit-count            465196
;  :time                    0.01)
(pop) ; 18
(push) ; 18
; [else-branch: 74 | !(i3@50@01 < V@11@01)]
(assert (not (< i3@50@01 V@11@01)))
(pop) ; 18
(pop) ; 17
; Joined path conditions
(assert (implies
  (< i3@50@01 V@11@01)
  (and
    (< i3@50@01 V@11@01)
    (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
    (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))))
; Joined path conditions
(pop) ; 16
(push) ; 16
; [else-branch: 73 | !(0 <= i3@50@01)]
(assert (not (<= 0 i3@50@01)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (implies
  (<= 0 i3@50@01)
  (and
    (<= 0 i3@50@01)
    (implies
      (< i3@50@01 V@11@01)
      (and
        (< i3@50@01 V@11@01)
        (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
        (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))))))
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 72 | !(i2@49@01 < V@11@01)]
(assert (not (< i2@49@01 V@11@01)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i2@49@01 V@11@01)
  (and
    (< i2@49@01 V@11@01)
    (implies
      (<= 0 i3@50@01)
      (and
        (<= 0 i3@50@01)
        (implies
          (< i3@50@01 V@11@01)
          (and
            (< i3@50@01 V@11@01)
            (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
            (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))))))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 71 | !(0 <= i2@49@01)]
(assert (not (<= 0 i2@49@01)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i2@49@01)
  (and
    (<= 0 i2@49@01)
    (implies
      (< i2@49@01 V@11@01)
      (and
        (< i2@49@01 V@11@01)
        (implies
          (<= 0 i3@50@01)
          (and
            (<= 0 i3@50@01)
            (implies
              (< i3@50@01 V@11@01)
              (and
                (< i3@50@01 V@11@01)
                (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))))))))))
; Joined path conditions
(push) ; 11
; [then-branch: 75 | Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i2@49@01)) == Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i3@50@01)) && i3@50@01 < V@11@01 && 0 <= i3@50@01 && i2@49@01 < V@11@01 && 0 <= i2@49@01 | live]
; [else-branch: 75 | !(Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i2@49@01)) == Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i3@50@01)) && i3@50@01 < V@11@01 && 0 <= i3@50@01 && i2@49@01 < V@11@01 && 0 <= i2@49@01) | live]
(push) ; 12
; [then-branch: 75 | Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i2@49@01)) == Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i3@50@01)) && i3@50@01 < V@11@01 && 0 <= i3@50@01 && i2@49@01 < V@11@01 && 0 <= i2@49@01]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
          ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
        (< i3@50@01 V@11@01))
      (<= 0 i3@50@01))
    (< i2@49@01 V@11@01))
  (<= 0 i2@49@01)))
; [eval] i2 == i3
(pop) ; 12
(push) ; 12
; [else-branch: 75 | !(Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i2@49@01)) == Lookup(option$array$,sm@46@01,aloc((_, _), opt_get1(_, target@8@01), i3@50@01)) && i3@50@01 < V@11@01 && 0 <= i3@50@01 && i2@49@01 < V@11@01 && 0 <= i2@49@01)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
            ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
          (< i3@50@01 V@11@01))
        (<= 0 i3@50@01))
      (< i2@49@01 V@11@01))
    (<= 0 i2@49@01))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
            ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
          (< i3@50@01 V@11@01))
        (<= 0 i3@50@01))
      (< i2@49@01 V@11@01))
    (<= 0 i2@49@01))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
      ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
    (< i3@50@01 V@11@01)
    (<= 0 i3@50@01)
    (< i2@49@01 V@11@01)
    (<= 0 i2@49@01))))
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@50@01 Int)) (!
  (and
    (implies
      (<= 0 i2@49@01)
      (and
        (<= 0 i2@49@01)
        (implies
          (< i2@49@01 V@11@01)
          (and
            (< i2@49@01 V@11@01)
            (implies
              (<= 0 i3@50@01)
              (and
                (<= 0 i3@50@01)
                (implies
                  (< i3@50@01 V@11@01)
                  (and
                    (< i3@50@01 V@11@01)
                    (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                    (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
              (< i3@50@01 V@11@01))
            (<= 0 i3@50@01))
          (< i2@49@01 V@11@01))
        (<= 0 i2@49@01))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
          ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
        (< i3@50@01 V@11@01)
        (<= 0 i3@50@01)
        (< i2@49@01 V@11@01)
        (<= 0 i2@49@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@49@01 Int)) (!
  (forall ((i3@50@01 Int)) (!
    (and
      (implies
        (<= 0 i2@49@01)
        (and
          (<= 0 i2@49@01)
          (implies
            (< i2@49@01 V@11@01)
            (and
              (< i2@49@01 V@11@01)
              (implies
                (<= 0 i3@50@01)
                (and
                  (<= 0 i3@50@01)
                  (implies
                    (< i3@50@01 V@11@01)
                    (and
                      (< i3@50@01 V@11@01)
                      (< i2@49@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                      (< i3@50@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                  ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
                (< i3@50@01 V@11@01))
              (<= 0 i3@50@01))
            (< i2@49@01 V@11@01))
          (<= 0 i2@49@01))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
            ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
          (< i3@50@01 V@11@01)
          (<= 0 i3@50@01)
          (< i2@49@01 V@11@01)
          (<= 0 i2@49@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (and
    (< 0 V@11@01)
    (= exc@12@01 $Ref.null)
    (forall ((i2@49@01 Int)) (!
      (forall ((i3@50@01 Int)) (!
        (and
          (implies
            (<= 0 i2@49@01)
            (and
              (<= 0 i2@49@01)
              (implies
                (< i2@49@01 V@11@01)
                (and
                  (< i2@49@01 V@11@01)
                  (implies
                    (<= 0 i3@50@01)
                    (and
                      (<= 0 i3@50@01)
                      (implies
                        (< i3@50@01 V@11@01)
                        (and
                          (< i3@50@01 V@11@01)
                          (<
                            i2@49@01
                            (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                          (<
                            i3@50@01
                            (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                      ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
                    (< i3@50@01 V@11@01))
                  (<= 0 i3@50@01))
                (< i2@49@01 V@11@01))
              (<= 0 i2@49@01))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
              (< i3@50@01 V@11@01)
              (<= 0 i3@50@01)
              (< i2@49@01 V@11@01)
              (<= 0 i2@49@01))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@11@01) (= exc@12@01 $Ref.null))
  (forall ((i2@49@01 Int)) (!
    (forall ((i3@50@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
                  ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01)))
                (< i3@50@01 V@11@01))
              (<= 0 i3@50@01))
            (< i2@49@01 V@11@01))
          (<= 0 i2@49@01))
        (= i2@49@01 i3@50@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@50@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@49@01))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5199
;  :arith-add-rows          2438
;  :arith-assert-diseq      97
;  :arith-assert-lower      1519
;  :arith-assert-upper      1198
;  :arith-bound-prop        145
;  :arith-conflicts         159
;  :arith-eq-adapter        308
;  :arith-fixed-eqs         229
;  :arith-gcd-tests         2
;  :arith-grobner           271
;  :arith-ineq-splits       2
;  :arith-max-min           1679
;  :arith-nonlinear-bounds  163
;  :arith-nonlinear-horner  223
;  :arith-offset-eqs        383
;  :arith-patches           2
;  :arith-pivots            527
;  :conflicts               354
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 615
;  :datatype-occurs-check   365
;  :datatype-splits         495
;  :decisions               1812
;  :del-clause              5399
;  :final-checks            333
;  :interface-eqs           75
;  :max-generation          6
;  :max-memory              5.61
;  :memory                  5.56
;  :minimized-lits          4
;  :mk-bool-var             8507
;  :mk-clause               5488
;  :num-allocs              255161
;  :num-checks              115
;  :propagations            2579
;  :quant-instantiations    1370
;  :rlimit-count            481791
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@01 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5199
;  :arith-add-rows          2438
;  :arith-assert-diseq      97
;  :arith-assert-lower      1519
;  :arith-assert-upper      1198
;  :arith-bound-prop        145
;  :arith-conflicts         159
;  :arith-eq-adapter        308
;  :arith-fixed-eqs         229
;  :arith-gcd-tests         2
;  :arith-grobner           271
;  :arith-ineq-splits       2
;  :arith-max-min           1679
;  :arith-nonlinear-bounds  163
;  :arith-nonlinear-horner  223
;  :arith-offset-eqs        383
;  :arith-patches           2
;  :arith-pivots            527
;  :conflicts               354
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 615
;  :datatype-occurs-check   365
;  :datatype-splits         495
;  :decisions               1812
;  :del-clause              5399
;  :final-checks            333
;  :interface-eqs           75
;  :max-generation          6
;  :max-memory              5.61
;  :memory                  5.56
;  :minimized-lits          4
;  :mk-bool-var             8507
;  :mk-clause               5488
;  :num-allocs              255179
;  :num-checks              116
;  :propagations            2579
;  :quant-instantiations    1370
;  :rlimit-count            481802)
; [then-branch: 76 | exc@12@01 == Null | live]
; [else-branch: 76 | exc@12@01 != Null | dead]
(push) ; 8
; [then-branch: 76 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 <= i1
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@01 $Ref.null) (<= 0 i1@7@01)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5584
;  :arith-add-rows          2478
;  :arith-assert-diseq      97
;  :arith-assert-lower      1571
;  :arith-assert-upper      1247
;  :arith-bound-prop        149
;  :arith-conflicts         163
;  :arith-eq-adapter        316
;  :arith-fixed-eqs         234
;  :arith-gcd-tests         2
;  :arith-grobner           289
;  :arith-ineq-splits       2
;  :arith-max-min           1756
;  :arith-nonlinear-bounds  172
;  :arith-nonlinear-horner  238
;  :arith-offset-eqs        411
;  :arith-patches           2
;  :arith-pivots            534
;  :conflicts               364
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 676
;  :datatype-occurs-check   404
;  :datatype-splits         546
;  :decisions               1935
;  :del-clause              5652
;  :final-checks            351
;  :interface-eqs           81
;  :max-generation          6
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             8811
;  :mk-clause               5741
;  :num-allocs              260639
;  :num-checks              117
;  :propagations            2694
;  :quant-instantiations    1408
;  :rlimit-count            498811
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@01 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5584
;  :arith-add-rows          2478
;  :arith-assert-diseq      97
;  :arith-assert-lower      1571
;  :arith-assert-upper      1247
;  :arith-bound-prop        149
;  :arith-conflicts         163
;  :arith-eq-adapter        316
;  :arith-fixed-eqs         234
;  :arith-gcd-tests         2
;  :arith-grobner           289
;  :arith-ineq-splits       2
;  :arith-max-min           1756
;  :arith-nonlinear-bounds  172
;  :arith-nonlinear-horner  238
;  :arith-offset-eqs        411
;  :arith-patches           2
;  :arith-pivots            534
;  :conflicts               364
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 676
;  :datatype-occurs-check   404
;  :datatype-splits         546
;  :decisions               1935
;  :del-clause              5652
;  :final-checks            351
;  :interface-eqs           81
;  :max-generation          6
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             8811
;  :mk-clause               5741
;  :num-allocs              260657
;  :num-checks              118
;  :propagations            2694
;  :quant-instantiations    1408
;  :rlimit-count            498822)
; [then-branch: 77 | exc@12@01 == Null | live]
; [else-branch: 77 | exc@12@01 != Null | dead]
(push) ; 8
; [then-branch: 77 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] i1 < V
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@01 $Ref.null) (< i1@7@01 V@11@01)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= j
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5970
;  :arith-add-rows          2518
;  :arith-assert-diseq      97
;  :arith-assert-lower      1623
;  :arith-assert-upper      1296
;  :arith-bound-prop        153
;  :arith-conflicts         167
;  :arith-eq-adapter        324
;  :arith-fixed-eqs         239
;  :arith-gcd-tests         2
;  :arith-grobner           305
;  :arith-ineq-splits       2
;  :arith-max-min           1833
;  :arith-nonlinear-bounds  181
;  :arith-nonlinear-horner  252
;  :arith-offset-eqs        437
;  :arith-patches           2
;  :arith-pivots            543
;  :conflicts               374
;  :datatype-accessor-ax    204
;  :datatype-constructor-ax 737
;  :datatype-occurs-check   443
;  :datatype-splits         597
;  :decisions               2058
;  :del-clause              5905
;  :final-checks            369
;  :interface-eqs           87
;  :max-generation          6
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             9115
;  :mk-clause               5994
;  :num-allocs              265898
;  :num-checks              119
;  :propagations            2809
;  :quant-instantiations    1446
;  :rlimit-count            514339
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@01 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5970
;  :arith-add-rows          2518
;  :arith-assert-diseq      97
;  :arith-assert-lower      1623
;  :arith-assert-upper      1296
;  :arith-bound-prop        153
;  :arith-conflicts         167
;  :arith-eq-adapter        324
;  :arith-fixed-eqs         239
;  :arith-gcd-tests         2
;  :arith-grobner           305
;  :arith-ineq-splits       2
;  :arith-max-min           1833
;  :arith-nonlinear-bounds  181
;  :arith-nonlinear-horner  252
;  :arith-offset-eqs        437
;  :arith-patches           2
;  :arith-pivots            543
;  :conflicts               374
;  :datatype-accessor-ax    204
;  :datatype-constructor-ax 737
;  :datatype-occurs-check   443
;  :datatype-splits         597
;  :decisions               2058
;  :del-clause              5905
;  :final-checks            369
;  :interface-eqs           87
;  :max-generation          6
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             9115
;  :mk-clause               5994
;  :num-allocs              265916
;  :num-checks              120
;  :propagations            2809
;  :quant-instantiations    1446
;  :rlimit-count            514350)
; [then-branch: 78 | exc@12@01 == Null | live]
; [else-branch: 78 | exc@12@01 != Null | dead]
(push) ; 8
; [then-branch: 78 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] 0 <= j
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@01 $Ref.null) (<= 0 j@10@01)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> j < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6361
;  :arith-add-rows          2558
;  :arith-assert-diseq      97
;  :arith-assert-lower      1675
;  :arith-assert-upper      1345
;  :arith-bound-prop        157
;  :arith-conflicts         171
;  :arith-eq-adapter        332
;  :arith-fixed-eqs         244
;  :arith-gcd-tests         2
;  :arith-grobner           323
;  :arith-ineq-splits       2
;  :arith-max-min           1910
;  :arith-nonlinear-bounds  190
;  :arith-nonlinear-horner  267
;  :arith-offset-eqs        465
;  :arith-patches           2
;  :arith-pivots            550
;  :conflicts               384
;  :datatype-accessor-ax    222
;  :datatype-constructor-ax 798
;  :datatype-occurs-check   482
;  :datatype-splits         648
;  :decisions               2181
;  :del-clause              6158
;  :final-checks            387
;  :interface-eqs           93
;  :max-generation          6
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             9419
;  :mk-clause               6247
;  :num-allocs              271763
;  :num-checks              121
;  :propagations            2924
;  :quant-instantiations    1484
;  :rlimit-count            531859
;  :time                    0.01)
(push) ; 8
(assert (not (= exc@12@01 $Ref.null)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6361
;  :arith-add-rows          2558
;  :arith-assert-diseq      97
;  :arith-assert-lower      1675
;  :arith-assert-upper      1345
;  :arith-bound-prop        157
;  :arith-conflicts         171
;  :arith-eq-adapter        332
;  :arith-fixed-eqs         244
;  :arith-gcd-tests         2
;  :arith-grobner           323
;  :arith-ineq-splits       2
;  :arith-max-min           1910
;  :arith-nonlinear-bounds  190
;  :arith-nonlinear-horner  267
;  :arith-offset-eqs        465
;  :arith-patches           2
;  :arith-pivots            550
;  :conflicts               384
;  :datatype-accessor-ax    222
;  :datatype-constructor-ax 798
;  :datatype-occurs-check   482
;  :datatype-splits         648
;  :decisions               2181
;  :del-clause              6158
;  :final-checks            387
;  :interface-eqs           93
;  :max-generation          6
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             9419
;  :mk-clause               6247
;  :num-allocs              271781
;  :num-checks              122
;  :propagations            2924
;  :quant-instantiations    1484
;  :rlimit-count            531870)
; [then-branch: 79 | exc@12@01 == Null | live]
; [else-branch: 79 | exc@12@01 != Null | dead]
(push) ; 8
; [then-branch: 79 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
; [eval] j < V
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies (= exc@12@01 $Ref.null) (< j@10@01 V@11@01)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))))))
; [eval] exc == null
(push) ; 7
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6764
;  :arith-add-rows          2598
;  :arith-assert-diseq      97
;  :arith-assert-lower      1727
;  :arith-assert-upper      1394
;  :arith-bound-prop        161
;  :arith-conflicts         175
;  :arith-eq-adapter        340
;  :arith-fixed-eqs         249
;  :arith-gcd-tests         2
;  :arith-grobner           341
;  :arith-ineq-splits       2
;  :arith-max-min           1987
;  :arith-nonlinear-bounds  199
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        491
;  :arith-patches           2
;  :arith-pivots            557
;  :conflicts               394
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 862
;  :datatype-occurs-check   521
;  :datatype-splits         702
;  :decisions               2307
;  :del-clause              6411
;  :final-checks            405
;  :interface-eqs           99
;  :max-generation          6
;  :max-memory              5.63
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             9725
;  :mk-clause               6500
;  :num-allocs              277221
;  :num-checks              123
;  :propagations            3039
;  :quant-instantiations    1522
;  :rlimit-count            548926
;  :time                    0.01)
(push) ; 7
(assert (not (= exc@12@01 $Ref.null)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6764
;  :arith-add-rows          2598
;  :arith-assert-diseq      97
;  :arith-assert-lower      1727
;  :arith-assert-upper      1394
;  :arith-bound-prop        161
;  :arith-conflicts         175
;  :arith-eq-adapter        340
;  :arith-fixed-eqs         249
;  :arith-gcd-tests         2
;  :arith-grobner           341
;  :arith-ineq-splits       2
;  :arith-max-min           1987
;  :arith-nonlinear-bounds  199
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        491
;  :arith-patches           2
;  :arith-pivots            557
;  :conflicts               394
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 862
;  :datatype-occurs-check   521
;  :datatype-splits         702
;  :decisions               2307
;  :del-clause              6411
;  :final-checks            405
;  :interface-eqs           99
;  :max-generation          6
;  :max-memory              5.63
;  :memory                  5.58
;  :minimized-lits          4
;  :mk-bool-var             9725
;  :mk-clause               6500
;  :num-allocs              277239
;  :num-checks              124
;  :propagations            3039
;  :quant-instantiations    1522
;  :rlimit-count            548937)
; [then-branch: 80 | exc@12@01 == Null | live]
; [else-branch: 80 | exc@12@01 != Null | dead]
(push) ; 7
; [then-branch: 80 | exc@12@01 == Null]
(assert (= exc@12@01 $Ref.null))
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
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@44@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@36@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7103
;  :arith-add-rows          2679
;  :arith-assert-diseq      98
;  :arith-assert-lower      1771
;  :arith-assert-upper      1434
;  :arith-bound-prop        164
;  :arith-conflicts         181
;  :arith-eq-adapter        362
;  :arith-fixed-eqs         259
;  :arith-gcd-tests         2
;  :arith-grobner           341
;  :arith-ineq-splits       2
;  :arith-max-min           2023
;  :arith-nonlinear-bounds  205
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        505
;  :arith-patches           2
;  :arith-pivots            573
;  :conflicts               414
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 906
;  :datatype-occurs-check   539
;  :datatype-splits         736
;  :decisions               2403
;  :del-clause              6663
;  :final-checks            416
;  :interface-eqs           103
;  :max-generation          6
;  :max-memory              5.63
;  :memory                  5.57
;  :minimized-lits          4
;  :mk-bool-var             10194
;  :mk-clause               6752
;  :num-allocs              278419
;  :num-checks              125
;  :propagations            3151
;  :quant-instantiations    1555
;  :rlimit-count            553855
;  :time                    0.00)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 9
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7103
;  :arith-add-rows          2679
;  :arith-assert-diseq      98
;  :arith-assert-lower      1771
;  :arith-assert-upper      1434
;  :arith-bound-prop        164
;  :arith-conflicts         181
;  :arith-eq-adapter        362
;  :arith-fixed-eqs         259
;  :arith-gcd-tests         2
;  :arith-grobner           341
;  :arith-ineq-splits       2
;  :arith-max-min           2023
;  :arith-nonlinear-bounds  205
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        505
;  :arith-patches           2
;  :arith-pivots            573
;  :conflicts               415
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 906
;  :datatype-occurs-check   539
;  :datatype-splits         736
;  :decisions               2403
;  :del-clause              6663
;  :final-checks            416
;  :interface-eqs           103
;  :max-generation          6
;  :max-memory              5.63
;  :memory                  5.57
;  :minimized-lits          4
;  :mk-bool-var             10194
;  :mk-clause               6752
;  :num-allocs              278510
;  :num-checks              126
;  :propagations            3151
;  :quant-instantiations    1555
;  :rlimit-count            553946)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7109
;  :arith-add-rows          2688
;  :arith-assert-diseq      98
;  :arith-assert-lower      1774
;  :arith-assert-upper      1435
;  :arith-bound-prop        164
;  :arith-conflicts         182
;  :arith-eq-adapter        363
;  :arith-fixed-eqs         260
;  :arith-gcd-tests         2
;  :arith-grobner           341
;  :arith-ineq-splits       2
;  :arith-max-min           2023
;  :arith-nonlinear-bounds  205
;  :arith-nonlinear-horner  282
;  :arith-offset-eqs        505
;  :arith-patches           2
;  :arith-pivots            577
;  :conflicts               416
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 906
;  :datatype-occurs-check   539
;  :datatype-splits         736
;  :decisions               2403
;  :del-clause              6667
;  :final-checks            416
;  :interface-eqs           103
;  :max-generation          6
;  :max-memory              5.63
;  :memory                  5.57
;  :minimized-lits          4
;  :mk-bool-var             10205
;  :mk-clause               6756
;  :num-allocs              278708
;  :num-checks              127
;  :propagations            3153
;  :quant-instantiations    1562
;  :rlimit-count            554506)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(pop) ; 8
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))))))))))))))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7511
;  :arith-add-rows          2748
;  :arith-assert-diseq      98
;  :arith-assert-lower      1828
;  :arith-assert-upper      1486
;  :arith-bound-prop        168
;  :arith-conflicts         186
;  :arith-eq-adapter        372
;  :arith-fixed-eqs         266
;  :arith-gcd-tests         2
;  :arith-grobner           361
;  :arith-ineq-splits       2
;  :arith-max-min           2100
;  :arith-nonlinear-bounds  214
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        515
;  :arith-patches           2
;  :arith-pivots            586
;  :conflicts               426
;  :datatype-accessor-ax    269
;  :datatype-constructor-ax 973
;  :datatype-occurs-check   578
;  :datatype-splits         793
;  :decisions               2532
;  :del-clause              6920
;  :final-checks            434
;  :interface-eqs           109
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.65
;  :minimized-lits          4
;  :mk-bool-var             10535
;  :mk-clause               7019
;  :num-allocs              285695
;  :num-checks              128
;  :propagations            3274
;  :quant-instantiations    1612
;  :rlimit-count            576729
;  :time                    0.01)
; [then-branch: 81 | exc@12@01 == Null | live]
; [else-branch: 81 | exc@12@01 != Null | dead]
(push) ; 8
; [then-branch: 81 | exc@12@01 == Null]
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
(declare-const sm@51@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@37@01 r) V@11@01) (<= 0 (inv@37@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r))
  :qid |qp.fvfValDef15|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@45@01 r) V@11@01) (<= 0 (inv@45@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))) r))
  :qid |qp.fvfValDef16|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef17|)))
(declare-const pm@52@01 $FPM)
(assert (forall ((r $Ref)) (!
  (=
    ($FVF.perm_option$array$ (as pm@52@01  $FPM) r)
    (+
      (ite
        (and (< (inv@37@01 r) V@11@01) (<= 0 (inv@37@01 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@36@01)
        $Perm.No)
      (ite
        (and (< (inv@45@01 r) V@11@01) (<= 0 (inv@45@01 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@44@01)
        $Perm.No)))
  :pattern (($FVF.perm_option$array$ (as pm@52@01  $FPM) r))
  :qid |qp.resPrmSumDef18|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@01))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01))))))))))) r) r))
  :pattern (($FVF.perm_option$array$ (as pm@52@01  $FPM) r))
  :qid |qp.resTrgDef19|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))
(set-option :timeout 0)
(push) ; 9
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@52@01  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7716
;  :arith-add-rows          2790
;  :arith-assert-diseq      99
;  :arith-assert-lower      1856
;  :arith-assert-upper      1511
;  :arith-bound-prop        170
;  :arith-conflicts         190
;  :arith-eq-adapter        389
;  :arith-fixed-eqs         276
;  :arith-gcd-tests         2
;  :arith-grobner           361
;  :arith-ineq-splits       2
;  :arith-max-min           2117
;  :arith-nonlinear-bounds  217
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        526
;  :arith-patches           2
;  :arith-pivots            596
;  :conflicts               441
;  :datatype-accessor-ax    274
;  :datatype-constructor-ax 996
;  :datatype-occurs-check   583
;  :datatype-splits         808
;  :decisions               2610
;  :del-clause              7233
;  :final-checks            439
;  :interface-eqs           111
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.64
;  :minimized-lits          4
;  :mk-bool-var             10975
;  :mk-clause               7339
;  :num-allocs              287321
;  :num-checks              129
;  :propagations            3380
;  :quant-instantiations    1660
;  :rlimit-count            583315
;  :time                    0.00)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7891
;  :arith-add-rows          2813
;  :arith-assert-diseq      99
;  :arith-assert-lower      1868
;  :arith-assert-upper      1526
;  :arith-bound-prop        171
;  :arith-conflicts         192
;  :arith-eq-adapter        398
;  :arith-fixed-eqs         279
;  :arith-gcd-tests         2
;  :arith-grobner           361
;  :arith-ineq-splits       2
;  :arith-max-min           2134
;  :arith-nonlinear-bounds  220
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        531
;  :arith-patches           2
;  :arith-pivots            599
;  :conflicts               454
;  :datatype-accessor-ax    279
;  :datatype-constructor-ax 1019
;  :datatype-occurs-check   588
;  :datatype-splits         823
;  :decisions               2660
;  :del-clause              7364
;  :final-checks            444
;  :interface-eqs           113
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.64
;  :minimized-lits          4
;  :mk-bool-var             11236
;  :mk-clause               7470
;  :num-allocs              287837
;  :num-checks              130
;  :propagations            3425
;  :quant-instantiations    1675
;  :rlimit-count            585807
;  :time                    0.00)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8087
;  :arith-add-rows          2850
;  :arith-assert-diseq      99
;  :arith-assert-lower      1886
;  :arith-assert-upper      1543
;  :arith-bound-prop        172
;  :arith-conflicts         195
;  :arith-eq-adapter        404
;  :arith-fixed-eqs         284
;  :arith-gcd-tests         2
;  :arith-grobner           361
;  :arith-ineq-splits       2
;  :arith-max-min           2151
;  :arith-nonlinear-bounds  223
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        536
;  :arith-patches           2
;  :arith-pivots            604
;  :conflicts               467
;  :datatype-accessor-ax    284
;  :datatype-constructor-ax 1042
;  :datatype-occurs-check   593
;  :datatype-splits         838
;  :decisions               2710
;  :del-clause              7478
;  :final-checks            449
;  :interface-eqs           115
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.64
;  :minimized-lits          4
;  :mk-bool-var             11513
;  :mk-clause               7584
;  :num-allocs              288476
;  :num-checks              131
;  :propagations            3475
;  :quant-instantiations    1699
;  :rlimit-count            588795
;  :time                    0.00)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(pop) ; 9
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(declare-const $k@53@01 $Perm)
(assert ($Perm.isReadVar $k@53@01 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@53@01 $Perm.No) (< $Perm.No $k@53@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8090
;  :arith-add-rows          2850
;  :arith-assert-diseq      100
;  :arith-assert-lower      1889
;  :arith-assert-upper      1545
;  :arith-bound-prop        172
;  :arith-conflicts         195
;  :arith-eq-adapter        405
;  :arith-fixed-eqs         284
;  :arith-gcd-tests         2
;  :arith-grobner           361
;  :arith-ineq-splits       2
;  :arith-max-min           2151
;  :arith-nonlinear-bounds  223
;  :arith-nonlinear-horner  299
;  :arith-offset-eqs        536
;  :arith-patches           2
;  :arith-pivots            605
;  :conflicts               468
;  :datatype-accessor-ax    284
;  :datatype-constructor-ax 1042
;  :datatype-occurs-check   593
;  :datatype-splits         838
;  :decisions               2710
;  :del-clause              7478
;  :final-checks            449
;  :interface-eqs           115
;  :max-generation          6
;  :max-memory              5.70
;  :memory                  5.64
;  :minimized-lits          4
;  :mk-bool-var             11523
;  :mk-clause               7586
;  :num-allocs              288742
;  :num-checks              132
;  :propagations            3476
;  :quant-instantiations    1704
;  :rlimit-count            589204)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8505
;  :arith-add-rows          2945
;  :arith-assert-diseq      100
;  :arith-assert-lower      1943
;  :arith-assert-upper      1596
;  :arith-bound-prop        175
;  :arith-conflicts         200
;  :arith-eq-adapter        414
;  :arith-fixed-eqs         290
;  :arith-gcd-tests         2
;  :arith-grobner           381
;  :arith-ineq-splits       2
;  :arith-max-min           2228
;  :arith-nonlinear-bounds  232
;  :arith-nonlinear-horner  317
;  :arith-offset-eqs        557
;  :arith-patches           2
;  :arith-pivots            614
;  :conflicts               479
;  :datatype-accessor-ax    301
;  :datatype-constructor-ax 1109
;  :datatype-occurs-check   632
;  :datatype-splits         895
;  :decisions               2840
;  :del-clause              7735
;  :final-checks            467
;  :interface-eqs           121
;  :max-generation          6
;  :max-memory              5.72
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             11840
;  :mk-clause               7843
;  :num-allocs              297365
;  :num-checks              133
;  :propagations            3596
;  :quant-instantiations    1747
;  :rlimit-count            615419
;  :time                    0.01)
(assert (<= $Perm.No $k@53@01))
(assert (<= $k@53@01 $Perm.Write))
(assert (implies
  (< $Perm.No $k@53@01)
  (not
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int == aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] exc == null
(push) ; 9
(push) ; 10
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unknown
(pop) ; 10
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8905
;  :arith-add-rows          3029
;  :arith-assert-diseq      100
;  :arith-assert-lower      1997
;  :arith-assert-upper      1648
;  :arith-bound-prop        178
;  :arith-conflicts         205
;  :arith-eq-adapter        423
;  :arith-fixed-eqs         296
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2305
;  :arith-nonlinear-bounds  241
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        568
;  :arith-patches           2
;  :arith-pivots            624
;  :conflicts               490
;  :datatype-accessor-ax    318
;  :datatype-constructor-ax 1173
;  :datatype-occurs-check   671
;  :datatype-splits         949
;  :decisions               2967
;  :del-clause              7986
;  :final-checks            485
;  :interface-eqs           127
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.70
;  :minimized-lits          4
;  :mk-bool-var             12156
;  :mk-clause               8100
;  :num-allocs              307403
;  :num-checks              134
;  :propagations            3716
;  :quant-instantiations    1790
;  :rlimit-count            644939
;  :time                    0.01)
; [then-branch: 82 | exc@12@01 == Null | live]
; [else-branch: 82 | exc@12@01 != Null | dead]
(push) ; 10
; [then-branch: 82 | exc@12@01 == Null]
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int == aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 11
; Joined path conditions
(set-option :timeout 0)
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@44@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@36@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9262
;  :arith-add-rows          3146
;  :arith-assert-diseq      101
;  :arith-assert-lower      2042
;  :arith-assert-upper      1689
;  :arith-bound-prop        181
;  :arith-conflicts         211
;  :arith-eq-adapter        446
;  :arith-fixed-eqs         307
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2341
;  :arith-nonlinear-bounds  247
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        591
;  :arith-patches           2
;  :arith-pivots            644
;  :conflicts               510
;  :datatype-accessor-ax    329
;  :datatype-constructor-ax 1217
;  :datatype-occurs-check   689
;  :datatype-splits         983
;  :decisions               3063
;  :del-clause              8236
;  :final-checks            496
;  :interface-eqs           131
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          4
;  :mk-bool-var             12625
;  :mk-clause               8350
;  :num-allocs              308522
;  :num-checks              135
;  :propagations            3830
;  :quant-instantiations    1823
;  :rlimit-count            650851
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 11
; Joined path conditions
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
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
(pop) ; 11
; Joined path conditions
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@45@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@44@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@37@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@36@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9466
;  :arith-add-rows          3185
;  :arith-assert-diseq      102
;  :arith-assert-lower      2070
;  :arith-assert-upper      1716
;  :arith-bound-prop        182
;  :arith-conflicts         216
;  :arith-eq-adapter        465
;  :arith-fixed-eqs         317
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2358
;  :arith-nonlinear-bounds  250
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        597
;  :arith-patches           2
;  :arith-pivots            655
;  :conflicts               526
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 1239
;  :datatype-occurs-check   694
;  :datatype-splits         997
;  :decisions               3141
;  :del-clause              8548
;  :final-checks            501
;  :interface-eqs           133
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          4
;  :mk-bool-var             13054
;  :mk-clause               8662
;  :num-allocs              309346
;  :num-checks              136
;  :propagations            3936
;  :quant-instantiations    1864
;  :rlimit-count            655115
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 12
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9637
;  :arith-add-rows          3208
;  :arith-assert-diseq      102
;  :arith-assert-lower      2082
;  :arith-assert-upper      1731
;  :arith-bound-prop        183
;  :arith-conflicts         218
;  :arith-eq-adapter        474
;  :arith-fixed-eqs         320
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2375
;  :arith-nonlinear-bounds  253
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        599
;  :arith-patches           2
;  :arith-pivots            658
;  :conflicts               539
;  :datatype-accessor-ax    339
;  :datatype-constructor-ax 1261
;  :datatype-occurs-check   699
;  :datatype-splits         1011
;  :decisions               3190
;  :del-clause              8679
;  :final-checks            506
;  :interface-eqs           135
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          4
;  :mk-bool-var             13314
;  :mk-clause               8793
;  :num-allocs              309863
;  :num-checks              137
;  :propagations            3981
;  :quant-instantiations    1879
;  :rlimit-count            657560
;  :time                    0.00)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 12
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9838
;  :arith-add-rows          3242
;  :arith-assert-diseq      102
;  :arith-assert-lower      2099
;  :arith-assert-upper      1747
;  :arith-bound-prop        184
;  :arith-conflicts         221
;  :arith-eq-adapter        481
;  :arith-fixed-eqs         324
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2392
;  :arith-nonlinear-bounds  256
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        601
;  :arith-patches           2
;  :arith-pivots            663
;  :conflicts               552
;  :datatype-accessor-ax    344
;  :datatype-constructor-ax 1283
;  :datatype-occurs-check   704
;  :datatype-splits         1025
;  :decisions               3239
;  :del-clause              8794
;  :final-checks            511
;  :interface-eqs           137
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          4
;  :mk-bool-var             13591
;  :mk-clause               8908
;  :num-allocs              310503
;  :num-checks              138
;  :propagations            4031
;  :quant-instantiations    1901
;  :rlimit-count            660484
;  :time                    0.00)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(pop) ; 11
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(set-option :timeout 10)
(push) ; 11
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@51@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10030
;  :arith-add-rows          3265
;  :arith-assert-diseq      102
;  :arith-assert-lower      2112
;  :arith-assert-upper      1763
;  :arith-bound-prop        185
;  :arith-conflicts         223
;  :arith-eq-adapter        490
;  :arith-fixed-eqs         327
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2409
;  :arith-nonlinear-bounds  259
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        603
;  :arith-patches           2
;  :arith-pivots            667
;  :conflicts               565
;  :datatype-accessor-ax    349
;  :datatype-constructor-ax 1305
;  :datatype-occurs-check   709
;  :datatype-splits         1039
;  :decisions               3288
;  :del-clause              8931
;  :final-checks            516
;  :interface-eqs           139
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          4
;  :mk-bool-var             13866
;  :mk-clause               9045
;  :num-allocs              311141
;  :num-checks              139
;  :propagations            4080
;  :quant-instantiations    1926
;  :rlimit-count            663413
;  :time                    0.00)
(push) ; 11
(assert (not (< $Perm.No $k@53@01)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10030
;  :arith-add-rows          3265
;  :arith-assert-diseq      102
;  :arith-assert-lower      2112
;  :arith-assert-upper      1763
;  :arith-bound-prop        185
;  :arith-conflicts         223
;  :arith-eq-adapter        490
;  :arith-fixed-eqs         327
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2409
;  :arith-nonlinear-bounds  259
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        603
;  :arith-patches           2
;  :arith-pivots            667
;  :conflicts               566
;  :datatype-accessor-ax    349
;  :datatype-constructor-ax 1305
;  :datatype-occurs-check   709
;  :datatype-splits         1039
;  :decisions               3288
;  :del-clause              8931
;  :final-checks            516
;  :interface-eqs           139
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          4
;  :mk-bool-var             13866
;  :mk-clause               9045
;  :num-allocs              311223
;  :num-checks              140
;  :propagations            4080
;  :quant-instantiations    1926
;  :rlimit-count            663461)
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (= exc@12@01 $Ref.null)
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
        (as None<option<array>>  option<array>)))
    (<
      j@10@01
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@46@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))))
(assert (implies
  (= exc@12@01 $Ref.null)
  (=
    ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))))
    ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@01)))))))))))))))))))))))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(push) ; 4
; [exec]
; var return: void
(declare-const return@54@01 void)
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
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10040
;  :arith-add-rows          3285
;  :arith-assert-diseq      103
;  :arith-assert-lower      2118
;  :arith-assert-upper      1770
;  :arith-bound-prop        185
;  :arith-conflicts         225
;  :arith-eq-adapter        495
;  :arith-fixed-eqs         329
;  :arith-gcd-tests         2
;  :arith-grobner           402
;  :arith-ineq-splits       2
;  :arith-max-min           2409
;  :arith-nonlinear-bounds  259
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        603
;  :arith-patches           2
;  :arith-pivots            678
;  :conflicts               569
;  :datatype-accessor-ax    349
;  :datatype-constructor-ax 1305
;  :datatype-occurs-check   709
;  :datatype-splits         1039
;  :decisions               3290
;  :del-clause              9022
;  :final-checks            516
;  :interface-eqs           139
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             13885
;  :mk-clause               9053
;  :num-allocs              311460
;  :num-checks              141
;  :propagations            4093
;  :quant-instantiations    1929
;  :rlimit-count            664575)
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
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))
(push) ; 5
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10103
;  :arith-add-rows          3300
;  :arith-assert-diseq      104
;  :arith-assert-lower      2141
;  :arith-assert-upper      1791
;  :arith-bound-prop        185
;  :arith-conflicts         229
;  :arith-eq-adapter        505
;  :arith-fixed-eqs         335
;  :arith-gcd-tests         3
;  :arith-grobner           402
;  :arith-ineq-splits       3
;  :arith-max-min           2433
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        604
;  :arith-patches           3
;  :arith-pivots            688
;  :conflicts               578
;  :datatype-accessor-ax    352
;  :datatype-constructor-ax 1321
;  :datatype-occurs-check   719
;  :datatype-splits         1055
;  :decisions               3318
;  :del-clause              9061
;  :final-checks            529
;  :interface-eqs           144
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             13957
;  :mk-clause               9092
;  :num-allocs              311987
;  :num-checks              142
;  :propagations            4123
;  :quant-instantiations    1935
;  :rlimit-count            666250
;  :time                    0.00)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10104
;  :arith-add-rows          3300
;  :arith-assert-diseq      104
;  :arith-assert-lower      2141
;  :arith-assert-upper      1791
;  :arith-bound-prop        185
;  :arith-conflicts         229
;  :arith-eq-adapter        505
;  :arith-fixed-eqs         335
;  :arith-gcd-tests         3
;  :arith-grobner           402
;  :arith-ineq-splits       3
;  :arith-max-min           2433
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        604
;  :arith-patches           3
;  :arith-pivots            688
;  :conflicts               579
;  :datatype-accessor-ax    352
;  :datatype-constructor-ax 1321
;  :datatype-occurs-check   719
;  :datatype-splits         1055
;  :decisions               3318
;  :del-clause              9061
;  :final-checks            529
;  :interface-eqs           144
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             13958
;  :mk-clause               9092
;  :num-allocs              312078
;  :num-checks              143
;  :propagations            4123
;  :quant-instantiations    1935
;  :rlimit-count            666343)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10108
;  :arith-add-rows          3310
;  :arith-assert-diseq      104
;  :arith-assert-lower      2143
;  :arith-assert-upper      1792
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        506
;  :arith-fixed-eqs         336
;  :arith-gcd-tests         3
;  :arith-grobner           402
;  :arith-ineq-splits       3
;  :arith-max-min           2433
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        604
;  :arith-patches           3
;  :arith-pivots            692
;  :conflicts               580
;  :datatype-accessor-ax    352
;  :datatype-constructor-ax 1321
;  :datatype-occurs-check   719
;  :datatype-splits         1055
;  :decisions               3318
;  :del-clause              9062
;  :final-checks            529
;  :interface-eqs           144
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             13963
;  :mk-clause               9093
;  :num-allocs              312246
;  :num-checks              144
;  :propagations            4123
;  :quant-instantiations    1935
;  :rlimit-count            666897)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(pop) ; 5
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10113
;  :arith-add-rows          3312
;  :arith-assert-diseq      104
;  :arith-assert-lower      2144
;  :arith-assert-upper      1794
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        507
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           402
;  :arith-ineq-splits       3
;  :arith-max-min           2433
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        604
;  :arith-patches           3
;  :arith-pivots            693
;  :conflicts               581
;  :datatype-accessor-ax    352
;  :datatype-constructor-ax 1321
;  :datatype-occurs-check   719
;  :datatype-splits         1055
;  :decisions               3318
;  :del-clause              9062
;  :final-checks            529
;  :interface-eqs           144
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             13968
;  :mk-clause               9093
;  :num-allocs              312431
;  :num-checks              145
;  :propagations            4123
;  :quant-instantiations    1935
;  :rlimit-count            667284)
(push) ; 5
(assert (not (< $Perm.No $k@33@01)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10113
;  :arith-add-rows          3312
;  :arith-assert-diseq      104
;  :arith-assert-lower      2144
;  :arith-assert-upper      1794
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        507
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           402
;  :arith-ineq-splits       3
;  :arith-max-min           2433
;  :arith-nonlinear-bounds  262
;  :arith-nonlinear-horner  336
;  :arith-offset-eqs        604
;  :arith-patches           3
;  :arith-pivots            693
;  :conflicts               582
;  :datatype-accessor-ax    352
;  :datatype-constructor-ax 1321
;  :datatype-occurs-check   719
;  :datatype-splits         1055
;  :decisions               3318
;  :del-clause              9062
;  :final-checks            529
;  :interface-eqs           144
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             13968
;  :mk-clause               9093
;  :num-allocs              312513
;  :num-checks              146
;  :propagations            4123
;  :quant-instantiations    1935
;  :rlimit-count            667332)
(declare-const int@55@01 Int)
(assert (=
  int@55@01
  ($SortWrappers.$SnapToInt ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))))))
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10137
;  :arith-add-rows          3331
;  :arith-assert-diseq      104
;  :arith-assert-lower      2162
;  :arith-assert-upper      1810
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        509
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           418
;  :arith-ineq-splits       3
;  :arith-max-min           2469
;  :arith-nonlinear-bounds  263
;  :arith-nonlinear-horner  349
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            695
;  :conflicts               582
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1327
;  :datatype-occurs-check   724
;  :datatype-splits         1061
;  :decisions               3331
;  :del-clause              9082
;  :final-checks            536
;  :interface-eqs           146
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             13994
;  :mk-clause               9113
;  :num-allocs              314691
;  :num-checks              147
;  :propagations            4134
;  :quant-instantiations    1941
;  :rlimit-count            674740
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
; [then-branch: 83 | True | live]
; [else-branch: 83 | False | live]
(push) ; 6
; [then-branch: 83 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 83 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10156
;  :arith-add-rows          3331
;  :arith-assert-diseq      104
;  :arith-assert-lower      2180
;  :arith-assert-upper      1826
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        511
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           434
;  :arith-ineq-splits       3
;  :arith-max-min           2505
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  362
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            695
;  :conflicts               582
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 1333
;  :datatype-occurs-check   729
;  :datatype-splits         1067
;  :decisions               3344
;  :del-clause              9102
;  :final-checks            543
;  :interface-eqs           148
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             14017
;  :mk-clause               9133
;  :num-allocs              317144
;  :num-checks              148
;  :propagations            4145
;  :quant-instantiations    1946
;  :rlimit-count            682209
;  :time                    0.00)
(push) ; 6
(assert (not (< 0 V@11@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10156
;  :arith-add-rows          3331
;  :arith-assert-diseq      104
;  :arith-assert-lower      2180
;  :arith-assert-upper      1826
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        511
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           434
;  :arith-ineq-splits       3
;  :arith-max-min           2505
;  :arith-nonlinear-bounds  264
;  :arith-nonlinear-horner  362
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            695
;  :conflicts               582
;  :datatype-accessor-ax    354
;  :datatype-constructor-ax 1333
;  :datatype-occurs-check   729
;  :datatype-splits         1067
;  :decisions               3344
;  :del-clause              9102
;  :final-checks            543
;  :interface-eqs           148
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             14017
;  :mk-clause               9133
;  :num-allocs              317162
;  :num-checks              149
;  :propagations            4145
;  :quant-instantiations    1946
;  :rlimit-count            682222)
; [then-branch: 84 | 0 < V@11@01 | live]
; [else-branch: 84 | !(0 < V@11@01) | dead]
(push) ; 6
; [then-branch: 84 | 0 < V@11@01]
(assert (< 0 V@11@01))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 85 | True | live]
; [else-branch: 85 | False | live]
(push) ; 6
; [then-branch: 85 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 85 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10175
;  :arith-add-rows          3331
;  :arith-assert-diseq      104
;  :arith-assert-lower      2198
;  :arith-assert-upper      1842
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        513
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           450
;  :arith-ineq-splits       3
;  :arith-max-min           2541
;  :arith-nonlinear-bounds  265
;  :arith-nonlinear-horner  375
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            695
;  :conflicts               582
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 1339
;  :datatype-occurs-check   734
;  :datatype-splits         1073
;  :decisions               3357
;  :del-clause              9122
;  :final-checks            550
;  :interface-eqs           150
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             14040
;  :mk-clause               9153
;  :num-allocs              319610
;  :num-checks              150
;  :propagations            4156
;  :quant-instantiations    1951
;  :rlimit-count            689701
;  :time                    0.00)
(push) ; 6
(assert (not (< 0 V@11@01)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10175
;  :arith-add-rows          3331
;  :arith-assert-diseq      104
;  :arith-assert-lower      2198
;  :arith-assert-upper      1842
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        513
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           450
;  :arith-ineq-splits       3
;  :arith-max-min           2541
;  :arith-nonlinear-bounds  265
;  :arith-nonlinear-horner  375
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            695
;  :conflicts               582
;  :datatype-accessor-ax    355
;  :datatype-constructor-ax 1339
;  :datatype-occurs-check   734
;  :datatype-splits         1073
;  :decisions               3357
;  :del-clause              9122
;  :final-checks            550
;  :interface-eqs           150
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             14040
;  :mk-clause               9153
;  :num-allocs              319628
;  :num-checks              151
;  :propagations            4156
;  :quant-instantiations    1951
;  :rlimit-count            689714)
; [then-branch: 86 | 0 < V@11@01 | live]
; [else-branch: 86 | !(0 < V@11@01) | dead]
(push) ; 6
; [then-branch: 86 | 0 < V@11@01]
(assert (< 0 V@11@01))
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
; [then-branch: 87 | True | live]
; [else-branch: 87 | False | live]
(push) ; 6
; [then-branch: 87 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 87 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10194
;  :arith-add-rows          3331
;  :arith-assert-diseq      104
;  :arith-assert-lower      2216
;  :arith-assert-upper      1858
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        515
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           466
;  :arith-ineq-splits       3
;  :arith-max-min           2577
;  :arith-nonlinear-bounds  266
;  :arith-nonlinear-horner  388
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            695
;  :conflicts               582
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 1345
;  :datatype-occurs-check   739
;  :datatype-splits         1079
;  :decisions               3370
;  :del-clause              9142
;  :final-checks            557
;  :interface-eqs           152
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             14063
;  :mk-clause               9173
;  :num-allocs              322076
;  :num-checks              152
;  :propagations            4167
;  :quant-instantiations    1956
;  :rlimit-count            697193
;  :time                    0.00)
(push) ; 5
(assert (not (< 0 V@11@01)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10194
;  :arith-add-rows          3331
;  :arith-assert-diseq      104
;  :arith-assert-lower      2216
;  :arith-assert-upper      1858
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        515
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           466
;  :arith-ineq-splits       3
;  :arith-max-min           2577
;  :arith-nonlinear-bounds  266
;  :arith-nonlinear-horner  388
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            695
;  :conflicts               582
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 1345
;  :datatype-occurs-check   739
;  :datatype-splits         1079
;  :decisions               3370
;  :del-clause              9142
;  :final-checks            557
;  :interface-eqs           152
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             14063
;  :mk-clause               9173
;  :num-allocs              322094
;  :num-checks              153
;  :propagations            4167
;  :quant-instantiations    1956
;  :rlimit-count            697206)
; [then-branch: 88 | 0 < V@11@01 | live]
; [else-branch: 88 | !(0 < V@11@01) | dead]
(push) ; 5
; [then-branch: 88 | 0 < V@11@01]
(assert (< 0 V@11@01))
(declare-const i2@56@01 Int)
(push) ; 6
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 7
; [then-branch: 89 | 0 <= i2@56@01 | live]
; [else-branch: 89 | !(0 <= i2@56@01) | live]
(push) ; 8
; [then-branch: 89 | 0 <= i2@56@01]
(assert (<= 0 i2@56@01))
; [eval] i2 < V
(pop) ; 8
(push) ; 8
; [else-branch: 89 | !(0 <= i2@56@01)]
(assert (not (<= 0 i2@56@01)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< i2@56@01 V@11@01) (<= 0 i2@56@01)))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 7
; [eval] amount >= 0 * write
; [eval] 0 * write
(set-option :timeout 0)
(push) ; 8
(assert (not (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10194
;  :arith-add-rows          3332
;  :arith-assert-diseq      104
;  :arith-assert-lower      2218
;  :arith-assert-upper      1858
;  :arith-bound-prop        185
;  :arith-conflicts         230
;  :arith-eq-adapter        515
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           466
;  :arith-ineq-splits       3
;  :arith-max-min           2577
;  :arith-nonlinear-bounds  266
;  :arith-nonlinear-horner  388
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            696
;  :conflicts               583
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 1345
;  :datatype-occurs-check   739
;  :datatype-splits         1079
;  :decisions               3370
;  :del-clause              9142
;  :final-checks            557
;  :interface-eqs           152
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          4
;  :mk-bool-var             14065
;  :mk-clause               9173
;  :num-allocs              322267
;  :num-checks              154
;  :propagations            4167
;  :quant-instantiations    1956
;  :rlimit-count            697457)
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(pop) ; 7
; Joined path conditions
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(declare-const $k@57@01 $Perm)
(assert ($Perm.isReadVar $k@57@01 $Perm.Write))
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
(assert (not (< i2@56@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10194
;  :arith-add-rows          3334
;  :arith-assert-diseq      105
;  :arith-assert-lower      2220
;  :arith-assert-upper      1860
;  :arith-bound-prop        185
;  :arith-conflicts         231
;  :arith-eq-adapter        516
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           466
;  :arith-ineq-splits       3
;  :arith-max-min           2577
;  :arith-nonlinear-bounds  266
;  :arith-nonlinear-horner  388
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            696
;  :conflicts               584
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 1345
;  :datatype-occurs-check   739
;  :datatype-splits         1079
;  :decisions               3370
;  :del-clause              9142
;  :final-checks            557
;  :interface-eqs           152
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             14070
;  :mk-clause               9175
;  :num-allocs              322521
;  :num-checks              155
;  :propagations            4168
;  :quant-instantiations    1956
;  :rlimit-count            697782)
(assert (< i2@56@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 7
; Joined path conditions
(assert (< i2@56@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 6
(declare-fun inv@58@01 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@57@01 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@56@01 Int)) (!
  (and
    (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)
    (< i2@56@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@56@01))
  :qid |option$array$-aux|)))
(push) ; 6
(assert (not (forall ((i2@56@01 Int)) (!
  (implies
    (and (< i2@56@01 V@11@01) (<= 0 i2@56@01))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@57@01)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@57@01))))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10194
;  :arith-add-rows          3335
;  :arith-assert-diseq      107
;  :arith-assert-lower      2234
;  :arith-assert-upper      1870
;  :arith-bound-prop        185
;  :arith-conflicts         232
;  :arith-eq-adapter        518
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           466
;  :arith-ineq-splits       3
;  :arith-max-min           2593
;  :arith-nonlinear-bounds  268
;  :arith-nonlinear-horner  388
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            697
;  :conflicts               585
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 1345
;  :datatype-occurs-check   739
;  :datatype-splits         1079
;  :decisions               3376
;  :del-clause              9162
;  :final-checks            558
;  :interface-eqs           152
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             14096
;  :mk-clause               9195
;  :num-allocs              323126
;  :num-checks              156
;  :propagations            4178
;  :quant-instantiations    1962
;  :rlimit-count            698999)
(declare-const sm@59@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r))
  :qid |qp.fvfValDef20|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r))
  :qid |qp.fvfValDef21|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef22|)))
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((i21@56@01 Int) (i22@56@01 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< i21@56@01 V@11@01) (<= 0 i21@56@01))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i21@56@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i21@56@01)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@57@01)))
      (and
        (and
          (and (< i22@56@01 V@11@01) (<= 0 i22@56@01))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i22@56@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i22@56@01)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@57@01)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i21@56@01)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i22@56@01)))
    (= i21@56@01 i22@56@01))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10209
;  :arith-add-rows          3341
;  :arith-assert-diseq      108
;  :arith-assert-lower      2239
;  :arith-assert-upper      1870
;  :arith-bound-prop        185
;  :arith-conflicts         232
;  :arith-eq-adapter        519
;  :arith-fixed-eqs         337
;  :arith-gcd-tests         3
;  :arith-grobner           466
;  :arith-ineq-splits       3
;  :arith-max-min           2593
;  :arith-nonlinear-bounds  268
;  :arith-nonlinear-horner  388
;  :arith-offset-eqs        607
;  :arith-patches           3
;  :arith-pivots            697
;  :conflicts               586
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 1345
;  :datatype-occurs-check   739
;  :datatype-splits         1079
;  :decisions               3376
;  :del-clause              9181
;  :final-checks            558
;  :interface-eqs           152
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.67
;  :minimized-lits          4
;  :mk-bool-var             14137
;  :mk-clause               9216
;  :num-allocs              324088
;  :num-checks              157
;  :propagations            4184
;  :quant-instantiations    1980
;  :rlimit-count            701551)
; Definitional axioms for inverse functions
(assert (forall ((i2@56@01 Int)) (!
  (implies
    (and
      (and (< i2@56@01 V@11@01) (<= 0 i2@56@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@57@01)))
    (=
      (inv@58@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@56@01))
      i2@56@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@56@01))
  :qid |option$array$-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@58@01 r) V@11@01) (<= 0 (inv@58@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@57@01)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) (inv@58@01 r))
      r))
  :pattern ((inv@58@01 r))
  :qid |option$array$-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@58@01 r) V@11@01) (<= 0 (inv@58@01 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) r) r))
  :pattern ((inv@58@01 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@60@01 ((r $Ref)) $Perm
  (ite
    (and (< (inv@58@01 r) V@11@01) (<= 0 (inv@58@01 r)))
    ($Perm.min
      (ite
        (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01)
        $Perm.No)
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@57@01))
    $Perm.No))
(define-fun pTaken@61@01 ((r $Ref)) $Perm
  (ite
    (and (< (inv@58@01 r) V@11@01) (<= 0 (inv@58@01 r)))
    ($Perm.min
      (ite
        (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01)
        $Perm.No)
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@57@01)
        (pTaken@60@01 r)))
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Constrain original permissions scale(_, V@11@01 * V@11@01 * W) * $k@57@01
(assert (forall ((r $Ref)) (!
  (implies
    (not
      (=
        (ite
          (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@16@01)
          $Perm.No)
        $Perm.No))
    (ite
      (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
      (<
        (ite
          (and (< (inv@58@01 r) V@11@01) (<= 0 (inv@58@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@57@01)
          $Perm.No)
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@16@01))
      (<
        (ite
          (and (< (inv@58@01 r) V@11@01) (<= 0 (inv@58@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@57@01)
          $Perm.No)
        $Perm.No)))
  :pattern ((inv@17@01 r))
  :pattern ((inv@58@01 r))
  :qid |qp.srp23|)))
; Intermediate check if already taken enough permissions
(set-option :timeout 500)
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@58@01 r) V@11@01) (<= 0 (inv@58@01 r)))
    (=
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@57@01)
        (pTaken@60@01 r))
      $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10329
;  :arith-add-rows          3433
;  :arith-assert-diseq      126
;  :arith-assert-lower      2290
;  :arith-assert-upper      1914
;  :arith-bound-prop        191
;  :arith-conflicts         236
;  :arith-eq-adapter        552
;  :arith-fixed-eqs         346
;  :arith-gcd-tests         3
;  :arith-grobner           482
;  :arith-ineq-splits       3
;  :arith-max-min           2641
;  :arith-nonlinear-bounds  269
;  :arith-nonlinear-horner  401
;  :arith-offset-eqs        611
;  :arith-patches           3
;  :arith-pivots            724
;  :conflicts               597
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1351
;  :datatype-occurs-check   744
;  :datatype-splits         1085
;  :decisions               3409
;  :del-clause              9364
;  :final-checks            565
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          6
;  :mk-bool-var             14378
;  :mk-clause               9406
;  :num-allocs              328471
;  :num-checks              159
;  :propagations            4289
;  :quant-instantiations    2034
;  :rlimit-count            715392
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 90 | True | live]
; [else-branch: 90 | False | live]
(push) ; 7
; [then-branch: 90 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 90 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10371
;  :arith-add-rows          3460
;  :arith-assert-diseq      132
;  :arith-assert-lower      2323
;  :arith-assert-upper      1936
;  :arith-bound-prop        192
;  :arith-conflicts         236
;  :arith-eq-adapter        559
;  :arith-fixed-eqs         349
;  :arith-gcd-tests         3
;  :arith-grobner           522
;  :arith-ineq-splits       3
;  :arith-max-min           2689
;  :arith-nonlinear-bounds  271
;  :arith-nonlinear-horner  437
;  :arith-offset-eqs        616
;  :arith-patches           3
;  :arith-pivots            733
;  :conflicts               599
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 1357
;  :datatype-occurs-check   748
;  :datatype-splits         1091
;  :decisions               3429
;  :del-clause              9414
;  :final-checks            570
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          7
;  :mk-bool-var             14439
;  :mk-clause               9456
;  :num-allocs              333647
;  :num-checks              160
;  :propagations            4309
;  :quant-instantiations    2044
;  :rlimit-count            741257
;  :time                    0.01)
; [then-branch: 91 | 0 < V@11@01 | live]
; [else-branch: 91 | !(0 < V@11@01) | dead]
(push) ; 7
; [then-branch: 91 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
(declare-const i2@62@01 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 92 | 0 <= i2@62@01 | live]
; [else-branch: 92 | !(0 <= i2@62@01) | live]
(push) ; 10
; [then-branch: 92 | 0 <= i2@62@01]
(assert (<= 0 i2@62@01))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 92 | !(0 <= i2@62@01)]
(assert (not (<= 0 i2@62@01)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 93 | i2@62@01 < V@11@01 && 0 <= i2@62@01 | live]
; [else-branch: 93 | !(i2@62@01 < V@11@01 && 0 <= i2@62@01) | live]
(push) ; 10
; [then-branch: 93 | i2@62@01 < V@11@01 && 0 <= i2@62@01]
(assert (and (< i2@62@01 V@11@01) (<= 0 i2@62@01)))
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
(assert (not (< i2@62@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10371
;  :arith-add-rows          3463
;  :arith-assert-diseq      132
;  :arith-assert-lower      2325
;  :arith-assert-upper      1937
;  :arith-bound-prop        192
;  :arith-conflicts         237
;  :arith-eq-adapter        559
;  :arith-fixed-eqs         349
;  :arith-gcd-tests         3
;  :arith-grobner           522
;  :arith-ineq-splits       3
;  :arith-max-min           2689
;  :arith-nonlinear-bounds  271
;  :arith-nonlinear-horner  437
;  :arith-offset-eqs        616
;  :arith-patches           3
;  :arith-pivots            734
;  :conflicts               600
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 1357
;  :datatype-occurs-check   748
;  :datatype-splits         1091
;  :decisions               3429
;  :del-clause              9414
;  :final-checks            570
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          7
;  :mk-bool-var             14442
;  :mk-clause               9456
;  :num-allocs              333803
;  :num-checks              161
;  :propagations            4309
;  :quant-instantiations    2044
;  :rlimit-count            741540)
(assert (< i2@62@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 11
; Joined path conditions
(assert (< i2@62@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10450
;  :arith-add-rows          3552
;  :arith-assert-diseq      144
;  :arith-assert-lower      2359
;  :arith-assert-upper      1952
;  :arith-bound-prop        196
;  :arith-conflicts         240
;  :arith-eq-adapter        578
;  :arith-fixed-eqs         357
;  :arith-gcd-tests         3
;  :arith-grobner           522
;  :arith-ineq-splits       3
;  :arith-max-min           2689
;  :arith-nonlinear-bounds  271
;  :arith-nonlinear-horner  437
;  :arith-offset-eqs        620
;  :arith-patches           3
;  :arith-pivots            752
;  :conflicts               614
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 1357
;  :datatype-occurs-check   748
;  :datatype-splits         1091
;  :decisions               3455
;  :del-clause              9489
;  :final-checks            570
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          8
;  :mk-bool-var             14628
;  :mk-clause               9587
;  :num-allocs              334654
;  :num-checks              162
;  :propagations            4375
;  :quant-instantiations    2084
;  :rlimit-count            745920
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 10
(push) ; 10
; [else-branch: 93 | !(i2@62@01 < V@11@01 && 0 <= i2@62@01)]
(assert (not (and (< i2@62@01 V@11@01) (<= 0 i2@62@01))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@62@01 V@11@01) (<= 0 i2@62@01))
  (and
    (< i2@62@01 V@11@01)
    (<= 0 i2@62@01)
    (< i2@62@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@62@01 Int)) (!
  (implies
    (and (< i2@62@01 V@11@01) (<= 0 i2@62@01))
    (and
      (< i2@62@01 V@11@01)
      (<= 0 i2@62@01)
      (< i2@62@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@62@01 Int)) (!
    (implies
      (and (< i2@62@01 V@11@01) (<= 0 i2@62@01))
      (and
        (< i2@62@01 V@11@01)
        (<= 0 i2@62@01)
        (< i2@62@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (< 0 V@11@01)
  (forall ((i2@62@01 Int)) (!
    (implies
      (and (< i2@62@01 V@11@01) (<= 0 i2@62@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10495
;  :arith-add-rows          3593
;  :arith-assert-diseq      150
;  :arith-assert-lower      2373
;  :arith-assert-upper      1960
;  :arith-bound-prop        198
;  :arith-conflicts         241
;  :arith-eq-adapter        587
;  :arith-fixed-eqs         361
;  :arith-gcd-tests         3
;  :arith-grobner           522
;  :arith-ineq-splits       3
;  :arith-max-min           2689
;  :arith-nonlinear-bounds  271
;  :arith-nonlinear-horner  437
;  :arith-offset-eqs        625
;  :arith-patches           3
;  :arith-pivots            762
;  :conflicts               625
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 1357
;  :datatype-occurs-check   748
;  :datatype-splits         1091
;  :decisions               3470
;  :del-clause              9661
;  :final-checks            570
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          9
;  :mk-bool-var             14766
;  :mk-clause               9705
;  :num-allocs              335512
;  :num-checks              163
;  :propagations            4420
;  :quant-instantiations    2125
;  :rlimit-count            749331
;  :time                    0.00)
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@62@01 Int)) (!
    (implies
      (and (< i2@62@01 V@11@01) (<= 0 i2@62@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@62@01))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 94 | True | live]
; [else-branch: 94 | False | live]
(push) ; 7
; [then-branch: 94 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 94 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          3607
;  :arith-assert-diseq      156
;  :arith-assert-lower      2406
;  :arith-assert-upper      1983
;  :arith-bound-prop        200
;  :arith-conflicts         241
;  :arith-eq-adapter        594
;  :arith-fixed-eqs         364
;  :arith-gcd-tests         3
;  :arith-grobner           562
;  :arith-ineq-splits       3
;  :arith-max-min           2737
;  :arith-nonlinear-bounds  273
;  :arith-nonlinear-horner  473
;  :arith-offset-eqs        627
;  :arith-patches           3
;  :arith-pivots            770
;  :conflicts               627
;  :datatype-accessor-ax    359
;  :datatype-constructor-ax 1363
;  :datatype-occurs-check   752
;  :datatype-splits         1097
;  :decisions               3490
;  :del-clause              9712
;  :final-checks            575
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.69
;  :minimized-lits          10
;  :mk-bool-var             14829
;  :mk-clause               9756
;  :num-allocs              341145
;  :num-checks              164
;  :propagations            4440
;  :quant-instantiations    2135
;  :rlimit-count            775863
;  :time                    0.01)
; [then-branch: 95 | 0 < V@11@01 | live]
; [else-branch: 95 | !(0 < V@11@01) | dead]
(push) ; 7
; [then-branch: 95 | 0 < V@11@01]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
(declare-const i2@63@01 Int)
(push) ; 8
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 9
; [then-branch: 96 | 0 <= i2@63@01 | live]
; [else-branch: 96 | !(0 <= i2@63@01) | live]
(push) ; 10
; [then-branch: 96 | 0 <= i2@63@01]
(assert (<= 0 i2@63@01))
; [eval] i2 < V
(pop) ; 10
(push) ; 10
; [else-branch: 96 | !(0 <= i2@63@01)]
(assert (not (<= 0 i2@63@01)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 97 | i2@63@01 < V@11@01 && 0 <= i2@63@01 | live]
; [else-branch: 97 | !(i2@63@01 < V@11@01 && 0 <= i2@63@01) | live]
(push) ; 10
; [then-branch: 97 | i2@63@01 < V@11@01 && 0 <= i2@63@01]
(assert (and (< i2@63@01 V@11@01) (<= 0 i2@63@01)))
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
(assert (not (< i2@63@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          3610
;  :arith-assert-diseq      156
;  :arith-assert-lower      2408
;  :arith-assert-upper      1984
;  :arith-bound-prop        200
;  :arith-conflicts         242
;  :arith-eq-adapter        594
;  :arith-fixed-eqs         364
;  :arith-gcd-tests         3
;  :arith-grobner           562
;  :arith-ineq-splits       3
;  :arith-max-min           2737
;  :arith-nonlinear-bounds  273
;  :arith-nonlinear-horner  473
;  :arith-offset-eqs        627
;  :arith-patches           3
;  :arith-pivots            771
;  :conflicts               628
;  :datatype-accessor-ax    359
;  :datatype-constructor-ax 1363
;  :datatype-occurs-check   752
;  :datatype-splits         1097
;  :decisions               3490
;  :del-clause              9712
;  :final-checks            575
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.75
;  :memory                  5.68
;  :minimized-lits          10
;  :mk-bool-var             14832
;  :mk-clause               9756
;  :num-allocs              341301
;  :num-checks              165
;  :propagations            4440
;  :quant-instantiations    2135
;  :rlimit-count            776144)
(assert (< i2@63@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 11
; Joined path conditions
(assert (< i2@63@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10609
;  :arith-add-rows          3644
;  :arith-assert-diseq      166
;  :arith-assert-lower      2430
;  :arith-assert-upper      2001
;  :arith-bound-prop        203
;  :arith-conflicts         245
;  :arith-eq-adapter        612
;  :arith-fixed-eqs         371
;  :arith-gcd-tests         3
;  :arith-grobner           562
;  :arith-ineq-splits       3
;  :arith-max-min           2737
;  :arith-nonlinear-bounds  273
;  :arith-nonlinear-horner  473
;  :arith-offset-eqs        633
;  :arith-patches           3
;  :arith-pivots            784
;  :conflicts               643
;  :datatype-accessor-ax    359
;  :datatype-constructor-ax 1363
;  :datatype-occurs-check   752
;  :datatype-splits         1097
;  :decisions               3509
;  :del-clause              9782
;  :final-checks            575
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.76
;  :minimized-lits          11
;  :mk-bool-var             15002
;  :mk-clause               9882
;  :num-allocs              342053
;  :num-checks              166
;  :propagations            4501
;  :quant-instantiations    2179
;  :rlimit-count            779477
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 12
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10609
;  :arith-add-rows          3644
;  :arith-assert-diseq      166
;  :arith-assert-lower      2430
;  :arith-assert-upper      2001
;  :arith-bound-prop        203
;  :arith-conflicts         245
;  :arith-eq-adapter        612
;  :arith-fixed-eqs         371
;  :arith-gcd-tests         3
;  :arith-grobner           562
;  :arith-ineq-splits       3
;  :arith-max-min           2737
;  :arith-nonlinear-bounds  273
;  :arith-nonlinear-horner  473
;  :arith-offset-eqs        633
;  :arith-patches           3
;  :arith-pivots            784
;  :conflicts               644
;  :datatype-accessor-ax    359
;  :datatype-constructor-ax 1363
;  :datatype-occurs-check   752
;  :datatype-splits         1097
;  :decisions               3509
;  :del-clause              9782
;  :final-checks            575
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.76
;  :minimized-lits          11
;  :mk-bool-var             15002
;  :mk-clause               9882
;  :num-allocs              342148
;  :num-checks              167
;  :propagations            4501
;  :quant-instantiations    2179
;  :rlimit-count            779572)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
    (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
    (as None<option<array>>  option<array>))))
(pop) ; 10
(push) ; 10
; [else-branch: 97 | !(i2@63@01 < V@11@01 && 0 <= i2@63@01)]
(assert (not (and (< i2@63@01 V@11@01) (<= 0 i2@63@01))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i2@63@01 V@11@01) (<= 0 i2@63@01))
  (and
    (< i2@63@01 V@11@01)
    (<= 0 i2@63@01)
    (< i2@63@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@63@01 Int)) (!
  (implies
    (and (< i2@63@01 V@11@01) (<= 0 i2@63@01))
    (and
      (< i2@63@01 V@11@01)
      (<= 0 i2@63@01)
      (< i2@63@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@63@01 Int)) (!
    (implies
      (and (< i2@63@01 V@11@01) (<= 0 i2@63@01))
      (and
        (< i2@63@01 V@11@01)
        (<= 0 i2@63@01)
        (< i2@63@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)))))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (< 0 V@11@01)
  (forall ((i2@63@01 Int)) (!
    (implies
      (and (< i2@63@01 V@11@01) (<= 0 i2@63@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)))))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10663
;  :arith-add-rows          3666
;  :arith-assert-diseq      174
;  :arith-assert-lower      2447
;  :arith-assert-upper      2011
;  :arith-bound-prop        206
;  :arith-conflicts         246
;  :arith-eq-adapter        622
;  :arith-fixed-eqs         375
;  :arith-gcd-tests         3
;  :arith-grobner           562
;  :arith-ineq-splits       3
;  :arith-max-min           2737
;  :arith-nonlinear-bounds  273
;  :arith-nonlinear-horner  473
;  :arith-offset-eqs        635
;  :arith-patches           3
;  :arith-pivots            792
;  :conflicts               656
;  :datatype-accessor-ax    359
;  :datatype-constructor-ax 1363
;  :datatype-occurs-check   752
;  :datatype-splits         1097
;  :decisions               3529
;  :del-clause              9964
;  :final-checks            575
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.77
;  :minimized-lits          12
;  :mk-bool-var             15155
;  :mk-clause               10010
;  :num-allocs              343079
;  :num-checks              168
;  :propagations            4549
;  :quant-instantiations    2230
;  :rlimit-count            783154
;  :time                    0.00)
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@63@01 Int)) (!
    (implies
      (and (< i2@63@01 V@11@01) (<= 0 i2@63@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@63@01)))))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 98 | True | live]
; [else-branch: 98 | False | live]
(push) ; 7
; [then-branch: 98 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 98 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10702
;  :arith-add-rows          3683
;  :arith-assert-diseq      180
;  :arith-assert-lower      2480
;  :arith-assert-upper      2032
;  :arith-bound-prop        208
;  :arith-conflicts         246
;  :arith-eq-adapter        629
;  :arith-fixed-eqs         378
;  :arith-gcd-tests         3
;  :arith-grobner           602
;  :arith-ineq-splits       3
;  :arith-max-min           2785
;  :arith-nonlinear-bounds  276
;  :arith-nonlinear-horner  509
;  :arith-offset-eqs        637
;  :arith-patches           3
;  :arith-pivots            802
;  :conflicts               658
;  :datatype-accessor-ax    360
;  :datatype-constructor-ax 1369
;  :datatype-occurs-check   756
;  :datatype-splits         1103
;  :decisions               3549
;  :del-clause              10015
;  :final-checks            580
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.78
;  :minimized-lits          13
;  :mk-bool-var             15218
;  :mk-clause               10061
;  :num-allocs              348714
;  :num-checks              169
;  :propagations            4569
;  :quant-instantiations    2240
;  :rlimit-count            809792
;  :time                    0.01)
; [then-branch: 99 | 0 < V@11@01 | live]
; [else-branch: 99 | !(0 < V@11@01) | dead]
(push) ; 7
; [then-branch: 99 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
(declare-const i2@64@01 Int)
(push) ; 8
; [eval] (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3)
(declare-const i3@65@01 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 100 | 0 <= i2@64@01 | live]
; [else-branch: 100 | !(0 <= i2@64@01) | live]
(push) ; 11
; [then-branch: 100 | 0 <= i2@64@01]
(assert (<= 0 i2@64@01))
; [eval] i2 < V
(push) ; 12
; [then-branch: 101 | i2@64@01 < V@11@01 | live]
; [else-branch: 101 | !(i2@64@01 < V@11@01) | live]
(push) ; 13
; [then-branch: 101 | i2@64@01 < V@11@01]
(assert (< i2@64@01 V@11@01))
; [eval] 0 <= i3
(push) ; 14
; [then-branch: 102 | 0 <= i3@65@01 | live]
; [else-branch: 102 | !(0 <= i3@65@01) | live]
(push) ; 15
; [then-branch: 102 | 0 <= i3@65@01]
(assert (<= 0 i3@65@01))
; [eval] i3 < V
(push) ; 16
; [then-branch: 103 | i3@65@01 < V@11@01 | live]
; [else-branch: 103 | !(i3@65@01 < V@11@01) | live]
(push) ; 17
; [then-branch: 103 | i3@65@01 < V@11@01]
(assert (< i3@65@01 V@11@01))
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
(assert (not (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10702
;  :arith-add-rows          3687
;  :arith-assert-diseq      180
;  :arith-assert-lower      2484
;  :arith-assert-upper      2033
;  :arith-bound-prop        208
;  :arith-conflicts         247
;  :arith-eq-adapter        629
;  :arith-fixed-eqs         378
;  :arith-gcd-tests         3
;  :arith-grobner           602
;  :arith-ineq-splits       3
;  :arith-max-min           2785
;  :arith-nonlinear-bounds  276
;  :arith-nonlinear-horner  509
;  :arith-offset-eqs        637
;  :arith-patches           3
;  :arith-pivots            803
;  :conflicts               659
;  :datatype-accessor-ax    360
;  :datatype-constructor-ax 1369
;  :datatype-occurs-check   756
;  :datatype-splits         1103
;  :decisions               3549
;  :del-clause              10015
;  :final-checks            580
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.77
;  :minimized-lits          13
;  :mk-bool-var             15223
;  :mk-clause               10061
;  :num-allocs              349047
;  :num-checks              170
;  :propagations            4569
;  :quant-instantiations    2240
;  :rlimit-count            810219)
(assert (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 18
; Joined path conditions
(assert (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)))
(push) ; 18
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10777
;  :arith-add-rows          3729
;  :arith-assert-diseq      190
;  :arith-assert-lower      2506
;  :arith-assert-upper      2050
;  :arith-bound-prop        211
;  :arith-conflicts         250
;  :arith-eq-adapter        647
;  :arith-fixed-eqs         385
;  :arith-gcd-tests         3
;  :arith-grobner           602
;  :arith-ineq-splits       3
;  :arith-max-min           2785
;  :arith-nonlinear-bounds  276
;  :arith-nonlinear-horner  509
;  :arith-offset-eqs        643
;  :arith-patches           3
;  :arith-pivots            815
;  :conflicts               674
;  :datatype-accessor-ax    360
;  :datatype-constructor-ax 1369
;  :datatype-occurs-check   756
;  :datatype-splits         1103
;  :decisions               3568
;  :del-clause              10085
;  :final-checks            580
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.78
;  :minimized-lits          14
;  :mk-bool-var             15393
;  :mk-clause               10187
;  :num-allocs              349800
;  :num-checks              171
;  :propagations            4630
;  :quant-instantiations    2284
;  :rlimit-count            813697
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
(assert (not (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10777
;  :arith-add-rows          3732
;  :arith-assert-diseq      190
;  :arith-assert-lower      2506
;  :arith-assert-upper      2051
;  :arith-bound-prop        211
;  :arith-conflicts         251
;  :arith-eq-adapter        647
;  :arith-fixed-eqs         385
;  :arith-gcd-tests         3
;  :arith-grobner           602
;  :arith-ineq-splits       3
;  :arith-max-min           2785
;  :arith-nonlinear-bounds  276
;  :arith-nonlinear-horner  509
;  :arith-offset-eqs        643
;  :arith-patches           3
;  :arith-pivots            817
;  :conflicts               675
;  :datatype-accessor-ax    360
;  :datatype-constructor-ax 1369
;  :datatype-occurs-check   756
;  :datatype-splits         1103
;  :decisions               3568
;  :del-clause              10085
;  :final-checks            580
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.78
;  :minimized-lits          14
;  :mk-bool-var             15394
;  :mk-clause               10187
;  :num-allocs              349885
;  :num-checks              172
;  :propagations            4630
;  :quant-instantiations    2284
;  :rlimit-count            813854)
(assert (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 18
; Joined path conditions
(assert (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
(push) ; 18
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10874
;  :arith-add-rows          3778
;  :arith-assert-diseq      203
;  :arith-assert-lower      2535
;  :arith-assert-upper      2070
;  :arith-bound-prop        218
;  :arith-conflicts         255
;  :arith-eq-adapter        666
;  :arith-fixed-eqs         392
;  :arith-gcd-tests         3
;  :arith-grobner           602
;  :arith-ineq-splits       3
;  :arith-max-min           2785
;  :arith-nonlinear-bounds  276
;  :arith-nonlinear-horner  509
;  :arith-offset-eqs        648
;  :arith-patches           3
;  :arith-pivots            826
;  :conflicts               696
;  :datatype-accessor-ax    360
;  :datatype-constructor-ax 1369
;  :datatype-occurs-check   756
;  :datatype-splits         1103
;  :decisions               3593
;  :del-clause              10172
;  :final-checks            580
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.84
;  :memory                  5.80
;  :minimized-lits          15
;  :mk-bool-var             15627
;  :mk-clause               10350
;  :num-allocs              350808
;  :num-checks              173
;  :propagations            4713
;  :quant-instantiations    2333
;  :rlimit-count            817896
;  :time                    0.00)
(pop) ; 17
(push) ; 17
; [else-branch: 103 | !(i3@65@01 < V@11@01)]
(assert (not (< i3@65@01 V@11@01)))
(pop) ; 17
(pop) ; 16
; Joined path conditions
(assert (implies
  (< i3@65@01 V@11@01)
  (and
    (< i3@65@01 V@11@01)
    (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
    (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))))
; Joined path conditions
(pop) ; 15
(push) ; 15
; [else-branch: 102 | !(0 <= i3@65@01)]
(assert (not (<= 0 i3@65@01)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (<= 0 i3@65@01)
  (and
    (<= 0 i3@65@01)
    (implies
      (< i3@65@01 V@11@01)
      (and
        (< i3@65@01 V@11@01)
        (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
        (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 101 | !(i2@64@01 < V@11@01)]
(assert (not (< i2@64@01 V@11@01)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (< i2@64@01 V@11@01)
  (and
    (< i2@64@01 V@11@01)
    (implies
      (<= 0 i3@65@01)
      (and
        (<= 0 i3@65@01)
        (implies
          (< i3@65@01 V@11@01)
          (and
            (< i3@65@01 V@11@01)
            (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
            (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 100 | !(0 <= i2@64@01)]
(assert (not (<= 0 i2@64@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (<= 0 i2@64@01)
  (and
    (<= 0 i2@64@01)
    (implies
      (< i2@64@01 V@11@01)
      (and
        (< i2@64@01 V@11@01)
        (implies
          (<= 0 i3@65@01)
          (and
            (<= 0 i3@65@01)
            (implies
              (< i3@65@01 V@11@01)
              (and
                (< i3@65@01 V@11@01)
                (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))))))))))
; Joined path conditions
(push) ; 10
; [then-branch: 104 | Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i2@64@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i3@65@01)) && i3@65@01 < V@11@01 && 0 <= i3@65@01 && i2@64@01 < V@11@01 && 0 <= i2@64@01 | live]
; [else-branch: 104 | !(Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i2@64@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i3@65@01)) && i3@65@01 < V@11@01 && 0 <= i3@65@01 && i2@64@01 < V@11@01 && 0 <= i2@64@01) | live]
(push) ; 11
; [then-branch: 104 | Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i2@64@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i3@65@01)) && i3@65@01 < V@11@01 && 0 <= i3@65@01 && i2@64@01 < V@11@01 && 0 <= i2@64@01]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
        (< i3@65@01 V@11@01))
      (<= 0 i3@65@01))
    (< i2@64@01 V@11@01))
  (<= 0 i2@64@01)))
; [eval] i2 == i3
(pop) ; 11
(push) ; 11
; [else-branch: 104 | !(Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i2@64@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, source@9@01), i3@65@01)) && i3@65@01 < V@11@01 && 0 <= i3@65@01 && i2@64@01 < V@11@01 && 0 <= i2@64@01)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
          (< i3@65@01 V@11@01))
        (<= 0 i3@65@01))
      (< i2@64@01 V@11@01))
    (<= 0 i2@64@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
          (< i3@65@01 V@11@01))
        (<= 0 i3@65@01))
      (< i2@64@01 V@11@01))
    (<= 0 i2@64@01))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
      ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
    (< i3@65@01 V@11@01)
    (<= 0 i3@65@01)
    (< i2@64@01 V@11@01)
    (<= 0 i2@64@01))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@65@01 Int)) (!
  (and
    (implies
      (<= 0 i2@64@01)
      (and
        (<= 0 i2@64@01)
        (implies
          (< i2@64@01 V@11@01)
          (and
            (< i2@64@01 V@11@01)
            (implies
              (<= 0 i3@65@01)
              (and
                (<= 0 i3@65@01)
                (implies
                  (< i3@65@01 V@11@01)
                  (and
                    (< i3@65@01 V@11@01)
                    (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                    (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
              (< i3@65@01 V@11@01))
            (<= 0 i3@65@01))
          (< i2@64@01 V@11@01))
        (<= 0 i2@64@01))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
        (< i3@65@01 V@11@01)
        (<= 0 i3@65@01)
        (< i2@64@01 V@11@01)
        (<= 0 i2@64@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@64@01 Int)) (!
  (forall ((i3@65@01 Int)) (!
    (and
      (implies
        (<= 0 i2@64@01)
        (and
          (<= 0 i2@64@01)
          (implies
            (< i2@64@01 V@11@01)
            (and
              (< i2@64@01 V@11@01)
              (implies
                (<= 0 i3@65@01)
                (and
                  (<= 0 i3@65@01)
                  (implies
                    (< i3@65@01 V@11@01)
                    (and
                      (< i3@65@01 V@11@01)
                      (< i2@64@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                      (< i3@65@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
                (< i3@65@01 V@11@01))
              (<= 0 i3@65@01))
            (< i2@64@01 V@11@01))
          (<= 0 i2@64@01))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
          (< i3@65@01 V@11@01)
          (<= 0 i3@65@01)
          (< i2@64@01 V@11@01)
          (<= 0 i2@64@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@64@01 Int)) (!
    (forall ((i3@65@01 Int)) (!
      (and
        (implies
          (<= 0 i2@64@01)
          (and
            (<= 0 i2@64@01)
            (implies
              (< i2@64@01 V@11@01)
              (and
                (< i2@64@01 V@11@01)
                (implies
                  (<= 0 i3@65@01)
                  (and
                    (<= 0 i3@65@01)
                    (implies
                      (< i3@65@01 V@11@01)
                      (and
                        (< i3@65@01 V@11@01)
                        (<
                          i2@64@01
                          (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                        (<
                          i3@65@01
                          (alen<Int> (opt_get1 $Snap.unit source@9@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
                  (< i3@65@01 V@11@01))
                (<= 0 i3@65@01))
              (< i2@64@01 V@11@01))
            (<= 0 i2@64@01))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
              ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
            (< i3@65@01 V@11@01)
            (<= 0 i3@65@01)
            (< i2@64@01 V@11@01)
            (<= 0 i2@64@01))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (< 0 V@11@01)
  (forall ((i2@64@01 Int)) (!
    (forall ((i3@65@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
                (< i3@65@01 V@11@01))
              (<= 0 i3@65@01))
            (< i2@64@01 V@11@01))
          (<= 0 i2@64@01))
        (= i2@64@01 i3@65@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10947
;  :arith-add-rows          3842
;  :arith-assert-diseq      210
;  :arith-assert-lower      2556
;  :arith-assert-upper      2081
;  :arith-bound-prop        222
;  :arith-conflicts         257
;  :arith-eq-adapter        678
;  :arith-fixed-eqs         397
;  :arith-gcd-tests         3
;  :arith-grobner           602
;  :arith-ineq-splits       3
;  :arith-max-min           2785
;  :arith-nonlinear-bounds  276
;  :arith-nonlinear-horner  509
;  :arith-offset-eqs        656
;  :arith-patches           3
;  :arith-pivots            841
;  :conflicts               710
;  :datatype-accessor-ax    360
;  :datatype-constructor-ax 1369
;  :datatype-occurs-check   756
;  :datatype-splits         1103
;  :decisions               3611
;  :del-clause              10546
;  :final-checks            580
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.85
;  :memory                  5.84
;  :minimized-lits          16
;  :mk-bool-var             15943
;  :mk-clause               10592
;  :num-allocs              352770
;  :num-checks              174
;  :propagations            4796
;  :quant-instantiations    2420
;  :rlimit-count            826261
;  :time                    0.00)
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@64@01 Int)) (!
    (forall ((i3@65@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01)))
                (< i3@65@01 V@11@01))
              (<= 0 i3@65@01))
            (< i2@64@01 V@11@01))
          (<= 0 i2@64@01))
        (= i2@64@01 i3@65@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i3@65@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i2@64@01))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 105 | True | live]
; [else-branch: 105 | False | live]
(push) ; 7
; [then-branch: 105 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 105 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10986
;  :arith-add-rows          3856
;  :arith-assert-diseq      216
;  :arith-assert-lower      2589
;  :arith-assert-upper      2104
;  :arith-bound-prop        224
;  :arith-conflicts         257
;  :arith-eq-adapter        685
;  :arith-fixed-eqs         400
;  :arith-gcd-tests         3
;  :arith-grobner           642
;  :arith-ineq-splits       3
;  :arith-max-min           2833
;  :arith-nonlinear-bounds  278
;  :arith-nonlinear-horner  545
;  :arith-offset-eqs        658
;  :arith-patches           3
;  :arith-pivots            849
;  :conflicts               712
;  :datatype-accessor-ax    361
;  :datatype-constructor-ax 1375
;  :datatype-occurs-check   760
;  :datatype-splits         1109
;  :decisions               3631
;  :del-clause              10597
;  :final-checks            585
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.89
;  :memory                  5.85
;  :minimized-lits          17
;  :mk-bool-var             16007
;  :mk-clause               10643
;  :num-allocs              358523
;  :num-checks              175
;  :propagations            4816
;  :quant-instantiations    2431
;  :rlimit-count            853002
;  :time                    0.01)
; [then-branch: 106 | 0 < V@11@01 | live]
; [else-branch: 106 | !(0 < V@11@01) | dead]
(push) ; 7
; [then-branch: 106 | 0 < V@11@01]
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 107 | True | live]
; [else-branch: 107 | False | live]
(push) ; 7
; [then-branch: 107 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 107 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(push) ; 7
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11025
;  :arith-add-rows          3870
;  :arith-assert-diseq      222
;  :arith-assert-lower      2622
;  :arith-assert-upper      2127
;  :arith-bound-prop        226
;  :arith-conflicts         257
;  :arith-eq-adapter        692
;  :arith-fixed-eqs         403
;  :arith-gcd-tests         3
;  :arith-grobner           682
;  :arith-ineq-splits       3
;  :arith-max-min           2881
;  :arith-nonlinear-bounds  280
;  :arith-nonlinear-horner  581
;  :arith-offset-eqs        660
;  :arith-patches           3
;  :arith-pivots            857
;  :conflicts               714
;  :datatype-accessor-ax    362
;  :datatype-constructor-ax 1381
;  :datatype-occurs-check   764
;  :datatype-splits         1115
;  :decisions               3651
;  :del-clause              10648
;  :final-checks            590
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.89
;  :memory                  5.85
;  :minimized-lits          18
;  :mk-bool-var             16069
;  :mk-clause               10694
;  :num-allocs              363904
;  :num-checks              176
;  :propagations            4836
;  :quant-instantiations    2441
;  :rlimit-count            879187
;  :time                    0.01)
; [then-branch: 108 | 0 < V@11@01 | live]
; [else-branch: 108 | !(0 < V@11@01) | dead]
(push) ; 7
; [then-branch: 108 | 0 < V@11@01]
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
; [then-branch: 109 | True | live]
; [else-branch: 109 | False | live]
(push) ; 7
; [then-branch: 109 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 109 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11064
;  :arith-add-rows          3884
;  :arith-assert-diseq      228
;  :arith-assert-lower      2655
;  :arith-assert-upper      2150
;  :arith-bound-prop        228
;  :arith-conflicts         257
;  :arith-eq-adapter        699
;  :arith-fixed-eqs         406
;  :arith-gcd-tests         3
;  :arith-grobner           722
;  :arith-ineq-splits       3
;  :arith-max-min           2929
;  :arith-nonlinear-bounds  282
;  :arith-nonlinear-horner  617
;  :arith-offset-eqs        662
;  :arith-patches           3
;  :arith-pivots            865
;  :conflicts               716
;  :datatype-accessor-ax    363
;  :datatype-constructor-ax 1387
;  :datatype-occurs-check   768
;  :datatype-splits         1121
;  :decisions               3671
;  :del-clause              10699
;  :final-checks            595
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.89
;  :memory                  5.85
;  :minimized-lits          19
;  :mk-bool-var             16131
;  :mk-clause               10745
;  :num-allocs              369285
;  :num-checks              177
;  :propagations            4856
;  :quant-instantiations    2451
;  :rlimit-count            905372
;  :time                    0.01)
; [then-branch: 110 | 0 < V@11@01 | live]
; [else-branch: 110 | !(0 < V@11@01) | dead]
(push) ; 6
; [then-branch: 110 | 0 < V@11@01]
(declare-const i2@66@01 Int)
(push) ; 7
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 8
; [then-branch: 111 | 0 <= i2@66@01 | live]
; [else-branch: 111 | !(0 <= i2@66@01) | live]
(push) ; 9
; [then-branch: 111 | 0 <= i2@66@01]
(assert (<= 0 i2@66@01))
; [eval] i2 < V
(pop) ; 9
(push) ; 9
; [else-branch: 111 | !(0 <= i2@66@01)]
(assert (not (<= 0 i2@66@01)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< i2@66@01 V@11@01) (<= 0 i2@66@01)))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 8
; [eval] amount >= 0 * write
; [eval] 0 * write
(set-option :timeout 0)
(push) ; 9
(assert (not (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11064
;  :arith-add-rows          3885
;  :arith-assert-diseq      228
;  :arith-assert-lower      2657
;  :arith-assert-upper      2150
;  :arith-bound-prop        228
;  :arith-conflicts         257
;  :arith-eq-adapter        699
;  :arith-fixed-eqs         406
;  :arith-gcd-tests         3
;  :arith-grobner           722
;  :arith-ineq-splits       3
;  :arith-max-min           2929
;  :arith-nonlinear-bounds  282
;  :arith-nonlinear-horner  617
;  :arith-offset-eqs        662
;  :arith-patches           3
;  :arith-pivots            865
;  :conflicts               717
;  :datatype-accessor-ax    363
;  :datatype-constructor-ax 1387
;  :datatype-occurs-check   768
;  :datatype-splits         1121
;  :decisions               3671
;  :del-clause              10699
;  :final-checks            595
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.89
;  :memory                  5.85
;  :minimized-lits          19
;  :mk-bool-var             16133
;  :mk-clause               10745
;  :num-allocs              369451
;  :num-checks              178
;  :propagations            4856
;  :quant-instantiations    2451
;  :rlimit-count            905611)
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(pop) ; 8
; Joined path conditions
(assert (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No))
(declare-const $k@67@01 $Perm)
(assert ($Perm.isReadVar $k@67@01 $Perm.Write))
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
(assert (not (< i2@66@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11064
;  :arith-add-rows          3885
;  :arith-assert-diseq      229
;  :arith-assert-lower      2659
;  :arith-assert-upper      2151
;  :arith-bound-prop        228
;  :arith-conflicts         257
;  :arith-eq-adapter        700
;  :arith-fixed-eqs         406
;  :arith-gcd-tests         3
;  :arith-grobner           722
;  :arith-ineq-splits       3
;  :arith-max-min           2929
;  :arith-nonlinear-bounds  282
;  :arith-nonlinear-horner  617
;  :arith-offset-eqs        662
;  :arith-patches           3
;  :arith-pivots            865
;  :conflicts               717
;  :datatype-accessor-ax    363
;  :datatype-constructor-ax 1387
;  :datatype-occurs-check   768
;  :datatype-splits         1121
;  :decisions               3671
;  :del-clause              10699
;  :final-checks            595
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.89
;  :memory                  5.85
;  :minimized-lits          19
;  :mk-bool-var             16137
;  :mk-clause               10747
;  :num-allocs              369646
;  :num-checks              179
;  :propagations            4857
;  :quant-instantiations    2451
;  :rlimit-count            905856)
(assert (< i2@66@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 8
; Joined path conditions
(assert (< i2@66@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 7
(declare-fun inv@68@01 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@67@01 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i2@66@01 Int)) (!
  (and
    (>= (* (to_real (* V@11@01 V@11@01)) $Perm.Write) $Perm.No)
    (< i2@66@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@66@01))
  :qid |option$array$-aux|)))
(push) ; 7
(assert (not (forall ((i2@66@01 Int)) (!
  (implies
    (and (< i2@66@01 V@11@01) (<= 0 i2@66@01))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@67@01)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@67@01))))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11086
;  :arith-add-rows          3893
;  :arith-assert-diseq      237
;  :arith-assert-lower      2686
;  :arith-assert-upper      2166
;  :arith-bound-prop        229
;  :arith-conflicts         258
;  :arith-eq-adapter        709
;  :arith-fixed-eqs         409
;  :arith-gcd-tests         3
;  :arith-grobner           722
;  :arith-ineq-splits       3
;  :arith-max-min           2948
;  :arith-nonlinear-bounds  285
;  :arith-nonlinear-horner  617
;  :arith-offset-eqs        664
;  :arith-patches           3
;  :arith-pivots            871
;  :conflicts               720
;  :datatype-accessor-ax    363
;  :datatype-constructor-ax 1387
;  :datatype-occurs-check   768
;  :datatype-splits         1121
;  :decisions               3686
;  :del-clause              10753
;  :final-checks            596
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.89
;  :memory                  5.84
;  :minimized-lits          20
;  :mk-bool-var             16203
;  :mk-clause               10801
;  :num-allocs              370323
;  :num-checks              180
;  :propagations            4878
;  :quant-instantiations    2462
;  :rlimit-count            907558
;  :time                    0.00)
(declare-const sm@69@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r))
  :qid |qp.fvfValDef24|)))
(assert (forall ((r $Ref)) (!
  (implies
    (<
      $Perm.No
      (-
        (ite
          (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@16@01)
          $Perm.No)
        (pTaken@60@01 r)))
    (=
      ($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r))
  :qid |qp.fvfValDef25|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@14@01)))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef26|)))
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((i21@66@01 Int) (i22@66@01 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< i21@66@01 V@11@01) (<= 0 i21@66@01))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i21@66@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i21@66@01)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@67@01)))
      (and
        (and
          (and (< i22@66@01 V@11@01) (<= 0 i22@66@01))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i22@66@01)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i22@66@01)))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@67@01)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i21@66@01)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i22@66@01)))
    (= i21@66@01 i22@66@01))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11097
;  :arith-add-rows          3905
;  :arith-assert-diseq      238
;  :arith-assert-lower      2691
;  :arith-assert-upper      2166
;  :arith-bound-prop        229
;  :arith-conflicts         258
;  :arith-eq-adapter        710
;  :arith-fixed-eqs         409
;  :arith-gcd-tests         3
;  :arith-grobner           722
;  :arith-ineq-splits       3
;  :arith-max-min           2948
;  :arith-nonlinear-bounds  285
;  :arith-nonlinear-horner  617
;  :arith-offset-eqs        664
;  :arith-patches           3
;  :arith-pivots            875
;  :conflicts               721
;  :datatype-accessor-ax    363
;  :datatype-constructor-ax 1387
;  :datatype-occurs-check   768
;  :datatype-splits         1121
;  :decisions               3686
;  :del-clause              10776
;  :final-checks            596
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.89
;  :memory                  5.84
;  :minimized-lits          20
;  :mk-bool-var             16272
;  :mk-clause               10843
;  :num-allocs              371439
;  :num-checks              181
;  :propagations            4880
;  :quant-instantiations    2480
;  :rlimit-count            910596)
; Definitional axioms for inverse functions
(assert (forall ((i2@66@01 Int)) (!
  (implies
    (and
      (and (< i2@66@01 V@11@01) (<= 0 i2@66@01))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@67@01)))
    (=
      (inv@68@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@66@01))
      i2@66@01))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@66@01))
  :qid |option$array$-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@68@01 r) V@11@01) (<= 0 (inv@68@01 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@67@01)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) (inv@68@01 r))
      r))
  :pattern ((inv@68@01 r))
  :qid |option$array$-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@68@01 r) V@11@01) (<= 0 (inv@68@01 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@69@01  $FVF<option<array>>) r) r))
  :pattern ((inv@68@01 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@70@01 ((r $Ref)) $Perm
  (ite
    (and (< (inv@68@01 r) V@11@01) (<= 0 (inv@68@01 r)))
    ($Perm.min
      (ite
        (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01)
        $Perm.No)
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@67@01))
    $Perm.No))
(define-fun pTaken@71@01 ((r $Ref)) $Perm
  (ite
    (and (< (inv@68@01 r) V@11@01) (<= 0 (inv@68@01 r)))
    ($Perm.min
      (-
        (ite
          (and (< (inv@17@01 r) V@11@01) (<= 0 (inv@17@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@16@01)
          $Perm.No)
        (pTaken@60@01 r))
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@67@01)
        (pTaken@70@01 r)))
    $Perm.No))
; Done precomputing, updating quantified chunks
; State saturation: before repetition
(set-option :timeout 10)
(check-sat)
; unknown
; Constrain original permissions scale(_, V@11@01 * V@11@01 * W) * $k@67@01
(assert (forall ((r $Ref)) (!
  (implies
    (not
      (=
        (ite
          (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@24@01)
          $Perm.No)
        $Perm.No))
    (ite
      (and (< (inv@25@01 r) V@11@01) (<= 0 (inv@25@01 r)))
      (<
        (ite
          (and (< (inv@68@01 r) V@11@01) (<= 0 (inv@68@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@67@01)
          $Perm.No)
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@24@01))
      (<
        (ite
          (and (< (inv@68@01 r) V@11@01) (<= 0 (inv@68@01 r)))
          (*
            (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
            $k@67@01)
          $Perm.No)
        $Perm.No)))
  :pattern ((inv@25@01 r))
  :pattern ((inv@68@01 r))
  :qid |qp.srp27|)))
; Intermediate check if already taken enough permissions
(set-option :timeout 500)
(push) ; 7
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@68@01 r) V@11@01) (<= 0 (inv@68@01 r)))
    (=
      (-
        (*
          (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
          $k@67@01)
        (pTaken@70@01 r))
      $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11324
;  :arith-add-rows          4078
;  :arith-assert-diseq      260
;  :arith-assert-lower      2797
;  :arith-assert-upper      2230
;  :arith-bound-prop        244
;  :arith-conflicts         266
;  :arith-eq-adapter        779
;  :arith-fixed-eqs         431
;  :arith-gcd-tests         3
;  :arith-grobner           766
;  :arith-ineq-splits       3
;  :arith-max-min           3028
;  :arith-nonlinear-bounds  289
;  :arith-nonlinear-horner  657
;  :arith-offset-eqs        689
;  :arith-patches           3
;  :arith-pivots            923
;  :conflicts               743
;  :datatype-accessor-ax    364
;  :datatype-constructor-ax 1393
;  :datatype-occurs-check   772
;  :datatype-splits         1127
;  :decisions               3737
;  :del-clause              11033
;  :final-checks            602
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.90
;  :memory                  5.86
;  :minimized-lits          25
;  :mk-bool-var             16629
;  :mk-clause               11121
;  :num-allocs              379733
;  :num-checks              183
;  :propagations            5039
;  :quant-instantiations    2535
;  :rlimit-count            951043
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 112 | True | live]
; [else-branch: 112 | False | live]
(push) ; 8
; [then-branch: 112 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 112 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11401
;  :arith-add-rows          4136
;  :arith-assert-diseq      266
;  :arith-assert-lower      2842
;  :arith-assert-upper      2260
;  :arith-bound-prop        250
;  :arith-conflicts         266
;  :arith-eq-adapter        793
;  :arith-fixed-eqs         439
;  :arith-gcd-tests         3
;  :arith-grobner           812
;  :arith-ineq-splits       3
;  :arith-max-min           3086
;  :arith-nonlinear-bounds  291
;  :arith-nonlinear-horner  701
;  :arith-offset-eqs        696
;  :arith-patches           3
;  :arith-pivots            939
;  :conflicts               746
;  :datatype-accessor-ax    365
;  :datatype-constructor-ax 1399
;  :datatype-occurs-check   776
;  :datatype-splits         1133
;  :decisions               3758
;  :del-clause              11080
;  :final-checks            607
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.92
;  :memory                  5.88
;  :minimized-lits          26
;  :mk-bool-var             16691
;  :mk-clause               11168
;  :num-allocs              386894
;  :num-checks              184
;  :propagations            5084
;  :quant-instantiations    2543
;  :rlimit-count            992991
;  :time                    0.01)
; [then-branch: 113 | 0 < V@11@01 | live]
; [else-branch: 113 | !(0 < V@11@01) | dead]
(push) ; 8
; [then-branch: 113 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
(declare-const i2@72@01 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array])
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 114 | 0 <= i2@72@01 | live]
; [else-branch: 114 | !(0 <= i2@72@01) | live]
(push) ; 11
; [then-branch: 114 | 0 <= i2@72@01]
(assert (<= 0 i2@72@01))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 114 | !(0 <= i2@72@01)]
(assert (not (<= 0 i2@72@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 115 | i2@72@01 < V@11@01 && 0 <= i2@72@01 | live]
; [else-branch: 115 | !(i2@72@01 < V@11@01 && 0 <= i2@72@01) | live]
(push) ; 11
; [then-branch: 115 | i2@72@01 < V@11@01 && 0 <= i2@72@01]
(assert (and (< i2@72@01 V@11@01) (<= 0 i2@72@01)))
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
(assert (not (< i2@72@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11401
;  :arith-add-rows          4137
;  :arith-assert-diseq      266
;  :arith-assert-lower      2844
;  :arith-assert-upper      2260
;  :arith-bound-prop        250
;  :arith-conflicts         266
;  :arith-eq-adapter        793
;  :arith-fixed-eqs         439
;  :arith-gcd-tests         3
;  :arith-grobner           812
;  :arith-ineq-splits       3
;  :arith-max-min           3086
;  :arith-nonlinear-bounds  291
;  :arith-nonlinear-horner  701
;  :arith-offset-eqs        696
;  :arith-patches           3
;  :arith-pivots            939
;  :conflicts               746
;  :datatype-accessor-ax    365
;  :datatype-constructor-ax 1399
;  :datatype-occurs-check   776
;  :datatype-splits         1133
;  :decisions               3758
;  :del-clause              11080
;  :final-checks            607
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.92
;  :memory                  5.88
;  :minimized-lits          26
;  :mk-bool-var             16693
;  :mk-clause               11168
;  :num-allocs              386992
;  :num-checks              185
;  :propagations            5084
;  :quant-instantiations    2543
;  :rlimit-count            993187)
(assert (< i2@72@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 12
; Joined path conditions
(assert (< i2@72@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11531
;  :arith-add-rows          4234
;  :arith-assert-diseq      276
;  :arith-assert-lower      2882
;  :arith-assert-upper      2284
;  :arith-bound-prop        259
;  :arith-conflicts         269
;  :arith-eq-adapter        826
;  :arith-fixed-eqs         453
;  :arith-gcd-tests         3
;  :arith-grobner           812
;  :arith-ineq-splits       3
;  :arith-max-min           3086
;  :arith-nonlinear-bounds  291
;  :arith-nonlinear-horner  701
;  :arith-offset-eqs        713
;  :arith-patches           3
;  :arith-pivots            954
;  :conflicts               764
;  :datatype-accessor-ax    365
;  :datatype-constructor-ax 1399
;  :datatype-occurs-check   776
;  :datatype-splits         1133
;  :decisions               3778
;  :del-clause              11201
;  :final-checks            607
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.92
;  :memory                  5.87
;  :minimized-lits          27
;  :mk-bool-var             16961
;  :mk-clause               11358
;  :num-allocs              388091
;  :num-checks              186
;  :propagations            5178
;  :quant-instantiations    2588
;  :rlimit-count            997740
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 11
(push) ; 11
; [else-branch: 115 | !(i2@72@01 < V@11@01 && 0 <= i2@72@01)]
(assert (not (and (< i2@72@01 V@11@01) (<= 0 i2@72@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@72@01 V@11@01) (<= 0 i2@72@01))
  (and
    (< i2@72@01 V@11@01)
    (<= 0 i2@72@01)
    (< i2@72@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01)))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@72@01 Int)) (!
  (implies
    (and (< i2@72@01 V@11@01) (<= 0 i2@72@01))
    (and
      (< i2@72@01 V@11@01)
      (<= 0 i2@72@01)
      (< i2@72@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@72@01 Int)) (!
    (implies
      (and (< i2@72@01 V@11@01) (<= 0 i2@72@01))
      (and
        (< i2@72@01 V@11@01)
        (<= 0 i2@72@01)
        (< i2@72@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
    :qid |prog.l<no position>-aux|))))
(push) ; 7
(assert (not (implies
  (< 0 V@11@01)
  (forall ((i2@72@01 Int)) (!
    (implies
      (and (< i2@72@01 V@11@01) (<= 0 i2@72@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11612
;  :arith-add-rows          4254
;  :arith-assert-diseq      282
;  :arith-assert-lower      2903
;  :arith-assert-upper      2299
;  :arith-bound-prop        265
;  :arith-conflicts         270
;  :arith-eq-adapter        847
;  :arith-fixed-eqs         462
;  :arith-gcd-tests         3
;  :arith-grobner           812
;  :arith-ineq-splits       3
;  :arith-max-min           3086
;  :arith-nonlinear-bounds  291
;  :arith-nonlinear-horner  701
;  :arith-offset-eqs        723
;  :arith-patches           3
;  :arith-pivots            962
;  :conflicts               779
;  :datatype-accessor-ax    365
;  :datatype-constructor-ax 1399
;  :datatype-occurs-check   776
;  :datatype-splits         1133
;  :decisions               3795
;  :del-clause              11419
;  :final-checks            607
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.92
;  :memory                  5.88
;  :minimized-lits          28
;  :mk-bool-var             17140
;  :mk-clause               11509
;  :num-allocs              389045
;  :num-checks              187
;  :propagations            5245
;  :quant-instantiations    2631
;  :rlimit-count            1001133
;  :time                    0.00)
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@72@01 Int)) (!
    (implies
      (and (< i2@72@01 V@11@01) (<= 0 i2@72@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@72@01))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 116 | True | live]
; [else-branch: 116 | False | live]
(push) ; 8
; [then-branch: 116 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 116 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11690
;  :arith-add-rows          4311
;  :arith-assert-diseq      288
;  :arith-assert-lower      2948
;  :arith-assert-upper      2331
;  :arith-bound-prop        270
;  :arith-conflicts         270
;  :arith-eq-adapter        861
;  :arith-fixed-eqs         470
;  :arith-gcd-tests         3
;  :arith-grobner           858
;  :arith-ineq-splits       3
;  :arith-max-min           3145
;  :arith-nonlinear-bounds  292
;  :arith-nonlinear-horner  745
;  :arith-offset-eqs        731
;  :arith-patches           3
;  :arith-pivots            973
;  :conflicts               782
;  :datatype-accessor-ax    366
;  :datatype-constructor-ax 1405
;  :datatype-occurs-check   780
;  :datatype-splits         1139
;  :decisions               3816
;  :del-clause              11465
;  :final-checks            612
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.93
;  :memory                  5.89
;  :minimized-lits          29
;  :mk-bool-var             17202
;  :mk-clause               11555
;  :num-allocs              396233
;  :num-checks              188
;  :propagations            5288
;  :quant-instantiations    2639
;  :rlimit-count            1043093
;  :time                    0.01)
; [then-branch: 117 | 0 < V@11@01 | live]
; [else-branch: 117 | !(0 < V@11@01) | dead]
(push) ; 8
; [then-branch: 117 | 0 < V@11@01]
; [eval] (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
(declare-const i2@73@01 Int)
(push) ; 9
; [eval] 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V
; [eval] 0 <= i2 && i2 < V
; [eval] 0 <= i2
(push) ; 10
; [then-branch: 118 | 0 <= i2@73@01 | live]
; [else-branch: 118 | !(0 <= i2@73@01) | live]
(push) ; 11
; [then-branch: 118 | 0 <= i2@73@01]
(assert (<= 0 i2@73@01))
; [eval] i2 < V
(pop) ; 11
(push) ; 11
; [else-branch: 118 | !(0 <= i2@73@01)]
(assert (not (<= 0 i2@73@01)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 119 | i2@73@01 < V@11@01 && 0 <= i2@73@01 | live]
; [else-branch: 119 | !(i2@73@01 < V@11@01 && 0 <= i2@73@01) | live]
(push) ; 11
; [then-branch: 119 | i2@73@01 < V@11@01 && 0 <= i2@73@01]
(assert (and (< i2@73@01 V@11@01) (<= 0 i2@73@01)))
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
(assert (not (< i2@73@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11690
;  :arith-add-rows          4312
;  :arith-assert-diseq      288
;  :arith-assert-lower      2950
;  :arith-assert-upper      2331
;  :arith-bound-prop        270
;  :arith-conflicts         270
;  :arith-eq-adapter        861
;  :arith-fixed-eqs         470
;  :arith-gcd-tests         3
;  :arith-grobner           858
;  :arith-ineq-splits       3
;  :arith-max-min           3145
;  :arith-nonlinear-bounds  292
;  :arith-nonlinear-horner  745
;  :arith-offset-eqs        731
;  :arith-patches           3
;  :arith-pivots            974
;  :conflicts               782
;  :datatype-accessor-ax    366
;  :datatype-constructor-ax 1405
;  :datatype-occurs-check   780
;  :datatype-splits         1139
;  :decisions               3816
;  :del-clause              11465
;  :final-checks            612
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.93
;  :memory                  5.89
;  :minimized-lits          29
;  :mk-bool-var             17204
;  :mk-clause               11555
;  :num-allocs              396331
;  :num-checks              189
;  :propagations            5288
;  :quant-instantiations    2639
;  :rlimit-count            1043294)
(assert (< i2@73@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 12
; Joined path conditions
(assert (< i2@73@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11811
;  :arith-add-rows          4428
;  :arith-assert-diseq      301
;  :arith-assert-lower      2985
;  :arith-assert-upper      2354
;  :arith-bound-prop        280
;  :arith-conflicts         273
;  :arith-eq-adapter        893
;  :arith-fixed-eqs         483
;  :arith-gcd-tests         3
;  :arith-grobner           858
;  :arith-ineq-splits       3
;  :arith-max-min           3145
;  :arith-nonlinear-bounds  292
;  :arith-nonlinear-horner  745
;  :arith-offset-eqs        741
;  :arith-patches           3
;  :arith-pivots            991
;  :conflicts               800
;  :datatype-accessor-ax    366
;  :datatype-constructor-ax 1405
;  :datatype-occurs-check   780
;  :datatype-splits         1139
;  :decisions               3840
;  :del-clause              11587
;  :final-checks            612
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.93
;  :memory                  5.88
;  :minimized-lits          30
;  :mk-bool-var             17471
;  :mk-clause               11746
;  :num-allocs              397415
;  :num-checks              190
;  :propagations            5387
;  :quant-instantiations    2685
;  :rlimit-count            1048099
;  :time                    0.00)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 13
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11811
;  :arith-add-rows          4428
;  :arith-assert-diseq      301
;  :arith-assert-lower      2985
;  :arith-assert-upper      2354
;  :arith-bound-prop        280
;  :arith-conflicts         273
;  :arith-eq-adapter        893
;  :arith-fixed-eqs         483
;  :arith-gcd-tests         3
;  :arith-grobner           858
;  :arith-ineq-splits       3
;  :arith-max-min           3145
;  :arith-nonlinear-bounds  292
;  :arith-nonlinear-horner  745
;  :arith-offset-eqs        741
;  :arith-patches           3
;  :arith-pivots            991
;  :conflicts               801
;  :datatype-accessor-ax    366
;  :datatype-constructor-ax 1405
;  :datatype-occurs-check   780
;  :datatype-splits         1139
;  :decisions               3840
;  :del-clause              11587
;  :final-checks            612
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.93
;  :memory                  5.88
;  :minimized-lits          30
;  :mk-bool-var             17471
;  :mk-clause               11746
;  :num-allocs              397507
;  :num-checks              191
;  :propagations            5387
;  :quant-instantiations    2685
;  :rlimit-count            1048194)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
    (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
    (as None<option<array>>  option<array>))))
(pop) ; 11
(push) ; 11
; [else-branch: 119 | !(i2@73@01 < V@11@01 && 0 <= i2@73@01)]
(assert (not (and (< i2@73@01 V@11@01) (<= 0 i2@73@01))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i2@73@01 V@11@01) (<= 0 i2@73@01))
  (and
    (< i2@73@01 V@11@01)
    (<= 0 i2@73@01)
    (< i2@73@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@73@01 Int)) (!
  (implies
    (and (< i2@73@01 V@11@01) (<= 0 i2@73@01))
    (and
      (< i2@73@01 V@11@01)
      (<= 0 i2@73@01)
      (< i2@73@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@73@01 Int)) (!
    (implies
      (and (< i2@73@01 V@11@01) (<= 0 i2@73@01))
      (and
        (< i2@73@01 V@11@01)
        (<= 0 i2@73@01)
        (< i2@73@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)))))
    :qid |prog.l<no position>-aux|))))
(push) ; 7
(assert (not (implies
  (< 0 V@11@01)
  (forall ((i2@73@01 Int)) (!
    (implies
      (and (< i2@73@01 V@11@01) (<= 0 i2@73@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)))))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11907
;  :arith-add-rows          4467
;  :arith-assert-diseq      309
;  :arith-assert-lower      3007
;  :arith-assert-upper      2367
;  :arith-bound-prop        285
;  :arith-conflicts         274
;  :arith-eq-adapter        914
;  :arith-fixed-eqs         492
;  :arith-gcd-tests         3
;  :arith-grobner           858
;  :arith-ineq-splits       3
;  :arith-max-min           3145
;  :arith-nonlinear-bounds  292
;  :arith-nonlinear-horner  745
;  :arith-offset-eqs        750
;  :arith-patches           3
;  :arith-pivots            1000
;  :conflicts               816
;  :datatype-accessor-ax    366
;  :datatype-constructor-ax 1405
;  :datatype-occurs-check   780
;  :datatype-splits         1139
;  :decisions               3857
;  :del-clause              11806
;  :final-checks            612
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.93
;  :memory                  5.88
;  :minimized-lits          31
;  :mk-bool-var             17653
;  :mk-clause               11898
;  :num-allocs              398484
;  :num-checks              192
;  :propagations            5455
;  :quant-instantiations    2733
;  :rlimit-count            1052139
;  :time                    0.00)
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@73@01 Int)) (!
    (implies
      (and (< i2@73@01 V@11@01) (<= 0 i2@73@01))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01))))
        V@11@01))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@73@01)))))
    :qid |prog.l<no position>|))))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 120 | True | live]
; [else-branch: 120 | False | live]
(push) ; 8
; [then-branch: 120 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 120 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (< 0 V@11@01))))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11985
;  :arith-add-rows          4524
;  :arith-assert-diseq      315
;  :arith-assert-lower      3052
;  :arith-assert-upper      2399
;  :arith-bound-prop        290
;  :arith-conflicts         274
;  :arith-eq-adapter        928
;  :arith-fixed-eqs         500
;  :arith-gcd-tests         3
;  :arith-grobner           904
;  :arith-ineq-splits       3
;  :arith-max-min           3204
;  :arith-nonlinear-bounds  293
;  :arith-nonlinear-horner  789
;  :arith-offset-eqs        758
;  :arith-patches           3
;  :arith-pivots            1011
;  :conflicts               819
;  :datatype-accessor-ax    367
;  :datatype-constructor-ax 1411
;  :datatype-occurs-check   784
;  :datatype-splits         1145
;  :decisions               3878
;  :del-clause              11852
;  :final-checks            617
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.93
;  :memory                  5.89
;  :minimized-lits          32
;  :mk-bool-var             17715
;  :mk-clause               11944
;  :num-allocs              405833
;  :num-checks              193
;  :propagations            5498
;  :quant-instantiations    2741
;  :rlimit-count            1094308
;  :time                    0.01)
; [then-branch: 121 | 0 < V@11@01 | live]
; [else-branch: 121 | !(0 < V@11@01) | dead]
(push) ; 8
; [then-branch: 121 | 0 < V@11@01]
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
(declare-const i2@74@01 Int)
(push) ; 9
; [eval] (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3)
(declare-const i3@75@01 Int)
(push) ; 10
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3
; [eval] 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$
; [eval] 0 <= i2
(push) ; 11
; [then-branch: 122 | 0 <= i2@74@01 | live]
; [else-branch: 122 | !(0 <= i2@74@01) | live]
(push) ; 12
; [then-branch: 122 | 0 <= i2@74@01]
(assert (<= 0 i2@74@01))
; [eval] i2 < V
(push) ; 13
; [then-branch: 123 | i2@74@01 < V@11@01 | live]
; [else-branch: 123 | !(i2@74@01 < V@11@01) | live]
(push) ; 14
; [then-branch: 123 | i2@74@01 < V@11@01]
(assert (< i2@74@01 V@11@01))
; [eval] 0 <= i3
(push) ; 15
; [then-branch: 124 | 0 <= i3@75@01 | live]
; [else-branch: 124 | !(0 <= i3@75@01) | live]
(push) ; 16
; [then-branch: 124 | 0 <= i3@75@01]
(assert (<= 0 i3@75@01))
; [eval] i3 < V
(push) ; 17
; [then-branch: 125 | i3@75@01 < V@11@01 | live]
; [else-branch: 125 | !(i3@75@01 < V@11@01) | live]
(push) ; 18
; [then-branch: 125 | i3@75@01 < V@11@01]
(assert (< i3@75@01 V@11@01))
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
(assert (not (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11985
;  :arith-add-rows          4526
;  :arith-assert-diseq      315
;  :arith-assert-lower      3056
;  :arith-assert-upper      2399
;  :arith-bound-prop        290
;  :arith-conflicts         274
;  :arith-eq-adapter        928
;  :arith-fixed-eqs         500
;  :arith-gcd-tests         3
;  :arith-grobner           904
;  :arith-ineq-splits       3
;  :arith-max-min           3204
;  :arith-nonlinear-bounds  293
;  :arith-nonlinear-horner  789
;  :arith-offset-eqs        758
;  :arith-patches           3
;  :arith-pivots            1013
;  :conflicts               819
;  :datatype-accessor-ax    367
;  :datatype-constructor-ax 1411
;  :datatype-occurs-check   784
;  :datatype-splits         1145
;  :decisions               3878
;  :del-clause              11852
;  :final-checks            617
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.93
;  :memory                  5.89
;  :minimized-lits          32
;  :mk-bool-var             17719
;  :mk-clause               11944
;  :num-allocs              406109
;  :num-checks              194
;  :propagations            5498
;  :quant-instantiations    2741
;  :rlimit-count            1094661)
(assert (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 19
; Joined path conditions
(assert (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12109
;  :arith-add-rows          4624
;  :arith-assert-diseq      325
;  :arith-assert-lower      3095
;  :arith-assert-upper      2422
;  :arith-bound-prop        299
;  :arith-conflicts         277
;  :arith-eq-adapter        961
;  :arith-fixed-eqs         514
;  :arith-gcd-tests         3
;  :arith-grobner           904
;  :arith-ineq-splits       3
;  :arith-max-min           3204
;  :arith-nonlinear-bounds  293
;  :arith-nonlinear-horner  789
;  :arith-offset-eqs        771
;  :arith-patches           3
;  :arith-pivots            1027
;  :conflicts               836
;  :datatype-accessor-ax    367
;  :datatype-constructor-ax 1411
;  :datatype-occurs-check   784
;  :datatype-splits         1145
;  :decisions               3897
;  :del-clause              11968
;  :final-checks            617
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.95
;  :memory                  5.91
;  :minimized-lits          33
;  :mk-bool-var             17982
;  :mk-clause               12129
;  :num-allocs              407180
;  :num-checks              195
;  :propagations            5591
;  :quant-instantiations    2787
;  :rlimit-count            1099174
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
(assert (not (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12109
;  :arith-add-rows          4624
;  :arith-assert-diseq      325
;  :arith-assert-lower      3095
;  :arith-assert-upper      2422
;  :arith-bound-prop        299
;  :arith-conflicts         277
;  :arith-eq-adapter        961
;  :arith-fixed-eqs         514
;  :arith-gcd-tests         3
;  :arith-grobner           904
;  :arith-ineq-splits       3
;  :arith-max-min           3204
;  :arith-nonlinear-bounds  293
;  :arith-nonlinear-horner  789
;  :arith-offset-eqs        771
;  :arith-patches           3
;  :arith-pivots            1027
;  :conflicts               836
;  :datatype-accessor-ax    367
;  :datatype-constructor-ax 1411
;  :datatype-occurs-check   784
;  :datatype-splits         1145
;  :decisions               3897
;  :del-clause              11968
;  :final-checks            617
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.95
;  :memory                  5.91
;  :minimized-lits          33
;  :mk-bool-var             17982
;  :mk-clause               12129
;  :num-allocs              407207
;  :num-checks              196
;  :propagations            5591
;  :quant-instantiations    2787
;  :rlimit-count            1099204)
(assert (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 19
; Joined path conditions
(assert (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12265
;  :arith-add-rows          4804
;  :arith-assert-diseq      348
;  :arith-assert-lower      3147
;  :arith-assert-upper      2450
;  :arith-bound-prop        312
;  :arith-conflicts         281
;  :arith-eq-adapter        994
;  :arith-fixed-eqs         529
;  :arith-gcd-tests         3
;  :arith-grobner           904
;  :arith-ineq-splits       3
;  :arith-max-min           3204
;  :arith-nonlinear-bounds  293
;  :arith-nonlinear-horner  789
;  :arith-offset-eqs        784
;  :arith-patches           3
;  :arith-pivots            1048
;  :conflicts               858
;  :datatype-accessor-ax    367
;  :datatype-constructor-ax 1411
;  :datatype-occurs-check   784
;  :datatype-splits         1145
;  :decisions               3934
;  :del-clause              12077
;  :final-checks            617
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.95
;  :memory                  5.94
;  :minimized-lits          34
;  :mk-bool-var             18274
;  :mk-clause               12327
;  :num-allocs              408495
;  :num-checks              197
;  :propagations            5707
;  :quant-instantiations    2841
;  :rlimit-count            1105877
;  :time                    0.00)
(pop) ; 18
(push) ; 18
; [else-branch: 125 | !(i3@75@01 < V@11@01)]
(assert (not (< i3@75@01 V@11@01)))
(pop) ; 18
(pop) ; 17
; Joined path conditions
(assert (implies
  (< i3@75@01 V@11@01)
  (and
    (< i3@75@01 V@11@01)
    (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
    (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))))
; Joined path conditions
(pop) ; 16
(push) ; 16
; [else-branch: 124 | !(0 <= i3@75@01)]
(assert (not (<= 0 i3@75@01)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (implies
  (<= 0 i3@75@01)
  (and
    (<= 0 i3@75@01)
    (implies
      (< i3@75@01 V@11@01)
      (and
        (< i3@75@01 V@11@01)
        (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
        (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))))))
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 123 | !(i2@74@01 < V@11@01)]
(assert (not (< i2@74@01 V@11@01)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i2@74@01 V@11@01)
  (and
    (< i2@74@01 V@11@01)
    (implies
      (<= 0 i3@75@01)
      (and
        (<= 0 i3@75@01)
        (implies
          (< i3@75@01 V@11@01)
          (and
            (< i3@75@01 V@11@01)
            (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
            (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))))))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 122 | !(0 <= i2@74@01)]
(assert (not (<= 0 i2@74@01)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i2@74@01)
  (and
    (<= 0 i2@74@01)
    (implies
      (< i2@74@01 V@11@01)
      (and
        (< i2@74@01 V@11@01)
        (implies
          (<= 0 i3@75@01)
          (and
            (<= 0 i3@75@01)
            (implies
              (< i3@75@01 V@11@01)
              (and
                (< i3@75@01 V@11@01)
                (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))))))))))
; Joined path conditions
(push) ; 11
; [then-branch: 126 | Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i2@74@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i3@75@01)) && i3@75@01 < V@11@01 && 0 <= i3@75@01 && i2@74@01 < V@11@01 && 0 <= i2@74@01 | live]
; [else-branch: 126 | !(Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i2@74@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i3@75@01)) && i3@75@01 < V@11@01 && 0 <= i3@75@01 && i2@74@01 < V@11@01 && 0 <= i2@74@01) | live]
(push) ; 12
; [then-branch: 126 | Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i2@74@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i3@75@01)) && i3@75@01 < V@11@01 && 0 <= i3@75@01 && i2@74@01 < V@11@01 && 0 <= i2@74@01]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
        (< i3@75@01 V@11@01))
      (<= 0 i3@75@01))
    (< i2@74@01 V@11@01))
  (<= 0 i2@74@01)))
; [eval] i2 == i3
(pop) ; 12
(push) ; 12
; [else-branch: 126 | !(Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i2@74@01)) == Lookup(option$array$,sm@59@01,aloc((_, _), opt_get1(_, target@8@01), i3@75@01)) && i3@75@01 < V@11@01 && 0 <= i3@75@01 && i2@74@01 < V@11@01 && 0 <= i2@74@01)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
          (< i3@75@01 V@11@01))
        (<= 0 i3@75@01))
      (< i2@74@01 V@11@01))
    (<= 0 i2@74@01))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
          (< i3@75@01 V@11@01))
        (<= 0 i3@75@01))
      (< i2@74@01 V@11@01))
    (<= 0 i2@74@01))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
      ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
    (< i3@75@01 V@11@01)
    (<= 0 i3@75@01)
    (< i2@74@01 V@11@01)
    (<= 0 i2@74@01))))
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i3@75@01 Int)) (!
  (and
    (implies
      (<= 0 i2@74@01)
      (and
        (<= 0 i2@74@01)
        (implies
          (< i2@74@01 V@11@01)
          (and
            (< i2@74@01 V@11@01)
            (implies
              (<= 0 i3@75@01)
              (and
                (<= 0 i3@75@01)
                (implies
                  (< i3@75@01 V@11@01)
                  (and
                    (< i3@75@01 V@11@01)
                    (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                    (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
              (< i3@75@01 V@11@01))
            (<= 0 i3@75@01))
          (< i2@74@01 V@11@01))
        (<= 0 i2@74@01))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
          ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
        (< i3@75@01 V@11@01)
        (<= 0 i3@75@01)
        (< i2@74@01 V@11@01)
        (<= 0 i2@74@01))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@74@01 Int)) (!
  (forall ((i3@75@01 Int)) (!
    (and
      (implies
        (<= 0 i2@74@01)
        (and
          (<= 0 i2@74@01)
          (implies
            (< i2@74@01 V@11@01)
            (and
              (< i2@74@01 V@11@01)
              (implies
                (<= 0 i3@75@01)
                (and
                  (<= 0 i3@75@01)
                  (implies
                    (< i3@75@01 V@11@01)
                    (and
                      (< i3@75@01 V@11@01)
                      (< i2@74@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                      (< i3@75@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
                (< i3@75@01 V@11@01))
              (<= 0 i3@75@01))
            (< i2@74@01 V@11@01))
          (<= 0 i2@74@01))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
            ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
          (< i3@75@01 V@11@01)
          (<= 0 i3@75@01)
          (< i2@74@01 V@11@01)
          (<= 0 i2@74@01))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@74@01 Int)) (!
    (forall ((i3@75@01 Int)) (!
      (and
        (implies
          (<= 0 i2@74@01)
          (and
            (<= 0 i2@74@01)
            (implies
              (< i2@74@01 V@11@01)
              (and
                (< i2@74@01 V@11@01)
                (implies
                  (<= 0 i3@75@01)
                  (and
                    (<= 0 i3@75@01)
                    (implies
                      (< i3@75@01 V@11@01)
                      (and
                        (< i3@75@01 V@11@01)
                        (<
                          i2@74@01
                          (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                        (<
                          i3@75@01
                          (alen<Int> (opt_get1 $Snap.unit target@8@01)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
                  (< i3@75@01 V@11@01))
                (<= 0 i3@75@01))
              (< i2@74@01 V@11@01))
            (<= 0 i2@74@01))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
              ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
            (< i3@75@01 V@11@01)
            (<= 0 i3@75@01)
            (< i2@74@01 V@11@01)
            (<= 0 i2@74@01))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
    :qid |prog.l<no position>-aux|))))
(push) ; 7
(assert (not (implies
  (< 0 V@11@01)
  (forall ((i2@74@01 Int)) (!
    (forall ((i3@75@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
                (< i3@75@01 V@11@01))
              (<= 0 i3@75@01))
            (< i2@74@01 V@11@01))
          (<= 0 i2@74@01))
        (= i2@74@01 i3@75@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12399
;  :arith-add-rows          4934
;  :arith-assert-diseq      355
;  :arith-assert-lower      3174
;  :arith-assert-upper      2470
;  :arith-bound-prop        320
;  :arith-conflicts         284
;  :arith-eq-adapter        1018
;  :arith-fixed-eqs         539
;  :arith-gcd-tests         3
;  :arith-grobner           904
;  :arith-ineq-splits       3
;  :arith-max-min           3204
;  :arith-nonlinear-bounds  293
;  :arith-nonlinear-horner  789
;  :arith-offset-eqs        796
;  :arith-patches           3
;  :arith-pivots            1069
;  :conflicts               875
;  :datatype-accessor-ax    367
;  :datatype-constructor-ax 1411
;  :datatype-occurs-check   784
;  :datatype-splits         1145
;  :decisions               3956
;  :del-clause              12516
;  :final-checks            617
;  :interface-eqs           154
;  :max-generation          6
;  :max-memory              5.98
;  :memory                  5.96
;  :minimized-lits          35
;  :mk-bool-var             18632
;  :mk-clause               12608
;  :num-allocs              410496
;  :num-checks              198
;  :propagations            5820
;  :quant-instantiations    2930
;  :rlimit-count            1115539
;  :time                    0.01)
(assert (implies
  (< 0 V@11@01)
  (forall ((i2@74@01 Int)) (!
    (forall ((i3@75@01 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
                  ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01)))
                (< i3@75@01 V@11@01))
              (<= 0 i3@75@01))
            (< i2@74@01 V@11@01))
          (<= 0 i2@74@01))
        (= i2@74@01 i3@75@01))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i3@75@01))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i2@74@01))
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
; (:added-eqs               12478
;  :arith-add-rows          4997
;  :arith-assert-diseq      361
;  :arith-assert-lower      3219
;  :arith-assert-upper      2503
;  :arith-bound-prop        325
;  :arith-conflicts         284
;  :arith-eq-adapter        1033
;  :arith-fixed-eqs         547
;  :arith-gcd-tests         3
;  :arith-grobner           948
;  :arith-ineq-splits       3
;  :arith-max-min           3263
;  :arith-nonlinear-bounds  294
;  :arith-nonlinear-horner  833
;  :arith-offset-eqs        804
;  :arith-patches           3
;  :arith-pivots            1081
;  :conflicts               878
;  :datatype-accessor-ax    368
;  :datatype-constructor-ax 1417
;  :datatype-occurs-check   788
;  :datatype-splits         1151
;  :decisions               3978
;  :del-clause              12564
;  :final-checks            623
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.98
;  :minimized-lits          36
;  :mk-bool-var             18697
;  :mk-clause               12656
;  :num-allocs              421355
;  :num-checks              199
;  :propagations            5864
;  :quant-instantiations    2939
;  :rlimit-count            1166050
;  :time                    0.01)
; [then-branch: 127 | True | live]
; [else-branch: 127 | False | dead]
(push) ; 8
; [then-branch: 127 | True]
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
; (:added-eqs               12556
;  :arith-add-rows          5067
;  :arith-assert-diseq      367
;  :arith-assert-lower      3264
;  :arith-assert-upper      2534
;  :arith-bound-prop        330
;  :arith-conflicts         284
;  :arith-eq-adapter        1047
;  :arith-fixed-eqs         555
;  :arith-gcd-tests         3
;  :arith-grobner           994
;  :arith-ineq-splits       3
;  :arith-max-min           3322
;  :arith-nonlinear-bounds  295
;  :arith-nonlinear-horner  877
;  :arith-offset-eqs        812
;  :arith-patches           3
;  :arith-pivots            1093
;  :conflicts               881
;  :datatype-accessor-ax    369
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   792
;  :datatype-splits         1157
;  :decisions               3999
;  :del-clause              12610
;  :final-checks            628
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          37
;  :mk-bool-var             18758
;  :mk-clause               12702
;  :num-allocs              427684
;  :num-checks              200
;  :propagations            5909
;  :quant-instantiations    2947
;  :rlimit-count            1206233
;  :time                    0.01)
; [then-branch: 128 | True | live]
; [else-branch: 128 | False | dead]
(push) ; 8
; [then-branch: 128 | True]
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
; (:added-eqs               12634
;  :arith-add-rows          5137
;  :arith-assert-diseq      373
;  :arith-assert-lower      3309
;  :arith-assert-upper      2565
;  :arith-bound-prop        335
;  :arith-conflicts         284
;  :arith-eq-adapter        1061
;  :arith-fixed-eqs         563
;  :arith-gcd-tests         3
;  :arith-grobner           1040
;  :arith-ineq-splits       3
;  :arith-max-min           3381
;  :arith-nonlinear-bounds  296
;  :arith-nonlinear-horner  921
;  :arith-offset-eqs        820
;  :arith-patches           3
;  :arith-pivots            1105
;  :conflicts               884
;  :datatype-accessor-ax    370
;  :datatype-constructor-ax 1429
;  :datatype-occurs-check   796
;  :datatype-splits         1163
;  :decisions               4020
;  :del-clause              12656
;  :final-checks            633
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          38
;  :mk-bool-var             18819
;  :mk-clause               12748
;  :num-allocs              434169
;  :num-checks              201
;  :propagations            5954
;  :quant-instantiations    2955
;  :rlimit-count            1246165
;  :time                    0.01)
; [then-branch: 129 | True | live]
; [else-branch: 129 | False | dead]
(push) ; 8
; [then-branch: 129 | True]
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
; (:added-eqs               12712
;  :arith-add-rows          5207
;  :arith-assert-diseq      379
;  :arith-assert-lower      3354
;  :arith-assert-upper      2596
;  :arith-bound-prop        340
;  :arith-conflicts         284
;  :arith-eq-adapter        1075
;  :arith-fixed-eqs         571
;  :arith-gcd-tests         3
;  :arith-grobner           1086
;  :arith-ineq-splits       3
;  :arith-max-min           3440
;  :arith-nonlinear-bounds  297
;  :arith-nonlinear-horner  965
;  :arith-offset-eqs        828
;  :arith-patches           3
;  :arith-pivots            1117
;  :conflicts               887
;  :datatype-accessor-ax    371
;  :datatype-constructor-ax 1435
;  :datatype-occurs-check   800
;  :datatype-splits         1169
;  :decisions               4041
;  :del-clause              12702
;  :final-checks            638
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          39
;  :mk-bool-var             18880
;  :mk-clause               12794
;  :num-allocs              440497
;  :num-checks              202
;  :propagations            5999
;  :quant-instantiations    2963
;  :rlimit-count            1286348
;  :time                    0.01)
; [then-branch: 130 | True | live]
; [else-branch: 130 | False | dead]
(push) ; 8
; [then-branch: 130 | True]
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
; (:added-eqs               12790
;  :arith-add-rows          5277
;  :arith-assert-diseq      385
;  :arith-assert-lower      3399
;  :arith-assert-upper      2627
;  :arith-bound-prop        345
;  :arith-conflicts         284
;  :arith-eq-adapter        1089
;  :arith-fixed-eqs         579
;  :arith-gcd-tests         3
;  :arith-grobner           1132
;  :arith-ineq-splits       3
;  :arith-max-min           3499
;  :arith-nonlinear-bounds  298
;  :arith-nonlinear-horner  1009
;  :arith-offset-eqs        836
;  :arith-patches           3
;  :arith-pivots            1129
;  :conflicts               890
;  :datatype-accessor-ax    372
;  :datatype-constructor-ax 1441
;  :datatype-occurs-check   804
;  :datatype-splits         1175
;  :decisions               4062
;  :del-clause              12748
;  :final-checks            643
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          40
;  :mk-bool-var             18941
;  :mk-clause               12840
;  :num-allocs              446981
;  :num-checks              203
;  :propagations            6044
;  :quant-instantiations    2971
;  :rlimit-count            1326814
;  :time                    0.01)
; [then-branch: 131 | True | live]
; [else-branch: 131 | False | dead]
(push) ; 7
; [then-branch: 131 | True]
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
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12801
;  :arith-add-rows          5304
;  :arith-assert-diseq      386
;  :arith-assert-lower      3405
;  :arith-assert-upper      2632
;  :arith-bound-prop        347
;  :arith-conflicts         285
;  :arith-eq-adapter        1093
;  :arith-fixed-eqs         581
;  :arith-gcd-tests         3
;  :arith-grobner           1132
;  :arith-ineq-splits       3
;  :arith-max-min           3499
;  :arith-nonlinear-bounds  298
;  :arith-nonlinear-horner  1009
;  :arith-offset-eqs        836
;  :arith-patches           3
;  :arith-pivots            1135
;  :conflicts               892
;  :datatype-accessor-ax    372
;  :datatype-constructor-ax 1441
;  :datatype-occurs-check   804
;  :datatype-splits         1175
;  :decisions               4063
;  :del-clause              12755
;  :final-checks            643
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          40
;  :mk-bool-var             18950
;  :mk-clause               12847
;  :num-allocs              447247
;  :num-checks              204
;  :propagations            6060
;  :quant-instantiations    2973
;  :rlimit-count            1328092)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 9
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12801
;  :arith-add-rows          5304
;  :arith-assert-diseq      386
;  :arith-assert-lower      3405
;  :arith-assert-upper      2632
;  :arith-bound-prop        347
;  :arith-conflicts         285
;  :arith-eq-adapter        1093
;  :arith-fixed-eqs         581
;  :arith-gcd-tests         3
;  :arith-grobner           1132
;  :arith-ineq-splits       3
;  :arith-max-min           3499
;  :arith-nonlinear-bounds  298
;  :arith-nonlinear-horner  1009
;  :arith-offset-eqs        836
;  :arith-patches           3
;  :arith-pivots            1135
;  :conflicts               893
;  :datatype-accessor-ax    372
;  :datatype-constructor-ax 1441
;  :datatype-occurs-check   804
;  :datatype-splits         1175
;  :decisions               4063
;  :del-clause              12755
;  :final-checks            643
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          40
;  :mk-bool-var             18950
;  :mk-clause               12847
;  :num-allocs              447337
;  :num-checks              205
;  :propagations            6060
;  :quant-instantiations    2973
;  :rlimit-count            1328183)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12804
;  :arith-add-rows          5316
;  :arith-assert-diseq      386
;  :arith-assert-lower      3407
;  :arith-assert-upper      2633
;  :arith-bound-prop        347
;  :arith-conflicts         286
;  :arith-eq-adapter        1094
;  :arith-fixed-eqs         582
;  :arith-gcd-tests         3
;  :arith-grobner           1132
;  :arith-ineq-splits       3
;  :arith-max-min           3499
;  :arith-nonlinear-bounds  298
;  :arith-nonlinear-horner  1009
;  :arith-offset-eqs        836
;  :arith-patches           3
;  :arith-pivots            1139
;  :conflicts               894
;  :datatype-accessor-ax    372
;  :datatype-constructor-ax 1441
;  :datatype-occurs-check   804
;  :datatype-splits         1175
;  :decisions               4063
;  :del-clause              12756
;  :final-checks            643
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          40
;  :mk-bool-var             18954
;  :mk-clause               12848
;  :num-allocs              447510
;  :num-checks              206
;  :propagations            6060
;  :quant-instantiations    2973
;  :rlimit-count            1328725)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(pop) ; 8
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12809
;  :arith-add-rows          5318
;  :arith-assert-diseq      386
;  :arith-assert-lower      3408
;  :arith-assert-upper      2635
;  :arith-bound-prop        347
;  :arith-conflicts         286
;  :arith-eq-adapter        1095
;  :arith-fixed-eqs         583
;  :arith-gcd-tests         3
;  :arith-grobner           1132
;  :arith-ineq-splits       3
;  :arith-max-min           3499
;  :arith-nonlinear-bounds  298
;  :arith-nonlinear-horner  1009
;  :arith-offset-eqs        836
;  :arith-patches           3
;  :arith-pivots            1140
;  :conflicts               895
;  :datatype-accessor-ax    372
;  :datatype-constructor-ax 1441
;  :datatype-occurs-check   804
;  :datatype-splits         1175
;  :decisions               4063
;  :del-clause              12756
;  :final-checks            643
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          40
;  :mk-bool-var             18959
;  :mk-clause               12848
;  :num-allocs              447697
;  :num-checks              207
;  :propagations            6060
;  :quant-instantiations    2973
;  :rlimit-count            1329110)
; [eval] exc == null
(push) ; 8
(assert (not false))
(check-sat)
; unknown
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12890
;  :arith-add-rows          5391
;  :arith-assert-diseq      392
;  :arith-assert-lower      3453
;  :arith-assert-upper      2666
;  :arith-bound-prop        352
;  :arith-conflicts         286
;  :arith-eq-adapter        1109
;  :arith-fixed-eqs         591
;  :arith-gcd-tests         3
;  :arith-grobner           1180
;  :arith-ineq-splits       3
;  :arith-max-min           3558
;  :arith-nonlinear-bounds  299
;  :arith-nonlinear-horner  1055
;  :arith-offset-eqs        847
;  :arith-patches           3
;  :arith-pivots            1154
;  :conflicts               898
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 1447
;  :datatype-occurs-check   808
;  :datatype-splits         1181
;  :decisions               4084
;  :del-clause              12802
;  :final-checks            648
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          41
;  :mk-bool-var             19020
;  :mk-clause               12894
;  :num-allocs              455168
;  :num-checks              208
;  :propagations            6105
;  :quant-instantiations    2981
;  :rlimit-count            1374105
;  :time                    0.01)
; [then-branch: 132 | True | live]
; [else-branch: 132 | False | dead]
(push) ; 8
; [then-branch: 132 | True]
(declare-const $k@76@01 $Perm)
(assert ($Perm.isReadVar $k@76@01 $Perm.Write))
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
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))
(set-option :timeout 0)
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12915
;  :arith-add-rows          5413
;  :arith-assert-diseq      394
;  :arith-assert-lower      3464
;  :arith-assert-upper      2677
;  :arith-bound-prop        354
;  :arith-conflicts         287
;  :arith-eq-adapter        1119
;  :arith-fixed-eqs         594
;  :arith-gcd-tests         3
;  :arith-grobner           1180
;  :arith-ineq-splits       3
;  :arith-max-min           3558
;  :arith-nonlinear-bounds  299
;  :arith-nonlinear-horner  1055
;  :arith-offset-eqs        852
;  :arith-patches           3
;  :arith-pivots            1160
;  :conflicts               906
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 1447
;  :datatype-occurs-check   808
;  :datatype-splits         1181
;  :decisions               4091
;  :del-clause              12854
;  :final-checks            648
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          41
;  :mk-bool-var             19086
;  :mk-clause               12948
;  :num-allocs              455649
;  :num-checks              209
;  :propagations            6142
;  :quant-instantiations    2990
;  :rlimit-count            1375695)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12915
;  :arith-add-rows          5413
;  :arith-assert-diseq      394
;  :arith-assert-lower      3464
;  :arith-assert-upper      2677
;  :arith-bound-prop        354
;  :arith-conflicts         287
;  :arith-eq-adapter        1119
;  :arith-fixed-eqs         594
;  :arith-gcd-tests         3
;  :arith-grobner           1180
;  :arith-ineq-splits       3
;  :arith-max-min           3558
;  :arith-nonlinear-bounds  299
;  :arith-nonlinear-horner  1055
;  :arith-offset-eqs        852
;  :arith-patches           3
;  :arith-pivots            1160
;  :conflicts               907
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 1447
;  :datatype-occurs-check   808
;  :datatype-splits         1181
;  :decisions               4091
;  :del-clause              12854
;  :final-checks            648
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          41
;  :mk-bool-var             19086
;  :mk-clause               12948
;  :num-allocs              455740
;  :num-checks              210
;  :propagations            6142
;  :quant-instantiations    2990
;  :rlimit-count            1375786)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12918
;  :arith-add-rows          5415
;  :arith-assert-diseq      394
;  :arith-assert-lower      3466
;  :arith-assert-upper      2678
;  :arith-bound-prop        354
;  :arith-conflicts         288
;  :arith-eq-adapter        1120
;  :arith-fixed-eqs         595
;  :arith-gcd-tests         3
;  :arith-grobner           1180
;  :arith-ineq-splits       3
;  :arith-max-min           3558
;  :arith-nonlinear-bounds  299
;  :arith-nonlinear-horner  1055
;  :arith-offset-eqs        852
;  :arith-patches           3
;  :arith-pivots            1162
;  :conflicts               908
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 1447
;  :datatype-occurs-check   808
;  :datatype-splits         1181
;  :decisions               4091
;  :del-clause              12855
;  :final-checks            648
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          41
;  :mk-bool-var             19090
;  :mk-clause               12949
;  :num-allocs              455915
;  :num-checks              211
;  :propagations            6142
;  :quant-instantiations    2990
;  :rlimit-count            1376096)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(pop) ; 9
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(push) ; 9
(assert (not (or (= $k@76@01 $Perm.No) (< $Perm.No $k@76@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12924
;  :arith-add-rows          5417
;  :arith-assert-diseq      394
;  :arith-assert-lower      3467
;  :arith-assert-upper      2680
;  :arith-bound-prop        354
;  :arith-conflicts         288
;  :arith-eq-adapter        1121
;  :arith-fixed-eqs         596
;  :arith-gcd-tests         3
;  :arith-grobner           1180
;  :arith-ineq-splits       3
;  :arith-max-min           3558
;  :arith-nonlinear-bounds  299
;  :arith-nonlinear-horner  1055
;  :arith-offset-eqs        854
;  :arith-patches           3
;  :arith-pivots            1163
;  :conflicts               909
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 1447
;  :datatype-occurs-check   808
;  :datatype-splits         1181
;  :decisions               4091
;  :del-clause              12855
;  :final-checks            648
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          41
;  :mk-bool-var             19094
;  :mk-clause               12949
;  :num-allocs              456112
;  :num-checks              212
;  :propagations            6142
;  :quant-instantiations    2990
;  :rlimit-count            1376380)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12925
;  :arith-add-rows          5417
;  :arith-assert-diseq      394
;  :arith-assert-lower      3467
;  :arith-assert-upper      2680
;  :arith-bound-prop        354
;  :arith-conflicts         288
;  :arith-eq-adapter        1121
;  :arith-fixed-eqs         596
;  :arith-gcd-tests         3
;  :arith-grobner           1180
;  :arith-ineq-splits       3
;  :arith-max-min           3558
;  :arith-nonlinear-bounds  299
;  :arith-nonlinear-horner  1055
;  :arith-offset-eqs        854
;  :arith-patches           3
;  :arith-pivots            1163
;  :conflicts               910
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 1447
;  :datatype-occurs-check   808
;  :datatype-splits         1181
;  :decisions               4091
;  :del-clause              12855
;  :final-checks            648
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          41
;  :mk-bool-var             19095
;  :mk-clause               12949
;  :num-allocs              456197
;  :num-checks              213
;  :propagations            6142
;  :quant-instantiations    2990
;  :rlimit-count            1376545)
(push) ; 9
(assert (not (not (= $k@33@01 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12925
;  :arith-add-rows          5417
;  :arith-assert-diseq      394
;  :arith-assert-lower      3467
;  :arith-assert-upper      2680
;  :arith-bound-prop        354
;  :arith-conflicts         288
;  :arith-eq-adapter        1121
;  :arith-fixed-eqs         596
;  :arith-gcd-tests         3
;  :arith-grobner           1180
;  :arith-ineq-splits       3
;  :arith-max-min           3558
;  :arith-nonlinear-bounds  299
;  :arith-nonlinear-horner  1055
;  :arith-offset-eqs        854
;  :arith-patches           3
;  :arith-pivots            1163
;  :conflicts               910
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 1447
;  :datatype-occurs-check   808
;  :datatype-splits         1181
;  :decisions               4091
;  :del-clause              12855
;  :final-checks            648
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.96
;  :minimized-lits          41
;  :mk-bool-var             19095
;  :mk-clause               12949
;  :num-allocs              456231
;  :num-checks              214
;  :propagations            6142
;  :quant-instantiations    2990
;  :rlimit-count            1376556)
(assert (< $k@76@01 $k@33@01))
(assert (<= $Perm.No (- $k@33@01 $k@76@01)))
(assert (<= (- $k@33@01 $k@76@01) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@33@01 $k@76@01))
  (not
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
      $Ref.null))))
; [eval] exc == null ==> aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int == aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] exc == null
(push) ; 9
(push) ; 10
(assert (not false))
(check-sat)
; unknown
(pop) ; 10
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12997
;  :arith-add-rows          5467
;  :arith-assert-diseq      400
;  :arith-assert-lower      3514
;  :arith-assert-upper      2712
;  :arith-bound-prop        359
;  :arith-conflicts         288
;  :arith-eq-adapter        1135
;  :arith-fixed-eqs         604
;  :arith-gcd-tests         3
;  :arith-grobner           1226
;  :arith-ineq-splits       3
;  :arith-max-min           3617
;  :arith-nonlinear-bounds  300
;  :arith-nonlinear-horner  1103
;  :arith-offset-eqs        856
;  :arith-patches           3
;  :arith-pivots            1177
;  :conflicts               913
;  :datatype-accessor-ax    374
;  :datatype-constructor-ax 1453
;  :datatype-occurs-check   812
;  :datatype-splits         1187
;  :decisions               4112
;  :del-clause              12901
;  :final-checks            653
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.98
;  :minimized-lits          42
;  :mk-bool-var             19159
;  :mk-clause               12995
;  :num-allocs              464016
;  :num-checks              215
;  :propagations            6187
;  :quant-instantiations    2998
;  :rlimit-count            1422196
;  :time                    0.01)
; [then-branch: 133 | True | live]
; [else-branch: 133 | False | dead]
(push) ; 10
; [then-branch: 133 | True]
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int == aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 11
; Joined path conditions
(set-option :timeout 0)
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13008
;  :arith-add-rows          5494
;  :arith-assert-diseq      401
;  :arith-assert-lower      3520
;  :arith-assert-upper      2717
;  :arith-bound-prop        361
;  :arith-conflicts         289
;  :arith-eq-adapter        1139
;  :arith-fixed-eqs         606
;  :arith-gcd-tests         3
;  :arith-grobner           1226
;  :arith-ineq-splits       3
;  :arith-max-min           3617
;  :arith-nonlinear-bounds  300
;  :arith-nonlinear-horner  1103
;  :arith-offset-eqs        856
;  :arith-patches           3
;  :arith-pivots            1183
;  :conflicts               915
;  :datatype-accessor-ax    374
;  :datatype-constructor-ax 1453
;  :datatype-occurs-check   812
;  :datatype-splits         1187
;  :decisions               4113
;  :del-clause              12908
;  :final-checks            653
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          42
;  :mk-bool-var             19168
;  :mk-clause               13002
;  :num-allocs              464215
;  :num-checks              216
;  :propagations            6203
;  :quant-instantiations    3000
;  :rlimit-count            1423343
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 11
; Joined path conditions
(set-option :timeout 10)
(push) ; 11
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13009
;  :arith-add-rows          5494
;  :arith-assert-diseq      401
;  :arith-assert-lower      3520
;  :arith-assert-upper      2717
;  :arith-bound-prop        361
;  :arith-conflicts         289
;  :arith-eq-adapter        1139
;  :arith-fixed-eqs         606
;  :arith-gcd-tests         3
;  :arith-grobner           1226
;  :arith-ineq-splits       3
;  :arith-max-min           3617
;  :arith-nonlinear-bounds  300
;  :arith-nonlinear-horner  1103
;  :arith-offset-eqs        856
;  :arith-patches           3
;  :arith-pivots            1183
;  :conflicts               916
;  :datatype-accessor-ax    374
;  :datatype-constructor-ax 1453
;  :datatype-occurs-check   812
;  :datatype-splits         1187
;  :decisions               4113
;  :del-clause              12908
;  :final-checks            653
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          42
;  :mk-bool-var             19169
;  :mk-clause               13002
;  :num-allocs              464300
;  :num-checks              217
;  :propagations            6203
;  :quant-instantiations    3000
;  :rlimit-count            1423514)
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
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
(pop) ; 11
; Joined path conditions
(set-option :timeout 0)
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@17@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@16@01)
      $Perm.No)
    (ite
      (and
        (<
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
          V@11@01)
        (<=
          0
          (inv@25@01 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))
      (*
        (scale $Snap.unit (* (to_real (* V@11@01 V@11@01)) $Perm.Write))
        $k@24@01)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13034
;  :arith-add-rows          5523
;  :arith-assert-diseq      402
;  :arith-assert-lower      3529
;  :arith-assert-upper      2727
;  :arith-bound-prop        363
;  :arith-conflicts         290
;  :arith-eq-adapter        1148
;  :arith-fixed-eqs         609
;  :arith-gcd-tests         3
;  :arith-grobner           1226
;  :arith-ineq-splits       3
;  :arith-max-min           3617
;  :arith-nonlinear-bounds  300
;  :arith-nonlinear-horner  1103
;  :arith-offset-eqs        861
;  :arith-patches           3
;  :arith-pivots            1190
;  :conflicts               924
;  :datatype-accessor-ax    374
;  :datatype-constructor-ax 1453
;  :datatype-occurs-check   812
;  :datatype-splits         1187
;  :decisions               4120
;  :del-clause              12960
;  :final-checks            653
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          42
;  :mk-bool-var             19231
;  :mk-clause               13054
;  :num-allocs              464612
;  :num-checks              218
;  :propagations            6239
;  :quant-instantiations    3009
;  :rlimit-count            1424978)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 11
; Joined path conditions
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(pop) ; 11
; Joined path conditions
(set-option :timeout 10)
(push) ; 11
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@26@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unknown
(pop) ; 11
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13107
;  :arith-add-rows          5573
;  :arith-assert-diseq      408
;  :arith-assert-lower      3574
;  :arith-assert-upper      2758
;  :arith-bound-prop        368
;  :arith-conflicts         290
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1202
;  :conflicts               927
;  :datatype-accessor-ax    375
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13006
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.98
;  :minimized-lits          43
;  :mk-bool-var             19293
;  :mk-clause               13100
;  :num-allocs              472393
;  :num-checks              219
;  :propagations            6284
;  :quant-instantiations    3017
;  :rlimit-count            1473887
;  :time                    0.01)
(push) ; 11
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@31@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@59@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13108
;  :arith-add-rows          5573
;  :arith-assert-diseq      408
;  :arith-assert-lower      3574
;  :arith-assert-upper      2758
;  :arith-bound-prop        368
;  :arith-conflicts         290
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1202
;  :conflicts               928
;  :datatype-accessor-ax    375
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13006
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          43
;  :mk-bool-var             19294
;  :mk-clause               13100
;  :num-allocs              472476
;  :num-checks              220
;  :propagations            6284
;  :quant-instantiations    3017
;  :rlimit-count            1474048)
(push) ; 11
(assert (not (< $Perm.No $k@33@01)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13108
;  :arith-add-rows          5573
;  :arith-assert-diseq      408
;  :arith-assert-lower      3574
;  :arith-assert-upper      2758
;  :arith-bound-prop        368
;  :arith-conflicts         290
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1202
;  :conflicts               929
;  :datatype-accessor-ax    375
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13006
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.97
;  :minimized-lits          43
;  :mk-bool-var             19294
;  :mk-clause               13100
;  :num-allocs              472558
;  :num-checks              221
;  :propagations            6284
;  :quant-instantiations    3017
;  :rlimit-count            1474096)
(pop) ; 10
(pop) ; 9
; Joined path conditions
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 2 | !(0 < V@11@01)]
(assert (not (< 0 V@11@01)))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@14@01))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@14@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@14@01))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
; [then-branch: 134 | 0 < V@11@01 | dead]
; [else-branch: 134 | !(0 < V@11@01) | live]
(push) ; 4
; [else-branch: 134 | !(0 < V@11@01)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
; [then-branch: 135 | 0 < V@11@01 | dead]
; [else-branch: 135 | !(0 < V@11@01) | live]
(push) ; 4
; [else-branch: 135 | !(0 < V@11@01)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 3
; [then-branch: 136 | 0 < V@11@01 | dead]
; [else-branch: 136 | !(0 < V@11@01) | live]
(push) ; 4
; [else-branch: 136 | !(0 < V@11@01)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
; [then-branch: 137 | 0 < V@11@01 | dead]
; [else-branch: 137 | !(0 < V@11@01) | live]
(push) ; 4
; [else-branch: 137 | !(0 < V@11@01)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
; [then-branch: 138 | 0 < V@11@01 | dead]
; [else-branch: 138 | !(0 < V@11@01) | live]
(push) ; 4
; [else-branch: 138 | !(0 < V@11@01)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
; [eval] 0 < V
; [then-branch: 139 | 0 < V@11@01 | dead]
; [else-branch: 139 | !(0 < V@11@01) | live]
(push) ; 3
; [else-branch: 139 | !(0 < V@11@01)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
; [then-branch: 140 | 0 < V@11@01 | dead]
; [else-branch: 140 | !(0 < V@11@01) | live]
(push) ; 5
; [else-branch: 140 | !(0 < V@11@01)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
; [then-branch: 141 | 0 < V@11@01 | dead]
; [else-branch: 141 | !(0 < V@11@01) | live]
(push) ; 5
; [else-branch: 141 | !(0 < V@11@01)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] 0 < V
(push) ; 4
; [then-branch: 142 | 0 < V@11@01 | dead]
; [else-branch: 142 | !(0 < V@11@01) | live]
(push) ; 5
; [else-branch: 142 | !(0 < V@11@01)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
  $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@7@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
  $Snap.unit))
; [eval] i1 < V
(assert (< i1@7@01 V@11@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
  $Snap.unit))
; [eval] 0 <= j
(assert (<= 0 j@10@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
  $Snap.unit))
; [eval] j < V
(assert (< j@10@01 V@11@01))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))))))
; [eval] aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(target), i1).option$array$)
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= target@8@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5609
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               931
;  :datatype-accessor-ax    389
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19327
;  :mk-clause               13100
;  :num-allocs              473940
;  :num-checks              222
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1477616)
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= target@8@01 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit target@8@01)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5610
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               932
;  :datatype-accessor-ax    389
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19329
;  :mk-clause               13100
;  :num-allocs              474085
;  :num-checks              223
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1477766)
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(pop) ; 4
; Joined path conditions
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit target@8@01))))
(declare-const sm@77@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@78@01 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@78@01  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@78@01  $FPM) r))
  :qid |qp.resPrmSumDef29|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@78@01  $FPM) r))
  :qid |qp.resTrgDef30|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))
(push) ; 4
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@78@01  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5611
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               933
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19334
;  :mk-clause               13100
;  :num-allocs              474469
;  :num-checks              224
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1478208)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5611
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               934
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19335
;  :mk-clause               13100
;  :num-allocs              474559
;  :num-checks              225
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1478297)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5611
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               935
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19337
;  :mk-clause               13100
;  :num-allocs              474709
;  :num-checks              226
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1478546)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
    $Ref.null)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j)
; [eval] opt_get1(aloc(opt_get1(source), i1).option$array$)
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not (= source@9@01 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5611
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               936
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19339
;  :mk-clause               13100
;  :num-allocs              474868
;  :num-checks              227
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1478819)
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@9@01 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit source@9@01)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5612
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               937
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19340
;  :mk-clause               13100
;  :num-allocs              475012
;  :num-checks              228
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1478961)
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(pop) ; 4
; Joined path conditions
(assert (< i1@7@01 (alen<Int> (opt_get1 $Snap.unit source@9@01))))
(declare-const sm@79@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@80@01 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@80@01  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@80@01  $FPM) r))
  :qid |qp.resPrmSumDef32|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@80@01  $FPM) r))
  :qid |qp.resTrgDef33|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))
(push) ; 4
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@80@01  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               938
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19345
;  :mk-clause               13100
;  :num-allocs              475393
;  :num-checks              229
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1479403)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 5
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               939
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19346
;  :mk-clause               13100
;  :num-allocs              475483
;  :num-checks              230
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1479492)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1162
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               940
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19348
;  :mk-clause               13100
;  :num-allocs              475630
;  :num-checks              231
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1479737)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(pop) ; 4
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(declare-const $k@81@01 $Perm)
(assert ($Perm.isReadVar $k@81@01 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@81@01 $Perm.No) (< $Perm.No $k@81@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               941
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19353
;  :mk-clause               13102
;  :num-allocs              475854
;  :num-checks              232
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1480074)
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@79@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               942
;  :datatype-accessor-ax    390
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.93
;  :minimized-lits          43
;  :mk-bool-var             19354
;  :mk-clause               13102
;  :num-allocs              475946
;  :num-checks              233
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1480257)
(assert (implies
  (< $Perm.No $k@81@01)
  (=
    ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))))
    ($SortWrappers.$SnapToInt ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01)))))))))))))))))))))
(assert (<= $Perm.No (+ $Perm.Write $k@81@01)))
(assert (<= (+ $Perm.Write $k@81@01) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $Perm.Write $k@81@01))
  (not
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
      $Ref.null))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unsat
(push) ; 4
(declare-const $t@82@01 $Snap)
(assert (= $t@82@01 ($Snap.combine ($Snap.first $t@82@01) ($Snap.second $t@82@01))))
(assert (= ($Snap.first $t@82@01) $Snap.unit))
; [eval] exc == null
(assert (= exc@12@01 $Ref.null))
(assert (=
  ($Snap.second $t@82@01)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@82@01))
    ($Snap.second ($Snap.second $t@82@01)))))
(assert (= ($Snap.first ($Snap.second $t@82@01)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 143 | exc@12@01 == Null | live]
; [else-branch: 143 | exc@12@01 != Null | live]
(push) ; 6
; [then-branch: 143 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 143 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               943
;  :datatype-accessor-ax    392
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19360
;  :mk-clause               13102
;  :num-allocs              476281
;  :num-checks              235
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1480784)
; [then-branch: 144 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 144 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 6
; [else-branch: 144 | !(0 < V@11@01 && exc@12@01 == Null)]
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second $t@82@01))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@82@01)))
    ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@82@01))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 145 | exc@12@01 == Null | live]
; [else-branch: 145 | exc@12@01 != Null | live]
(push) ; 6
; [then-branch: 145 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 145 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               943
;  :datatype-accessor-ax    393
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19362
;  :mk-clause               13102
;  :num-allocs              476389
;  :num-checks              236
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1480965)
; [then-branch: 146 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 146 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 6
; [else-branch: 146 | !(0 < V@11@01 && exc@12@01 == Null)]
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@82@01)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@01))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 147 | exc@12@01 == Null | live]
; [else-branch: 147 | exc@12@01 != Null | live]
(push) ; 6
; [then-branch: 147 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 147 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               943
;  :datatype-accessor-ax    394
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19363
;  :mk-clause               13102
;  :num-allocs              476497
;  :num-checks              237
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1481124)
; [then-branch: 148 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 148 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 5
; [else-branch: 148 | !(0 < V@11@01 && exc@12@01 == Null)]
(assert (not (and (< 0 V@11@01) (= exc@12@01 $Ref.null))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@82@01))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 149 | exc@12@01 == Null | live]
; [else-branch: 149 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 149 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 149 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 150 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 150 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 7
; [else-branch: 150 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 151 | exc@12@01 == Null | live]
; [else-branch: 151 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 151 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 151 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 152 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 152 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 7
; [else-branch: 152 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 153 | exc@12@01 == Null | live]
; [else-branch: 153 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 153 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 153 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 154 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 154 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 7
; [else-branch: 154 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 155 | exc@12@01 == Null | live]
; [else-branch: 155 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 155 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 155 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 156 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 156 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 7
; [else-branch: 156 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 157 | exc@12@01 == Null | live]
; [else-branch: 157 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 157 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 157 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 158 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 158 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 7
; [else-branch: 158 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 159 | exc@12@01 == Null | live]
; [else-branch: 159 | exc@12@01 != Null | live]
(push) ; 7
; [then-branch: 159 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 159 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
; [then-branch: 160 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 160 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 6
; [else-branch: 160 | !(0 < V@11@01 && exc@12@01 == Null)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 161 | exc@12@01 == Null | live]
; [else-branch: 161 | exc@12@01 != Null | live]
(push) ; 8
; [then-branch: 161 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 161 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 162 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 162 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 8
; [else-branch: 162 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 163 | exc@12@01 == Null | live]
; [else-branch: 163 | exc@12@01 != Null | live]
(push) ; 8
; [then-branch: 163 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 163 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 164 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 164 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 8
; [else-branch: 164 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 165 | exc@12@01 == Null | live]
; [else-branch: 165 | exc@12@01 != Null | live]
(push) ; 8
; [then-branch: 165 | exc@12@01 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 165 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 166 | 0 < V@11@01 && exc@12@01 == Null | dead]
; [else-branch: 166 | !(0 < V@11@01 && exc@12@01 == Null) | live]
(push) ; 8
; [else-branch: 166 | !(0 < V@11@01 && exc@12@01 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               944
;  :datatype-accessor-ax    404
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19384
;  :mk-clause               13102
;  :num-allocs              477640
;  :num-checks              238
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1483391)
; [then-branch: 167 | exc@12@01 == Null | dead]
; [else-branch: 167 | exc@12@01 != Null | live]
(push) ; 8
; [else-branch: 167 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               945
;  :datatype-accessor-ax    405
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19386
;  :mk-clause               13102
;  :num-allocs              477776
;  :num-checks              239
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1483670)
; [then-branch: 168 | exc@12@01 == Null | dead]
; [else-branch: 168 | exc@12@01 != Null | live]
(push) ; 8
; [else-branch: 168 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= j
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               946
;  :datatype-accessor-ax    406
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19388
;  :mk-clause               13102
;  :num-allocs              477912
;  :num-checks              240
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1483959)
; [then-branch: 169 | exc@12@01 == Null | dead]
; [else-branch: 169 | exc@12@01 != Null | live]
(push) ; 8
; [else-branch: 169 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> j < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               947
;  :datatype-accessor-ax    407
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19390
;  :mk-clause               13102
;  :num-allocs              478049
;  :num-checks              241
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1484258)
; [then-branch: 170 | exc@12@01 == Null | dead]
; [else-branch: 170 | exc@12@01 != Null | live]
(push) ; 8
; [else-branch: 170 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))))))
; [eval] exc == null
(push) ; 7
(assert (not (not (= exc@12@01 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               948
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19391
;  :mk-clause               13102
;  :num-allocs              478180
;  :num-checks              242
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1484535)
; [then-branch: 171 | exc@12@01 == Null | dead]
; [else-branch: 171 | exc@12@01 != Null | live]
(push) ; 7
; [else-branch: 171 | exc@12@01 != Null]
(assert (not (= exc@12@01 $Ref.null)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01))))))))))))))))))))))
; [eval] exc == null
; [then-branch: 172 | exc@12@01 == Null | dead]
; [else-branch: 172 | exc@12@01 != Null | live]
(push) ; 8
; [else-branch: 172 | exc@12@01 != Null]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@82@01)))))))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int == aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] exc == null
(push) ; 9
; [then-branch: 173 | exc@12@01 == Null | dead]
; [else-branch: 173 | exc@12@01 != Null | live]
(push) ; 10
; [else-branch: 173 | exc@12@01 != Null]
(pop) ; 10
(pop) ; 9
; Joined path conditions
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(push) ; 4
; [exec]
; var return: void
(declare-const return@83@01 void)
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
(declare-const sm@84@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@85@01 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@85@01  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@85@01  $FPM) r))
  :qid |qp.resPrmSumDef35|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@85@01  $FPM) r))
  :qid |qp.resTrgDef36|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@85@01  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               949
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19395
;  :mk-clause               13102
;  :num-allocs              478536
;  :num-checks              243
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1484911)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               950
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19396
;  :mk-clause               13102
;  :num-allocs              478628
;  :num-checks              244
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1485000)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               951
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19398
;  :mk-clause               13102
;  :num-allocs              478782
;  :num-checks              245
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1485245)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
(pop) ; 5
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))))))
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
(declare-const sm@86@01 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@87@01 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@87@01  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@87@01  $FPM) r))
  :qid |qp.resPrmSumDef38|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@87@01  $FPM) r))
  :qid |qp.resTrgDef39|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@87@01  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               952
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19403
;  :mk-clause               13102
;  :num-allocs              479217
;  :num-checks              246
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1485763)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               953
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19404
;  :mk-clause               13102
;  :num-allocs              479307
;  :num-checks              247
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1485852)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               954
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19406
;  :mk-clause               13102
;  :num-allocs              479458
;  :num-checks              248
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1486097)
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(pop) ; 5
; Joined path conditions
(assert (<
  j@10@01
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))))))
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@9@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               955
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19408
;  :mk-clause               13102
;  :num-allocs              479625
;  :num-checks              249
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1486434)
(push) ; 5
(assert (not (< $Perm.No (+ $Perm.Write $k@81@01))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               956
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19409
;  :mk-clause               13102
;  :num-allocs              479721
;  :num-checks              250
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1486481)
(push) ; 5
(assert (not (=
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
  (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               957
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19410
;  :mk-clause               13102
;  :num-allocs              479804
;  :num-checks              251
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1486640)
(push) ; 5
(assert (not (=
  (- (+ $Perm.Write $k@81@01) ($Perm.min (+ $Perm.Write $k@81@01) $Perm.Write))
  $Perm.No)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               957
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19410
;  :mk-clause               13102
;  :num-allocs              479898
;  :num-checks              252
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1486680)
(set-option :timeout 0)
(push) ; 5
(assert (not (or
  (= (- $Perm.Write ($Perm.min (+ $Perm.Write $k@81@01) $Perm.Write)) $Perm.No)
  (< (- $Perm.Write ($Perm.min (+ $Perm.Write $k@81@01) $Perm.Write)) $Perm.No))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               958
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19410
;  :mk-clause               13102
;  :num-allocs              480079
;  :num-checks              253
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1486747)
(declare-const int@88@01 Int)
(assert (=
  int@88@01
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@14@01))))))))))))))))))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@84@01  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@8@01) i1@7@01))) j@10@01)
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
; [then-branch: 174 | True | live]
; [else-branch: 174 | False | live]
(push) ; 6
; [then-branch: 174 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 174 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 175 | 0 < V@11@01 | dead]
; [else-branch: 175 | !(0 < V@11@01) | live]
(push) ; 6
; [else-branch: 175 | !(0 < V@11@01)]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 176 | True | live]
; [else-branch: 176 | False | live]
(push) ; 6
; [then-branch: 176 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 176 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 177 | 0 < V@11@01 | dead]
; [else-branch: 177 | !(0 < V@11@01) | live]
(push) ; 6
; [else-branch: 177 | !(0 < V@11@01)]
(pop) ; 6
(pop) ; 5
; Joined path conditions
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 178 | True | live]
; [else-branch: 178 | False | live]
(push) ; 6
; [then-branch: 178 | True]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 178 | False]
(assert false)
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
; [then-branch: 179 | 0 < V@11@01 | dead]
; [else-branch: 179 | !(0 < V@11@01) | live]
(push) ; 5
; [else-branch: 179 | !(0 < V@11@01)]
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(source), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 180 | True | live]
; [else-branch: 180 | False | live]
(push) ; 7
; [then-branch: 180 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 180 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 181 | 0 < V@11@01 | dead]
; [else-branch: 181 | !(0 < V@11@01) | live]
(push) ; 7
; [else-branch: 181 | !(0 < V@11@01)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(source), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 182 | True | live]
; [else-branch: 182 | False | live]
(push) ; 7
; [then-branch: 182 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 182 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 183 | 0 < V@11@01 | dead]
; [else-branch: 183 | !(0 < V@11@01) | live]
(push) ; 7
; [else-branch: 183 | !(0 < V@11@01)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(source), i2) } (forall i3: Int :: { aloc(opt_get1(source), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(source), i2).option$array$ == aloc(opt_get1(source), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 184 | True | live]
; [else-branch: 184 | False | live]
(push) ; 7
; [then-branch: 184 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 184 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 185 | 0 < V@11@01 | dead]
; [else-branch: 185 | !(0 < V@11@01) | live]
(push) ; 7
; [else-branch: 185 | !(0 < V@11@01)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 186 | True | live]
; [else-branch: 186 | False | live]
(push) ; 7
; [then-branch: 186 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 186 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 187 | 0 < V@11@01 | dead]
; [else-branch: 187 | !(0 < V@11@01) | live]
(push) ; 7
; [else-branch: 187 | !(0 < V@11@01)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 188 | True | live]
; [else-branch: 188 | False | live]
(push) ; 7
; [then-branch: 188 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 188 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 189 | 0 < V@11@01 | dead]
; [else-branch: 189 | !(0 < V@11@01) | live]
(push) ; 7
; [else-branch: 189 | !(0 < V@11@01)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 190 | True | live]
; [else-branch: 190 | False | live]
(push) ; 7
; [then-branch: 190 | True]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 190 | False]
(assert false)
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
; [then-branch: 191 | 0 < V@11@01 | dead]
; [else-branch: 191 | !(0 < V@11@01) | live]
(push) ; 6
; [else-branch: 191 | !(0 < V@11@01)]
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i2 && i2 < V ==> aloc(opt_get1(target), i2).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 192 | True | live]
; [else-branch: 192 | False | live]
(push) ; 8
; [then-branch: 192 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 192 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 193 | 0 < V@11@01 | dead]
; [else-branch: 193 | !(0 < V@11@01) | live]
(push) ; 8
; [else-branch: 193 | !(0 < V@11@01)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) } 0 <= i2 && i2 < V ==> alen(opt_get1(aloc(opt_get1(target), i2).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 194 | True | live]
; [else-branch: 194 | False | live]
(push) ; 8
; [then-branch: 194 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 194 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 195 | 0 < V@11@01 | dead]
; [else-branch: 195 | !(0 < V@11@01) | live]
(push) ; 8
; [else-branch: 195 | !(0 < V@11@01)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null && 0 < V ==> (forall i2: Int :: { aloc(opt_get1(target), i2) } (forall i3: Int :: { aloc(opt_get1(target), i3) } 0 <= i2 && i2 < V && 0 <= i3 && i3 < V && aloc(opt_get1(target), i2).option$array$ == aloc(opt_get1(target), i3).option$array$ ==> i2 == i3))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 196 | True | live]
; [else-branch: 196 | False | live]
(push) ; 8
; [then-branch: 196 | True]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 196 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 197 | 0 < V@11@01 | dead]
; [else-branch: 197 | !(0 < V@11@01) | live]
(push) ; 8
; [else-branch: 197 | !(0 < V@11@01)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not false))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               959
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19412
;  :mk-clause               13102
;  :num-allocs              480212
;  :num-checks              254
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1487229)
; [then-branch: 198 | True | dead]
; [else-branch: 198 | False | live]
(push) ; 8
; [else-branch: 198 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not false))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               960
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19412
;  :mk-clause               13102
;  :num-allocs              480229
;  :num-checks              255
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1487242)
; [then-branch: 199 | True | dead]
; [else-branch: 199 | False | live]
(push) ; 8
; [else-branch: 199 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> 0 <= j
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not false))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               961
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19412
;  :mk-clause               13102
;  :num-allocs              480246
;  :num-checks              256
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1487255)
; [then-branch: 200 | True | dead]
; [else-branch: 200 | False | live]
(push) ; 8
; [else-branch: 200 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null ==> j < V
; [eval] exc == null
(push) ; 7
(push) ; 8
(assert (not false))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               962
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19412
;  :mk-clause               13102
;  :num-allocs              480263
;  :num-checks              257
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1487268)
; [then-branch: 201 | True | dead]
; [else-branch: 201 | False | live]
(push) ; 8
; [else-branch: 201 | False]
(assert false)
(pop) ; 8
(pop) ; 7
; Joined path conditions
; [eval] exc == null
(push) ; 7
(assert (not false))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13192
;  :arith-add-rows          5613
;  :arith-assert-diseq      408
;  :arith-assert-lower      3578
;  :arith-assert-upper      2759
;  :arith-bound-prop        368
;  :arith-conflicts         291
;  :arith-eq-adapter        1163
;  :arith-fixed-eqs         617
;  :arith-gcd-tests         3
;  :arith-grobner           1276
;  :arith-ineq-splits       3
;  :arith-max-min           3676
;  :arith-nonlinear-bounds  301
;  :arith-nonlinear-horner  1151
;  :arith-offset-eqs        863
;  :arith-patches           3
;  :arith-pivots            1226
;  :conflicts               963
;  :datatype-accessor-ax    408
;  :datatype-constructor-ax 1459
;  :datatype-occurs-check   816
;  :datatype-splits         1193
;  :decisions               4141
;  :del-clause              13094
;  :final-checks            658
;  :interface-eqs           155
;  :max-generation          6
;  :max-memory              6.02
;  :memory                  5.94
;  :minimized-lits          43
;  :mk-bool-var             19412
;  :mk-clause               13102
;  :num-allocs              480280
;  :num-checks              258
;  :propagations            6285
;  :quant-instantiations    3017
;  :rlimit-count            1487279)
; [then-branch: 202 | True | dead]
; [else-branch: 202 | False | live]
(push) ; 7
; [else-branch: 202 | False]
(assert false)
; [eval] exc == null
; [then-branch: 203 | True | dead]
; [else-branch: 203 | False | live]
(push) ; 8
; [else-branch: 203 | False]
; [eval] exc == null ==> aloc(opt_get1(aloc(opt_get1(target), i1).option$array$), j).int == aloc(opt_get1(aloc(opt_get1(source), i1).option$array$), j).int
; [eval] exc == null
(push) ; 9
; [then-branch: 204 | True | dead]
; [else-branch: 204 | False | live]
(push) ; 10
; [else-branch: 204 | False]
(pop) ; 10
(pop) ; 9
; Joined path conditions
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
