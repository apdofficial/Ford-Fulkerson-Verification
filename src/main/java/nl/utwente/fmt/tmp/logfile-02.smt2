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
; ---------- do_par_$unknown$1 ----------
(declare-const V@0@02 Int)
(declare-const source@1@02 option<array>)
(declare-const target@2@02 option<array>)
(declare-const exc@3@02 $Ref)
(declare-const res@4@02 void)
(declare-const V@5@02 Int)
(declare-const source@6@02 option<array>)
(declare-const target@7@02 option<array>)
(declare-const exc@8@02 $Ref)
(declare-const res@9@02 void)
(push) ; 1
(declare-const $t@10@02 $Snap)
(assert (= $t@10@02 ($Snap.combine ($Snap.first $t@10@02) ($Snap.second $t@10@02))))
(assert (= ($Snap.first $t@10@02) $Snap.unit))
; [eval] 0 < V ==> source != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@5@02))))
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
;  :memory                  4.18
;  :mk-bool-var             413
;  :num-allocs              158063
;  :num-checks              1
;  :quant-instantiations    2
;  :rlimit-count            180175)
(push) ; 3
(assert (not (< 0 V@5@02)))
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
;  :memory                  4.18
;  :mk-bool-var             415
;  :num-allocs              158433
;  :num-checks              2
;  :quant-instantiations    2
;  :rlimit-count            180671)
; [then-branch: 0 | 0 < V@5@02 | live]
; [else-branch: 0 | !(0 < V@5@02) | live]
(push) ; 3
; [then-branch: 0 | 0 < V@5@02]
(assert (< 0 V@5@02))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 0 | !(0 < V@5@02)]
(assert (not (< 0 V@5@02)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (not (= source@6@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@10@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@10@02))
    ($Snap.second ($Snap.second $t@10@02)))))
(assert (= ($Snap.first ($Snap.second $t@10@02)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(source)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@5@02))))
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
(assert (not (< 0 V@5@02)))
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
; [then-branch: 1 | 0 < V@5@02 | live]
; [else-branch: 1 | !(0 < V@5@02) | live]
(push) ; 3
; [then-branch: 1 | 0 < V@5@02]
(assert (< 0 V@5@02))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
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
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 1 | !(0 < V@5@02)]
(assert (not (< 0 V@5@02)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (and
    (< 0 V@5@02)
    (not (= source@6@02 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies (< 0 V@5@02) (= (alen<Int> (opt_get1 $Snap.unit source@6@02)) V@5@02)))
(assert (=
  ($Snap.second ($Snap.second $t@10@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@10@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 2
(assert (not (not (< 0 V@5@02))))
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
;  :num-allocs              160232
;  :num-checks              6
;  :propagations            5
;  :quant-instantiations    7
;  :rlimit-count            183002)
(push) ; 2
(assert (not (< 0 V@5@02)))
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
;  :num-allocs              160608
;  :num-checks              7
;  :propagations            6
;  :quant-instantiations    7
;  :rlimit-count            183518)
; [then-branch: 2 | 0 < V@5@02 | live]
; [else-branch: 2 | !(0 < V@5@02) | live]
(push) ; 2
; [then-branch: 2 | 0 < V@5@02]
(assert (< 0 V@5@02))
(declare-const i1@11@02 Int)
(push) ; 3
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 4
; [then-branch: 3 | 0 <= i1@11@02 | live]
; [else-branch: 3 | !(0 <= i1@11@02) | live]
(push) ; 5
; [then-branch: 3 | 0 <= i1@11@02]
(assert (<= 0 i1@11@02))
; [eval] i1 < V
(pop) ; 5
(push) ; 5
; [else-branch: 3 | !(0 <= i1@11@02)]
(assert (not (<= 0 i1@11@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i1@11@02 V@5@02) (<= 0 i1@11@02)))
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
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
;  :num-allocs              160878
;  :num-checks              8
;  :propagations            9
;  :quant-instantiations    12
;  :rlimit-count            183874)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 4
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 5
(assert (not (< i1@11@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
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
;  :memory                  4.22
;  :mk-bool-var             447
;  :mk-clause               7
;  :num-allocs              161031
;  :num-checks              9
;  :propagations            9
;  :quant-instantiations    12
;  :rlimit-count            184037)
(assert (< i1@11@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 4
; Joined path conditions
(assert (< i1@11@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 4
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 5
(assert (not (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No)))
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
;  :num-allocs              161227
;  :num-checks              10
;  :propagations            9
;  :quant-instantiations    12
;  :rlimit-count            184283)
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(pop) ; 4
; Joined path conditions
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(declare-const $k@12@02 $Perm)
(assert ($Perm.isReadVar $k@12@02 $Perm.Write))
(pop) ; 3
(declare-fun inv@13@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@12@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@11@02 Int)) (!
  (and
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@11@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@11@02))
  :qid |option$array$-aux|)))
(push) ; 3
(assert (not (forall ((i1@11@02 Int)) (!
  (implies
    (and (< i1@11@02 V@5@02) (<= 0 i1@11@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@12@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@12@02))))
  
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
;  :num-allocs              162013
;  :num-checks              11
;  :propagations            14
;  :quant-instantiations    15
;  :rlimit-count            185327)
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i11@11@02 Int) (i12@11@02 Int)) (!
  (implies
    (and
      (and
        (and (< i11@11@02 V@5@02) (<= 0 i11@11@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@12@02)))
      (and
        (and (< i12@11@02 V@5@02) (<= 0 i12@11@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@12@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i11@11@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i12@11@02)))
    (= i11@11@02 i12@11@02))
  
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
;  :num-allocs              162557
;  :num-checks              12
;  :propagations            30
;  :quant-instantiations    30
;  :rlimit-count            186289)
; Definitional axioms for inverse functions
(assert (forall ((i1@11@02 Int)) (!
  (implies
    (and
      (and (< i1@11@02 V@5@02) (<= 0 i1@11@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@12@02)))
    (=
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@11@02))
      i1@11@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@11@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@13@02 r) V@5@02) (<= 0 (inv@13@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@12@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) (inv@13@02 r))
      r))
  :pattern ((inv@13@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@11@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@11@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@11@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@11@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@11@02 Int)) (!
  (implies
    (and
      (and (< i1@11@02 V@5@02) (<= 0 i1@11@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@12@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@11@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@11@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@14@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@13@02 r) V@5@02) (<= 0 (inv@13@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@12@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@02)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@02)))) r))
  :qid |qp.fvfValDef0|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@02)))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef1|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@13@02 r) V@5@02) (<= 0 (inv@13@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) r) r))
  :pattern ((inv@13@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@5@02))))
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
;  :num-allocs              164436
;  :num-checks              13
;  :propagations            33
;  :quant-instantiations    33
;  :rlimit-count            189756)
; [then-branch: 4 | 0 < V@5@02 | live]
; [else-branch: 4 | !(0 < V@5@02) | dead]
(push) ; 4
; [then-branch: 4 | 0 < V@5@02]
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
(declare-const i1@15@02 Int)
(push) ; 5
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 6
; [then-branch: 5 | 0 <= i1@15@02 | live]
; [else-branch: 5 | !(0 <= i1@15@02) | live]
(push) ; 7
; [then-branch: 5 | 0 <= i1@15@02]
(assert (<= 0 i1@15@02))
; [eval] i1 < V
(pop) ; 7
(push) ; 7
; [else-branch: 5 | !(0 <= i1@15@02)]
(assert (not (<= 0 i1@15@02)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 6 | i1@15@02 < V@5@02 && 0 <= i1@15@02 | live]
; [else-branch: 6 | !(i1@15@02 < V@5@02 && 0 <= i1@15@02) | live]
(push) ; 7
; [then-branch: 6 | i1@15@02 < V@5@02 && 0 <= i1@15@02]
(assert (and (< i1@15@02 V@5@02) (<= 0 i1@15@02)))
; [eval] aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
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
;  :num-allocs              164647
;  :num-checks              14
;  :propagations            33
;  :quant-instantiations    33
;  :rlimit-count            189976)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i1@15@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
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
;  :num-allocs              164791
;  :num-checks              15
;  :propagations            33
;  :quant-instantiations    33
;  :rlimit-count            190131)
(assert (< i1@15@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 8
; Joined path conditions
(assert (< i1@15@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))
      V@5@02)
    (<=
      0
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02))
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
;  :num-allocs              165291
;  :num-checks              16
;  :propagations            47
;  :quant-instantiations    44
;  :rlimit-count            191192)
; [eval] (None(): option[array])
(pop) ; 7
(push) ; 7
; [else-branch: 6 | !(i1@15@02 < V@5@02 && 0 <= i1@15@02)]
(assert (not (and (< i1@15@02 V@5@02) (<= 0 i1@15@02))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i1@15@02 V@5@02) (<= 0 i1@15@02))
  (and
    (< i1@15@02 V@5@02)
    (<= 0 i1@15@02)
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@15@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02)))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@15@02 Int)) (!
  (implies
    (and (< i1@15@02 V@5@02) (<= 0 i1@15@02))
    (and
      (< i1@15@02 V@5@02)
      (<= 0 i1@15@02)
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< i1@15@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@15@02 Int)) (!
    (implies
      (and (< i1@15@02 V@5@02) (<= 0 i1@15@02))
      (and
        (< i1@15@02 V@5@02)
        (<= 0 i1@15@02)
        (not (= source@6@02 (as None<option<array>>  option<array>)))
        (< i1@15@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@15@02 Int)) (!
    (implies
      (and (< i1@15@02 V@5@02) (<= 0 i1@15@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@15@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@5@02))))
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
; [then-branch: 7 | 0 < V@5@02 | live]
; [else-branch: 7 | !(0 < V@5@02) | dead]
(push) ; 4
; [then-branch: 7 | 0 < V@5@02]
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
(declare-const i1@16@02 Int)
(push) ; 5
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 6
; [then-branch: 8 | 0 <= i1@16@02 | live]
; [else-branch: 8 | !(0 <= i1@16@02) | live]
(push) ; 7
; [then-branch: 8 | 0 <= i1@16@02]
(assert (<= 0 i1@16@02))
; [eval] i1 < V
(pop) ; 7
(push) ; 7
; [else-branch: 8 | !(0 <= i1@16@02)]
(assert (not (<= 0 i1@16@02)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 9 | i1@16@02 < V@5@02 && 0 <= i1@16@02 | live]
; [else-branch: 9 | !(i1@16@02 < V@5@02 && 0 <= i1@16@02) | live]
(push) ; 7
; [then-branch: 9 | i1@16@02 < V@5@02 && 0 <= i1@16@02]
(assert (and (< i1@16@02 V@5@02) (<= 0 i1@16@02)))
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
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
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
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i1@16@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
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
;  :memory                  4.32
;  :mk-bool-var             565
;  :mk-clause               70
;  :num-allocs              166744
;  :num-checks              19
;  :propagations            50
;  :quant-instantiations    44
;  :rlimit-count            193612)
(assert (< i1@16@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 8
; Joined path conditions
(assert (< i1@16@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)))
(push) ; 8
(assert (not (ite
  (and
    (<
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
      V@5@02)
    (<=
      0
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02))
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
;  :memory                  4.33
;  :mk-bool-var             593
;  :mk-clause               87
;  :num-allocs              167109
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
    ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
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
;  :memory                  4.33
;  :mk-bool-var             593
;  :mk-clause               87
;  :num-allocs              167200
;  :num-checks              21
;  :propagations            62
;  :quant-instantiations    57
;  :rlimit-count            194763)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
    (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
    (as None<option<array>>  option<array>))))
(pop) ; 7
(push) ; 7
; [else-branch: 9 | !(i1@16@02 < V@5@02 && 0 <= i1@16@02)]
(assert (not (and (< i1@16@02 V@5@02) (<= 0 i1@16@02))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< i1@16@02 V@5@02) (<= 0 i1@16@02))
  (and
    (< i1@16@02 V@5@02)
    (<= 0 i1@16@02)
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@16@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@16@02 Int)) (!
  (implies
    (and (< i1@16@02 V@5@02) (<= 0 i1@16@02))
    (and
      (< i1@16@02 V@5@02)
      (<= 0 i1@16@02)
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< i1@16@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@16@02 Int)) (!
    (implies
      (and (< i1@16@02 V@5@02) (<= 0 i1@16@02))
      (and
        (< i1@16@02 V@5@02)
        (<= 0 i1@16@02)
        (not (= source@6@02 (as None<option<array>>  option<array>)))
        (< i1@16@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@16@02 Int)) (!
    (implies
      (and (< i1@16@02 V@5@02) (<= 0 i1@16@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02))))
        V@5@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@16@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@5@02))))
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
;  :num-allocs              168389
;  :num-checks              22
;  :propagations            65
;  :quant-instantiations    57
;  :rlimit-count            196885)
; [then-branch: 10 | 0 < V@5@02 | live]
; [else-branch: 10 | !(0 < V@5@02) | dead]
(push) ; 4
; [then-branch: 10 | 0 < V@5@02]
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
(declare-const i1@17@02 Int)
(push) ; 5
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2)
(declare-const i2@18@02 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 11 | 0 <= i1@17@02 | live]
; [else-branch: 11 | !(0 <= i1@17@02) | live]
(push) ; 8
; [then-branch: 11 | 0 <= i1@17@02]
(assert (<= 0 i1@17@02))
; [eval] i1 < V
(push) ; 9
; [then-branch: 12 | i1@17@02 < V@5@02 | live]
; [else-branch: 12 | !(i1@17@02 < V@5@02) | live]
(push) ; 10
; [then-branch: 12 | i1@17@02 < V@5@02]
(assert (< i1@17@02 V@5@02))
; [eval] 0 <= i2
(push) ; 11
; [then-branch: 13 | 0 <= i2@18@02 | live]
; [else-branch: 13 | !(0 <= i2@18@02) | live]
(push) ; 12
; [then-branch: 13 | 0 <= i2@18@02]
(assert (<= 0 i2@18@02))
; [eval] i2 < V
(push) ; 13
; [then-branch: 14 | i2@18@02 < V@5@02 | live]
; [else-branch: 14 | !(i2@18@02 < V@5@02) | live]
(push) ; 14
; [then-branch: 14 | i2@18@02 < V@5@02]
(assert (< i2@18@02 V@5@02))
; [eval] aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 15
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 16
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
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
;  :num-allocs              168748
;  :num-checks              23
;  :propagations            65
;  :quant-instantiations    57
;  :rlimit-count            197234)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 15
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 15
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 16
(assert (not (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
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
;  :memory                  4.34
;  :mk-bool-var             604
;  :mk-clause               87
;  :num-allocs              168900
;  :num-checks              24
;  :propagations            65
;  :quant-instantiations    57
;  :rlimit-count            197385)
(assert (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 15
; Joined path conditions
(assert (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
      V@5@02)
    (<=
      0
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02))
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
;  :memory                  4.34
;  :mk-bool-var             629
;  :mk-clause               101
;  :num-allocs              169251
;  :num-checks              25
;  :propagations            76
;  :quant-instantiations    70
;  :rlimit-count            198405)
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
(assert (not (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
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
;  :memory                  4.34
;  :mk-bool-var             630
;  :mk-clause               101
;  :num-allocs              169342
;  :num-checks              26
;  :propagations            76
;  :quant-instantiations    70
;  :rlimit-count            198550)
(assert (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 15
; Joined path conditions
(assert (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
(push) ; 15
(assert (not (ite
  (and
    (<
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))
      V@5@02)
    (<=
      0
      (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02))
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
;  :memory                  4.36
;  :mk-bool-var             655
;  :mk-clause               114
;  :num-allocs              169730
;  :num-checks              27
;  :propagations            85
;  :quant-instantiations    82
;  :rlimit-count            199561)
(pop) ; 14
(push) ; 14
; [else-branch: 14 | !(i2@18@02 < V@5@02)]
(assert (not (< i2@18@02 V@5@02)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i2@18@02 V@5@02)
  (and
    (< i2@18@02 V@5@02)
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
    (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 13 | !(0 <= i2@18@02)]
(assert (not (<= 0 i2@18@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i2@18@02)
  (and
    (<= 0 i2@18@02)
    (implies
      (< i2@18@02 V@5@02)
      (and
        (< i2@18@02 V@5@02)
        (not (= source@6@02 (as None<option<array>>  option<array>)))
        (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
        (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))))))
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 12 | !(i1@17@02 < V@5@02)]
(assert (not (< i1@17@02 V@5@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (< i1@17@02 V@5@02)
  (and
    (< i1@17@02 V@5@02)
    (implies
      (<= 0 i2@18@02)
      (and
        (<= 0 i2@18@02)
        (implies
          (< i2@18@02 V@5@02)
          (and
            (< i2@18@02 V@5@02)
            (not (= source@6@02 (as None<option<array>>  option<array>)))
            (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
            (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))))))))
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= i1@17@02)]
(assert (not (<= 0 i1@17@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (<= 0 i1@17@02)
  (and
    (<= 0 i1@17@02)
    (implies
      (< i1@17@02 V@5@02)
      (and
        (< i1@17@02 V@5@02)
        (implies
          (<= 0 i2@18@02)
          (and
            (<= 0 i2@18@02)
            (implies
              (< i2@18@02 V@5@02)
              (and
                (< i2@18@02 V@5@02)
                (not (= source@6@02 (as None<option<array>>  option<array>)))
                (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))))))))))
; Joined path conditions
(push) ; 7
; [then-branch: 15 | Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i1@17@02)) == Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i2@18@02)) && i2@18@02 < V@5@02 && 0 <= i2@18@02 && i1@17@02 < V@5@02 && 0 <= i1@17@02 | live]
; [else-branch: 15 | !(Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i1@17@02)) == Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i2@18@02)) && i2@18@02 < V@5@02 && 0 <= i2@18@02 && i1@17@02 < V@5@02 && 0 <= i1@17@02) | live]
(push) ; 8
; [then-branch: 15 | Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i1@17@02)) == Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i2@18@02)) && i2@18@02 < V@5@02 && 0 <= i2@18@02 && i1@17@02 < V@5@02 && 0 <= i1@17@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
          ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
        (< i2@18@02 V@5@02))
      (<= 0 i2@18@02))
    (< i1@17@02 V@5@02))
  (<= 0 i1@17@02)))
; [eval] i1 == i2
(pop) ; 8
(push) ; 8
; [else-branch: 15 | !(Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i1@17@02)) == Lookup(option$array$,sm@14@02,aloc((_, _), opt_get1(_, source@6@02), i2@18@02)) && i2@18@02 < V@5@02 && 0 <= i2@18@02 && i1@17@02 < V@5@02 && 0 <= i1@17@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
            ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
          (< i2@18@02 V@5@02))
        (<= 0 i2@18@02))
      (< i1@17@02 V@5@02))
    (<= 0 i1@17@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
            ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
          (< i2@18@02 V@5@02))
        (<= 0 i2@18@02))
      (< i1@17@02 V@5@02))
    (<= 0 i1@17@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
      ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
    (< i2@18@02 V@5@02)
    (<= 0 i2@18@02)
    (< i1@17@02 V@5@02)
    (<= 0 i1@17@02))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@18@02 Int)) (!
  (and
    (implies
      (<= 0 i1@17@02)
      (and
        (<= 0 i1@17@02)
        (implies
          (< i1@17@02 V@5@02)
          (and
            (< i1@17@02 V@5@02)
            (implies
              (<= 0 i2@18@02)
              (and
                (<= 0 i2@18@02)
                (implies
                  (< i2@18@02 V@5@02)
                  (and
                    (< i2@18@02 V@5@02)
                    (not (= source@6@02 (as None<option<array>>  option<array>)))
                    (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                    (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
              (< i2@18@02 V@5@02))
            (<= 0 i2@18@02))
          (< i1@17@02 V@5@02))
        (<= 0 i1@17@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
          ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
        (< i2@18@02 V@5@02)
        (<= 0 i2@18@02)
        (< i1@17@02 V@5@02)
        (<= 0 i1@17@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@17@02 Int)) (!
  (forall ((i2@18@02 Int)) (!
    (and
      (implies
        (<= 0 i1@17@02)
        (and
          (<= 0 i1@17@02)
          (implies
            (< i1@17@02 V@5@02)
            (and
              (< i1@17@02 V@5@02)
              (implies
                (<= 0 i2@18@02)
                (and
                  (<= 0 i2@18@02)
                  (implies
                    (< i2@18@02 V@5@02)
                    (and
                      (< i2@18@02 V@5@02)
                      (not
                        (= source@6@02 (as None<option<array>>  option<array>)))
                      (< i1@17@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                      (< i2@18@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                  ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
                (< i2@18@02 V@5@02))
              (<= 0 i2@18@02))
            (< i1@17@02 V@5@02))
          (<= 0 i1@17@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
            ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
          (< i2@18@02 V@5@02)
          (<= 0 i2@18@02)
          (< i1@17@02 V@5@02)
          (<= 0 i1@17@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@17@02 Int)) (!
    (forall ((i2@18@02 Int)) (!
      (and
        (implies
          (<= 0 i1@17@02)
          (and
            (<= 0 i1@17@02)
            (implies
              (< i1@17@02 V@5@02)
              (and
                (< i1@17@02 V@5@02)
                (implies
                  (<= 0 i2@18@02)
                  (and
                    (<= 0 i2@18@02)
                    (implies
                      (< i2@18@02 V@5@02)
                      (and
                        (< i2@18@02 V@5@02)
                        (not
                          (= source@6@02 (as None<option<array>>  option<array>)))
                        (<
                          i1@17@02
                          (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                        (<
                          i2@18@02
                          (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                    ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
                  (< i2@18@02 V@5@02))
                (<= 0 i2@18@02))
              (< i1@17@02 V@5@02))
            (<= 0 i1@17@02))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
              ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
            (< i2@18@02 V@5@02)
            (<= 0 i2@18@02)
            (< i1@17@02 V@5@02)
            (<= 0 i1@17@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@17@02 Int)) (!
    (forall ((i2@18@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
                  ($FVF.lookup_option$array$ (as sm@14@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02)))
                (< i2@18@02 V@5@02))
              (<= 0 i2@18@02))
            (< i1@17@02 V@5@02))
          (<= 0 i1@17@02))
        (= i1@17@02 i2@18@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@18@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@17@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@5@02))))
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
;  :num-allocs              171656
;  :num-checks              28
;  :propagations            88
;  :quant-instantiations    82
;  :rlimit-count            203354)
; [then-branch: 16 | 0 < V@5@02 | live]
; [else-branch: 16 | !(0 < V@5@02) | dead]
(push) ; 4
; [then-branch: 16 | 0 < V@5@02]
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (not (= target@7@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@5@02))))
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
;  :num-allocs              172429
;  :num-checks              29
;  :propagations            91
;  :quant-instantiations    82
;  :rlimit-count            204550)
; [then-branch: 17 | 0 < V@5@02 | live]
; [else-branch: 17 | !(0 < V@5@02) | dead]
(push) ; 4
; [then-branch: 17 | 0 < V@5@02]
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
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
;  :num-allocs              172454
;  :num-checks              30
;  :propagations            91
;  :quant-instantiations    82
;  :rlimit-count            204571)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (< 0 V@5@02) (= (alen<Int> (opt_get1 $Snap.unit target@7@02)) V@5@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
; [eval] 0 < V
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@5@02))))
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
;  :num-allocs              173359
;  :num-checks              31
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206098)
; [then-branch: 18 | 0 < V@5@02 | live]
; [else-branch: 18 | !(0 < V@5@02) | dead]
(push) ; 3
; [then-branch: 18 | 0 < V@5@02]
(declare-const i1@19@02 Int)
(push) ; 4
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 5
; [then-branch: 19 | 0 <= i1@19@02 | live]
; [else-branch: 19 | !(0 <= i1@19@02) | live]
(push) ; 6
; [then-branch: 19 | 0 <= i1@19@02]
(assert (<= 0 i1@19@02))
; [eval] i1 < V
(pop) ; 6
(push) ; 6
; [else-branch: 19 | !(0 <= i1@19@02)]
(assert (not (<= 0 i1@19@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< i1@19@02 V@5@02) (<= 0 i1@19@02)))
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
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
;  :num-allocs              173460
;  :num-checks              32
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206273)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i1@19@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
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
;  :num-allocs              173481
;  :num-checks              33
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206304)
(assert (< i1@19@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 5
; Joined path conditions
(assert (< i1@19@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 5
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 6
(assert (not (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No)))
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
;  :num-allocs              173655
;  :num-checks              34
;  :propagations            94
;  :quant-instantiations    87
;  :rlimit-count            206469)
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(pop) ; 5
; Joined path conditions
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(declare-const $k@20@02 $Perm)
(assert ($Perm.isReadVar $k@20@02 $Perm.Write))
(pop) ; 4
(declare-fun inv@21@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@20@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@19@02 Int)) (!
  (and
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@19@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@19@02))
  :qid |option$array$-aux|)))
(push) ; 4
(assert (not (forall ((i1@19@02 Int)) (!
  (implies
    (and (< i1@19@02 V@5@02) (<= 0 i1@19@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@20@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@20@02))))
  
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
;  :num-allocs              174325
;  :num-checks              35
;  :propagations            99
;  :quant-instantiations    87
;  :rlimit-count            207448)
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((i11@19@02 Int) (i12@19@02 Int)) (!
  (implies
    (and
      (and
        (and (< i11@19@02 V@5@02) (<= 0 i11@19@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@20@02)))
      (and
        (and (< i12@19@02 V@5@02) (<= 0 i12@19@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@20@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i11@19@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i12@19@02)))
    (= i11@19@02 i12@19@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               258
;  :arith-add-rows          65
;  :arith-assert-diseq      9
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
;  :mk-bool-var             735
;  :mk-clause               162
;  :num-allocs              174733
;  :num-checks              36
;  :propagations            108
;  :quant-instantiations    97
;  :rlimit-count            208376)
; Definitional axioms for inverse functions
(assert (forall ((i1@19@02 Int)) (!
  (implies
    (and
      (and (< i1@19@02 V@5@02) (<= 0 i1@19@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@20@02)))
    (=
      (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@19@02))
      i1@19@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@19@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@21@02 r) V@5@02) (<= 0 (inv@21@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@20@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) (inv@21@02 r))
      r))
  :pattern ((inv@21@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@19@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@19@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@19@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@19@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@19@02 Int)) (!
  (implies
    (and
      (and (< i1@19@02 V@5@02) (<= 0 i1@19@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@20@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@19@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@19@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@22@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@21@02 r) V@5@02) (<= 0 (inv@21@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@20@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))) r))
  :qid |qp.fvfValDef2|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@13@02 r) V@5@02) (<= 0 (inv@13@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@12@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@02)))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@02)))) r))
  :qid |qp.fvfValDef3|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second $t@10@02)))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef4|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@21@02 r) V@5@02) (<= 0 (inv@21@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) r) r))
  :pattern ((inv@21@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@5@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-add-rows          65
;  :arith-assert-diseq      9
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
;  :mk-bool-var             749
;  :mk-clause               162
;  :num-allocs              176921
;  :num-checks              37
;  :propagations            111
;  :quant-instantiations    97
;  :rlimit-count            213081)
; [then-branch: 20 | 0 < V@5@02 | live]
; [else-branch: 20 | !(0 < V@5@02) | dead]
(push) ; 5
; [then-branch: 20 | 0 < V@5@02]
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
(declare-const i1@23@02 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 21 | 0 <= i1@23@02 | live]
; [else-branch: 21 | !(0 <= i1@23@02) | live]
(push) ; 8
; [then-branch: 21 | 0 <= i1@23@02]
(assert (<= 0 i1@23@02))
; [eval] i1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 21 | !(0 <= i1@23@02)]
(assert (not (<= 0 i1@23@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 22 | i1@23@02 < V@5@02 && 0 <= i1@23@02 | live]
; [else-branch: 22 | !(i1@23@02 < V@5@02 && 0 <= i1@23@02) | live]
(push) ; 8
; [then-branch: 22 | i1@23@02 < V@5@02 && 0 <= i1@23@02]
(assert (and (< i1@23@02 V@5@02) (<= 0 i1@23@02)))
; [eval] aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-add-rows          65
;  :arith-assert-diseq      9
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
;  :mk-bool-var             751
;  :mk-clause               162
;  :num-allocs              177021
;  :num-checks              38
;  :propagations            111
;  :quant-instantiations    97
;  :rlimit-count            213262)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i1@23@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-add-rows          65
;  :arith-assert-diseq      9
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
;  :mk-bool-var             751
;  :mk-clause               162
;  :num-allocs              177042
;  :num-checks              39
;  :propagations            111
;  :quant-instantiations    97
;  :rlimit-count            213293)
(assert (< i1@23@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 9
; Joined path conditions
(assert (< i1@23@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))
          V@5@02)
        (<=
          0
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))
          V@5@02)
        (<=
          0
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               381
;  :arith-add-rows          80
;  :arith-assert-diseq      10
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
;  :max-memory              4.51
;  :memory                  4.51
;  :mk-bool-var             882
;  :mk-clause               254
;  :num-allocs              178021
;  :num-checks              40
;  :propagations            177
;  :quant-instantiations    124
;  :rlimit-count            215892
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 8
(push) ; 8
; [else-branch: 22 | !(i1@23@02 < V@5@02 && 0 <= i1@23@02)]
(assert (not (and (< i1@23@02 V@5@02) (<= 0 i1@23@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i1@23@02 V@5@02) (<= 0 i1@23@02))
  (and
    (< i1@23@02 V@5@02)
    (<= 0 i1@23@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@23@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@23@02 Int)) (!
  (implies
    (and (< i1@23@02 V@5@02) (<= 0 i1@23@02))
    (and
      (< i1@23@02 V@5@02)
      (<= 0 i1@23@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< i1@23@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@23@02 Int)) (!
    (implies
      (and (< i1@23@02 V@5@02) (<= 0 i1@23@02))
      (and
        (< i1@23@02 V@5@02)
        (<= 0 i1@23@02)
        (not (= target@7@02 (as None<option<array>>  option<array>)))
        (< i1@23@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@23@02 Int)) (!
    (implies
      (and (< i1@23@02 V@5@02) (<= 0 i1@23@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@23@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@5@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          80
;  :arith-assert-diseq      10
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
;  :max-memory              4.53
;  :memory                  4.52
;  :mk-bool-var             889
;  :mk-clause               254
;  :num-allocs              179298
;  :num-checks              41
;  :propagations            180
;  :quant-instantiations    124
;  :rlimit-count            218166)
; [then-branch: 23 | 0 < V@5@02 | live]
; [else-branch: 23 | !(0 < V@5@02) | dead]
(push) ; 5
; [then-branch: 23 | 0 < V@5@02]
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
(declare-const i1@24@02 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 24 | 0 <= i1@24@02 | live]
; [else-branch: 24 | !(0 <= i1@24@02) | live]
(push) ; 8
; [then-branch: 24 | 0 <= i1@24@02]
(assert (<= 0 i1@24@02))
; [eval] i1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(0 <= i1@24@02)]
(assert (not (<= 0 i1@24@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 25 | i1@24@02 < V@5@02 && 0 <= i1@24@02 | live]
; [else-branch: 25 | !(i1@24@02 < V@5@02 && 0 <= i1@24@02) | live]
(push) ; 8
; [then-branch: 25 | i1@24@02 < V@5@02 && 0 <= i1@24@02]
(assert (and (< i1@24@02 V@5@02) (<= 0 i1@24@02)))
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
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          80
;  :arith-assert-diseq      10
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
;  :max-memory              4.53
;  :memory                  4.52
;  :mk-bool-var             891
;  :mk-clause               254
;  :num-allocs              179398
;  :num-checks              42
;  :propagations            180
;  :quant-instantiations    124
;  :rlimit-count            218351)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i1@24@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               397
;  :arith-add-rows          80
;  :arith-assert-diseq      10
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
;  :max-memory              4.53
;  :memory                  4.52
;  :mk-bool-var             891
;  :mk-clause               254
;  :num-allocs              179419
;  :num-checks              43
;  :propagations            180
;  :quant-instantiations    124
;  :rlimit-count            218382)
(assert (< i1@24@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 9
; Joined path conditions
(assert (< i1@24@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
          V@5@02)
        (<=
          0
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
          V@5@02)
        (<=
          0
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               465
;  :arith-add-rows          101
;  :arith-assert-diseq      12
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
;  :max-memory              4.53
;  :memory                  4.52
;  :mk-bool-var             1032
;  :mk-clause               366
;  :num-allocs              180100
;  :num-checks              44
;  :propagations            250
;  :quant-instantiations    155
;  :rlimit-count            220981
;  :time                    0.00)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               465
;  :arith-add-rows          101
;  :arith-assert-diseq      12
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
;  :max-memory              4.53
;  :memory                  4.52
;  :mk-bool-var             1032
;  :mk-clause               366
;  :num-allocs              180191
;  :num-checks              45
;  :propagations            250
;  :quant-instantiations    155
;  :rlimit-count            221076)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
    (as None<option<array>>  option<array>))))
(pop) ; 8
(push) ; 8
; [else-branch: 25 | !(i1@24@02 < V@5@02 && 0 <= i1@24@02)]
(assert (not (and (< i1@24@02 V@5@02) (<= 0 i1@24@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i1@24@02 V@5@02) (<= 0 i1@24@02))
  (and
    (< i1@24@02 V@5@02)
    (<= 0 i1@24@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@24@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@24@02 Int)) (!
  (implies
    (and (< i1@24@02 V@5@02) (<= 0 i1@24@02))
    (and
      (< i1@24@02 V@5@02)
      (<= 0 i1@24@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< i1@24@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@24@02 Int)) (!
    (implies
      (and (< i1@24@02 V@5@02) (<= 0 i1@24@02))
      (and
        (< i1@24@02 V@5@02)
        (<= 0 i1@24@02)
        (not (= target@7@02 (as None<option<array>>  option<array>)))
        (< i1@24@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
        (not
          (=
            ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))
            (as None<option<array>>  option<array>)))))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)))))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@24@02 Int)) (!
    (implies
      (and (< i1@24@02 V@5@02) (<= 0 i1@24@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02))))
        V@5@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@24@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (< 0 V@5@02))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               481
;  :arith-add-rows          101
;  :arith-assert-diseq      12
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
;  :mk-bool-var             1039
;  :mk-clause               366
;  :num-allocs              181491
;  :num-checks              46
;  :propagations            253
;  :quant-instantiations    155
;  :rlimit-count            223454)
; [then-branch: 26 | 0 < V@5@02 | live]
; [else-branch: 26 | !(0 < V@5@02) | dead]
(push) ; 5
; [then-branch: 26 | 0 < V@5@02]
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
(declare-const i1@25@02 Int)
(push) ; 6
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2)
(declare-const i2@26@02 Int)
(push) ; 7
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] 0 <= i1
(push) ; 8
; [then-branch: 27 | 0 <= i1@25@02 | live]
; [else-branch: 27 | !(0 <= i1@25@02) | live]
(push) ; 9
; [then-branch: 27 | 0 <= i1@25@02]
(assert (<= 0 i1@25@02))
; [eval] i1 < V
(push) ; 10
; [then-branch: 28 | i1@25@02 < V@5@02 | live]
; [else-branch: 28 | !(i1@25@02 < V@5@02) | live]
(push) ; 11
; [then-branch: 28 | i1@25@02 < V@5@02]
(assert (< i1@25@02 V@5@02))
; [eval] 0 <= i2
(push) ; 12
; [then-branch: 29 | 0 <= i2@26@02 | live]
; [else-branch: 29 | !(0 <= i2@26@02) | live]
(push) ; 13
; [then-branch: 29 | 0 <= i2@26@02]
(assert (<= 0 i2@26@02))
; [eval] i2 < V
(push) ; 14
; [then-branch: 30 | i2@26@02 < V@5@02 | live]
; [else-branch: 30 | !(i2@26@02 < V@5@02) | live]
(push) ; 15
; [then-branch: 30 | i2@26@02 < V@5@02]
(assert (< i2@26@02 V@5@02))
; [eval] aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 16
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 17
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               481
;  :arith-add-rows          101
;  :arith-assert-diseq      12
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
;  :mk-bool-var             1043
;  :mk-clause               366
;  :num-allocs              181768
;  :num-checks              47
;  :propagations            253
;  :quant-instantiations    155
;  :rlimit-count            223789)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 16
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 16
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 17
(assert (not (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               481
;  :arith-add-rows          101
;  :arith-assert-diseq      12
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
;  :mk-bool-var             1043
;  :mk-clause               366
;  :num-allocs              181789
;  :num-checks              48
;  :propagations            253
;  :quant-instantiations    155
;  :rlimit-count            223820)
(assert (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 16
; Joined path conditions
(assert (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
          V@5@02)
        (<=
          0
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
          V@5@02)
        (<=
          0
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               550
;  :arith-add-rows          122
;  :arith-assert-diseq      14
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
;  :memory                  4.54
;  :mk-bool-var             1186
;  :mk-clause               478
;  :num-allocs              182473
;  :num-checks              49
;  :propagations            321
;  :quant-instantiations    186
;  :rlimit-count            226435
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
(assert (not (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               550
;  :arith-add-rows          122
;  :arith-assert-diseq      14
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
;  :memory                  4.54
;  :mk-bool-var             1186
;  :mk-clause               478
;  :num-allocs              182500
;  :num-checks              50
;  :propagations            321
;  :quant-instantiations    186
;  :rlimit-count            226465)
(assert (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 16
; Joined path conditions
(assert (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
(push) ; 16
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))
          V@5@02)
        (<=
          0
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))
          V@5@02)
        (<=
          0
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               693
;  :arith-add-rows          169
;  :arith-assert-diseq      16
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
;  :arith-pivots            130
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
;  :mk-bool-var             1342
;  :mk-clause               580
;  :num-allocs              183438
;  :num-checks              51
;  :propagations            392
;  :quant-instantiations    215
;  :rlimit-count            229367
;  :time                    0.00)
(pop) ; 15
(push) ; 15
; [else-branch: 30 | !(i2@26@02 < V@5@02)]
(assert (not (< i2@26@02 V@5@02)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (< i2@26@02 V@5@02)
  (and
    (< i2@26@02 V@5@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
    (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 29 | !(0 <= i2@26@02)]
(assert (not (<= 0 i2@26@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (<= 0 i2@26@02)
  (and
    (<= 0 i2@26@02)
    (implies
      (< i2@26@02 V@5@02)
      (and
        (< i2@26@02 V@5@02)
        (not (= target@7@02 (as None<option<array>>  option<array>)))
        (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
        (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 28 | !(i1@25@02 < V@5@02)]
(assert (not (< i1@25@02 V@5@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (< i1@25@02 V@5@02)
  (and
    (< i1@25@02 V@5@02)
    (implies
      (<= 0 i2@26@02)
      (and
        (<= 0 i2@26@02)
        (implies
          (< i2@26@02 V@5@02)
          (and
            (< i2@26@02 V@5@02)
            (not (= target@7@02 (as None<option<array>>  option<array>)))
            (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
            (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))))))))
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 27 | !(0 <= i1@25@02)]
(assert (not (<= 0 i1@25@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (<= 0 i1@25@02)
  (and
    (<= 0 i1@25@02)
    (implies
      (< i1@25@02 V@5@02)
      (and
        (< i1@25@02 V@5@02)
        (implies
          (<= 0 i2@26@02)
          (and
            (<= 0 i2@26@02)
            (implies
              (< i2@26@02 V@5@02)
              (and
                (< i2@26@02 V@5@02)
                (not (= target@7@02 (as None<option<array>>  option<array>)))
                (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))))))))))
; Joined path conditions
(push) ; 8
; [then-branch: 31 | Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i1@25@02)) == Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i2@26@02)) && i2@26@02 < V@5@02 && 0 <= i2@26@02 && i1@25@02 < V@5@02 && 0 <= i1@25@02 | live]
; [else-branch: 31 | !(Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i1@25@02)) == Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i2@26@02)) && i2@26@02 < V@5@02 && 0 <= i2@26@02 && i1@25@02 < V@5@02 && 0 <= i1@25@02) | live]
(push) ; 9
; [then-branch: 31 | Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i1@25@02)) == Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i2@26@02)) && i2@26@02 < V@5@02 && 0 <= i2@26@02 && i1@25@02 < V@5@02 && 0 <= i1@25@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
          ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
        (< i2@26@02 V@5@02))
      (<= 0 i2@26@02))
    (< i1@25@02 V@5@02))
  (<= 0 i1@25@02)))
; [eval] i1 == i2
(pop) ; 9
(push) ; 9
; [else-branch: 31 | !(Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i1@25@02)) == Lookup(option$array$,sm@22@02,aloc((_, _), opt_get1(_, target@7@02), i2@26@02)) && i2@26@02 < V@5@02 && 0 <= i2@26@02 && i1@25@02 < V@5@02 && 0 <= i1@25@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
            ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
          (< i2@26@02 V@5@02))
        (<= 0 i2@26@02))
      (< i1@25@02 V@5@02))
    (<= 0 i1@25@02))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
            ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
          (< i2@26@02 V@5@02))
        (<= 0 i2@26@02))
      (< i1@25@02 V@5@02))
    (<= 0 i1@25@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
      ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
    (< i2@26@02 V@5@02)
    (<= 0 i2@26@02)
    (< i1@25@02 V@5@02)
    (<= 0 i1@25@02))))
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@26@02 Int)) (!
  (and
    (implies
      (<= 0 i1@25@02)
      (and
        (<= 0 i1@25@02)
        (implies
          (< i1@25@02 V@5@02)
          (and
            (< i1@25@02 V@5@02)
            (implies
              (<= 0 i2@26@02)
              (and
                (<= 0 i2@26@02)
                (implies
                  (< i2@26@02 V@5@02)
                  (and
                    (< i2@26@02 V@5@02)
                    (not (= target@7@02 (as None<option<array>>  option<array>)))
                    (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                    (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
              (< i2@26@02 V@5@02))
            (<= 0 i2@26@02))
          (< i1@25@02 V@5@02))
        (<= 0 i1@25@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
          ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
        (< i2@26@02 V@5@02)
        (<= 0 i2@26@02)
        (< i1@25@02 V@5@02)
        (<= 0 i1@25@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@25@02 Int)) (!
  (forall ((i2@26@02 Int)) (!
    (and
      (implies
        (<= 0 i1@25@02)
        (and
          (<= 0 i1@25@02)
          (implies
            (< i1@25@02 V@5@02)
            (and
              (< i1@25@02 V@5@02)
              (implies
                (<= 0 i2@26@02)
                (and
                  (<= 0 i2@26@02)
                  (implies
                    (< i2@26@02 V@5@02)
                    (and
                      (< i2@26@02 V@5@02)
                      (not
                        (= target@7@02 (as None<option<array>>  option<array>)))
                      (< i1@25@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                      (< i2@26@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                  ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
                (< i2@26@02 V@5@02))
              (<= 0 i2@26@02))
            (< i1@25@02 V@5@02))
          (<= 0 i1@25@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
            ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
          (< i2@26@02 V@5@02)
          (<= 0 i2@26@02)
          (< i1@25@02 V@5@02)
          (<= 0 i1@25@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@25@02 Int)) (!
    (forall ((i2@26@02 Int)) (!
      (and
        (implies
          (<= 0 i1@25@02)
          (and
            (<= 0 i1@25@02)
            (implies
              (< i1@25@02 V@5@02)
              (and
                (< i1@25@02 V@5@02)
                (implies
                  (<= 0 i2@26@02)
                  (and
                    (<= 0 i2@26@02)
                    (implies
                      (< i2@26@02 V@5@02)
                      (and
                        (< i2@26@02 V@5@02)
                        (not
                          (= target@7@02 (as None<option<array>>  option<array>)))
                        (<
                          i1@25@02
                          (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                        (<
                          i2@26@02
                          (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)) (aloc ($Snap.combine
                          $Snap.unit
                          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))))))))))
        (implies
          (and
            (and
              (and
                (and
                  (=
                    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
                  (< i2@26@02 V@5@02))
                (<= 0 i2@26@02))
              (< i1@25@02 V@5@02))
            (<= 0 i1@25@02))
          (and
            (=
              ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
              ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
            (< i2@26@02 V@5@02)
            (<= 0 i2@26@02)
            (< i1@25@02 V@5@02)
            (<= 0 i1@25@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))
      :qid |prog.l<no position>-aux|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (< 0 V@5@02)
  (forall ((i1@25@02 Int)) (!
    (forall ((i2@26@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
                  ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02)))
                (< i2@26@02 V@5@02))
              (<= 0 i2@26@02))
            (< i1@25@02 V@5@02))
          (<= 0 i1@25@02))
        (= i1@25@02 i2@26@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@26@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@25@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))))))
(declare-const unknown@27@02 Int)
(declare-const unknown1@28@02 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 32 | 0 <= unknown@27@02 | live]
; [else-branch: 32 | !(0 <= unknown@27@02) | live]
(push) ; 6
; [then-branch: 32 | 0 <= unknown@27@02]
(assert (<= 0 unknown@27@02))
; [eval] unknown < V
(push) ; 7
; [then-branch: 33 | unknown@27@02 < V@5@02 | live]
; [else-branch: 33 | !(unknown@27@02 < V@5@02) | live]
(push) ; 8
; [then-branch: 33 | unknown@27@02 < V@5@02]
(assert (< unknown@27@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 34 | 0 <= unknown1@28@02 | live]
; [else-branch: 34 | !(0 <= unknown1@28@02) | live]
(push) ; 10
; [then-branch: 34 | 0 <= unknown1@28@02]
(assert (<= 0 unknown1@28@02))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 34 | !(0 <= unknown1@28@02)]
(assert (not (<= 0 unknown1@28@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 33 | !(unknown@27@02 < V@5@02)]
(assert (not (< unknown@27@02 V@5@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 32 | !(0 <= unknown@27@02)]
(assert (not (<= 0 unknown@27@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@28@02 V@5@02) (<= 0 unknown1@28@02))
    (< unknown@27@02 V@5@02))
  (<= 0 unknown@27@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               698
;  :arith-add-rows          169
;  :arith-assert-diseq      16
;  :arith-assert-lower      435
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
;  :arith-pivots            134
;  :conflicts               86
;  :datatype-accessor-ax    21
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
;  :mk-bool-var             1364
;  :mk-clause               604
;  :num-allocs              184683
;  :num-checks              52
;  :propagations            392
;  :quant-instantiations    215
;  :rlimit-count            232266)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@28@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               698
;  :arith-add-rows          169
;  :arith-assert-diseq      16
;  :arith-assert-lower      435
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
;  :arith-pivots            134
;  :conflicts               86
;  :datatype-accessor-ax    21
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
;  :mk-bool-var             1364
;  :mk-clause               604
;  :num-allocs              184704
;  :num-checks              53
;  :propagations            392
;  :quant-instantiations    215
;  :rlimit-count            232297)
(assert (< unknown1@28@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@28@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02)))
(push) ; 5
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))
          V@5@02)
        (<=
          0
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))
          V@5@02)
        (<=
          0
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               768
;  :arith-add-rows          190
;  :arith-assert-diseq      18
;  :arith-assert-lower      472
;  :arith-assert-upper      302
;  :arith-bound-prop        21
;  :arith-conflicts         58
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         72
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        70
;  :arith-pivots            155
;  :conflicts               97
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   70
;  :datatype-splits         63
;  :decisions               207
;  :del-clause              678
;  :final-checks            94
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.75
;  :mk-bool-var             1516
;  :mk-clause               716
;  :num-allocs              185453
;  :num-checks              54
;  :propagations            460
;  :quant-instantiations    249
;  :rlimit-count            235244
;  :time                    0.00)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               768
;  :arith-add-rows          190
;  :arith-assert-diseq      18
;  :arith-assert-lower      472
;  :arith-assert-upper      302
;  :arith-bound-prop        21
;  :arith-conflicts         58
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         72
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        70
;  :arith-pivots            155
;  :conflicts               98
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   70
;  :datatype-splits         63
;  :decisions               207
;  :del-clause              678
;  :final-checks            94
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.75
;  :mk-bool-var             1516
;  :mk-clause               716
;  :num-allocs              185544
;  :num-checks              55
;  :propagations            460
;  :quant-instantiations    249
;  :rlimit-count            235339)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@27@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               774
;  :arith-add-rows          195
;  :arith-assert-diseq      18
;  :arith-assert-lower      475
;  :arith-assert-upper      303
;  :arith-bound-prop        21
;  :arith-conflicts         59
;  :arith-eq-adapter        103
;  :arith-fixed-eqs         73
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        70
;  :arith-pivots            159
;  :conflicts               99
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   70
;  :datatype-splits         63
;  :decisions               207
;  :del-clause              682
;  :final-checks            94
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.77
;  :mk-bool-var             1527
;  :mk-clause               720
;  :num-allocs              185746
;  :num-checks              56
;  :propagations            462
;  :quant-instantiations    256
;  :rlimit-count            235842)
(assert (<
  unknown@27@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@27@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))))))
(pop) ; 4
(declare-fun inv@29@02 ($Ref) Int)
(declare-fun inv@30@02 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@27@02 Int) (unknown1@28@02 Int)) (!
  (and
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< unknown1@28@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@27@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))) unknown@27@02))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@27@02 Int) (unknown11@28@02 Int) (unknown2@27@02 Int) (unknown12@28@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@28@02 V@5@02) (<= 0 unknown11@28@02))
          (< unknown1@27@02 V@5@02))
        (<= 0 unknown1@27@02))
      (and
        (and
          (and (< unknown12@28@02 V@5@02) (<= 0 unknown12@28@02))
          (< unknown2@27@02 V@5@02))
        (<= 0 unknown2@27@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown11@28@02))) unknown1@27@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown12@28@02))) unknown2@27@02)))
    (and (= unknown1@27@02 unknown2@27@02) (= unknown11@28@02 unknown12@28@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               817
;  :arith-add-rows          202
;  :arith-assert-diseq      18
;  :arith-assert-lower      487
;  :arith-assert-upper      306
;  :arith-bound-prop        22
;  :arith-conflicts         59
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         73
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        72
;  :arith-pivots            167
;  :conflicts               100
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   70
;  :datatype-splits         63
;  :decisions               207
;  :del-clause              786
;  :final-checks            94
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.81
;  :mk-bool-var             1681
;  :mk-clause               801
;  :num-allocs              186964
;  :num-checks              57
;  :propagations            497
;  :quant-instantiations    321
;  :rlimit-count            239688
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((unknown@27@02 Int) (unknown1@28@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@28@02 V@5@02) (<= 0 unknown1@28@02))
        (< unknown@27@02 V@5@02))
      (<= 0 unknown@27@02))
    (and
      (=
        (inv@29@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))) unknown@27@02))
        unknown@27@02)
      (=
        (inv@30@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))) unknown@27@02))
        unknown1@28@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))) unknown@27@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@02 r) V@5@02) (<= 0 (inv@30@02 r)))
        (< (inv@29@02 r) V@5@02))
      (<= 0 (inv@29@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) (inv@30@02 r)))) (inv@29@02 r))
      r))
  :pattern ((inv@29@02 r))
  :pattern ((inv@30@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@27@02 Int) (unknown1@28@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@28@02 V@5@02) (<= 0 unknown1@28@02))
        (< unknown@27@02 V@5@02))
      (<= 0 unknown@27@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))) unknown@27@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@28@02))) unknown@27@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@31@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@02 r) V@5@02) (<= 0 (inv@30@02 r)))
        (< (inv@29@02 r) V@5@02))
      (<= 0 (inv@29@02 r)))
    (=
      ($FVF.lookup_int (as sm@31@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@31@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r))
  :qid |qp.fvfValDef5|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@31@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef6|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@02 r) V@5@02) (<= 0 (inv@30@02 r)))
        (< (inv@29@02 r) V@5@02))
      (<= 0 (inv@29@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@31@02  $FVF<Int>) r) r))
  :pattern ((inv@29@02 r) (inv@30@02 r))
  )))
(declare-const unknown@32@02 Int)
(declare-const unknown1@33@02 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 35 | 0 <= unknown@32@02 | live]
; [else-branch: 35 | !(0 <= unknown@32@02) | live]
(push) ; 6
; [then-branch: 35 | 0 <= unknown@32@02]
(assert (<= 0 unknown@32@02))
; [eval] unknown < V
(push) ; 7
; [then-branch: 36 | unknown@32@02 < V@5@02 | live]
; [else-branch: 36 | !(unknown@32@02 < V@5@02) | live]
(push) ; 8
; [then-branch: 36 | unknown@32@02 < V@5@02]
(assert (< unknown@32@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 37 | 0 <= unknown1@33@02 | live]
; [else-branch: 37 | !(0 <= unknown1@33@02) | live]
(push) ; 10
; [then-branch: 37 | 0 <= unknown1@33@02]
(assert (<= 0 unknown1@33@02))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 37 | !(0 <= unknown1@33@02)]
(assert (not (<= 0 unknown1@33@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 36 | !(unknown@32@02 < V@5@02)]
(assert (not (< unknown@32@02 V@5@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 35 | !(0 <= unknown@32@02)]
(assert (not (<= 0 unknown@32@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@33@02 V@5@02) (<= 0 unknown1@33@02))
    (< unknown@32@02 V@5@02))
  (<= 0 unknown@32@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               817
;  :arith-add-rows          202
;  :arith-assert-diseq      18
;  :arith-assert-lower      493
;  :arith-assert-upper      306
;  :arith-bound-prop        22
;  :arith-conflicts         59
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         73
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        72
;  :arith-pivots            167
;  :conflicts               101
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   70
;  :datatype-splits         63
;  :decisions               207
;  :del-clause              786
;  :final-checks            94
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.82
;  :mk-bool-var             1693
;  :mk-clause               801
;  :num-allocs              188240
;  :num-checks              58
;  :propagations            497
;  :quant-instantiations    321
;  :rlimit-count            242847)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@33@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               817
;  :arith-add-rows          205
;  :arith-assert-diseq      18
;  :arith-assert-lower      493
;  :arith-assert-upper      307
;  :arith-bound-prop        22
;  :arith-conflicts         60
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         73
;  :arith-grobner           40
;  :arith-max-min           448
;  :arith-nonlinear-bounds  42
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        72
;  :arith-pivots            169
;  :conflicts               102
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 68
;  :datatype-occurs-check   70
;  :datatype-splits         63
;  :decisions               207
;  :del-clause              786
;  :final-checks            94
;  :interface-eqs           5
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.84
;  :mk-bool-var             1694
;  :mk-clause               801
;  :num-allocs              188386
;  :num-checks              59
;  :propagations            497
;  :quant-instantiations    321
;  :rlimit-count            243041)
(assert (< unknown1@33@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@33@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02)))
(push) ; 5
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))
          V@5@02)
        (<=
          0
          (inv@21@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@20@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))
          V@5@02)
        (<=
          0
          (inv@13@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@12@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               900
;  :arith-add-rows          224
;  :arith-assert-diseq      18
;  :arith-assert-lower      521
;  :arith-assert-upper      326
;  :arith-bound-prop        22
;  :arith-conflicts         65
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         83
;  :arith-grobner           40
;  :arith-max-min           457
;  :arith-nonlinear-bounds  44
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        84
;  :arith-pivots            184
;  :conflicts               110
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   72
;  :datatype-splits         67
;  :decisions               229
;  :del-clause              858
;  :final-checks            97
;  :interface-eqs           6
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.84
;  :mk-bool-var             1822
;  :mk-clause               899
;  :num-allocs              189027
;  :num-checks              60
;  :propagations            555
;  :quant-instantiations    348
;  :rlimit-count            245712
;  :time                    0.00)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               938
;  :arith-add-rows          231
;  :arith-assert-diseq      18
;  :arith-assert-lower      529
;  :arith-assert-upper      337
;  :arith-bound-prop        22
;  :arith-conflicts         68
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         88
;  :arith-grobner           40
;  :arith-max-min           466
;  :arith-nonlinear-bounds  46
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        88
;  :arith-pivots            188
;  :conflicts               116
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   74
;  :datatype-splits         71
;  :decisions               243
;  :del-clause              878
;  :final-checks            100
;  :interface-eqs           7
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.84
;  :mk-bool-var             1851
;  :mk-clause               919
;  :num-allocs              189203
;  :num-checks              61
;  :propagations            566
;  :quant-instantiations    350
;  :rlimit-count            246405)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@32@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               996
;  :arith-add-rows          244
;  :arith-assert-diseq      18
;  :arith-assert-lower      541
;  :arith-assert-upper      350
;  :arith-bound-prop        22
;  :arith-conflicts         72
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         94
;  :arith-grobner           40
;  :arith-max-min           475
;  :arith-nonlinear-bounds  48
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        95
;  :arith-pivots            196
;  :conflicts               122
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 83
;  :datatype-occurs-check   76
;  :datatype-splits         75
;  :decisions               257
;  :del-clause              899
;  :final-checks            103
;  :interface-eqs           8
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.84
;  :mk-bool-var             1896
;  :mk-clause               940
;  :num-allocs              189496
;  :num-checks              62
;  :propagations            579
;  :quant-instantiations    361
;  :rlimit-count            247584
;  :time                    0.01)
(assert (<
  unknown@32@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@32@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))))))
(declare-const $k@34@02 $Perm)
(assert ($Perm.isReadVar $k@34@02 $Perm.Write))
(pop) ; 4
(declare-fun inv@35@02 ($Ref) Int)
(declare-fun inv@36@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@34@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@32@02 Int) (unknown1@33@02 Int)) (!
  (and
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< unknown1@33@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@32@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02))
  :qid |int-aux|)))
(push) ; 4
(assert (not (forall ((unknown@32@02 Int) (unknown1@33@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@33@02 V@5@02) (<= 0 unknown1@33@02))
        (< unknown@32@02 V@5@02))
      (<= 0 unknown@32@02))
    (or (= $k@34@02 $Perm.No) (< $Perm.No $k@34@02)))
  
  ))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               996
;  :arith-add-rows          244
;  :arith-assert-diseq      19
;  :arith-assert-lower      543
;  :arith-assert-upper      351
;  :arith-bound-prop        22
;  :arith-conflicts         72
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         94
;  :arith-grobner           40
;  :arith-max-min           475
;  :arith-nonlinear-bounds  48
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        95
;  :arith-pivots            198
;  :conflicts               123
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 83
;  :datatype-occurs-check   76
;  :datatype-splits         75
;  :decisions               257
;  :del-clause              925
;  :final-checks            103
;  :interface-eqs           8
;  :max-generation          3
;  :max-memory              4.88
;  :memory                  4.84
;  :mk-bool-var             1905
;  :mk-clause               942
;  :num-allocs              190038
;  :num-checks              63
;  :propagations            580
;  :quant-instantiations    361
;  :rlimit-count            248550)
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@32@02 Int) (unknown11@33@02 Int) (unknown2@32@02 Int) (unknown12@33@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and
            (and (< unknown11@33@02 V@5@02) (<= 0 unknown11@33@02))
            (< unknown1@32@02 V@5@02))
          (<= 0 unknown1@32@02))
        (< $Perm.No $k@34@02))
      (and
        (and
          (and
            (and (< unknown12@33@02 V@5@02) (<= 0 unknown12@33@02))
            (< unknown2@32@02 V@5@02))
          (<= 0 unknown2@32@02))
        (< $Perm.No $k@34@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown11@33@02))) unknown1@32@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown12@33@02))) unknown2@32@02)))
    (and (= unknown1@32@02 unknown2@32@02) (= unknown11@33@02 unknown12@33@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1133
;  :arith-add-rows          328
;  :arith-assert-diseq      21
;  :arith-assert-lower      581
;  :arith-assert-upper      373
;  :arith-bound-prop        28
;  :arith-conflicts         74
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           40
;  :arith-max-min           493
;  :arith-nonlinear-bounds  52
;  :arith-nonlinear-horner  31
;  :arith-offset-eqs        108
;  :arith-pivots            221
;  :conflicts               128
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 90
;  :datatype-occurs-check   79
;  :datatype-splits         81
;  :decisions               277
;  :del-clause              1061
;  :final-checks            108
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.91
;  :memory                  4.90
;  :mk-bool-var             2115
;  :mk-clause               1078
;  :num-allocs              191337
;  :num-checks              64
;  :propagations            659
;  :quant-instantiations    430
;  :rlimit-count            254536
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((unknown@32@02 Int) (unknown1@33@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@33@02 V@5@02) (<= 0 unknown1@33@02))
          (< unknown@32@02 V@5@02))
        (<= 0 unknown@32@02))
      (< $Perm.No $k@34@02))
    (and
      (=
        (inv@35@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02))
        unknown@32@02)
      (=
        (inv@36@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02))
        unknown1@33@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and
          (and (< (inv@36@02 r) V@5@02) (<= 0 (inv@36@02 r)))
          (< (inv@35@02 r) V@5@02))
        (<= 0 (inv@35@02 r)))
      (< $Perm.No $k@34@02))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) (inv@36@02 r)))) (inv@35@02 r))
      r))
  :pattern ((inv@35@02 r))
  :pattern ((inv@36@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((unknown@32@02 Int) (unknown1@33@02 Int)) (!
  (<= $Perm.No $k@34@02)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02))
  :qid |int-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((unknown@32@02 Int) (unknown1@33@02 Int)) (!
  (<= $k@34@02 $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02))
  :qid |int-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((unknown@32@02 Int) (unknown1@33@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@33@02 V@5@02) (<= 0 unknown1@33@02))
          (< unknown@32@02 V@5@02))
        (<= 0 unknown@32@02))
      (< $Perm.No $k@34@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@22@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@33@02))) unknown@32@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@37@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and
        (and
          (and (< (inv@36@02 r) V@5@02) (<= 0 (inv@36@02 r)))
          (< (inv@35@02 r) V@5@02))
        (<= 0 (inv@35@02 r)))
      (< $Perm.No $k@34@02)
      false)
    (=
      ($FVF.lookup_int (as sm@37@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@37@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r))
  :qid |qp.fvfValDef7|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@30@02 r) V@5@02) (<= 0 (inv@30@02 r)))
        (< (inv@29@02 r) V@5@02))
      (<= 0 (inv@29@02 r)))
    (=
      ($FVF.lookup_int (as sm@37@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@37@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r))
  :qid |qp.fvfValDef8|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@37@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef9|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@36@02 r) V@5@02) (<= 0 (inv@36@02 r)))
        (< (inv@35@02 r) V@5@02))
      (<= 0 (inv@35@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@37@02  $FVF<Int>) r) r))
  :pattern ((inv@35@02 r) (inv@36@02 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 4
(declare-const $t@38@02 $Snap)
(assert (= $t@38@02 ($Snap.combine ($Snap.first $t@38@02) ($Snap.second $t@38@02))))
(assert (= ($Snap.first $t@38@02) $Snap.unit))
; [eval] exc == null
(assert (= exc@8@02 $Ref.null))
(assert (=
  ($Snap.second $t@38@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@38@02))
    ($Snap.second ($Snap.second $t@38@02)))))
(assert (= ($Snap.first ($Snap.second $t@38@02)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 38 | exc@8@02 == Null | live]
; [else-branch: 38 | exc@8@02 != Null | live]
(push) ; 6
; [then-branch: 38 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 38 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1174
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      603
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 99
;  :datatype-occurs-check   86
;  :datatype-splits         86
;  :decisions               287
;  :del-clause              1065
;  :final-checks            115
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2133
;  :mk-clause               1078
;  :num-allocs              194196
;  :num-checks              66
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            260777)
(push) ; 6
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1174
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      603
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 99
;  :datatype-occurs-check   86
;  :datatype-splits         86
;  :decisions               287
;  :del-clause              1065
;  :final-checks            115
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2133
;  :mk-clause               1078
;  :num-allocs              194214
;  :num-checks              67
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            260794)
; [then-branch: 39 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 39 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 6
; [then-branch: 39 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] source != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (not (= source@6@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@38@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@38@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@38@02))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 40 | exc@8@02 == Null | live]
; [else-branch: 40 | exc@8@02 != Null | live]
(push) ; 6
; [then-branch: 40 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 40 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1196
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      603
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 104
;  :datatype-occurs-check   89
;  :datatype-splits         87
;  :decisions               292
;  :del-clause              1065
;  :final-checks            117
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2136
;  :mk-clause               1078
;  :num-allocs              194881
;  :num-checks              68
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            261644)
(push) ; 6
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1196
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      603
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 104
;  :datatype-occurs-check   89
;  :datatype-splits         87
;  :decisions               292
;  :del-clause              1065
;  :final-checks            117
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2136
;  :mk-clause               1078
;  :num-allocs              194899
;  :num-checks              69
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            261661)
; [then-branch: 41 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 41 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 6
; [then-branch: 41 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] alen(opt_get1(source)) == V
; [eval] alen(opt_get1(source))
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1196
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      603
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 104
;  :datatype-occurs-check   89
;  :datatype-splits         87
;  :decisions               292
;  :del-clause              1065
;  :final-checks            117
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2136
;  :mk-clause               1078
;  :num-allocs              194924
;  :num-checks              70
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            261691)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 7
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (not (= source@6@02 (as None<option<array>>  option<array>))))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit source@6@02)) V@5@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@38@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 42 | exc@8@02 == Null | live]
; [else-branch: 42 | exc@8@02 != Null | live]
(push) ; 6
; [then-branch: 42 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 42 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 5
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1220
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      603
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   92
;  :datatype-splits         89
;  :decisions               298
;  :del-clause              1065
;  :final-checks            119
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2139
;  :mk-clause               1078
;  :num-allocs              195602
;  :num-checks              71
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            262535)
(push) ; 5
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1220
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      603
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   92
;  :datatype-splits         89
;  :decisions               298
;  :del-clause              1065
;  :final-checks            119
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2139
;  :mk-clause               1078
;  :num-allocs              195620
;  :num-checks              72
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            262552)
; [then-branch: 43 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 43 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 5
; [then-branch: 43 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
(declare-const i1@39@02 Int)
(push) ; 6
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 7
; [then-branch: 44 | 0 <= i1@39@02 | live]
; [else-branch: 44 | !(0 <= i1@39@02) | live]
(push) ; 8
; [then-branch: 44 | 0 <= i1@39@02]
(assert (<= 0 i1@39@02))
; [eval] i1 < V
(pop) ; 8
(push) ; 8
; [else-branch: 44 | !(0 <= i1@39@02)]
(assert (not (<= 0 i1@39@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< i1@39@02 V@5@02) (<= 0 i1@39@02)))
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 7
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1220
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      605
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   92
;  :datatype-splits         89
;  :decisions               298
;  :del-clause              1065
;  :final-checks            119
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2141
;  :mk-clause               1078
;  :num-allocs              195715
;  :num-checks              73
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            262732)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 7
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 7
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 8
(assert (not (< i1@39@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1220
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      605
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               129
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   92
;  :datatype-splits         89
;  :decisions               298
;  :del-clause              1065
;  :final-checks            119
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2141
;  :mk-clause               1078
;  :num-allocs              195736
;  :num-checks              74
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            262763)
(assert (< i1@39@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 7
; Joined path conditions
(assert (< i1@39@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 7
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 8
(assert (not (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1220
;  :arith-add-rows          330
;  :arith-assert-diseq      21
;  :arith-assert-lower      605
;  :arith-assert-upper      388
;  :arith-bound-prop        28
;  :arith-conflicts         75
;  :arith-eq-adapter        133
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           531
;  :arith-nonlinear-bounds  54
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               130
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   92
;  :datatype-splits         89
;  :decisions               298
;  :del-clause              1065
;  :final-checks            119
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.92
;  :mk-bool-var             2141
;  :mk-clause               1078
;  :num-allocs              195880
;  :num-checks              75
;  :propagations            662
;  :quant-instantiations    430
;  :rlimit-count            262875)
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(pop) ; 7
; Joined path conditions
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(declare-const $k@40@02 $Perm)
(assert ($Perm.isReadVar $k@40@02 $Perm.Write))
(pop) ; 6
(declare-fun inv@41@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@40@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@39@02 Int)) (!
  (and
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@39@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@39@02))
  :qid |option$array$-aux|)))
(push) ; 6
(assert (not (forall ((i1@39@02 Int)) (!
  (implies
    (and (< i1@39@02 V@5@02) (<= 0 i1@39@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@40@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@40@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1231
;  :arith-add-rows          330
;  :arith-assert-diseq      23
;  :arith-assert-lower      618
;  :arith-assert-upper      396
;  :arith-bound-prop        28
;  :arith-conflicts         76
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           547
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        109
;  :arith-pivots            222
;  :conflicts               131
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   92
;  :datatype-splits         89
;  :decisions               302
;  :del-clause              1068
;  :final-checks            120
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.91
;  :mk-bool-var             2151
;  :mk-clause               1083
;  :num-allocs              196518
;  :num-checks              76
;  :propagations            664
;  :quant-instantiations    430
;  :rlimit-count            263793)
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((i11@39@02 Int) (i12@39@02 Int)) (!
  (implies
    (and
      (and
        (and (< i11@39@02 V@5@02) (<= 0 i11@39@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@40@02)))
      (and
        (and (< i12@39@02 V@5@02) (<= 0 i12@39@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@40@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i11@39@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i12@39@02)))
    (= i11@39@02 i12@39@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1251
;  :arith-add-rows          334
;  :arith-assert-diseq      25
;  :arith-assert-lower      625
;  :arith-assert-upper      396
;  :arith-bound-prop        28
;  :arith-conflicts         76
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         107
;  :arith-grobner           45
;  :arith-max-min           547
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  35
;  :arith-offset-eqs        110
;  :arith-pivots            224
;  :conflicts               132
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   92
;  :datatype-splits         89
;  :decisions               302
;  :del-clause              1098
;  :final-checks            120
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.93
;  :memory                  4.93
;  :mk-bool-var             2199
;  :mk-clause               1113
;  :num-allocs              197108
;  :num-checks              77
;  :propagations            678
;  :quant-instantiations    455
;  :rlimit-count            265453
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((i1@39@02 Int)) (!
  (implies
    (and
      (and (< i1@39@02 V@5@02) (<= 0 i1@39@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@40@02)))
    (=
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@39@02))
      i1@39@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@39@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@41@02 r) V@5@02) (<= 0 (inv@41@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@40@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) (inv@41@02 r))
      r))
  :pattern ((inv@41@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@39@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@39@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@39@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@39@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@39@02 Int)) (!
  (implies
    (and
      (and (< i1@39@02 V@5@02) (<= 0 i1@39@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@40@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@39@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@39@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@42@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@41@02 r) V@5@02) (<= 0 (inv@41@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@40@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@02))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@02))))) r))
  :qid |qp.fvfValDef10|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@02))))) r) r)
  :pattern (($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef11|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@41@02 r) V@5@02) (<= 0 (inv@41@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) r) r))
  :pattern ((inv@41@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 45 | exc@8@02 == Null | live]
; [else-branch: 45 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 45 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 45 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1278
;  :arith-add-rows          334
;  :arith-assert-diseq      25
;  :arith-assert-lower      645
;  :arith-assert-upper      409
;  :arith-bound-prop        28
;  :arith-conflicts         76
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           580
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        110
;  :arith-pivots            224
;  :conflicts               132
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 120
;  :datatype-occurs-check   95
;  :datatype-splits         91
;  :decisions               308
;  :del-clause              1098
;  :final-checks            124
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.95
;  :memory                  4.93
;  :mk-bool-var             2211
;  :mk-clause               1113
;  :num-allocs              199111
;  :num-checks              78
;  :propagations            678
;  :quant-instantiations    455
;  :rlimit-count            269347)
(push) ; 7
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1278
;  :arith-add-rows          334
;  :arith-assert-diseq      25
;  :arith-assert-lower      645
;  :arith-assert-upper      409
;  :arith-bound-prop        28
;  :arith-conflicts         76
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           580
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        110
;  :arith-pivots            224
;  :conflicts               132
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 120
;  :datatype-occurs-check   95
;  :datatype-splits         91
;  :decisions               308
;  :del-clause              1098
;  :final-checks            124
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.95
;  :memory                  4.93
;  :mk-bool-var             2211
;  :mk-clause               1113
;  :num-allocs              199129
;  :num-checks              79
;  :propagations            678
;  :quant-instantiations    455
;  :rlimit-count            269364)
; [then-branch: 46 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 46 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 7
; [then-branch: 46 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
(declare-const i1@43@02 Int)
(push) ; 8
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 9
; [then-branch: 47 | 0 <= i1@43@02 | live]
; [else-branch: 47 | !(0 <= i1@43@02) | live]
(push) ; 10
; [then-branch: 47 | 0 <= i1@43@02]
(assert (<= 0 i1@43@02))
; [eval] i1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 47 | !(0 <= i1@43@02)]
(assert (not (<= 0 i1@43@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 48 | i1@43@02 < V@5@02 && 0 <= i1@43@02 | live]
; [else-branch: 48 | !(i1@43@02 < V@5@02 && 0 <= i1@43@02) | live]
(push) ; 10
; [then-branch: 48 | i1@43@02 < V@5@02 && 0 <= i1@43@02]
(assert (and (< i1@43@02 V@5@02) (<= 0 i1@43@02)))
; [eval] aloc(opt_get1(source), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1278
;  :arith-add-rows          334
;  :arith-assert-diseq      25
;  :arith-assert-lower      647
;  :arith-assert-upper      409
;  :arith-bound-prop        28
;  :arith-conflicts         76
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           580
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        110
;  :arith-pivots            225
;  :conflicts               132
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 120
;  :datatype-occurs-check   95
;  :datatype-splits         91
;  :decisions               308
;  :del-clause              1098
;  :final-checks            124
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.95
;  :memory                  4.93
;  :mk-bool-var             2213
;  :mk-clause               1113
;  :num-allocs              199224
;  :num-checks              80
;  :propagations            678
;  :quant-instantiations    455
;  :rlimit-count            269558)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 12
(assert (not (< i1@43@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1278
;  :arith-add-rows          334
;  :arith-assert-diseq      25
;  :arith-assert-lower      647
;  :arith-assert-upper      409
;  :arith-bound-prop        28
;  :arith-conflicts         76
;  :arith-eq-adapter        136
;  :arith-fixed-eqs         107
;  :arith-grobner           50
;  :arith-max-min           580
;  :arith-nonlinear-bounds  55
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        110
;  :arith-pivots            225
;  :conflicts               132
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 120
;  :datatype-occurs-check   95
;  :datatype-splits         91
;  :decisions               308
;  :del-clause              1098
;  :final-checks            124
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.95
;  :memory                  4.93
;  :mk-bool-var             2213
;  :mk-clause               1113
;  :num-allocs              199245
;  :num-checks              81
;  :propagations            678
;  :quant-instantiations    455
;  :rlimit-count            269589)
(assert (< i1@43@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 11
; Joined path conditions
(assert (< i1@43@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))
      V@5@02)
    (<=
      0
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1360
;  :arith-add-rows          372
;  :arith-assert-diseq      25
;  :arith-assert-lower      669
;  :arith-assert-upper      431
;  :arith-bound-prop        30
;  :arith-conflicts         80
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         114
;  :arith-grobner           50
;  :arith-max-min           606
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  39
;  :arith-offset-eqs        116
;  :arith-pivots            231
;  :conflicts               143
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 131
;  :datatype-occurs-check   101
;  :datatype-splits         98
;  :decisions               339
;  :del-clause              1171
;  :final-checks            131
;  :interface-eqs           11
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  4.99
;  :mk-bool-var             2370
;  :mk-clause               1212
;  :num-allocs              200041
;  :num-checks              82
;  :propagations            715
;  :quant-instantiations    487
;  :rlimit-count            272518
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 10
(push) ; 10
; [else-branch: 48 | !(i1@43@02 < V@5@02 && 0 <= i1@43@02)]
(assert (not (and (< i1@43@02 V@5@02) (<= 0 i1@43@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i1@43@02 V@5@02) (<= 0 i1@43@02))
  (and
    (< i1@43@02 V@5@02)
    (<= 0 i1@43@02)
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@43@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@43@02 Int)) (!
  (implies
    (and (< i1@43@02 V@5@02) (<= 0 i1@43@02))
    (and
      (< i1@43@02 V@5@02)
      (<= 0 i1@43@02)
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< i1@43@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (forall ((i1@43@02 Int)) (!
      (implies
        (and (< i1@43@02 V@5@02) (<= 0 i1@43@02))
        (and
          (< i1@43@02 V@5@02)
          (<= 0 i1@43@02)
          (not (= source@6@02 (as None<option<array>>  option<array>)))
          (< i1@43@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (forall ((i1@43@02 Int)) (!
    (implies
      (and (< i1@43@02 V@5@02) (<= 0 i1@43@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@43@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 49 | exc@8@02 == Null | live]
; [else-branch: 49 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 49 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 49 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1388
;  :arith-add-rows          373
;  :arith-assert-diseq      25
;  :arith-assert-lower      688
;  :arith-assert-upper      443
;  :arith-bound-prop        30
;  :arith-conflicts         80
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           639
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        116
;  :arith-pivots            234
;  :conflicts               143
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 137
;  :datatype-occurs-check   104
;  :datatype-splits         100
;  :decisions               345
;  :del-clause              1197
;  :final-checks            135
;  :interface-eqs           11
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  4.99
;  :mk-bool-var             2376
;  :mk-clause               1212
;  :num-allocs              201339
;  :num-checks              83
;  :propagations            715
;  :quant-instantiations    487
;  :rlimit-count            274835)
(push) ; 7
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1388
;  :arith-add-rows          373
;  :arith-assert-diseq      25
;  :arith-assert-lower      688
;  :arith-assert-upper      443
;  :arith-bound-prop        30
;  :arith-conflicts         80
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           639
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        116
;  :arith-pivots            234
;  :conflicts               143
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 137
;  :datatype-occurs-check   104
;  :datatype-splits         100
;  :decisions               345
;  :del-clause              1197
;  :final-checks            135
;  :interface-eqs           11
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  4.99
;  :mk-bool-var             2376
;  :mk-clause               1212
;  :num-allocs              201357
;  :num-checks              84
;  :propagations            715
;  :quant-instantiations    487
;  :rlimit-count            274852)
; [then-branch: 50 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 50 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 7
; [then-branch: 50 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
(declare-const i1@44@02 Int)
(push) ; 8
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 9
; [then-branch: 51 | 0 <= i1@44@02 | live]
; [else-branch: 51 | !(0 <= i1@44@02) | live]
(push) ; 10
; [then-branch: 51 | 0 <= i1@44@02]
(assert (<= 0 i1@44@02))
; [eval] i1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 51 | !(0 <= i1@44@02)]
(assert (not (<= 0 i1@44@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 52 | i1@44@02 < V@5@02 && 0 <= i1@44@02 | live]
; [else-branch: 52 | !(i1@44@02 < V@5@02 && 0 <= i1@44@02) | live]
(push) ; 10
; [then-branch: 52 | i1@44@02 < V@5@02 && 0 <= i1@44@02]
(assert (and (< i1@44@02 V@5@02) (<= 0 i1@44@02)))
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
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1388
;  :arith-add-rows          373
;  :arith-assert-diseq      25
;  :arith-assert-lower      690
;  :arith-assert-upper      443
;  :arith-bound-prop        30
;  :arith-conflicts         80
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           639
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        116
;  :arith-pivots            235
;  :conflicts               143
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 137
;  :datatype-occurs-check   104
;  :datatype-splits         100
;  :decisions               345
;  :del-clause              1197
;  :final-checks            135
;  :interface-eqs           11
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  4.99
;  :mk-bool-var             2378
;  :mk-clause               1212
;  :num-allocs              201452
;  :num-checks              85
;  :propagations            715
;  :quant-instantiations    487
;  :rlimit-count            275046)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 11
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 12
(assert (not (< i1@44@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1388
;  :arith-add-rows          373
;  :arith-assert-diseq      25
;  :arith-assert-lower      690
;  :arith-assert-upper      443
;  :arith-bound-prop        30
;  :arith-conflicts         80
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         114
;  :arith-grobner           55
;  :arith-max-min           639
;  :arith-nonlinear-bounds  60
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        116
;  :arith-pivots            235
;  :conflicts               143
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 137
;  :datatype-occurs-check   104
;  :datatype-splits         100
;  :decisions               345
;  :del-clause              1197
;  :final-checks            135
;  :interface-eqs           11
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  4.99
;  :mk-bool-var             2378
;  :mk-clause               1212
;  :num-allocs              201473
;  :num-checks              86
;  :propagations            715
;  :quant-instantiations    487
;  :rlimit-count            275077)
(assert (< i1@44@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 11
; Joined path conditions
(assert (< i1@44@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)))
(push) ; 11
(assert (not (ite
  (and
    (<
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
      V@5@02)
    (<=
      0
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02))
  false)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1474
;  :arith-add-rows          405
;  :arith-assert-diseq      26
;  :arith-assert-lower      721
;  :arith-assert-upper      472
;  :arith-bound-prop        33
;  :arith-conflicts         84
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         125
;  :arith-grobner           55
;  :arith-max-min           680
;  :arith-nonlinear-bounds  66
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        123
;  :arith-pivots            244
;  :conflicts               153
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 148
;  :datatype-occurs-check   110
;  :datatype-splits         107
;  :decisions               376
;  :del-clause              1269
;  :final-checks            142
;  :interface-eqs           12
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.00
;  :mk-bool-var             2534
;  :mk-clause               1310
;  :num-allocs              202260
;  :num-checks              87
;  :propagations            757
;  :quant-instantiations    521
;  :rlimit-count            278030
;  :time                    0.00)
(push) ; 11
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 12
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1474
;  :arith-add-rows          405
;  :arith-assert-diseq      26
;  :arith-assert-lower      721
;  :arith-assert-upper      472
;  :arith-bound-prop        33
;  :arith-conflicts         84
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         125
;  :arith-grobner           55
;  :arith-max-min           680
;  :arith-nonlinear-bounds  66
;  :arith-nonlinear-horner  43
;  :arith-offset-eqs        123
;  :arith-pivots            244
;  :conflicts               154
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 148
;  :datatype-occurs-check   110
;  :datatype-splits         107
;  :decisions               376
;  :del-clause              1269
;  :final-checks            142
;  :interface-eqs           12
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.00
;  :mk-bool-var             2534
;  :mk-clause               1310
;  :num-allocs              202351
;  :num-checks              88
;  :propagations            757
;  :quant-instantiations    521
;  :rlimit-count            278125)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
    (as None<option<array>>  option<array>))))
(pop) ; 11
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
    (as None<option<array>>  option<array>))))
(pop) ; 10
(push) ; 10
; [else-branch: 52 | !(i1@44@02 < V@5@02 && 0 <= i1@44@02)]
(assert (not (and (< i1@44@02 V@5@02) (<= 0 i1@44@02))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and (< i1@44@02 V@5@02) (<= 0 i1@44@02))
  (and
    (< i1@44@02 V@5@02)
    (<= 0 i1@44@02)
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@44@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@44@02 Int)) (!
  (implies
    (and (< i1@44@02 V@5@02) (<= 0 i1@44@02))
    (and
      (< i1@44@02 V@5@02)
      (<= 0 i1@44@02)
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< i1@44@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (forall ((i1@44@02 Int)) (!
      (implies
        (and (< i1@44@02 V@5@02) (<= 0 i1@44@02))
        (and
          (< i1@44@02 V@5@02)
          (<= 0 i1@44@02)
          (not (= source@6@02 (as None<option<array>>  option<array>)))
          (< i1@44@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (forall ((i1@44@02 Int)) (!
    (implies
      (and (< i1@44@02 V@5@02) (<= 0 i1@44@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02))))
        V@5@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@44@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 53 | exc@8@02 == Null | live]
; [else-branch: 53 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 53 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 53 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1503
;  :arith-add-rows          405
;  :arith-assert-diseq      26
;  :arith-assert-lower      740
;  :arith-assert-upper      484
;  :arith-bound-prop        33
;  :arith-conflicts         84
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         125
;  :arith-grobner           60
;  :arith-max-min           713
;  :arith-nonlinear-bounds  66
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        123
;  :arith-pivots            245
;  :conflicts               154
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   113
;  :datatype-splits         109
;  :decisions               382
;  :del-clause              1295
;  :final-checks            146
;  :interface-eqs           12
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.01
;  :mk-bool-var             2540
;  :mk-clause               1310
;  :num-allocs              203670
;  :num-checks              89
;  :propagations            757
;  :quant-instantiations    521
;  :rlimit-count            280527)
(push) ; 7
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1503
;  :arith-add-rows          405
;  :arith-assert-diseq      26
;  :arith-assert-lower      740
;  :arith-assert-upper      484
;  :arith-bound-prop        33
;  :arith-conflicts         84
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         125
;  :arith-grobner           60
;  :arith-max-min           713
;  :arith-nonlinear-bounds  66
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        123
;  :arith-pivots            245
;  :conflicts               154
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   113
;  :datatype-splits         109
;  :decisions               382
;  :del-clause              1295
;  :final-checks            146
;  :interface-eqs           12
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.01
;  :mk-bool-var             2540
;  :mk-clause               1310
;  :num-allocs              203688
;  :num-checks              90
;  :propagations            757
;  :quant-instantiations    521
;  :rlimit-count            280544)
; [then-branch: 54 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 54 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 7
; [then-branch: 54 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
(declare-const i1@45@02 Int)
(push) ; 8
; [eval] (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2)
(declare-const i2@46@02 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 55 | 0 <= i1@45@02 | live]
; [else-branch: 55 | !(0 <= i1@45@02) | live]
(push) ; 11
; [then-branch: 55 | 0 <= i1@45@02]
(assert (<= 0 i1@45@02))
; [eval] i1 < V
(push) ; 12
; [then-branch: 56 | i1@45@02 < V@5@02 | live]
; [else-branch: 56 | !(i1@45@02 < V@5@02) | live]
(push) ; 13
; [then-branch: 56 | i1@45@02 < V@5@02]
(assert (< i1@45@02 V@5@02))
; [eval] 0 <= i2
(push) ; 14
; [then-branch: 57 | 0 <= i2@46@02 | live]
; [else-branch: 57 | !(0 <= i2@46@02) | live]
(push) ; 15
; [then-branch: 57 | 0 <= i2@46@02]
(assert (<= 0 i2@46@02))
; [eval] i2 < V
(push) ; 16
; [then-branch: 58 | i2@46@02 < V@5@02 | live]
; [else-branch: 58 | !(i2@46@02 < V@5@02) | live]
(push) ; 17
; [then-branch: 58 | i2@46@02 < V@5@02]
(assert (< i2@46@02 V@5@02))
; [eval] aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$
; [eval] aloc(opt_get1(source), i1)
; [eval] opt_get1(source)
(push) ; 18
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 19
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1503
;  :arith-add-rows          405
;  :arith-assert-diseq      26
;  :arith-assert-lower      744
;  :arith-assert-upper      484
;  :arith-bound-prop        33
;  :arith-conflicts         84
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         125
;  :arith-grobner           60
;  :arith-max-min           713
;  :arith-nonlinear-bounds  66
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        123
;  :arith-pivots            245
;  :conflicts               154
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   113
;  :datatype-splits         109
;  :decisions               382
;  :del-clause              1295
;  :final-checks            146
;  :interface-eqs           12
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.01
;  :mk-bool-var             2544
;  :mk-clause               1310
;  :num-allocs              203966
;  :num-checks              91
;  :propagations            757
;  :quant-instantiations    521
;  :rlimit-count            280878)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 18
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 18
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 19
(assert (not (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1503
;  :arith-add-rows          405
;  :arith-assert-diseq      26
;  :arith-assert-lower      744
;  :arith-assert-upper      484
;  :arith-bound-prop        33
;  :arith-conflicts         84
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         125
;  :arith-grobner           60
;  :arith-max-min           713
;  :arith-nonlinear-bounds  66
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        123
;  :arith-pivots            245
;  :conflicts               154
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 154
;  :datatype-occurs-check   113
;  :datatype-splits         109
;  :decisions               382
;  :del-clause              1295
;  :final-checks            146
;  :interface-eqs           12
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.01
;  :mk-bool-var             2544
;  :mk-clause               1310
;  :num-allocs              203987
;  :num-checks              92
;  :propagations            757
;  :quant-instantiations    521
;  :rlimit-count            280909)
(assert (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 18
; Joined path conditions
(assert (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
      V@5@02)
    (<=
      0
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1596
;  :arith-add-rows          431
;  :arith-assert-diseq      26
;  :arith-assert-lower      766
;  :arith-assert-upper      506
;  :arith-bound-prop        35
;  :arith-conflicts         88
;  :arith-eq-adapter        152
;  :arith-fixed-eqs         132
;  :arith-grobner           60
;  :arith-max-min           739
;  :arith-nonlinear-bounds  71
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        134
;  :arith-pivots            251
;  :conflicts               164
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 165
;  :datatype-occurs-check   119
;  :datatype-splits         116
;  :decisions               407
;  :del-clause              1345
;  :final-checks            153
;  :interface-eqs           14
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.01
;  :mk-bool-var             2685
;  :mk-clause               1386
;  :num-allocs              204702
;  :num-checks              93
;  :propagations            790
;  :quant-instantiations    553
;  :rlimit-count            283568
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
(assert (not (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1596
;  :arith-add-rows          431
;  :arith-assert-diseq      26
;  :arith-assert-lower      766
;  :arith-assert-upper      506
;  :arith-bound-prop        35
;  :arith-conflicts         88
;  :arith-eq-adapter        152
;  :arith-fixed-eqs         132
;  :arith-grobner           60
;  :arith-max-min           739
;  :arith-nonlinear-bounds  71
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        134
;  :arith-pivots            251
;  :conflicts               164
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 165
;  :datatype-occurs-check   119
;  :datatype-splits         116
;  :decisions               407
;  :del-clause              1345
;  :final-checks            153
;  :interface-eqs           14
;  :max-generation          4
;  :max-memory              5.03
;  :memory                  5.01
;  :mk-bool-var             2685
;  :mk-clause               1386
;  :num-allocs              204729
;  :num-checks              94
;  :propagations            790
;  :quant-instantiations    553
;  :rlimit-count            283598)
(assert (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 18
; Joined path conditions
(assert (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
(push) ; 18
(assert (not (ite
  (and
    (<
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))
      V@5@02)
    (<=
      0
      (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))))
  (<
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02))
  false)))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1730
;  :arith-add-rows          541
;  :arith-assert-diseq      32
;  :arith-assert-lower      808
;  :arith-assert-upper      544
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           60
;  :arith-max-min           787
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  47
;  :arith-offset-eqs        146
;  :arith-pivots            268
;  :conflicts               176
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 175
;  :datatype-occurs-check   125
;  :datatype-splits         122
;  :decisions               443
;  :del-clause              1445
;  :final-checks            160
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2892
;  :mk-clause               1524
;  :num-allocs              205745
;  :num-checks              95
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            288632
;  :time                    0.00)
(pop) ; 17
(push) ; 17
; [else-branch: 58 | !(i2@46@02 < V@5@02)]
(assert (not (< i2@46@02 V@5@02)))
(pop) ; 17
(pop) ; 16
; Joined path conditions
(assert (implies
  (< i2@46@02 V@5@02)
  (and
    (< i2@46@02 V@5@02)
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
    (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))))
; Joined path conditions
(pop) ; 15
(push) ; 15
; [else-branch: 57 | !(0 <= i2@46@02)]
(assert (not (<= 0 i2@46@02)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
(assert (implies
  (<= 0 i2@46@02)
  (and
    (<= 0 i2@46@02)
    (implies
      (< i2@46@02 V@5@02)
      (and
        (< i2@46@02 V@5@02)
        (not (= source@6@02 (as None<option<array>>  option<array>)))
        (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
        (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))))))
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 56 | !(i1@45@02 < V@5@02)]
(assert (not (< i1@45@02 V@5@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (< i1@45@02 V@5@02)
  (and
    (< i1@45@02 V@5@02)
    (implies
      (<= 0 i2@46@02)
      (and
        (<= 0 i2@46@02)
        (implies
          (< i2@46@02 V@5@02)
          (and
            (< i2@46@02 V@5@02)
            (not (= source@6@02 (as None<option<array>>  option<array>)))
            (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
            (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))))))))
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 55 | !(0 <= i1@45@02)]
(assert (not (<= 0 i1@45@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (<= 0 i1@45@02)
  (and
    (<= 0 i1@45@02)
    (implies
      (< i1@45@02 V@5@02)
      (and
        (< i1@45@02 V@5@02)
        (implies
          (<= 0 i2@46@02)
          (and
            (<= 0 i2@46@02)
            (implies
              (< i2@46@02 V@5@02)
              (and
                (< i2@46@02 V@5@02)
                (not (= source@6@02 (as None<option<array>>  option<array>)))
                (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))))))))))
; Joined path conditions
(push) ; 10
; [then-branch: 59 | Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i1@45@02)) == Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i2@46@02)) && i2@46@02 < V@5@02 && 0 <= i2@46@02 && i1@45@02 < V@5@02 && 0 <= i1@45@02 | live]
; [else-branch: 59 | !(Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i1@45@02)) == Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i2@46@02)) && i2@46@02 < V@5@02 && 0 <= i2@46@02 && i1@45@02 < V@5@02 && 0 <= i1@45@02) | live]
(push) ; 11
; [then-branch: 59 | Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i1@45@02)) == Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i2@46@02)) && i2@46@02 < V@5@02 && 0 <= i2@46@02 && i1@45@02 < V@5@02 && 0 <= i1@45@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
          ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
        (< i2@46@02 V@5@02))
      (<= 0 i2@46@02))
    (< i1@45@02 V@5@02))
  (<= 0 i1@45@02)))
; [eval] i1 == i2
(pop) ; 11
(push) ; 11
; [else-branch: 59 | !(Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i1@45@02)) == Lookup(option$array$,sm@42@02,aloc((_, _), opt_get1(_, source@6@02), i2@46@02)) && i2@46@02 < V@5@02 && 0 <= i2@46@02 && i1@45@02 < V@5@02 && 0 <= i1@45@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
            ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
          (< i2@46@02 V@5@02))
        (<= 0 i2@46@02))
      (< i1@45@02 V@5@02))
    (<= 0 i1@45@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
            ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
          (< i2@46@02 V@5@02))
        (<= 0 i2@46@02))
      (< i1@45@02 V@5@02))
    (<= 0 i1@45@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
      ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
    (< i2@46@02 V@5@02)
    (<= 0 i2@46@02)
    (< i1@45@02 V@5@02)
    (<= 0 i1@45@02))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@46@02 Int)) (!
  (and
    (implies
      (<= 0 i1@45@02)
      (and
        (<= 0 i1@45@02)
        (implies
          (< i1@45@02 V@5@02)
          (and
            (< i1@45@02 V@5@02)
            (implies
              (<= 0 i2@46@02)
              (and
                (<= 0 i2@46@02)
                (implies
                  (< i2@46@02 V@5@02)
                  (and
                    (< i2@46@02 V@5@02)
                    (not (= source@6@02 (as None<option<array>>  option<array>)))
                    (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                    (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
              (< i2@46@02 V@5@02))
            (<= 0 i2@46@02))
          (< i1@45@02 V@5@02))
        (<= 0 i1@45@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
          ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
        (< i2@46@02 V@5@02)
        (<= 0 i2@46@02)
        (< i1@45@02 V@5@02)
        (<= 0 i1@45@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@45@02 Int)) (!
  (forall ((i2@46@02 Int)) (!
    (and
      (implies
        (<= 0 i1@45@02)
        (and
          (<= 0 i1@45@02)
          (implies
            (< i1@45@02 V@5@02)
            (and
              (< i1@45@02 V@5@02)
              (implies
                (<= 0 i2@46@02)
                (and
                  (<= 0 i2@46@02)
                  (implies
                    (< i2@46@02 V@5@02)
                    (and
                      (< i2@46@02 V@5@02)
                      (not
                        (= source@6@02 (as None<option<array>>  option<array>)))
                      (< i1@45@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                      (< i2@46@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                  ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
                (< i2@46@02 V@5@02))
              (<= 0 i2@46@02))
            (< i1@45@02 V@5@02))
          (<= 0 i1@45@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
            ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
          (< i2@46@02 V@5@02)
          (<= 0 i2@46@02)
          (< i1@45@02 V@5@02)
          (<= 0 i1@45@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (forall ((i1@45@02 Int)) (!
      (forall ((i2@46@02 Int)) (!
        (and
          (implies
            (<= 0 i1@45@02)
            (and
              (<= 0 i1@45@02)
              (implies
                (< i1@45@02 V@5@02)
                (and
                  (< i1@45@02 V@5@02)
                  (implies
                    (<= 0 i2@46@02)
                    (and
                      (<= 0 i2@46@02)
                      (implies
                        (< i2@46@02 V@5@02)
                        (and
                          (< i2@46@02 V@5@02)
                          (not
                            (=
                              source@6@02
                              (as None<option<array>>  option<array>)))
                          (<
                            i1@45@02
                            (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                          (<
                            i2@46@02
                            (alen<Int> (opt_get1 $Snap.unit source@6@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                      ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
                    (< i2@46@02 V@5@02))
                  (<= 0 i2@46@02))
                (< i1@45@02 V@5@02))
              (<= 0 i1@45@02))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
              (< i2@46@02 V@5@02)
              (<= 0 i2@46@02)
              (< i1@45@02 V@5@02)
              (<= 0 i1@45@02))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (forall ((i1@45@02 Int)) (!
    (forall ((i2@46@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
                  ($FVF.lookup_option$array$ (as sm@42@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02)))
                (< i2@46@02 V@5@02))
              (<= 0 i2@46@02))
            (< i1@45@02 V@5@02))
          (<= 0 i1@45@02))
        (= i1@45@02 i2@46@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i2@46@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) i1@45@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 60 | exc@8@02 == Null | live]
; [else-branch: 60 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 60 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 60 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1760
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      827
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 181
;  :datatype-occurs-check   128
;  :datatype-splits         124
;  :decisions               449
;  :del-clause              1533
;  :final-checks            164
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2911
;  :mk-clause               1548
;  :num-allocs              207620
;  :num-checks              96
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            292633)
(push) ; 7
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1760
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      827
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 181
;  :datatype-occurs-check   128
;  :datatype-splits         124
;  :decisions               449
;  :del-clause              1533
;  :final-checks            164
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2911
;  :mk-clause               1548
;  :num-allocs              207638
;  :num-checks              97
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            292650)
; [then-branch: 61 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 61 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 7
; [then-branch: 61 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] target != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (not (= target@7@02 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 62 | exc@8@02 == Null | live]
; [else-branch: 62 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 62 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 62 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(push) ; 7
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1791
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      827
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   131
;  :datatype-splits         126
;  :decisions               455
;  :del-clause              1533
;  :final-checks            166
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2915
;  :mk-clause               1548
;  :num-allocs              208339
;  :num-checks              98
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            293571)
(push) ; 7
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1791
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      827
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   131
;  :datatype-splits         126
;  :decisions               455
;  :del-clause              1533
;  :final-checks            166
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2915
;  :mk-clause               1548
;  :num-allocs              208357
;  :num-checks              99
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            293588)
; [then-branch: 63 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 63 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 7
; [then-branch: 63 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] alen(opt_get1(target)) == V
; [eval] alen(opt_get1(target))
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1791
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      827
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   131
;  :datatype-splits         126
;  :decisions               455
;  :del-clause              1533
;  :final-checks            166
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2915
;  :mk-clause               1548
;  :num-allocs              208382
;  :num-checks              100
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            293618)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (not (= target@7@02 (as None<option<array>>  option<array>))))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit target@7@02)) V@5@02)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 64 | exc@8@02 == Null | live]
; [else-branch: 64 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 64 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 64 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      827
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 194
;  :datatype-occurs-check   134
;  :datatype-splits         129
;  :decisions               462
;  :del-clause              1533
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2919
;  :mk-clause               1548
;  :num-allocs              209088
;  :num-checks              101
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            294525)
(push) ; 6
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      827
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 194
;  :datatype-occurs-check   134
;  :datatype-splits         129
;  :decisions               462
;  :del-clause              1533
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2919
;  :mk-clause               1548
;  :num-allocs              209106
;  :num-checks              102
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            294542)
; [then-branch: 65 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 65 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 6
; [then-branch: 65 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
(declare-const i1@47@02 Int)
(push) ; 7
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 8
; [then-branch: 66 | 0 <= i1@47@02 | live]
; [else-branch: 66 | !(0 <= i1@47@02) | live]
(push) ; 9
; [then-branch: 66 | 0 <= i1@47@02]
(assert (<= 0 i1@47@02))
; [eval] i1 < V
(pop) ; 9
(push) ; 9
; [else-branch: 66 | !(0 <= i1@47@02)]
(assert (not (<= 0 i1@47@02)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< i1@47@02 V@5@02) (<= 0 i1@47@02)))
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 8
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      829
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 194
;  :datatype-occurs-check   134
;  :datatype-splits         129
;  :decisions               462
;  :del-clause              1533
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2921
;  :mk-clause               1548
;  :num-allocs              209201
;  :num-checks              103
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            294722)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 8
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 8
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 9
(assert (not (< i1@47@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      829
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               176
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 194
;  :datatype-occurs-check   134
;  :datatype-splits         129
;  :decisions               462
;  :del-clause              1533
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2921
;  :mk-clause               1548
;  :num-allocs              209222
;  :num-checks              104
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            294753)
(assert (< i1@47@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 8
; Joined path conditions
(assert (< i1@47@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
; [eval] scale(V * V * write) * wildcard
; [eval] scale(V * V * write)
; [eval] V * V * write
; [eval] V * V
(push) ; 8
; [eval] amount >= 0 * write
; [eval] 0 * write
(push) ; 9
(assert (not (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1824
;  :arith-add-rows          548
;  :arith-assert-diseq      32
;  :arith-assert-lower      829
;  :arith-assert-upper      556
;  :arith-bound-prop        40
;  :arith-conflicts         93
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           820
;  :arith-nonlinear-bounds  82
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            273
;  :conflicts               177
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 194
;  :datatype-occurs-check   134
;  :datatype-splits         129
;  :decisions               462
;  :del-clause              1533
;  :final-checks            168
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.04
;  :mk-bool-var             2921
;  :mk-clause               1548
;  :num-allocs              209366
;  :num-checks              105
;  :propagations            857
;  :quant-instantiations    590
;  :rlimit-count            294865)
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(pop) ; 8
; Joined path conditions
(assert (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
(declare-const $k@48@02 $Perm)
(assert ($Perm.isReadVar $k@48@02 $Perm.Write))
(pop) ; 7
(declare-fun inv@49@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@48@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((i1@47@02 Int)) (!
  (and
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@47@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    (>= (* (to_real (* V@5@02 V@5@02)) $Perm.Write) $Perm.No))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@47@02))
  :qid |option$array$-aux|)))
(push) ; 7
(assert (not (forall ((i1@47@02 Int)) (!
  (implies
    (and (< i1@47@02 V@5@02) (<= 0 i1@47@02))
    (or
      (=
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@48@02)
        $Perm.No)
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@48@02))))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1835
;  :arith-add-rows          548
;  :arith-assert-diseq      34
;  :arith-assert-lower      844
;  :arith-assert-upper      565
;  :arith-bound-prop        40
;  :arith-conflicts         94
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           839
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        146
;  :arith-pivots            275
;  :conflicts               178
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 198
;  :datatype-occurs-check   134
;  :datatype-splits         129
;  :decisions               466
;  :del-clause              1536
;  :final-checks            169
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.03
;  :mk-bool-var             2931
;  :mk-clause               1553
;  :num-allocs              210013
;  :num-checks              106
;  :propagations            859
;  :quant-instantiations    590
;  :rlimit-count            295811)
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((i11@47@02 Int) (i12@47@02 Int)) (!
  (implies
    (and
      (and
        (and (< i11@47@02 V@5@02) (<= 0 i11@47@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@48@02)))
      (and
        (and (< i12@47@02 V@5@02) (<= 0 i12@47@02))
        (<
          $Perm.No
          (*
            (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
            $k@48@02)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i11@47@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i12@47@02)))
    (= i11@47@02 i12@47@02))
  
  :qid |option$array$-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1852
;  :arith-add-rows          554
;  :arith-assert-diseq      36
;  :arith-assert-lower      849
;  :arith-assert-upper      565
;  :arith-bound-prop        42
;  :arith-conflicts         94
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         147
;  :arith-grobner           65
;  :arith-max-min           839
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  51
;  :arith-offset-eqs        148
;  :arith-pivots            279
;  :conflicts               179
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 198
;  :datatype-occurs-check   134
;  :datatype-splits         129
;  :decisions               466
;  :del-clause              1558
;  :final-checks            169
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.06
;  :memory                  5.03
;  :mk-bool-var             2971
;  :mk-clause               1575
;  :num-allocs              210568
;  :num-checks              107
;  :propagations            867
;  :quant-instantiations    613
;  :rlimit-count            297353)
; Definitional axioms for inverse functions
(assert (forall ((i1@47@02 Int)) (!
  (implies
    (and
      (and (< i1@47@02 V@5@02) (<= 0 i1@47@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@48@02)))
    (=
      (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@47@02))
      i1@47@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@47@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and (< (inv@49@02 r) V@5@02) (<= 0 (inv@49@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@48@02)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) (inv@49@02 r))
      r))
  :pattern ((inv@49@02 r))
  :qid |option$array$-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((i1@47@02 Int)) (!
  (<=
    $Perm.No
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@47@02))
  :qid |option$array$-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((i1@47@02 Int)) (!
  (<=
    (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
    $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@47@02))
  :qid |option$array$-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((i1@47@02 Int)) (!
  (implies
    (and
      (and (< i1@47@02 V@5@02) (<= 0 i1@47@02))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@48@02)))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@47@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@47@02))
  :qid |option$array$-permImpliesNonNull|)))
(declare-const sm@50@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@49@02 r) V@5@02) (<= 0 (inv@49@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@48@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))) r))
  :qid |qp.fvfValDef12|)))
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and (< (inv@41@02 r) V@5@02) (<= 0 (inv@41@02 r)))
      (<
        $Perm.No
        (*
          (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write))
          $k@40@02))
      false)
    (=
      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r)
      ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@02))))) r)))
  :pattern (($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r))
  :pattern (($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@02))))) r))
  :qid |qp.fvfValDef13|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))) r) r)
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ ($SortWrappers.$SnapTo$FVF<option<array>> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@02))))) r) r))
  :pattern (($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r))
  :qid |qp.fvfResTrgDef14|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@49@02 r) V@5@02) (<= 0 (inv@49@02 r)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) r) r))
  :pattern ((inv@49@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 67 | exc@8@02 == Null | live]
; [else-branch: 67 | exc@8@02 != Null | live]
(push) ; 8
; [then-branch: 67 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 67 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1888
;  :arith-add-rows          554
;  :arith-assert-diseq      36
;  :arith-assert-lower      874
;  :arith-assert-upper      581
;  :arith-bound-prop        42
;  :arith-conflicts         94
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         147
;  :arith-grobner           70
;  :arith-max-min           879
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        148
;  :arith-pivots            279
;  :conflicts               179
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   137
;  :datatype-splits         132
;  :decisions               473
;  :del-clause              1558
;  :final-checks            173
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.07
;  :memory                  5.05
;  :mk-bool-var             2985
;  :mk-clause               1575
;  :num-allocs              212811
;  :num-checks              108
;  :propagations            867
;  :quant-instantiations    613
;  :rlimit-count            302287)
(push) ; 8
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1888
;  :arith-add-rows          554
;  :arith-assert-diseq      36
;  :arith-assert-lower      874
;  :arith-assert-upper      581
;  :arith-bound-prop        42
;  :arith-conflicts         94
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         147
;  :arith-grobner           70
;  :arith-max-min           879
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        148
;  :arith-pivots            279
;  :conflicts               179
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   137
;  :datatype-splits         132
;  :decisions               473
;  :del-clause              1558
;  :final-checks            173
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.07
;  :memory                  5.05
;  :mk-bool-var             2985
;  :mk-clause               1575
;  :num-allocs              212829
;  :num-checks              109
;  :propagations            867
;  :quant-instantiations    613
;  :rlimit-count            302304)
; [then-branch: 68 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 68 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 8
; [then-branch: 68 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
(declare-const i1@51@02 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 69 | 0 <= i1@51@02 | live]
; [else-branch: 69 | !(0 <= i1@51@02) | live]
(push) ; 11
; [then-branch: 69 | 0 <= i1@51@02]
(assert (<= 0 i1@51@02))
; [eval] i1 < V
(pop) ; 11
(push) ; 11
; [else-branch: 69 | !(0 <= i1@51@02)]
(assert (not (<= 0 i1@51@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 70 | i1@51@02 < V@5@02 && 0 <= i1@51@02 | live]
; [else-branch: 70 | !(i1@51@02 < V@5@02 && 0 <= i1@51@02) | live]
(push) ; 11
; [then-branch: 70 | i1@51@02 < V@5@02 && 0 <= i1@51@02]
(assert (and (< i1@51@02 V@5@02) (<= 0 i1@51@02)))
; [eval] aloc(opt_get1(target), i1).option$array$ != (None(): option[array])
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 13
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1888
;  :arith-add-rows          554
;  :arith-assert-diseq      36
;  :arith-assert-lower      876
;  :arith-assert-upper      581
;  :arith-bound-prop        42
;  :arith-conflicts         94
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         147
;  :arith-grobner           70
;  :arith-max-min           879
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        148
;  :arith-pivots            280
;  :conflicts               179
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   137
;  :datatype-splits         132
;  :decisions               473
;  :del-clause              1558
;  :final-checks            173
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.07
;  :memory                  5.05
;  :mk-bool-var             2987
;  :mk-clause               1575
;  :num-allocs              212924
;  :num-checks              110
;  :propagations            867
;  :quant-instantiations    613
;  :rlimit-count            302498)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 13
(assert (not (< i1@51@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1888
;  :arith-add-rows          554
;  :arith-assert-diseq      36
;  :arith-assert-lower      876
;  :arith-assert-upper      581
;  :arith-bound-prop        42
;  :arith-conflicts         94
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         147
;  :arith-grobner           70
;  :arith-max-min           879
;  :arith-nonlinear-bounds  83
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        148
;  :arith-pivots            280
;  :conflicts               179
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 205
;  :datatype-occurs-check   137
;  :datatype-splits         132
;  :decisions               473
;  :del-clause              1558
;  :final-checks            173
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.07
;  :memory                  5.05
;  :mk-bool-var             2987
;  :mk-clause               1575
;  :num-allocs              212945
;  :num-checks              111
;  :propagations            867
;  :quant-instantiations    613
;  :rlimit-count            302529)
(assert (< i1@51@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 12
; Joined path conditions
(assert (< i1@51@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2111
;  :arith-add-rows          607
;  :arith-assert-diseq      38
;  :arith-assert-lower      957
;  :arith-assert-upper      646
;  :arith-bound-prop        47
;  :arith-conflicts         102
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         166
;  :arith-grobner           70
;  :arith-max-min           943
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  55
;  :arith-offset-eqs        157
;  :arith-pivots            307
;  :conflicts               196
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 217
;  :datatype-occurs-check   143
;  :datatype-splits         141
;  :decisions               587
;  :del-clause              1942
;  :final-checks            180
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.14
;  :memory                  5.14
;  :mk-bool-var             3522
;  :mk-clause               2030
;  :num-allocs              214615
;  :num-checks              112
;  :propagations            1063
;  :quant-instantiations    716
;  :rlimit-count            309960
;  :time                    0.00)
; [eval] (None(): option[array])
(pop) ; 11
(push) ; 11
; [else-branch: 70 | !(i1@51@02 < V@5@02 && 0 <= i1@51@02)]
(assert (not (and (< i1@51@02 V@5@02) (<= 0 i1@51@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i1@51@02 V@5@02) (<= 0 i1@51@02))
  (and
    (< i1@51@02 V@5@02)
    (<= 0 i1@51@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@51@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02)))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@51@02 Int)) (!
  (implies
    (and (< i1@51@02 V@5@02) (<= 0 i1@51@02))
    (and
      (< i1@51@02 V@5@02)
      (<= 0 i1@51@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< i1@51@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (forall ((i1@51@02 Int)) (!
      (implies
        (and (< i1@51@02 V@5@02) (<= 0 i1@51@02))
        (and
          (< i1@51@02 V@5@02)
          (<= 0 i1@51@02)
          (not (= target@7@02 (as None<option<array>>  option<array>)))
          (< i1@51@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (forall ((i1@51@02 Int)) (!
    (implies
      (and (< i1@51@02 V@5@02) (<= 0 i1@51@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))
          (as None<option<array>>  option<array>))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@51@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 71 | exc@8@02 == Null | live]
; [else-branch: 71 | exc@8@02 != Null | live]
(push) ; 8
; [then-branch: 71 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 71 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2148
;  :arith-add-rows          607
;  :arith-assert-diseq      38
;  :arith-assert-lower      981
;  :arith-assert-upper      662
;  :arith-bound-prop        47
;  :arith-conflicts         102
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         166
;  :arith-grobner           75
;  :arith-max-min           984
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        157
;  :arith-pivots            309
;  :conflicts               196
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 224
;  :datatype-occurs-check   146
;  :datatype-splits         144
;  :decisions               594
;  :del-clause              2013
;  :final-checks            184
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.16
;  :memory                  5.14
;  :mk-bool-var             3529
;  :mk-clause               2030
;  :num-allocs              215965
;  :num-checks              113
;  :propagations            1063
;  :quant-instantiations    716
;  :rlimit-count            312421)
(push) ; 8
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2148
;  :arith-add-rows          607
;  :arith-assert-diseq      38
;  :arith-assert-lower      981
;  :arith-assert-upper      662
;  :arith-bound-prop        47
;  :arith-conflicts         102
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         166
;  :arith-grobner           75
;  :arith-max-min           984
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        157
;  :arith-pivots            309
;  :conflicts               196
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 224
;  :datatype-occurs-check   146
;  :datatype-splits         144
;  :decisions               594
;  :del-clause              2013
;  :final-checks            184
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.16
;  :memory                  5.14
;  :mk-bool-var             3529
;  :mk-clause               2030
;  :num-allocs              215983
;  :num-checks              114
;  :propagations            1063
;  :quant-instantiations    716
;  :rlimit-count            312438)
; [then-branch: 72 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 72 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 8
; [then-branch: 72 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
(declare-const i1@52@02 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 73 | 0 <= i1@52@02 | live]
; [else-branch: 73 | !(0 <= i1@52@02) | live]
(push) ; 11
; [then-branch: 73 | 0 <= i1@52@02]
(assert (<= 0 i1@52@02))
; [eval] i1 < V
(pop) ; 11
(push) ; 11
; [else-branch: 73 | !(0 <= i1@52@02)]
(assert (not (<= 0 i1@52@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 74 | i1@52@02 < V@5@02 && 0 <= i1@52@02 | live]
; [else-branch: 74 | !(i1@52@02 < V@5@02 && 0 <= i1@52@02) | live]
(push) ; 11
; [then-branch: 74 | i1@52@02 < V@5@02 && 0 <= i1@52@02]
(assert (and (< i1@52@02 V@5@02) (<= 0 i1@52@02)))
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
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2148
;  :arith-add-rows          607
;  :arith-assert-diseq      38
;  :arith-assert-lower      983
;  :arith-assert-upper      662
;  :arith-bound-prop        47
;  :arith-conflicts         102
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         166
;  :arith-grobner           75
;  :arith-max-min           984
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        157
;  :arith-pivots            309
;  :conflicts               196
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 224
;  :datatype-occurs-check   146
;  :datatype-splits         144
;  :decisions               594
;  :del-clause              2013
;  :final-checks            184
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.16
;  :memory                  5.14
;  :mk-bool-var             3531
;  :mk-clause               2030
;  :num-allocs              216078
;  :num-checks              115
;  :propagations            1063
;  :quant-instantiations    716
;  :rlimit-count            312628)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 12
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 13
(assert (not (< i1@52@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2148
;  :arith-add-rows          607
;  :arith-assert-diseq      38
;  :arith-assert-lower      983
;  :arith-assert-upper      662
;  :arith-bound-prop        47
;  :arith-conflicts         102
;  :arith-eq-adapter        187
;  :arith-fixed-eqs         166
;  :arith-grobner           75
;  :arith-max-min           984
;  :arith-nonlinear-bounds  97
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        157
;  :arith-pivots            309
;  :conflicts               196
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 224
;  :datatype-occurs-check   146
;  :datatype-splits         144
;  :decisions               594
;  :del-clause              2013
;  :final-checks            184
;  :interface-eqs           14
;  :max-generation          5
;  :max-memory              5.16
;  :memory                  5.14
;  :mk-bool-var             3531
;  :mk-clause               2030
;  :num-allocs              216099
;  :num-checks              116
;  :propagations            1063
;  :quant-instantiations    716
;  :rlimit-count            312659)
(assert (< i1@52@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 12
; Joined path conditions
(assert (< i1@52@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)))
(push) ; 12
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2572
;  :arith-add-rows          662
;  :arith-assert-diseq      39
;  :arith-assert-lower      1070
;  :arith-assert-upper      737
;  :arith-bound-prop        56
;  :arith-conflicts         109
;  :arith-eq-adapter        216
;  :arith-fixed-eqs         189
;  :arith-grobner           75
;  :arith-max-min           1068
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        218
;  :arith-pivots            337
;  :conflicts               213
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 271
;  :datatype-occurs-check   184
;  :datatype-splits         189
;  :decisions               727
;  :del-clause              2332
;  :final-checks            209
;  :interface-eqs           23
;  :max-generation          5
;  :max-memory              5.17
;  :memory                  5.17
;  :mk-bool-var             4150
;  :mk-clause               2420
;  :num-allocs              218069
;  :num-checks              117
;  :propagations            1263
;  :quant-instantiations    804
;  :rlimit-count            320243
;  :time                    0.00)
(push) ; 12
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 13
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2572
;  :arith-add-rows          662
;  :arith-assert-diseq      39
;  :arith-assert-lower      1070
;  :arith-assert-upper      737
;  :arith-bound-prop        56
;  :arith-conflicts         109
;  :arith-eq-adapter        216
;  :arith-fixed-eqs         189
;  :arith-grobner           75
;  :arith-max-min           1068
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  59
;  :arith-offset-eqs        218
;  :arith-pivots            337
;  :conflicts               214
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 271
;  :datatype-occurs-check   184
;  :datatype-splits         189
;  :decisions               727
;  :del-clause              2332
;  :final-checks            209
;  :interface-eqs           23
;  :max-generation          5
;  :max-memory              5.18
;  :memory                  5.17
;  :mk-bool-var             4150
;  :mk-clause               2420
;  :num-allocs              218159
;  :num-checks              118
;  :propagations            1263
;  :quant-instantiations    804
;  :rlimit-count            320338)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
    (as None<option<array>>  option<array>))))
(pop) ; 12
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
    (as None<option<array>>  option<array>))))
(pop) ; 11
(push) ; 11
; [else-branch: 74 | !(i1@52@02 < V@5@02 && 0 <= i1@52@02)]
(assert (not (and (< i1@52@02 V@5@02) (<= 0 i1@52@02))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i1@52@02 V@5@02) (<= 0 i1@52@02))
  (and
    (< i1@52@02 V@5@02)
    (<= 0 i1@52@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@52@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
        (as None<option<array>>  option<array>))))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@52@02 Int)) (!
  (implies
    (and (< i1@52@02 V@5@02) (<= 0 i1@52@02))
    (and
      (< i1@52@02 V@5@02)
      (<= 0 i1@52@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< i1@52@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
          (as None<option<array>>  option<array>)))))
  :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)))))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (forall ((i1@52@02 Int)) (!
      (implies
        (and (< i1@52@02 V@5@02) (<= 0 i1@52@02))
        (and
          (< i1@52@02 V@5@02)
          (<= 0 i1@52@02)
          (not (= target@7@02 (as None<option<array>>  option<array>)))
          (< i1@52@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))
              (as None<option<array>>  option<array>)))))
      :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)))))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (forall ((i1@52@02 Int)) (!
    (implies
      (and (< i1@52@02 V@5@02) (<= 0 i1@52@02))
      (=
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02))))
        V@5@02))
    :pattern ((alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@52@02)))))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 75 | exc@8@02 == Null | live]
; [else-branch: 75 | exc@8@02 != Null | live]
(push) ; 8
; [then-branch: 75 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 75 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2610
;  :arith-add-rows          662
;  :arith-assert-diseq      39
;  :arith-assert-lower      1094
;  :arith-assert-upper      753
;  :arith-bound-prop        56
;  :arith-conflicts         109
;  :arith-eq-adapter        216
;  :arith-fixed-eqs         189
;  :arith-grobner           80
;  :arith-max-min           1109
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        218
;  :arith-pivots            340
;  :conflicts               214
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 278
;  :datatype-occurs-check   189
;  :datatype-splits         192
;  :decisions               734
;  :del-clause              2403
;  :final-checks            213
;  :interface-eqs           23
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.17
;  :mk-bool-var             4157
;  :mk-clause               2420
;  :num-allocs              219532
;  :num-checks              119
;  :propagations            1263
;  :quant-instantiations    804
;  :rlimit-count            322905)
(push) ; 8
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2610
;  :arith-add-rows          662
;  :arith-assert-diseq      39
;  :arith-assert-lower      1094
;  :arith-assert-upper      753
;  :arith-bound-prop        56
;  :arith-conflicts         109
;  :arith-eq-adapter        216
;  :arith-fixed-eqs         189
;  :arith-grobner           80
;  :arith-max-min           1109
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        218
;  :arith-pivots            340
;  :conflicts               214
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 278
;  :datatype-occurs-check   189
;  :datatype-splits         192
;  :decisions               734
;  :del-clause              2403
;  :final-checks            213
;  :interface-eqs           23
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.17
;  :mk-bool-var             4157
;  :mk-clause               2420
;  :num-allocs              219550
;  :num-checks              120
;  :propagations            1263
;  :quant-instantiations    804
;  :rlimit-count            322922)
; [then-branch: 76 | 0 < V@5@02 && exc@8@02 == Null | live]
; [else-branch: 76 | !(0 < V@5@02 && exc@8@02 == Null) | dead]
(push) ; 8
; [then-branch: 76 | 0 < V@5@02 && exc@8@02 == Null]
(assert (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))
; [eval] (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
(declare-const i1@53@02 Int)
(push) ; 9
; [eval] (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2)
(declare-const i2@54@02 Int)
(push) ; 10
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2
; [eval] 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] 0 <= i1
(push) ; 11
; [then-branch: 77 | 0 <= i1@53@02 | live]
; [else-branch: 77 | !(0 <= i1@53@02) | live]
(push) ; 12
; [then-branch: 77 | 0 <= i1@53@02]
(assert (<= 0 i1@53@02))
; [eval] i1 < V
(push) ; 13
; [then-branch: 78 | i1@53@02 < V@5@02 | live]
; [else-branch: 78 | !(i1@53@02 < V@5@02) | live]
(push) ; 14
; [then-branch: 78 | i1@53@02 < V@5@02]
(assert (< i1@53@02 V@5@02))
; [eval] 0 <= i2
(push) ; 15
; [then-branch: 79 | 0 <= i2@54@02 | live]
; [else-branch: 79 | !(0 <= i2@54@02) | live]
(push) ; 16
; [then-branch: 79 | 0 <= i2@54@02]
(assert (<= 0 i2@54@02))
; [eval] i2 < V
(push) ; 17
; [then-branch: 80 | i2@54@02 < V@5@02 | live]
; [else-branch: 80 | !(i2@54@02 < V@5@02) | live]
(push) ; 18
; [then-branch: 80 | i2@54@02 < V@5@02]
(assert (< i2@54@02 V@5@02))
; [eval] aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$
; [eval] aloc(opt_get1(target), i1)
; [eval] opt_get1(target)
(push) ; 19
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 20
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2610
;  :arith-add-rows          662
;  :arith-assert-diseq      39
;  :arith-assert-lower      1098
;  :arith-assert-upper      753
;  :arith-bound-prop        56
;  :arith-conflicts         109
;  :arith-eq-adapter        216
;  :arith-fixed-eqs         189
;  :arith-grobner           80
;  :arith-max-min           1109
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        218
;  :arith-pivots            341
;  :conflicts               214
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 278
;  :datatype-occurs-check   189
;  :datatype-splits         192
;  :decisions               734
;  :del-clause              2403
;  :final-checks            213
;  :interface-eqs           23
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.17
;  :mk-bool-var             4161
;  :mk-clause               2420
;  :num-allocs              219822
;  :num-checks              121
;  :propagations            1263
;  :quant-instantiations    804
;  :rlimit-count            323261)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 19
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 19
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 20
(assert (not (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2610
;  :arith-add-rows          662
;  :arith-assert-diseq      39
;  :arith-assert-lower      1098
;  :arith-assert-upper      753
;  :arith-bound-prop        56
;  :arith-conflicts         109
;  :arith-eq-adapter        216
;  :arith-fixed-eqs         189
;  :arith-grobner           80
;  :arith-max-min           1109
;  :arith-nonlinear-bounds  111
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        218
;  :arith-pivots            341
;  :conflicts               214
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 278
;  :datatype-occurs-check   189
;  :datatype-splits         192
;  :decisions               734
;  :del-clause              2403
;  :final-checks            213
;  :interface-eqs           23
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.17
;  :mk-bool-var             4161
;  :mk-clause               2420
;  :num-allocs              219843
;  :num-checks              122
;  :propagations            1263
;  :quant-instantiations    804
;  :rlimit-count            323292)
(assert (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 19
; Joined path conditions
(assert (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2867
;  :arith-add-rows          722
;  :arith-assert-diseq      41
;  :arith-assert-lower      1178
;  :arith-assert-upper      819
;  :arith-bound-prop        61
;  :arith-conflicts         117
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         211
;  :arith-grobner           80
;  :arith-max-min           1173
;  :arith-nonlinear-bounds  125
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        229
;  :arith-pivots            372
;  :conflicts               232
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 295
;  :datatype-occurs-check   197
;  :datatype-splits         205
;  :decisions               850
;  :del-clause              2792
;  :final-checks            222
;  :interface-eqs           24
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :mk-bool-var             4742
;  :mk-clause               2880
;  :num-allocs              221329
;  :num-checks              123
;  :propagations            1461
;  :quant-instantiations    909
;  :rlimit-count            330785
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
(assert (not (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 20
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2867
;  :arith-add-rows          722
;  :arith-assert-diseq      41
;  :arith-assert-lower      1178
;  :arith-assert-upper      819
;  :arith-bound-prop        61
;  :arith-conflicts         117
;  :arith-eq-adapter        239
;  :arith-fixed-eqs         211
;  :arith-grobner           80
;  :arith-max-min           1173
;  :arith-nonlinear-bounds  125
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        229
;  :arith-pivots            372
;  :conflicts               232
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 295
;  :datatype-occurs-check   197
;  :datatype-splits         205
;  :decisions               850
;  :del-clause              2792
;  :final-checks            222
;  :interface-eqs           24
;  :max-generation          5
;  :max-memory              5.19
;  :memory                  5.19
;  :mk-bool-var             4742
;  :mk-clause               2880
;  :num-allocs              221356
;  :num-checks              124
;  :propagations            1461
;  :quant-instantiations    909
;  :rlimit-count            330815)
(assert (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 19
; Joined path conditions
(assert (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
(push) ; 19
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 19
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3206
;  :arith-add-rows          912
;  :arith-assert-diseq      52
;  :arith-assert-lower      1297
;  :arith-assert-upper      916
;  :arith-bound-prop        82
;  :arith-conflicts         127
;  :arith-eq-adapter        269
;  :arith-fixed-eqs         247
;  :arith-grobner           80
;  :arith-max-min           1263
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  63
;  :arith-offset-eqs        248
;  :arith-pivots            425
;  :conflicts               250
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   207
;  :datatype-splits         220
;  :decisions               1015
;  :del-clause              3319
;  :final-checks            233
;  :interface-eqs           24
;  :max-generation          5
;  :max-memory              5.24
;  :memory                  5.23
;  :minimized-lits          1
;  :mk-bool-var             5399
;  :mk-clause               3450
;  :num-allocs              223261
;  :num-checks              125
;  :propagations            1752
;  :quant-instantiations    1030
;  :rlimit-count            341804
;  :time                    0.01)
(pop) ; 18
(push) ; 18
; [else-branch: 80 | !(i2@54@02 < V@5@02)]
(assert (not (< i2@54@02 V@5@02)))
(pop) ; 18
(pop) ; 17
; Joined path conditions
(assert (implies
  (< i2@54@02 V@5@02)
  (and
    (< i2@54@02 V@5@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
    (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))))
; Joined path conditions
(pop) ; 16
(push) ; 16
; [else-branch: 79 | !(0 <= i2@54@02)]
(assert (not (<= 0 i2@54@02)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (implies
  (<= 0 i2@54@02)
  (and
    (<= 0 i2@54@02)
    (implies
      (< i2@54@02 V@5@02)
      (and
        (< i2@54@02 V@5@02)
        (not (= target@7@02 (as None<option<array>>  option<array>)))
        (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
        (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
        ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))))))
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 78 | !(i1@53@02 < V@5@02)]
(assert (not (< i1@53@02 V@5@02)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
(assert (implies
  (< i1@53@02 V@5@02)
  (and
    (< i1@53@02 V@5@02)
    (implies
      (<= 0 i2@54@02)
      (and
        (<= 0 i2@54@02)
        (implies
          (< i2@54@02 V@5@02)
          (and
            (< i2@54@02 V@5@02)
            (not (= target@7@02 (as None<option<array>>  option<array>)))
            (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
            (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
            ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))))))))
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 77 | !(0 <= i1@53@02)]
(assert (not (<= 0 i1@53@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (<= 0 i1@53@02)
  (and
    (<= 0 i1@53@02)
    (implies
      (< i1@53@02 V@5@02)
      (and
        (< i1@53@02 V@5@02)
        (implies
          (<= 0 i2@54@02)
          (and
            (<= 0 i2@54@02)
            (implies
              (< i2@54@02 V@5@02)
              (and
                (< i2@54@02 V@5@02)
                (not (= target@7@02 (as None<option<array>>  option<array>)))
                (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))))))))))
; Joined path conditions
(push) ; 11
; [then-branch: 81 | Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i1@53@02)) == Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i2@54@02)) && i2@54@02 < V@5@02 && 0 <= i2@54@02 && i1@53@02 < V@5@02 && 0 <= i1@53@02 | live]
; [else-branch: 81 | !(Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i1@53@02)) == Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i2@54@02)) && i2@54@02 < V@5@02 && 0 <= i2@54@02 && i1@53@02 < V@5@02 && 0 <= i1@53@02) | live]
(push) ; 12
; [then-branch: 81 | Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i1@53@02)) == Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i2@54@02)) && i2@54@02 < V@5@02 && 0 <= i2@54@02 && i1@53@02 < V@5@02 && 0 <= i1@53@02]
(assert (and
  (and
    (and
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
        (< i2@54@02 V@5@02))
      (<= 0 i2@54@02))
    (< i1@53@02 V@5@02))
  (<= 0 i1@53@02)))
; [eval] i1 == i2
(pop) ; 12
(push) ; 12
; [else-branch: 81 | !(Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i1@53@02)) == Lookup(option$array$,sm@50@02,aloc((_, _), opt_get1(_, target@7@02), i2@54@02)) && i2@54@02 < V@5@02 && 0 <= i2@54@02 && i1@53@02 < V@5@02 && 0 <= i1@53@02)]
(assert (not
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
            ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
          (< i2@54@02 V@5@02))
        (<= 0 i2@54@02))
      (< i1@53@02 V@5@02))
    (<= 0 i1@53@02))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
            ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
          (< i2@54@02 V@5@02))
        (<= 0 i2@54@02))
      (< i1@53@02 V@5@02))
    (<= 0 i1@53@02))
  (and
    (=
      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
    (< i2@54@02 V@5@02)
    (<= 0 i2@54@02)
    (< i1@53@02 V@5@02)
    (<= 0 i1@53@02))))
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i2@54@02 Int)) (!
  (and
    (implies
      (<= 0 i1@53@02)
      (and
        (<= 0 i1@53@02)
        (implies
          (< i1@53@02 V@5@02)
          (and
            (< i1@53@02 V@5@02)
            (implies
              (<= 0 i2@54@02)
              (and
                (<= 0 i2@54@02)
                (implies
                  (< i2@54@02 V@5@02)
                  (and
                    (< i2@54@02 V@5@02)
                    (not (= target@7@02 (as None<option<array>>  option<array>)))
                    (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                    (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
                      $Snap.unit
                      $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))))))))))
    (implies
      (and
        (and
          (and
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
              (< i2@54@02 V@5@02))
            (<= 0 i2@54@02))
          (< i1@53@02 V@5@02))
        (<= 0 i1@53@02))
      (and
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
        (< i2@54@02 V@5@02)
        (<= 0 i2@54@02)
        (< i1@53@02 V@5@02)
        (<= 0 i1@53@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@53@02 Int)) (!
  (forall ((i2@54@02 Int)) (!
    (and
      (implies
        (<= 0 i1@53@02)
        (and
          (<= 0 i1@53@02)
          (implies
            (< i1@53@02 V@5@02)
            (and
              (< i1@53@02 V@5@02)
              (implies
                (<= 0 i2@54@02)
                (and
                  (<= 0 i2@54@02)
                  (implies
                    (< i2@54@02 V@5@02)
                    (and
                      (< i2@54@02 V@5@02)
                      (not
                        (= target@7@02 (as None<option<array>>  option<array>)))
                      (< i1@53@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                      (< i2@54@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))))))))))
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                  ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
                (< i2@54@02 V@5@02))
              (<= 0 i2@54@02))
            (< i1@53@02 V@5@02))
          (<= 0 i1@53@02))
        (and
          (=
            ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
            ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
          (< i2@54@02 V@5@02)
          (<= 0 i2@54@02)
          (< i1@53@02 V@5@02)
          (<= 0 i1@53@02))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))
    :qid |prog.l<no position>-aux|))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (and
    (< 0 V@5@02)
    (= exc@8@02 $Ref.null)
    (forall ((i1@53@02 Int)) (!
      (forall ((i2@54@02 Int)) (!
        (and
          (implies
            (<= 0 i1@53@02)
            (and
              (<= 0 i1@53@02)
              (implies
                (< i1@53@02 V@5@02)
                (and
                  (< i1@53@02 V@5@02)
                  (implies
                    (<= 0 i2@54@02)
                    (and
                      (<= 0 i2@54@02)
                      (implies
                        (< i2@54@02 V@5@02)
                        (and
                          (< i2@54@02 V@5@02)
                          (not
                            (=
                              target@7@02
                              (as None<option<array>>  option<array>)))
                          (<
                            i1@53@02
                            (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                          (<
                            i2@54@02
                            (alen<Int> (opt_get1 $Snap.unit target@7@02)))
                          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)) (aloc ($Snap.combine
                            $Snap.unit
                            $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))))))))))
          (implies
            (and
              (and
                (and
                  (and
                    (=
                      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                      ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                        $Snap.unit
                        $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
                    (< i2@54@02 V@5@02))
                  (<= 0 i2@54@02))
                (< i1@53@02 V@5@02))
              (<= 0 i1@53@02))
            (and
              (=
                ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                  $Snap.unit
                  $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
              (< i2@54@02 V@5@02)
              (<= 0 i2@54@02)
              (< i1@53@02 V@5@02)
              (<= 0 i1@53@02))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))
        :qid |prog.l<no position>-aux|))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
      :qid |prog.l<no position>-aux|)))))
(assert (implies
  (and (< 0 V@5@02) (= exc@8@02 $Ref.null))
  (forall ((i1@53@02 Int)) (!
    (forall ((i2@54@02 Int)) (!
      (implies
        (and
          (and
            (and
              (and
                (=
                  ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
                  ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                    $Snap.unit
                    $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02)))
                (< i2@54@02 V@5@02))
              (<= 0 i2@54@02))
            (< i1@53@02 V@5@02))
          (<= 0 i1@53@02))
        (= i1@53@02 i2@54@02))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i2@54@02))
      :qid |prog.l<no position>|))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) i1@53@02))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))))))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@8@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3245
;  :arith-add-rows          914
;  :arith-assert-diseq      52
;  :arith-assert-lower      1321
;  :arith-assert-upper      932
;  :arith-bound-prop        82
;  :arith-conflicts         127
;  :arith-eq-adapter        269
;  :arith-fixed-eqs         247
;  :arith-grobner           85
;  :arith-max-min           1304
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        248
;  :arith-pivots            430
;  :conflicts               250
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 321
;  :datatype-occurs-check   212
;  :datatype-splits         224
;  :decisions               1023
;  :del-clause              3457
;  :final-checks            237
;  :interface-eqs           24
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          1
;  :mk-bool-var             5419
;  :mk-clause               3474
;  :num-allocs              225127
;  :num-checks              126
;  :propagations            1752
;  :quant-instantiations    1030
;  :rlimit-count            345717)
(push) ; 7
(assert (not (= exc@8@02 $Ref.null)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3245
;  :arith-add-rows          914
;  :arith-assert-diseq      52
;  :arith-assert-lower      1321
;  :arith-assert-upper      932
;  :arith-bound-prop        82
;  :arith-conflicts         127
;  :arith-eq-adapter        269
;  :arith-fixed-eqs         247
;  :arith-grobner           85
;  :arith-max-min           1304
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        248
;  :arith-pivots            430
;  :conflicts               250
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 321
;  :datatype-occurs-check   212
;  :datatype-splits         224
;  :decisions               1023
;  :del-clause              3457
;  :final-checks            237
;  :interface-eqs           24
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          1
;  :mk-bool-var             5419
;  :mk-clause               3474
;  :num-allocs              225145
;  :num-checks              127
;  :propagations            1752
;  :quant-instantiations    1030
;  :rlimit-count            345728)
; [then-branch: 82 | exc@8@02 == Null | live]
; [else-branch: 82 | exc@8@02 != Null | dead]
(push) ; 7
; [then-branch: 82 | exc@8@02 == Null]
(assert (= exc@8@02 $Ref.null))
(declare-const unknown@55@02 Int)
(declare-const unknown1@56@02 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 83 | 0 <= unknown@55@02 | live]
; [else-branch: 83 | !(0 <= unknown@55@02) | live]
(push) ; 10
; [then-branch: 83 | 0 <= unknown@55@02]
(assert (<= 0 unknown@55@02))
; [eval] unknown < V
(push) ; 11
; [then-branch: 84 | unknown@55@02 < V@5@02 | live]
; [else-branch: 84 | !(unknown@55@02 < V@5@02) | live]
(push) ; 12
; [then-branch: 84 | unknown@55@02 < V@5@02]
(assert (< unknown@55@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 13
; [then-branch: 85 | 0 <= unknown1@56@02 | live]
; [else-branch: 85 | !(0 <= unknown1@56@02) | live]
(push) ; 14
; [then-branch: 85 | 0 <= unknown1@56@02]
(assert (<= 0 unknown1@56@02))
; [eval] unknown1 < V
(pop) ; 14
(push) ; 14
; [else-branch: 85 | !(0 <= unknown1@56@02)]
(assert (not (<= 0 unknown1@56@02)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 84 | !(unknown@55@02 < V@5@02)]
(assert (not (< unknown@55@02 V@5@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 83 | !(0 <= unknown@55@02)]
(assert (not (<= 0 unknown@55@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@56@02 V@5@02) (<= 0 unknown1@56@02))
    (< unknown@55@02 V@5@02))
  (<= 0 unknown@55@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3245
;  :arith-add-rows          914
;  :arith-assert-diseq      52
;  :arith-assert-lower      1327
;  :arith-assert-upper      932
;  :arith-bound-prop        82
;  :arith-conflicts         127
;  :arith-eq-adapter        269
;  :arith-fixed-eqs         247
;  :arith-grobner           85
;  :arith-max-min           1304
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        248
;  :arith-pivots            431
;  :conflicts               250
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 321
;  :datatype-occurs-check   212
;  :datatype-splits         224
;  :decisions               1023
;  :del-clause              3457
;  :final-checks            237
;  :interface-eqs           24
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          1
;  :mk-bool-var             5425
;  :mk-clause               3474
;  :num-allocs              225415
;  :num-checks              128
;  :propagations            1752
;  :quant-instantiations    1030
;  :rlimit-count            346193)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< unknown1@56@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3245
;  :arith-add-rows          914
;  :arith-assert-diseq      52
;  :arith-assert-lower      1327
;  :arith-assert-upper      932
;  :arith-bound-prop        82
;  :arith-conflicts         127
;  :arith-eq-adapter        269
;  :arith-fixed-eqs         247
;  :arith-grobner           85
;  :arith-max-min           1304
;  :arith-nonlinear-bounds  147
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        248
;  :arith-pivots            431
;  :conflicts               250
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 321
;  :datatype-occurs-check   212
;  :datatype-splits         224
;  :decisions               1023
;  :del-clause              3457
;  :final-checks            237
;  :interface-eqs           24
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          1
;  :mk-bool-var             5425
;  :mk-clause               3474
;  :num-allocs              225436
;  :num-checks              129
;  :propagations            1752
;  :quant-instantiations    1030
;  :rlimit-count            346224)
(assert (< unknown1@56@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 9
; Joined path conditions
(assert (< unknown1@56@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02)))
(push) ; 9
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3515
;  :arith-add-rows          977
;  :arith-assert-diseq      54
;  :arith-assert-lower      1405
;  :arith-assert-upper      993
;  :arith-bound-prop        86
;  :arith-conflicts         136
;  :arith-eq-adapter        292
;  :arith-fixed-eqs         267
;  :arith-grobner           85
;  :arith-max-min           1368
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        258
;  :arith-pivots            459
;  :conflicts               269
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 344
;  :datatype-occurs-check   222
;  :datatype-splits         245
;  :decisions               1135
;  :del-clause              3797
;  :final-checks            248
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.24
;  :minimized-lits          1
;  :mk-bool-var             5975
;  :mk-clause               3885
;  :num-allocs              226961
;  :num-checks              130
;  :propagations            1928
;  :quant-instantiations    1120
;  :rlimit-count            353552
;  :time                    0.00)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3515
;  :arith-add-rows          977
;  :arith-assert-diseq      54
;  :arith-assert-lower      1405
;  :arith-assert-upper      993
;  :arith-bound-prop        86
;  :arith-conflicts         136
;  :arith-eq-adapter        292
;  :arith-fixed-eqs         267
;  :arith-grobner           85
;  :arith-max-min           1368
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        258
;  :arith-pivots            459
;  :conflicts               270
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 344
;  :datatype-occurs-check   222
;  :datatype-splits         245
;  :decisions               1135
;  :del-clause              3797
;  :final-checks            248
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          1
;  :mk-bool-var             5975
;  :mk-clause               3885
;  :num-allocs              227051
;  :num-checks              131
;  :propagations            1928
;  :quant-instantiations    1120
;  :rlimit-count            353647)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  unknown@55@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3521
;  :arith-add-rows          982
;  :arith-assert-diseq      54
;  :arith-assert-lower      1408
;  :arith-assert-upper      994
;  :arith-bound-prop        86
;  :arith-conflicts         137
;  :arith-eq-adapter        293
;  :arith-fixed-eqs         268
;  :arith-grobner           85
;  :arith-max-min           1368
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        258
;  :arith-pivots            463
;  :conflicts               271
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 344
;  :datatype-occurs-check   222
;  :datatype-splits         245
;  :decisions               1135
;  :del-clause              3801
;  :final-checks            248
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.25
;  :memory                  5.23
;  :minimized-lits          1
;  :mk-bool-var             5986
;  :mk-clause               3889
;  :num-allocs              227246
;  :num-checks              132
;  :propagations            1930
;  :quant-instantiations    1127
;  :rlimit-count            354139)
(assert (<
  unknown@55@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))))))
(pop) ; 9
; Joined path conditions
(assert (<
  unknown@55@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))))))
(pop) ; 8
(declare-fun inv@57@02 ($Ref) Int)
(declare-fun inv@58@02 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@55@02 Int) (unknown1@56@02 Int)) (!
  (and
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< unknown1@56@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@55@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))) unknown@55@02))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 8
(assert (not (forall ((unknown1@55@02 Int) (unknown11@56@02 Int) (unknown2@55@02 Int) (unknown12@56@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@56@02 V@5@02) (<= 0 unknown11@56@02))
          (< unknown1@55@02 V@5@02))
        (<= 0 unknown1@55@02))
      (and
        (and
          (and (< unknown12@56@02 V@5@02) (<= 0 unknown12@56@02))
          (< unknown2@55@02 V@5@02))
        (<= 0 unknown2@55@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown11@56@02))) unknown1@55@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown12@56@02))) unknown2@55@02)))
    (and (= unknown1@55@02 unknown2@55@02) (= unknown11@56@02 unknown12@56@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3562
;  :arith-add-rows          991
;  :arith-assert-diseq      54
;  :arith-assert-lower      1418
;  :arith-assert-upper      996
;  :arith-bound-prop        87
;  :arith-conflicts         137
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         268
;  :arith-grobner           85
;  :arith-max-min           1368
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  67
;  :arith-offset-eqs        259
;  :arith-pivots            473
;  :conflicts               272
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 344
;  :datatype-occurs-check   222
;  :datatype-splits         245
;  :decisions               1135
;  :del-clause              3969
;  :final-checks            248
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.33
;  :memory                  5.31
;  :minimized-lits          1
;  :mk-bool-var             6201
;  :mk-clause               3986
;  :num-allocs              228634
;  :num-checks              133
;  :propagations            1963
;  :quant-instantiations    1218
;  :rlimit-count            359292
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((unknown@55@02 Int) (unknown1@56@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@56@02 V@5@02) (<= 0 unknown1@56@02))
        (< unknown@55@02 V@5@02))
      (<= 0 unknown@55@02))
    (and
      (=
        (inv@57@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))) unknown@55@02))
        unknown@55@02)
      (=
        (inv@58@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))) unknown@55@02))
        unknown1@56@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))) unknown@55@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@58@02 r) V@5@02) (<= 0 (inv@58@02 r)))
        (< (inv@57@02 r) V@5@02))
      (<= 0 (inv@57@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) (inv@58@02 r)))) (inv@57@02 r))
      r))
  :pattern ((inv@57@02 r))
  :pattern ((inv@58@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@55@02 Int) (unknown1@56@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@56@02 V@5@02) (<= 0 unknown1@56@02))
        (< unknown@55@02 V@5@02))
      (<= 0 unknown@55@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))) unknown@55@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@56@02))) unknown@55@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@59@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@58@02 r) V@5@02) (<= 0 (inv@58@02 r)))
        (< (inv@57@02 r) V@5@02))
      (<= 0 (inv@57@02 r)))
    (=
      ($FVF.lookup_int (as sm@59@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@59@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))) r))
  :qid |qp.fvfValDef15|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@59@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef16|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@58@02 r) V@5@02) (<= 0 (inv@58@02 r)))
        (< (inv@57@02 r) V@5@02))
      (<= 0 (inv@57@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@59@02  $FVF<Int>) r) r))
  :pattern ((inv@57@02 r) (inv@58@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))))))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@8@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3604
;  :arith-add-rows          991
;  :arith-assert-diseq      54
;  :arith-assert-lower      1442
;  :arith-assert-upper      1012
;  :arith-bound-prop        87
;  :arith-conflicts         137
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         268
;  :arith-grobner           90
;  :arith-max-min           1409
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        259
;  :arith-pivots            473
;  :conflicts               272
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 353
;  :datatype-occurs-check   227
;  :datatype-splits         250
;  :decisions               1144
;  :del-clause              3969
;  :final-checks            252
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.34
;  :memory                  5.32
;  :minimized-lits          1
;  :mk-bool-var             6213
;  :mk-clause               3986
;  :num-allocs              230527
;  :num-checks              134
;  :propagations            1963
;  :quant-instantiations    1218
;  :rlimit-count            363666
;  :time                    0.00)
; [then-branch: 86 | exc@8@02 == Null | live]
; [else-branch: 86 | exc@8@02 != Null | dead]
(push) ; 8
; [then-branch: 86 | exc@8@02 == Null]
(declare-const unknown@60@02 Int)
(declare-const unknown1@61@02 Int)
(push) ; 9
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 10
; [then-branch: 87 | 0 <= unknown@60@02 | live]
; [else-branch: 87 | !(0 <= unknown@60@02) | live]
(push) ; 11
; [then-branch: 87 | 0 <= unknown@60@02]
(assert (<= 0 unknown@60@02))
; [eval] unknown < V
(push) ; 12
; [then-branch: 88 | unknown@60@02 < V@5@02 | live]
; [else-branch: 88 | !(unknown@60@02 < V@5@02) | live]
(push) ; 13
; [then-branch: 88 | unknown@60@02 < V@5@02]
(assert (< unknown@60@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 14
; [then-branch: 89 | 0 <= unknown1@61@02 | live]
; [else-branch: 89 | !(0 <= unknown1@61@02) | live]
(push) ; 15
; [then-branch: 89 | 0 <= unknown1@61@02]
(assert (<= 0 unknown1@61@02))
; [eval] unknown1 < V
(pop) ; 15
(push) ; 15
; [else-branch: 89 | !(0 <= unknown1@61@02)]
(assert (not (<= 0 unknown1@61@02)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 88 | !(unknown@60@02 < V@5@02)]
(assert (not (< unknown@60@02 V@5@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 87 | !(0 <= unknown@60@02)]
(assert (not (<= 0 unknown@60@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@61@02 V@5@02) (<= 0 unknown1@61@02))
    (< unknown@60@02 V@5@02))
  (<= 0 unknown@60@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 11
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3604
;  :arith-add-rows          991
;  :arith-assert-diseq      54
;  :arith-assert-lower      1448
;  :arith-assert-upper      1012
;  :arith-bound-prop        87
;  :arith-conflicts         137
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         268
;  :arith-grobner           90
;  :arith-max-min           1409
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        259
;  :arith-pivots            475
;  :conflicts               272
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 353
;  :datatype-occurs-check   227
;  :datatype-splits         250
;  :decisions               1144
;  :del-clause              3969
;  :final-checks            252
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.34
;  :memory                  5.32
;  :minimized-lits          1
;  :mk-bool-var             6219
;  :mk-clause               3986
;  :num-allocs              230797
;  :num-checks              135
;  :propagations            1963
;  :quant-instantiations    1218
;  :rlimit-count            364132)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (< unknown1@61@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3604
;  :arith-add-rows          991
;  :arith-assert-diseq      54
;  :arith-assert-lower      1448
;  :arith-assert-upper      1012
;  :arith-bound-prop        87
;  :arith-conflicts         137
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         268
;  :arith-grobner           90
;  :arith-max-min           1409
;  :arith-nonlinear-bounds  161
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        259
;  :arith-pivots            475
;  :conflicts               272
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 353
;  :datatype-occurs-check   227
;  :datatype-splits         250
;  :decisions               1144
;  :del-clause              3969
;  :final-checks            252
;  :interface-eqs           26
;  :max-generation          5
;  :max-memory              5.34
;  :memory                  5.32
;  :minimized-lits          1
;  :mk-bool-var             6219
;  :mk-clause               3986
;  :num-allocs              230818
;  :num-checks              136
;  :propagations            1963
;  :quant-instantiations    1218
;  :rlimit-count            364163)
(assert (< unknown1@61@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 10
; Joined path conditions
(assert (< unknown1@61@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02)))
(push) ; 10
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3839
;  :arith-add-rows          1023
;  :arith-assert-diseq      55
;  :arith-assert-lower      1492
;  :arith-assert-upper      1051
;  :arith-bound-prop        90
;  :arith-conflicts         142
;  :arith-eq-adapter        314
;  :arith-fixed-eqs         287
;  :arith-grobner           90
;  :arith-max-min           1439
;  :arith-nonlinear-bounds  168
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        282
;  :arith-pivots            493
;  :conflicts               286
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 377
;  :datatype-occurs-check   237
;  :datatype-splits         276
;  :decisions               1229
;  :del-clause              4210
;  :final-checks            263
;  :interface-eqs           30
;  :max-generation          5
;  :max-memory              5.38
;  :memory                  5.36
;  :minimized-lits          2
;  :mk-bool-var             6662
;  :mk-clause               4276
;  :num-allocs              232075
;  :num-checks              137
;  :propagations            2075
;  :quant-instantiations    1280
;  :rlimit-count            369623
;  :time                    0.00)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 11
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4015
;  :arith-add-rows          1038
;  :arith-assert-diseq      55
;  :arith-assert-lower      1515
;  :arith-assert-upper      1082
;  :arith-bound-prop        91
;  :arith-conflicts         146
;  :arith-eq-adapter        321
;  :arith-fixed-eqs         298
;  :arith-grobner           90
;  :arith-max-min           1469
;  :arith-nonlinear-bounds  175
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        297
;  :arith-pivots            498
;  :conflicts               299
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   247
;  :datatype-splits         302
;  :decisions               1292
;  :del-clause              4329
;  :final-checks            274
;  :interface-eqs           34
;  :max-generation          5
;  :max-memory              5.38
;  :memory                  5.36
;  :minimized-lits          2
;  :mk-bool-var             6901
;  :mk-clause               4395
;  :num-allocs              232634
;  :num-checks              138
;  :propagations            2129
;  :quant-instantiations    1293
;  :rlimit-count            371979
;  :time                    0.00)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))
    (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))
    (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (<
  unknown@60@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02)))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4213
;  :arith-add-rows          1059
;  :arith-assert-diseq      55
;  :arith-assert-lower      1543
;  :arith-assert-upper      1115
;  :arith-bound-prop        93
;  :arith-conflicts         150
;  :arith-eq-adapter        332
;  :arith-fixed-eqs         311
;  :arith-grobner           90
;  :arith-max-min           1499
;  :arith-nonlinear-bounds  182
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        312
;  :arith-pivots            507
;  :conflicts               311
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 425
;  :datatype-occurs-check   257
;  :datatype-splits         328
;  :decisions               1353
;  :del-clause              4450
;  :final-checks            285
;  :interface-eqs           38
;  :max-generation          5
;  :max-memory              5.38
;  :memory                  5.36
;  :minimized-lits          2
;  :mk-bool-var             7163
;  :mk-clause               4516
;  :num-allocs              233328
;  :num-checks              139
;  :propagations            2191
;  :quant-instantiations    1315
;  :rlimit-count            374787
;  :time                    0.00)
(assert (<
  unknown@60@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))))))
(pop) ; 10
; Joined path conditions
(assert (<
  unknown@60@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))))))
(declare-const $k@62@02 $Perm)
(assert ($Perm.isReadVar $k@62@02 $Perm.Write))
(pop) ; 9
(declare-fun inv@63@02 ($Ref) Int)
(declare-fun inv@64@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert ($Perm.isReadVar $k@62@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@60@02 Int) (unknown1@61@02 Int)) (!
  (and
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< unknown1@61@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@60@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02))
  :qid |int-aux|)))
(push) ; 9
(assert (not (forall ((unknown@60@02 Int) (unknown1@61@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@61@02 V@5@02) (<= 0 unknown1@61@02))
        (< unknown@60@02 V@5@02))
      (<= 0 unknown@60@02))
    (or (= $k@62@02 $Perm.No) (< $Perm.No $k@62@02)))
  
  ))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4213
;  :arith-add-rows          1059
;  :arith-assert-diseq      56
;  :arith-assert-lower      1545
;  :arith-assert-upper      1116
;  :arith-bound-prop        93
;  :arith-conflicts         150
;  :arith-eq-adapter        333
;  :arith-fixed-eqs         311
;  :arith-grobner           90
;  :arith-max-min           1499
;  :arith-nonlinear-bounds  182
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        312
;  :arith-pivots            509
;  :conflicts               312
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 425
;  :datatype-occurs-check   257
;  :datatype-splits         328
;  :decisions               1353
;  :del-clause              4499
;  :final-checks            285
;  :interface-eqs           38
;  :max-generation          5
;  :max-memory              5.38
;  :memory                  5.36
;  :minimized-lits          2
;  :mk-bool-var             7172
;  :mk-clause               4518
;  :num-allocs              233870
;  :num-checks              140
;  :propagations            2192
;  :quant-instantiations    1315
;  :rlimit-count            375708)
; Check receiver injectivity
(push) ; 9
(assert (not (forall ((unknown1@60@02 Int) (unknown11@61@02 Int) (unknown2@60@02 Int) (unknown12@61@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and
            (and (< unknown11@61@02 V@5@02) (<= 0 unknown11@61@02))
            (< unknown1@60@02 V@5@02))
          (<= 0 unknown1@60@02))
        (< $Perm.No $k@62@02))
      (and
        (and
          (and
            (and (< unknown12@61@02 V@5@02) (<= 0 unknown12@61@02))
            (< unknown2@60@02 V@5@02))
          (<= 0 unknown2@60@02))
        (< $Perm.No $k@62@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown11@61@02))) unknown1@60@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown12@61@02))) unknown2@60@02)))
    (and (= unknown1@60@02 unknown2@60@02) (= unknown11@61@02 unknown12@61@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4515
;  :arith-add-rows          1198
;  :arith-assert-diseq      58
;  :arith-assert-lower      1602
;  :arith-assert-upper      1166
;  :arith-bound-prop        105
;  :arith-conflicts         153
;  :arith-eq-adapter        348
;  :arith-fixed-eqs         337
;  :arith-grobner           90
;  :arith-max-min           1542
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  71
;  :arith-offset-eqs        332
;  :arith-pivots            545
;  :conflicts               324
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   273
;  :datatype-splits         363
;  :decisions               1434
;  :del-clause              4817
;  :final-checks            298
;  :interface-eqs           42
;  :max-generation          5
;  :max-memory              5.54
;  :memory                  5.52
;  :minimized-lits          2
;  :mk-bool-var             7710
;  :mk-clause               4836
;  :num-allocs              236036
;  :num-checks              141
;  :propagations            2347
;  :quant-instantiations    1431
;  :rlimit-count            385959
;  :time                    0.01)
; Definitional axioms for inverse functions
(assert (forall ((unknown@60@02 Int) (unknown1@61@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@61@02 V@5@02) (<= 0 unknown1@61@02))
          (< unknown@60@02 V@5@02))
        (<= 0 unknown@60@02))
      (< $Perm.No $k@62@02))
    (and
      (=
        (inv@63@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02))
        unknown@60@02)
      (=
        (inv@64@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02))
        unknown1@61@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and
          (and (< (inv@64@02 r) V@5@02) (<= 0 (inv@64@02 r)))
          (< (inv@63@02 r) V@5@02))
        (<= 0 (inv@63@02 r)))
      (< $Perm.No $k@62@02))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) (inv@64@02 r)))) (inv@63@02 r))
      r))
  :pattern ((inv@63@02 r))
  :pattern ((inv@64@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((unknown@60@02 Int) (unknown1@61@02 Int)) (!
  (<= $Perm.No $k@62@02)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02))
  :qid |int-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((unknown@60@02 Int) (unknown1@61@02 Int)) (!
  (<= $k@62@02 $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02))
  :qid |int-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((unknown@60@02 Int) (unknown1@61@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@61@02 V@5@02) (<= 0 unknown1@61@02))
          (< unknown@60@02 V@5@02))
        (<= 0 unknown@60@02))
      (< $Perm.No $k@62@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@61@02))) unknown@60@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@65@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and
        (and
          (and (< (inv@64@02 r) V@5@02) (<= 0 (inv@64@02 r)))
          (< (inv@63@02 r) V@5@02))
        (<= 0 (inv@63@02 r)))
      (< $Perm.No $k@62@02)
      false)
    (=
      ($FVF.lookup_int (as sm@65@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@65@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))))) r))
  :qid |qp.fvfValDef17|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@58@02 r) V@5@02) (<= 0 (inv@58@02 r)))
        (< (inv@57@02 r) V@5@02))
      (<= 0 (inv@57@02 r)))
    (=
      ($FVF.lookup_int (as sm@65@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@65@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))) r))
  :qid |qp.fvfValDef18|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02))))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@65@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef19|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@64@02 r) V@5@02) (<= 0 (inv@64@02 r)))
        (< (inv@63@02 r) V@5@02))
      (<= 0 (inv@63@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) r) r))
  :pattern ((inv@63@02 r) (inv@64@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@02)))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: 0 <= unknown && unknown < V ==> (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int))
; [eval] exc == null
(push) ; 9
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= exc@8@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4552
;  :arith-add-rows          1200
;  :arith-assert-diseq      58
;  :arith-assert-lower      1626
;  :arith-assert-upper      1183
;  :arith-bound-prop        105
;  :arith-conflicts         153
;  :arith-eq-adapter        348
;  :arith-fixed-eqs         337
;  :arith-grobner           95
;  :arith-max-min           1583
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        332
;  :arith-pivots            546
;  :conflicts               324
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 466
;  :datatype-occurs-check   278
;  :datatype-splits         367
;  :decisions               1442
;  :del-clause              4817
;  :final-checks            302
;  :interface-eqs           42
;  :max-generation          5
;  :max-memory              5.54
;  :memory                  5.52
;  :minimized-lits          2
;  :mk-bool-var             7723
;  :mk-clause               4836
;  :num-allocs              238314
;  :num-checks              142
;  :propagations            2347
;  :quant-instantiations    1431
;  :rlimit-count            391754
;  :time                    0.00)
; [then-branch: 90 | exc@8@02 == Null | live]
; [else-branch: 90 | exc@8@02 != Null | dead]
(push) ; 10
; [then-branch: 90 | exc@8@02 == Null]
; [eval] (forall unknown: Int :: 0 <= unknown && unknown < V ==> (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int))
(declare-const unknown@66@02 Int)
(push) ; 11
; [eval] 0 <= unknown && unknown < V ==> (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int)
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 12
; [then-branch: 91 | 0 <= unknown@66@02 | live]
; [else-branch: 91 | !(0 <= unknown@66@02) | live]
(push) ; 13
; [then-branch: 91 | 0 <= unknown@66@02]
(assert (<= 0 unknown@66@02))
; [eval] unknown < V
(pop) ; 13
(push) ; 13
; [else-branch: 91 | !(0 <= unknown@66@02)]
(assert (not (<= 0 unknown@66@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(push) ; 12
; [then-branch: 92 | unknown@66@02 < V@5@02 && 0 <= unknown@66@02 | live]
; [else-branch: 92 | !(unknown@66@02 < V@5@02 && 0 <= unknown@66@02) | live]
(push) ; 13
; [then-branch: 92 | unknown@66@02 < V@5@02 && 0 <= unknown@66@02]
(assert (and (< unknown@66@02 V@5@02) (<= 0 unknown@66@02)))
; [eval] (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int)
(declare-const unknown1@67@02 Int)
(push) ; 14
; [eval] 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int
; [eval] 0 <= unknown1 && unknown1 < V
; [eval] 0 <= unknown1
(push) ; 15
; [then-branch: 93 | 0 <= unknown1@67@02 | live]
; [else-branch: 93 | !(0 <= unknown1@67@02) | live]
(push) ; 16
; [then-branch: 93 | 0 <= unknown1@67@02]
(assert (<= 0 unknown1@67@02))
; [eval] unknown1 < V
(pop) ; 16
(push) ; 16
; [else-branch: 93 | !(0 <= unknown1@67@02)]
(assert (not (<= 0 unknown1@67@02)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(push) ; 15
; [then-branch: 94 | unknown1@67@02 < V@5@02 && 0 <= unknown1@67@02 | live]
; [else-branch: 94 | !(unknown1@67@02 < V@5@02 && 0 <= unknown1@67@02) | live]
(push) ; 16
; [then-branch: 94 | unknown1@67@02 < V@5@02 && 0 <= unknown1@67@02]
(assert (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 18
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4552
;  :arith-add-rows          1200
;  :arith-assert-diseq      58
;  :arith-assert-lower      1630
;  :arith-assert-upper      1183
;  :arith-bound-prop        105
;  :arith-conflicts         153
;  :arith-eq-adapter        348
;  :arith-fixed-eqs         337
;  :arith-grobner           95
;  :arith-max-min           1583
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        332
;  :arith-pivots            547
;  :conflicts               324
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 466
;  :datatype-occurs-check   278
;  :datatype-splits         367
;  :decisions               1442
;  :del-clause              4817
;  :final-checks            302
;  :interface-eqs           42
;  :max-generation          5
;  :max-memory              5.54
;  :memory                  5.53
;  :minimized-lits          2
;  :mk-bool-var             7727
;  :mk-clause               4836
;  :num-allocs              238495
;  :num-checks              143
;  :propagations            2347
;  :quant-instantiations    1431
;  :rlimit-count            392099)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4552
;  :arith-add-rows          1200
;  :arith-assert-diseq      58
;  :arith-assert-lower      1630
;  :arith-assert-upper      1183
;  :arith-bound-prop        105
;  :arith-conflicts         153
;  :arith-eq-adapter        348
;  :arith-fixed-eqs         337
;  :arith-grobner           95
;  :arith-max-min           1583
;  :arith-nonlinear-bounds  193
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        332
;  :arith-pivots            547
;  :conflicts               324
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 466
;  :datatype-occurs-check   278
;  :datatype-splits         367
;  :decisions               1442
;  :del-clause              4817
;  :final-checks            302
;  :interface-eqs           42
;  :max-generation          5
;  :max-memory              5.54
;  :memory                  5.53
;  :minimized-lits          2
;  :mk-bool-var             7727
;  :mk-clause               4836
;  :num-allocs              238516
;  :num-checks              144
;  :propagations            2347
;  :quant-instantiations    1431
;  :rlimit-count            392130)
(assert (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 17
; Joined path conditions
(assert (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4914
;  :arith-add-rows          1244
;  :arith-assert-diseq      59
;  :arith-assert-lower      1706
;  :arith-assert-upper      1248
;  :arith-bound-prop        110
;  :arith-conflicts         162
;  :arith-eq-adapter        371
;  :arith-fixed-eqs         359
;  :arith-grobner           95
;  :arith-max-min           1647
;  :arith-nonlinear-bounds  207
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        352
;  :arith-pivots            577
;  :conflicts               342
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   302
;  :datatype-splits         407
;  :decisions               1553
;  :del-clause              5076
;  :final-checks            319
;  :interface-eqs           47
;  :max-generation          5
;  :max-memory              5.54
;  :memory                  5.52
;  :minimized-lits          3
;  :mk-bool-var             8242
;  :mk-clause               5166
;  :num-allocs              240141
;  :num-checks              145
;  :propagations            2518
;  :quant-instantiations    1515
;  :rlimit-count            399224
;  :time                    0.00)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 18
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4914
;  :arith-add-rows          1244
;  :arith-assert-diseq      59
;  :arith-assert-lower      1706
;  :arith-assert-upper      1248
;  :arith-bound-prop        110
;  :arith-conflicts         162
;  :arith-eq-adapter        371
;  :arith-fixed-eqs         359
;  :arith-grobner           95
;  :arith-max-min           1647
;  :arith-nonlinear-bounds  207
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        352
;  :arith-pivots            577
;  :conflicts               343
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   302
;  :datatype-splits         407
;  :decisions               1553
;  :del-clause              5076
;  :final-checks            319
;  :interface-eqs           47
;  :max-generation          5
;  :max-memory              5.54
;  :memory                  5.52
;  :minimized-lits          3
;  :mk-bool-var             8242
;  :mk-clause               5166
;  :num-allocs              240232
;  :num-checks              146
;  :propagations            2518
;  :quant-instantiations    1515
;  :rlimit-count            399319)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
    (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
    (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (<
  unknown@66@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)))))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4920
;  :arith-add-rows          1247
;  :arith-assert-diseq      59
;  :arith-assert-lower      1708
;  :arith-assert-upper      1250
;  :arith-bound-prop        110
;  :arith-conflicts         163
;  :arith-eq-adapter        372
;  :arith-fixed-eqs         360
;  :arith-grobner           95
;  :arith-max-min           1647
;  :arith-nonlinear-bounds  207
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        352
;  :arith-pivots            579
;  :conflicts               344
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 506
;  :datatype-occurs-check   302
;  :datatype-splits         407
;  :decisions               1553
;  :del-clause              5080
;  :final-checks            319
;  :interface-eqs           47
;  :max-generation          5
;  :max-memory              5.54
;  :memory                  5.52
;  :minimized-lits          3
;  :mk-bool-var             8253
;  :mk-clause               5170
;  :num-allocs              240419
;  :num-checks              147
;  :propagations            2520
;  :quant-instantiations    1522
;  :rlimit-count            399768)
(assert (<
  unknown@66@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))))))
(pop) ; 17
; Joined path conditions
(assert (<
  unknown@66@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (and
          (and
            (<
              (inv@64@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
              V@5@02)
            (<=
              0
              (inv@64@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))))
          (<
            (inv@63@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
            V@5@02))
        (<=
          0
          (inv@63@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))))
      $k@62@02
      $Perm.No)
    (ite
      (and
        (and
          (and
            (<
              (inv@58@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
              V@5@02)
            (<=
              0
              (inv@58@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))))
          (<
            (inv@57@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
            V@5@02))
        (<=
          0
          (inv@57@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))))
      $Perm.Write
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5039
;  :arith-add-rows          1276
;  :arith-assert-diseq      61
;  :arith-assert-lower      1726
;  :arith-assert-upper      1265
;  :arith-bound-prop        116
;  :arith-conflicts         166
;  :arith-eq-adapter        385
;  :arith-fixed-eqs         367
;  :arith-grobner           95
;  :arith-max-min           1647
;  :arith-nonlinear-bounds  207
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        363
;  :arith-pivots            588
;  :conflicts               365
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   302
;  :datatype-splits         407
;  :decisions               1583
;  :del-clause              5220
;  :final-checks            319
;  :interface-eqs           47
;  :max-generation          5
;  :max-memory              5.55
;  :memory                  5.54
;  :minimized-lits          3
;  :mk-bool-var             8486
;  :mk-clause               5340
;  :num-allocs              241335
;  :num-checks              148
;  :propagations            2594
;  :quant-instantiations    1558
;  :rlimit-count            403071
;  :time                    0.00)
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 18
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5039
;  :arith-add-rows          1276
;  :arith-assert-diseq      61
;  :arith-assert-lower      1726
;  :arith-assert-upper      1265
;  :arith-bound-prop        116
;  :arith-conflicts         166
;  :arith-eq-adapter        385
;  :arith-fixed-eqs         367
;  :arith-grobner           95
;  :arith-max-min           1647
;  :arith-nonlinear-bounds  207
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        363
;  :arith-pivots            588
;  :conflicts               365
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   302
;  :datatype-splits         407
;  :decisions               1583
;  :del-clause              5220
;  :final-checks            319
;  :interface-eqs           47
;  :max-generation          5
;  :max-memory              5.55
;  :memory                  5.54
;  :minimized-lits          3
;  :mk-bool-var             8486
;  :mk-clause               5340
;  :num-allocs              241358
;  :num-checks              149
;  :propagations            2594
;  :quant-instantiations    1558
;  :rlimit-count            403087)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5039
;  :arith-add-rows          1276
;  :arith-assert-diseq      61
;  :arith-assert-lower      1726
;  :arith-assert-upper      1265
;  :arith-bound-prop        116
;  :arith-conflicts         166
;  :arith-eq-adapter        385
;  :arith-fixed-eqs         367
;  :arith-grobner           95
;  :arith-max-min           1647
;  :arith-nonlinear-bounds  207
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        363
;  :arith-pivots            588
;  :conflicts               365
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   302
;  :datatype-splits         407
;  :decisions               1583
;  :del-clause              5220
;  :final-checks            319
;  :interface-eqs           47
;  :max-generation          5
;  :max-memory              5.55
;  :memory                  5.54
;  :minimized-lits          3
;  :mk-bool-var             8486
;  :mk-clause               5340
;  :num-allocs              241379
;  :num-checks              150
;  :propagations            2594
;  :quant-instantiations    1558
;  :rlimit-count            403118)
(assert (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 17
; Joined path conditions
(assert (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (<
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
          V@5@02)
        (<=
          0
          (inv@49@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@48@02)
      $Perm.No)
    (ite
      (and
        (<
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
          V@5@02)
        (<=
          0
          (inv@41@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))))
      (* (scale $Snap.unit (* (to_real (* V@5@02 V@5@02)) $Perm.Write)) $k@40@02)
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 17
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5486
;  :arith-add-rows          1574
;  :arith-assert-diseq      61
;  :arith-assert-lower      1818
;  :arith-assert-upper      1367
;  :arith-bound-prop        128
;  :arith-conflicts         176
;  :arith-eq-adapter        409
;  :arith-fixed-eqs         402
;  :arith-grobner           95
;  :arith-max-min           1725
;  :arith-nonlinear-bounds  224
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        397
;  :arith-pivots            647
;  :arith-pseudo-nonlinear  4
;  :conflicts               386
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 550
;  :datatype-occurs-check   322
;  :datatype-splits         444
;  :decisions               1793
;  :del-clause              5831
;  :final-checks            336
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.61
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             9312
;  :mk-clause               5977
;  :num-allocs              243812
;  :num-checks              151
;  :propagations            2895
;  :quant-instantiations    1698
;  :rlimit-count            417174
;  :time                    0.01)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 18
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5687
;  :arith-add-rows          1660
;  :arith-assert-diseq      61
;  :arith-assert-lower      1855
;  :arith-assert-upper      1418
;  :arith-bound-prop        133
;  :arith-conflicts         184
;  :arith-eq-adapter        413
;  :arith-fixed-eqs         413
;  :arith-grobner           95
;  :arith-max-min           1770
;  :arith-nonlinear-bounds  235
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        407
;  :arith-pivots            657
;  :arith-pseudo-nonlinear  4
;  :conflicts               403
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 559
;  :datatype-occurs-check   326
;  :datatype-splits         452
;  :decisions               1941
;  :del-clause              6317
;  :final-checks            341
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.61
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             9817
;  :mk-clause               6463
;  :num-allocs              244526
;  :num-checks              152
;  :propagations            3084
;  :quant-instantiations    1779
;  :rlimit-count            423775
;  :time                    0.00)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
    (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
    (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (<
  unknown@66@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)))))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5920
;  :arith-add-rows          1728
;  :arith-assert-diseq      61
;  :arith-assert-lower      1899
;  :arith-assert-upper      1469
;  :arith-bound-prop        139
;  :arith-conflicts         192
;  :arith-eq-adapter        422
;  :arith-fixed-eqs         428
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        419
;  :arith-pivots            670
;  :arith-pseudo-nonlinear  4
;  :conflicts               419
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 568
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2074
;  :del-clause              6740
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.61
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10286
;  :mk-clause               6886
;  :num-allocs              245347
;  :num-checks              153
;  :propagations            3272
;  :quant-instantiations    1856
;  :rlimit-count            430218
;  :time                    0.00)
(assert (<
  unknown@66@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))))))
(pop) ; 17
; Joined path conditions
(assert (<
  unknown@66@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (and
          (and
            (<
              (inv@64@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))
              V@5@02)
            (<=
              0
              (inv@64@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
          (<
            (inv@63@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))
            V@5@02))
        (<=
          0
          (inv@63@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
      $k@62@02
      $Perm.No)
    (ite
      (and
        (and
          (and
            (<
              (inv@58@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))
              V@5@02)
            (<=
              0
              (inv@58@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
          (<
            (inv@57@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))
            V@5@02))
        (<=
          0
          (inv@57@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
      $Perm.Write
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6029
;  :arith-add-rows          1748
;  :arith-assert-diseq      64
;  :arith-assert-lower      1919
;  :arith-assert-upper      1485
;  :arith-bound-prop        147
;  :arith-conflicts         195
;  :arith-eq-adapter        434
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            681
;  :arith-pseudo-nonlinear  4
;  :conflicts               440
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              6851
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.61
;  :minimized-lits          3
;  :mk-bool-var             10477
;  :mk-clause               7014
;  :num-allocs              246108
;  :num-checks              154
;  :propagations            3333
;  :quant-instantiations    1885
;  :rlimit-count            433249
;  :time                    0.00)
(pop) ; 16
(push) ; 16
; [else-branch: 94 | !(unknown1@67@02 < V@5@02 && 0 <= unknown1@67@02)]
(assert (not (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02))))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (implies
  (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02))
  (and
    (< unknown1@67@02 V@5@02)
    (<= 0 unknown1@67@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@66@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)))))
    ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@66@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)))))
    ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)))))
; Joined path conditions
(pop) ; 14
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown1@67@02 Int)) (!
  (implies
    (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02))
    (and
      (< unknown1@67@02 V@5@02)
      (<= 0 unknown1@67@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@66@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@66@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
  :qid |prog.l<no position>-aux|)))
(assert (forall ((unknown1@67@02 Int)) (!
  (implies
    (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02))
    (and
      (< unknown1@67@02 V@5@02)
      (<= 0 unknown1@67@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@66@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@66@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 13
(push) ; 13
; [else-branch: 92 | !(unknown@66@02 < V@5@02 && 0 <= unknown@66@02)]
(assert (not (and (< unknown@66@02 V@5@02) (<= 0 unknown@66@02))))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (implies
  (and (< unknown@66@02 V@5@02) (<= 0 unknown@66@02))
  (and
    (< unknown@66@02 V@5@02)
    (<= 0 unknown@66@02)
    (forall ((unknown1@67@02 Int)) (!
      (implies
        (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02))
        (and
          (< unknown1@67@02 V@5@02)
          (<= 0 unknown1@67@02)
          (not (= target@7@02 (as None<option<array>>  option<array>)))
          (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@66@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
          (not (= source@6@02 (as None<option<array>>  option<array>)))
          (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@66@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
      :qid |prog.l<no position>-aux|))
    (forall ((unknown1@67@02 Int)) (!
      (implies
        (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02))
        (and
          (< unknown1@67@02 V@5@02)
          (<= 0 unknown1@67@02)
          (not (= target@7@02 (as None<option<array>>  option<array>)))
          (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@66@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
          (not (= source@6@02 (as None<option<array>>  option<array>)))
          (< unknown1@67@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@66@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))
      :qid |prog.l<no position>-aux|)))))
; Joined path conditions
(pop) ; 11
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (= exc@8@02 $Ref.null)
  (forall ((unknown@66@02 Int)) (!
    (implies
      (and (< unknown@66@02 V@5@02) (<= 0 unknown@66@02))
      (forall ((unknown1@67@02 Int)) (!
        (implies
          (and (< unknown1@67@02 V@5@02) (<= 0 unknown1@67@02))
          (=
            ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
            ($FVF.lookup_int (as sm@65@02  $FVF<Int>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@67@02))) unknown@66@02))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@50@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@67@02))) unknown@66@02))
        :qid |prog.l<no position>|)))
    
    :qid |prog.l<no position>|))))
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
; [else-branch: 2 | !(0 < V@5@02)]
(assert (not (< 0 V@5@02)))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@10@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 3
; [then-branch: 95 | 0 < V@5@02 | dead]
; [else-branch: 95 | !(0 < V@5@02) | live]
(push) ; 4
; [else-branch: 95 | !(0 < V@5@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 3
; [then-branch: 96 | 0 < V@5@02 | dead]
; [else-branch: 96 | !(0 < V@5@02) | live]
(push) ; 4
; [else-branch: 96 | !(0 < V@5@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 3
; [then-branch: 97 | 0 < V@5@02 | dead]
; [else-branch: 97 | !(0 < V@5@02) | live]
(push) ; 4
; [else-branch: 97 | !(0 < V@5@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
  $Snap.unit))
; [eval] 0 < V ==> target != (None(): option[array])
; [eval] 0 < V
(push) ; 3
; [then-branch: 98 | 0 < V@5@02 | dead]
; [else-branch: 98 | !(0 < V@5@02) | live]
(push) ; 4
; [else-branch: 98 | !(0 < V@5@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
  $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(target)) == V
; [eval] 0 < V
(push) ; 3
; [then-branch: 99 | 0 < V@5@02 | dead]
; [else-branch: 99 | !(0 < V@5@02) | live]
(push) ; 4
; [else-branch: 99 | !(0 < V@5@02)]
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
; [eval] 0 < V
; [then-branch: 100 | 0 < V@5@02 | dead]
; [else-branch: 100 | !(0 < V@5@02) | live]
(push) ; 3
; [else-branch: 100 | !(0 < V@5@02)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] 0 < V
(push) ; 4
; [then-branch: 101 | 0 < V@5@02 | dead]
; [else-branch: 101 | !(0 < V@5@02) | live]
(push) ; 5
; [else-branch: 101 | !(0 < V@5@02)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] 0 < V
(push) ; 4
; [then-branch: 102 | 0 < V@5@02 | dead]
; [else-branch: 102 | !(0 < V@5@02) | live]
(push) ; 5
; [else-branch: 102 | !(0 < V@5@02)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
  $Snap.unit))
; [eval] 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] 0 < V
(push) ; 4
; [then-branch: 103 | 0 < V@5@02 | dead]
; [else-branch: 103 | !(0 < V@5@02) | live]
(push) ; 5
; [else-branch: 103 | !(0 < V@5@02)]
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02))))))))))))))))
(declare-const unknown@68@02 Int)
(declare-const unknown1@69@02 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 104 | 0 <= unknown@68@02 | live]
; [else-branch: 104 | !(0 <= unknown@68@02) | live]
(push) ; 6
; [then-branch: 104 | 0 <= unknown@68@02]
(assert (<= 0 unknown@68@02))
; [eval] unknown < V
(push) ; 7
; [then-branch: 105 | unknown@68@02 < V@5@02 | live]
; [else-branch: 105 | !(unknown@68@02 < V@5@02) | live]
(push) ; 8
; [then-branch: 105 | unknown@68@02 < V@5@02]
(assert (< unknown@68@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 106 | 0 <= unknown1@69@02 | live]
; [else-branch: 106 | !(0 <= unknown1@69@02) | live]
(push) ; 10
; [then-branch: 106 | 0 <= unknown1@69@02]
(assert (<= 0 unknown1@69@02))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 106 | !(0 <= unknown1@69@02)]
(assert (not (<= 0 unknown1@69@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 105 | !(unknown@68@02 < V@5@02)]
(assert (not (< unknown@68@02 V@5@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 104 | !(0 <= unknown@68@02)]
(assert (not (<= 0 unknown@68@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@69@02 V@5@02) (<= 0 unknown1@69@02))
    (< unknown@68@02 V@5@02))
  (<= 0 unknown@68@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6089
;  :arith-add-rows          1763
;  :arith-assert-diseq      64
;  :arith-assert-lower      1922
;  :arith-assert-upper      1489
;  :arith-bound-prop        147
;  :arith-conflicts         197
;  :arith-eq-adapter        434
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            702
;  :arith-pseudo-nonlinear  4
;  :conflicts               443
;  :datatype-accessor-ax    160
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7008
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10504
;  :mk-clause               7014
;  :num-allocs              247913
;  :num-checks              155
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            436604)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@69@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6089
;  :arith-add-rows          1764
;  :arith-assert-diseq      64
;  :arith-assert-lower      1922
;  :arith-assert-upper      1489
;  :arith-bound-prop        147
;  :arith-conflicts         197
;  :arith-eq-adapter        434
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            702
;  :arith-pseudo-nonlinear  4
;  :conflicts               444
;  :datatype-accessor-ax    160
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7008
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10506
;  :mk-clause               7014
;  :num-allocs              248065
;  :num-checks              156
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            436758)
(assert (< unknown1@69@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@69@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(declare-const sm@70@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@71@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@71@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@71@02  $FPM) r))
  :qid |qp.resPrmSumDef21|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@71@02  $FPM) r))
  :qid |qp.resTrgDef22|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02)))
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@71@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6089
;  :arith-add-rows          1765
;  :arith-assert-diseq      64
;  :arith-assert-lower      1922
;  :arith-assert-upper      1489
;  :arith-bound-prop        147
;  :arith-conflicts         197
;  :arith-eq-adapter        434
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            702
;  :arith-pseudo-nonlinear  4
;  :conflicts               445
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7008
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10511
;  :mk-clause               7014
;  :num-allocs              248467
;  :num-checks              157
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            437212)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6089
;  :arith-add-rows          1765
;  :arith-assert-diseq      64
;  :arith-assert-lower      1922
;  :arith-assert-upper      1489
;  :arith-bound-prop        147
;  :arith-conflicts         197
;  :arith-eq-adapter        434
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            702
;  :arith-pseudo-nonlinear  4
;  :conflicts               446
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7008
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10512
;  :mk-clause               7014
;  :num-allocs              248557
;  :num-checks              158
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            437301)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@68@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6089
;  :arith-add-rows          1765
;  :arith-assert-diseq      64
;  :arith-assert-lower      1922
;  :arith-assert-upper      1489
;  :arith-bound-prop        147
;  :arith-conflicts         197
;  :arith-eq-adapter        434
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            702
;  :arith-pseudo-nonlinear  4
;  :conflicts               447
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7008
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10514
;  :mk-clause               7014
;  :num-allocs              248710
;  :num-checks              159
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            437554)
(assert (<
  unknown@68@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@68@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))))))
(pop) ; 4
(declare-fun inv@72@02 ($Ref) Int)
(declare-fun inv@73@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@71@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@71@02  $FPM) r))
  :qid |qp.resPrmSumDef21|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@71@02  $FPM) r))
  :qid |qp.resTrgDef22|)))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@68@02 Int) (unknown1@69@02 Int)) (!
  (and
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< unknown1@69@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@68@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))) unknown@68@02))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@68@02 Int) (unknown11@69@02 Int) (unknown2@68@02 Int) (unknown12@69@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@69@02 V@5@02) (<= 0 unknown11@69@02))
          (< unknown1@68@02 V@5@02))
        (<= 0 unknown1@68@02))
      (and
        (and
          (and (< unknown12@69@02 V@5@02) (<= 0 unknown12@69@02))
          (< unknown2@68@02 V@5@02))
        (<= 0 unknown2@68@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown11@69@02))) unknown1@68@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown12@69@02))) unknown2@68@02)))
    (and (= unknown1@68@02 unknown2@68@02) (= unknown11@69@02 unknown12@69@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6093
;  :arith-add-rows          1765
;  :arith-assert-diseq      64
;  :arith-assert-lower      1930
;  :arith-assert-upper      1489
;  :arith-bound-prop        147
;  :arith-conflicts         198
;  :arith-eq-adapter        436
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            703
;  :arith-pseudo-nonlinear  4
;  :conflicts               448
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7017
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10533
;  :mk-clause               7023
;  :num-allocs              249539
;  :num-checks              160
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            439045)
; Definitional axioms for inverse functions
(assert (forall ((unknown@68@02 Int) (unknown1@69@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@69@02 V@5@02) (<= 0 unknown1@69@02))
        (< unknown@68@02 V@5@02))
      (<= 0 unknown@68@02))
    (and
      (=
        (inv@72@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))) unknown@68@02))
        unknown@68@02)
      (=
        (inv@73@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))) unknown@68@02))
        unknown1@69@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))) unknown@68@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@73@02 r) V@5@02) (<= 0 (inv@73@02 r)))
        (< (inv@72@02 r) V@5@02))
      (<= 0 (inv@72@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) (inv@73@02 r)))) (inv@72@02 r))
      r))
  :pattern ((inv@72@02 r))
  :pattern ((inv@73@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@68@02 Int) (unknown1@69@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@69@02 V@5@02) (<= 0 unknown1@69@02))
        (< unknown@68@02 V@5@02))
      (<= 0 unknown@68@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))) unknown@68@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@70@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@69@02))) unknown@68@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@74@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@73@02 r) V@5@02) (<= 0 (inv@73@02 r)))
        (< (inv@72@02 r) V@5@02))
      (<= 0 (inv@72@02 r)))
    (=
      ($FVF.lookup_int (as sm@74@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@74@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r))
  :qid |qp.fvfValDef23|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@74@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef24|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@73@02 r) V@5@02) (<= 0 (inv@73@02 r)))
        (< (inv@72@02 r) V@5@02))
      (<= 0 (inv@72@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@74@02  $FVF<Int>) r) r))
  :pattern ((inv@72@02 r) (inv@73@02 r))
  )))
(declare-const unknown@75@02 Int)
(declare-const unknown1@76@02 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 107 | 0 <= unknown@75@02 | live]
; [else-branch: 107 | !(0 <= unknown@75@02) | live]
(push) ; 6
; [then-branch: 107 | 0 <= unknown@75@02]
(assert (<= 0 unknown@75@02))
; [eval] unknown < V
(push) ; 7
; [then-branch: 108 | unknown@75@02 < V@5@02 | live]
; [else-branch: 108 | !(unknown@75@02 < V@5@02) | live]
(push) ; 8
; [then-branch: 108 | unknown@75@02 < V@5@02]
(assert (< unknown@75@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 9
; [then-branch: 109 | 0 <= unknown1@76@02 | live]
; [else-branch: 109 | !(0 <= unknown1@76@02) | live]
(push) ; 10
; [then-branch: 109 | 0 <= unknown1@76@02]
(assert (<= 0 unknown1@76@02))
; [eval] unknown1 < V
(pop) ; 10
(push) ; 10
; [else-branch: 109 | !(0 <= unknown1@76@02)]
(assert (not (<= 0 unknown1@76@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 108 | !(unknown@75@02 < V@5@02)]
(assert (not (< unknown@75@02 V@5@02)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 107 | !(0 <= unknown@75@02)]
(assert (not (<= 0 unknown@75@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@76@02 V@5@02) (<= 0 unknown1@76@02))
    (< unknown@75@02 V@5@02))
  (<= 0 unknown@75@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6093
;  :arith-add-rows          1765
;  :arith-assert-diseq      64
;  :arith-assert-lower      1933
;  :arith-assert-upper      1492
;  :arith-bound-prop        147
;  :arith-conflicts         200
;  :arith-eq-adapter        436
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            706
;  :arith-pseudo-nonlinear  4
;  :conflicts               451
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7017
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10545
;  :mk-clause               7023
;  :num-allocs              250840
;  :num-checks              161
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            442169)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< unknown1@76@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6093
;  :arith-add-rows          1766
;  :arith-assert-diseq      64
;  :arith-assert-lower      1933
;  :arith-assert-upper      1492
;  :arith-bound-prop        147
;  :arith-conflicts         200
;  :arith-eq-adapter        436
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            706
;  :arith-pseudo-nonlinear  4
;  :conflicts               452
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7017
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10546
;  :mk-clause               7023
;  :num-allocs              250989
;  :num-checks              162
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            442311)
(assert (< unknown1@76@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 5
; Joined path conditions
(assert (< unknown1@76@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(declare-const sm@77@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@78@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@78@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@78@02  $FPM) r))
  :qid |qp.resPrmSumDef26|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@78@02  $FPM) r))
  :qid |qp.resTrgDef27|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02)))
(push) ; 5
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@78@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6093
;  :arith-add-rows          1767
;  :arith-assert-diseq      64
;  :arith-assert-lower      1933
;  :arith-assert-upper      1492
;  :arith-bound-prop        147
;  :arith-conflicts         200
;  :arith-eq-adapter        436
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            706
;  :arith-pseudo-nonlinear  4
;  :conflicts               453
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7017
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10551
;  :mk-clause               7023
;  :num-allocs              251383
;  :num-checks              163
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            442765)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 6
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6093
;  :arith-add-rows          1767
;  :arith-assert-diseq      64
;  :arith-assert-lower      1933
;  :arith-assert-upper      1492
;  :arith-bound-prop        147
;  :arith-conflicts         200
;  :arith-eq-adapter        436
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            706
;  :arith-pseudo-nonlinear  4
;  :conflicts               454
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7017
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10552
;  :mk-clause               7023
;  :num-allocs              251473
;  :num-checks              164
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            442854)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))
    (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))
    (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (<
  unknown@75@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6093
;  :arith-add-rows          1767
;  :arith-assert-diseq      64
;  :arith-assert-lower      1933
;  :arith-assert-upper      1492
;  :arith-bound-prop        147
;  :arith-conflicts         200
;  :arith-eq-adapter        436
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            706
;  :arith-pseudo-nonlinear  4
;  :conflicts               455
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7017
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10554
;  :mk-clause               7023
;  :num-allocs              251626
;  :num-checks              165
;  :propagations            3334
;  :quant-instantiations    1885
;  :rlimit-count            443107)
(assert (<
  unknown@75@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))))))
(pop) ; 5
; Joined path conditions
(assert (<
  unknown@75@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))))))
(declare-const $k@79@02 $Perm)
(assert ($Perm.isReadVar $k@79@02 $Perm.Write))
(pop) ; 4
(declare-fun inv@80@02 ($Ref) Int)
(declare-fun inv@81@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@78@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@78@02  $FPM) r))
  :qid |qp.resPrmSumDef26|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@78@02  $FPM) r))
  :qid |qp.resTrgDef27|)))
(assert ($Perm.isReadVar $k@79@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@75@02 Int) (unknown1@76@02 Int)) (!
  (and
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< unknown1@76@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@75@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02))
  :qid |int-aux|)))
(push) ; 4
(assert (not (forall ((unknown@75@02 Int) (unknown1@76@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@76@02 V@5@02) (<= 0 unknown1@76@02))
        (< unknown@75@02 V@5@02))
      (<= 0 unknown@75@02))
    (or (= $k@79@02 $Perm.No) (< $Perm.No $k@79@02)))
  
  ))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6093
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1935
;  :arith-assert-upper      1493
;  :arith-bound-prop        147
;  :arith-conflicts         200
;  :arith-eq-adapter        437
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            707
;  :arith-pseudo-nonlinear  4
;  :conflicts               456
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7017
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10565
;  :mk-clause               7025
;  :num-allocs              252401
;  :num-checks              166
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            444261)
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@75@02 Int) (unknown11@76@02 Int) (unknown2@75@02 Int) (unknown12@76@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and
            (and (< unknown11@76@02 V@5@02) (<= 0 unknown11@76@02))
            (< unknown1@75@02 V@5@02))
          (<= 0 unknown1@75@02))
        (< $Perm.No $k@79@02))
      (and
        (and
          (and
            (and (< unknown12@76@02 V@5@02) (<= 0 unknown12@76@02))
            (< unknown2@75@02 V@5@02))
          (<= 0 unknown2@75@02))
        (< $Perm.No $k@79@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown11@76@02))) unknown1@75@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown12@76@02))) unknown2@75@02)))
    (and (= unknown1@75@02 unknown2@75@02) (= unknown11@76@02 unknown12@76@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6094
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1943
;  :arith-assert-upper      1493
;  :arith-bound-prop        147
;  :arith-conflicts         201
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            707
;  :arith-pseudo-nonlinear  4
;  :conflicts               457
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 572
;  :datatype-occurs-check   330
;  :datatype-splits         460
;  :decisions               2101
;  :del-clause              7026
;  :final-checks            346
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.57
;  :minimized-lits          3
;  :mk-bool-var             10580
;  :mk-clause               7034
;  :num-allocs              252805
;  :num-checks              167
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            445118)
; Definitional axioms for inverse functions
(assert (forall ((unknown@75@02 Int) (unknown1@76@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@76@02 V@5@02) (<= 0 unknown1@76@02))
          (< unknown@75@02 V@5@02))
        (<= 0 unknown@75@02))
      (< $Perm.No $k@79@02))
    (and
      (=
        (inv@80@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02))
        unknown@75@02)
      (=
        (inv@81@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02))
        unknown1@76@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and
          (and (< (inv@81@02 r) V@5@02) (<= 0 (inv@81@02 r)))
          (< (inv@80@02 r) V@5@02))
        (<= 0 (inv@80@02 r)))
      (< $Perm.No $k@79@02))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) (inv@81@02 r)))) (inv@80@02 r))
      r))
  :pattern ((inv@80@02 r))
  :pattern ((inv@81@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((unknown@75@02 Int) (unknown1@76@02 Int)) (!
  (<= $Perm.No $k@79@02)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02))
  :qid |int-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((unknown@75@02 Int) (unknown1@76@02 Int)) (!
  (<= $k@79@02 $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02))
  :qid |int-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((unknown@75@02 Int) (unknown1@76@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@76@02 V@5@02) (<= 0 unknown1@76@02))
          (< unknown@75@02 V@5@02))
        (<= 0 unknown@75@02))
      (< $Perm.No $k@79@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@77@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@76@02))) unknown@75@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@82@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and
        (and
          (and (< (inv@81@02 r) V@5@02) (<= 0 (inv@81@02 r)))
          (< (inv@80@02 r) V@5@02))
        (<= 0 (inv@80@02 r)))
      (< $Perm.No $k@79@02)
      false)
    (=
      ($FVF.lookup_int (as sm@82@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@82@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r))
  :qid |qp.fvfValDef28|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@73@02 r) V@5@02) (<= 0 (inv@73@02 r)))
        (< (inv@72@02 r) V@5@02))
      (<= 0 (inv@72@02 r)))
    (=
      ($FVF.lookup_int (as sm@82@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@82@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r))
  :qid |qp.fvfValDef29|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@02)))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@82@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef30|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@81@02 r) V@5@02) (<= 0 (inv@81@02 r)))
        (< (inv@80@02 r) V@5@02))
      (<= 0 (inv@80@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@82@02  $FVF<Int>) r) r))
  :pattern ((inv@80@02 r) (inv@81@02 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 4
(declare-const $t@83@02 $Snap)
(assert (= $t@83@02 ($Snap.combine ($Snap.first $t@83@02) ($Snap.second $t@83@02))))
(assert (= ($Snap.first $t@83@02) $Snap.unit))
; [eval] exc == null
(assert (= exc@8@02 $Ref.null))
(assert (=
  ($Snap.second $t@83@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@83@02))
    ($Snap.second ($Snap.second $t@83@02)))))
(assert (= ($Snap.first ($Snap.second $t@83@02)) $Snap.unit))
; [eval] exc == null && 0 < V ==> source != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 110 | exc@8@02 == Null | live]
; [else-branch: 110 | exc@8@02 != Null | live]
(push) ; 6
; [then-branch: 110 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 110 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6113
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1943
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         201
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            707
;  :arith-pseudo-nonlinear  4
;  :conflicts               457
;  :datatype-accessor-ax    164
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   333
;  :datatype-splits         462
;  :decisions               2103
;  :del-clause              7028
;  :final-checks            348
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          3
;  :mk-bool-var             10595
;  :mk-clause               7034
;  :num-allocs              254709
;  :num-checks              169
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            449982)
; [then-branch: 111 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 111 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 6
; [else-branch: 111 | !(0 < V@5@02 && exc@8@02 == Null)]
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second $t@83@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@83@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@83@02))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(source)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 112 | exc@8@02 == Null | live]
; [else-branch: 112 | exc@8@02 != Null | live]
(push) ; 6
; [then-branch: 112 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 112 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(push) ; 6
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6119
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1943
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         201
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            707
;  :arith-pseudo-nonlinear  4
;  :conflicts               457
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   333
;  :datatype-splits         462
;  :decisions               2103
;  :del-clause              7028
;  :final-checks            348
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          3
;  :mk-bool-var             10597
;  :mk-clause               7034
;  :num-allocs              254819
;  :num-checks              170
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            450189)
; [then-branch: 113 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 113 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 6
; [else-branch: 113 | !(0 < V@5@02 && exc@8@02 == Null)]
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@83@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 5
; [then-branch: 114 | exc@8@02 == Null | live]
; [else-branch: 114 | exc@8@02 != Null | live]
(push) ; 6
; [then-branch: 114 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 6
(push) ; 6
; [else-branch: 114 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
(assert (not (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6124
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1943
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         201
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            707
;  :arith-pseudo-nonlinear  4
;  :conflicts               457
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   333
;  :datatype-splits         462
;  :decisions               2103
;  :del-clause              7028
;  :final-checks            348
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.58
;  :minimized-lits          3
;  :mk-bool-var             10598
;  :mk-clause               7034
;  :num-allocs              254929
;  :num-checks              171
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            450369)
; [then-branch: 115 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 115 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 5
; [else-branch: 115 | !(0 < V@5@02 && exc@8@02 == Null)]
(assert (not (and (< 0 V@5@02) (= exc@8@02 $Ref.null))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@02))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(source), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 116 | exc@8@02 == Null | live]
; [else-branch: 116 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 116 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 116 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 117 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 117 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 7
; [else-branch: 117 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(source), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 118 | exc@8@02 == Null | live]
; [else-branch: 118 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 118 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 118 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 119 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 119 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 7
; [else-branch: 119 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(source), i1) } (forall i2: Int :: { aloc(opt_get1(source), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(source), i1).option$array$ == aloc(opt_get1(source), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 120 | exc@8@02 == Null | live]
; [else-branch: 120 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 120 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 120 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 121 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 121 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 7
; [else-branch: 121 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> target != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 122 | exc@8@02 == Null | live]
; [else-branch: 122 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 122 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 122 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 123 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 123 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 7
; [else-branch: 123 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(target)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 124 | exc@8@02 == Null | live]
; [else-branch: 124 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 124 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 124 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
; [then-branch: 125 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 125 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 7
; [else-branch: 125 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 6
; [then-branch: 126 | exc@8@02 == Null | live]
; [else-branch: 126 | exc@8@02 != Null | live]
(push) ; 7
; [then-branch: 126 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 7
(push) ; 7
; [else-branch: 126 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
; [then-branch: 127 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 127 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 6
; [else-branch: 127 | !(0 < V@5@02 && exc@8@02 == Null)]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(target), i1).option$array$ != (None(): option[array]))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 128 | exc@8@02 == Null | live]
; [else-branch: 128 | exc@8@02 != Null | live]
(push) ; 8
; [then-branch: 128 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 128 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 129 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 129 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 8
; [else-branch: 129 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) } 0 <= i1 && i1 < V ==> alen(opt_get1(aloc(opt_get1(target), i1).option$array$)) == V)
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 130 | exc@8@02 == Null | live]
; [else-branch: 130 | exc@8@02 != Null | live]
(push) ; 8
; [then-branch: 130 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 130 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 131 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 131 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 8
; [else-branch: 131 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> (forall i1: Int :: { aloc(opt_get1(target), i1) } (forall i2: Int :: { aloc(opt_get1(target), i2) } 0 <= i1 && i1 < V && 0 <= i2 && i2 < V && aloc(opt_get1(target), i1).option$array$ == aloc(opt_get1(target), i2).option$array$ ==> i1 == i2))
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 7
; [then-branch: 132 | exc@8@02 == Null | live]
; [else-branch: 132 | exc@8@02 != Null | live]
(push) ; 8
; [then-branch: 132 | exc@8@02 == Null]
; [eval] 0 < V
(pop) ; 8
(push) ; 8
; [else-branch: 132 | exc@8@02 != Null]
(assert (not (= exc@8@02 $Ref.null)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 133 | 0 < V@5@02 && exc@8@02 == Null | dead]
; [else-branch: 133 | !(0 < V@5@02 && exc@8@02 == Null) | live]
(push) ; 8
; [else-branch: 133 | !(0 < V@5@02 && exc@8@02 == Null)]
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))))))
; [eval] exc == null
(push) ; 7
(assert (not (not (= exc@8@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6207
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1943
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         201
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            707
;  :arith-pseudo-nonlinear  4
;  :conflicts               457
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   338
;  :datatype-splits         464
;  :decisions               2107
;  :del-clause              7028
;  :final-checks            350
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10620
;  :mk-clause               7034
;  :num-allocs              256535
;  :num-checks              172
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            453396)
; [then-branch: 134 | exc@8@02 == Null | live]
; [else-branch: 134 | exc@8@02 != Null | dead]
(push) ; 7
; [then-branch: 134 | exc@8@02 == Null]
(declare-const unknown@84@02 Int)
(declare-const unknown1@85@02 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 135 | 0 <= unknown@84@02 | live]
; [else-branch: 135 | !(0 <= unknown@84@02) | live]
(push) ; 10
; [then-branch: 135 | 0 <= unknown@84@02]
(assert (<= 0 unknown@84@02))
; [eval] unknown < V
(push) ; 11
; [then-branch: 136 | unknown@84@02 < V@5@02 | live]
; [else-branch: 136 | !(unknown@84@02 < V@5@02) | live]
(push) ; 12
; [then-branch: 136 | unknown@84@02 < V@5@02]
(assert (< unknown@84@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 13
; [then-branch: 137 | 0 <= unknown1@85@02 | live]
; [else-branch: 137 | !(0 <= unknown1@85@02) | live]
(push) ; 14
; [then-branch: 137 | 0 <= unknown1@85@02]
(assert (<= 0 unknown1@85@02))
; [eval] unknown1 < V
(pop) ; 14
(push) ; 14
; [else-branch: 137 | !(0 <= unknown1@85@02)]
(assert (not (<= 0 unknown1@85@02)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 136 | !(unknown@84@02 < V@5@02)]
(assert (not (< unknown@84@02 V@5@02)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 135 | !(0 <= unknown@84@02)]
(assert (not (<= 0 unknown@84@02)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@85@02 V@5@02) (<= 0 unknown1@85@02))
    (< unknown@84@02 V@5@02))
  (<= 0 unknown@84@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6207
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1949
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            709
;  :arith-pseudo-nonlinear  4
;  :conflicts               460
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   338
;  :datatype-splits         464
;  :decisions               2107
;  :del-clause              7028
;  :final-checks            350
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10627
;  :mk-clause               7034
;  :num-allocs              256866
;  :num-checks              173
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            453882)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< unknown1@85@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6207
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1949
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            709
;  :arith-pseudo-nonlinear  4
;  :conflicts               461
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   338
;  :datatype-splits         464
;  :decisions               2107
;  :del-clause              7028
;  :final-checks            350
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10629
;  :mk-clause               7034
;  :num-allocs              257010
;  :num-checks              174
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            454027)
(assert (< unknown1@85@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 9
; Joined path conditions
(assert (< unknown1@85@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(declare-const sm@86@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@87@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@87@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@87@02  $FPM) r))
  :qid |qp.resPrmSumDef32|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@87@02  $FPM) r))
  :qid |qp.resTrgDef33|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02)))
(push) ; 9
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@87@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02)))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6207
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1949
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            709
;  :arith-pseudo-nonlinear  4
;  :conflicts               462
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   338
;  :datatype-splits         464
;  :decisions               2107
;  :del-clause              7028
;  :final-checks            350
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10634
;  :mk-clause               7034
;  :num-allocs              257386
;  :num-checks              175
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            454480)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 10
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6207
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1949
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            709
;  :arith-pseudo-nonlinear  4
;  :conflicts               463
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   338
;  :datatype-splits         464
;  :decisions               2107
;  :del-clause              7028
;  :final-checks            350
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10635
;  :mk-clause               7034
;  :num-allocs              257476
;  :num-checks              176
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            454569)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))
    (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))
    (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (<
  unknown@84@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6207
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1949
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         203
;  :arith-eq-adapter        439
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            709
;  :arith-pseudo-nonlinear  4
;  :conflicts               464
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   338
;  :datatype-splits         464
;  :decisions               2107
;  :del-clause              7028
;  :final-checks            350
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10637
;  :mk-clause               7034
;  :num-allocs              257625
;  :num-checks              177
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            454818)
(assert (<
  unknown@84@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))))))
(pop) ; 9
; Joined path conditions
(assert (<
  unknown@84@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))))))
(pop) ; 8
(declare-fun inv@88@02 ($Ref) Int)
(declare-fun inv@89@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@87@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@87@02  $FPM) r))
  :qid |qp.resPrmSumDef32|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@87@02  $FPM) r))
  :qid |qp.resTrgDef33|)))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@84@02 Int) (unknown1@85@02 Int)) (!
  (and
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< unknown1@85@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@84@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))) unknown@84@02))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 8
(assert (not (forall ((unknown1@84@02 Int) (unknown11@85@02 Int) (unknown2@84@02 Int) (unknown12@85@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown11@85@02 V@5@02) (<= 0 unknown11@85@02))
          (< unknown1@84@02 V@5@02))
        (<= 0 unknown1@84@02))
      (and
        (and
          (and (< unknown12@85@02 V@5@02) (<= 0 unknown12@85@02))
          (< unknown2@84@02 V@5@02))
        (<= 0 unknown2@84@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown11@85@02))) unknown1@84@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown12@85@02))) unknown2@84@02)))
    (and (= unknown1@84@02 unknown2@84@02) (= unknown11@85@02 unknown12@85@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6209
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1957
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         204
;  :arith-eq-adapter        441
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            709
;  :arith-pseudo-nonlinear  4
;  :conflicts               465
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 578
;  :datatype-occurs-check   338
;  :datatype-splits         464
;  :decisions               2107
;  :del-clause              7037
;  :final-checks            350
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10656
;  :mk-clause               7043
;  :num-allocs              258430
;  :num-checks              178
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            456304)
; Definitional axioms for inverse functions
(assert (forall ((unknown@84@02 Int) (unknown1@85@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@85@02 V@5@02) (<= 0 unknown1@85@02))
        (< unknown@84@02 V@5@02))
      (<= 0 unknown@84@02))
    (and
      (=
        (inv@88@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))) unknown@84@02))
        unknown@84@02)
      (=
        (inv@89@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))) unknown@84@02))
        unknown1@85@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))) unknown@84@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@89@02 r) V@5@02) (<= 0 (inv@89@02 r)))
        (< (inv@88@02 r) V@5@02))
      (<= 0 (inv@88@02 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) (inv@89@02 r)))) (inv@88@02 r))
      r))
  :pattern ((inv@88@02 r))
  :pattern ((inv@89@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@84@02 Int) (unknown1@85@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@85@02 V@5@02) (<= 0 unknown1@85@02))
        (< unknown@84@02 V@5@02))
      (<= 0 unknown@84@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))) unknown@84@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@86@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@85@02))) unknown@84@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@90@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@89@02 r) V@5@02) (<= 0 (inv@89@02 r)))
        (< (inv@88@02 r) V@5@02))
      (<= 0 (inv@88@02 r)))
    (=
      ($FVF.lookup_int (as sm@90@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@90@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))) r))
  :qid |qp.fvfValDef34|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@90@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef35|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@89@02 r) V@5@02) (<= 0 (inv@89@02 r)))
        (< (inv@88@02 r) V@5@02))
      (<= 0 (inv@88@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@90@02  $FVF<Int>) r) r))
  :pattern ((inv@88@02 r) (inv@89@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))))))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@8@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6240
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1957
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         204
;  :arith-eq-adapter        441
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            709
;  :arith-pseudo-nonlinear  4
;  :conflicts               465
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7037
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10666
;  :mk-clause               7043
;  :num-allocs              259898
;  :num-checks              179
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            459854)
; [then-branch: 138 | exc@8@02 == Null | live]
; [else-branch: 138 | exc@8@02 != Null | dead]
(push) ; 8
; [then-branch: 138 | exc@8@02 == Null]
(declare-const unknown@91@02 Int)
(declare-const unknown1@92@02 Int)
(push) ; 9
; [eval] 0 <= unknown && unknown < V && (0 <= unknown1 && unknown1 < V)
; [eval] 0 <= unknown
(push) ; 10
; [then-branch: 139 | 0 <= unknown@91@02 | live]
; [else-branch: 139 | !(0 <= unknown@91@02) | live]
(push) ; 11
; [then-branch: 139 | 0 <= unknown@91@02]
(assert (<= 0 unknown@91@02))
; [eval] unknown < V
(push) ; 12
; [then-branch: 140 | unknown@91@02 < V@5@02 | live]
; [else-branch: 140 | !(unknown@91@02 < V@5@02) | live]
(push) ; 13
; [then-branch: 140 | unknown@91@02 < V@5@02]
(assert (< unknown@91@02 V@5@02))
; [eval] 0 <= unknown1
(push) ; 14
; [then-branch: 141 | 0 <= unknown1@92@02 | live]
; [else-branch: 141 | !(0 <= unknown1@92@02) | live]
(push) ; 15
; [then-branch: 141 | 0 <= unknown1@92@02]
(assert (<= 0 unknown1@92@02))
; [eval] unknown1 < V
(pop) ; 15
(push) ; 15
; [else-branch: 141 | !(0 <= unknown1@92@02)]
(assert (not (<= 0 unknown1@92@02)))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(push) ; 13
; [else-branch: 140 | !(unknown@91@02 < V@5@02)]
(assert (not (< unknown@91@02 V@5@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 139 | !(0 <= unknown@91@02)]
(assert (not (<= 0 unknown@91@02)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(assert (and
  (and
    (and (< unknown1@92@02 V@5@02) (<= 0 unknown1@92@02))
    (< unknown@91@02 V@5@02))
  (<= 0 unknown@91@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 11
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6240
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1963
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         206
;  :arith-eq-adapter        441
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               468
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7037
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10672
;  :mk-clause               7043
;  :num-allocs              260229
;  :num-checks              180
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            460338)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (< unknown1@92@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6240
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1963
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         206
;  :arith-eq-adapter        441
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               469
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7037
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10673
;  :mk-clause               7043
;  :num-allocs              260371
;  :num-checks              181
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            460483)
(assert (< unknown1@92@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 10
; Joined path conditions
(assert (< unknown1@92@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(declare-const sm@93@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@94@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@94@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@94@02  $FPM) r))
  :qid |qp.resPrmSumDef37|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@94@02  $FPM) r))
  :qid |qp.resTrgDef38|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02)))
(push) ; 10
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@94@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6240
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1963
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         206
;  :arith-eq-adapter        441
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               470
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7037
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10678
;  :mk-clause               7043
;  :num-allocs              260746
;  :num-checks              182
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            460936)
(push) ; 10
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 11
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6240
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1963
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         206
;  :arith-eq-adapter        441
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               471
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7037
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10679
;  :mk-clause               7043
;  :num-allocs              260836
;  :num-checks              183
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            461025)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))
    (as None<option<array>>  option<array>))))
(pop) ; 10
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))
    (as None<option<array>>  option<array>))))
(push) ; 10
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 11
(assert (not (<
  unknown@91@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02)))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6240
;  :arith-add-rows          1767
;  :arith-assert-diseq      65
;  :arith-assert-lower      1963
;  :arith-assert-upper      1494
;  :arith-bound-prop        147
;  :arith-conflicts         206
;  :arith-eq-adapter        441
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               472
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7037
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10681
;  :mk-clause               7043
;  :num-allocs              260981
;  :num-checks              184
;  :propagations            3335
;  :quant-instantiations    1885
;  :rlimit-count            461274)
(assert (<
  unknown@91@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))))))
(pop) ; 10
; Joined path conditions
(assert (<
  unknown@91@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))))))
(declare-const $k@95@02 $Perm)
(assert ($Perm.isReadVar $k@95@02 $Perm.Write))
(pop) ; 9
(declare-fun inv@96@02 ($Ref) Int)
(declare-fun inv@97@02 ($Ref) Int)
; Nested auxiliary terms: globals
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@94@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@94@02  $FPM) r))
  :qid |qp.resPrmSumDef37|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@94@02  $FPM) r))
  :qid |qp.resTrgDef38|)))
(assert ($Perm.isReadVar $k@95@02 $Perm.Write))
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@91@02 Int) (unknown1@92@02 Int)) (!
  (and
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< unknown1@92@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@91@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))))))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02))
  :qid |int-aux|)))
(push) ; 9
(assert (not (forall ((unknown@91@02 Int) (unknown1@92@02 Int)) (!
  (implies
    (and
      (and
        (and (< unknown1@92@02 V@5@02) (<= 0 unknown1@92@02))
        (< unknown@91@02 V@5@02))
      (<= 0 unknown@91@02))
    (or (= $k@95@02 $Perm.No) (< $Perm.No $k@95@02)))
  
  ))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6240
;  :arith-add-rows          1767
;  :arith-assert-diseq      66
;  :arith-assert-lower      1965
;  :arith-assert-upper      1495
;  :arith-bound-prop        147
;  :arith-conflicts         206
;  :arith-eq-adapter        442
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               473
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7037
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10692
;  :mk-clause               7045
;  :num-allocs              261746
;  :num-checks              185
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            462425)
; Check receiver injectivity
(push) ; 9
(assert (not (forall ((unknown1@91@02 Int) (unknown11@92@02 Int) (unknown2@91@02 Int) (unknown12@92@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and
            (and (< unknown11@92@02 V@5@02) (<= 0 unknown11@92@02))
            (< unknown1@91@02 V@5@02))
          (<= 0 unknown1@91@02))
        (< $Perm.No $k@95@02))
      (and
        (and
          (and
            (and (< unknown12@92@02 V@5@02) (<= 0 unknown12@92@02))
            (< unknown2@91@02 V@5@02))
          (<= 0 unknown2@91@02))
        (< $Perm.No $k@95@02))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown11@92@02))) unknown1@91@02)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown12@92@02))) unknown2@91@02)))
    (and (= unknown1@91@02 unknown2@91@02) (= unknown11@92@02 unknown12@92@02)))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6242
;  :arith-add-rows          1767
;  :arith-assert-diseq      66
;  :arith-assert-lower      1973
;  :arith-assert-upper      1495
;  :arith-bound-prop        147
;  :arith-conflicts         207
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               474
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 583
;  :datatype-occurs-check   343
;  :datatype-splits         467
;  :decisions               2112
;  :del-clause              7046
;  :final-checks            352
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10708
;  :mk-clause               7054
;  :num-allocs              262150
;  :num-checks              186
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            463283)
; Definitional axioms for inverse functions
(assert (forall ((unknown@91@02 Int) (unknown1@92@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@92@02 V@5@02) (<= 0 unknown1@92@02))
          (< unknown@91@02 V@5@02))
        (<= 0 unknown@91@02))
      (< $Perm.No $k@95@02))
    (and
      (=
        (inv@96@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02))
        unknown@91@02)
      (=
        (inv@97@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02))
        unknown1@92@02)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and
          (and (< (inv@97@02 r) V@5@02) (<= 0 (inv@97@02 r)))
          (< (inv@96@02 r) V@5@02))
        (<= 0 (inv@96@02 r)))
      (< $Perm.No $k@95@02))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) (inv@97@02 r)))) (inv@96@02 r))
      r))
  :pattern ((inv@96@02 r))
  :pattern ((inv@97@02 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
(assert (forall ((unknown@91@02 Int) (unknown1@92@02 Int)) (!
  (<= $Perm.No $k@95@02)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02))
  :qid |int-permAtLeastZero|)))
; Field permissions are at most one
(assert (forall ((unknown@91@02 Int) (unknown1@92@02 Int)) (!
  (<= $k@95@02 $Perm.Write)
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02))
  :qid |int-permAtMostOne|)))
; Permission implies non-null receiver
(assert (forall ((unknown@91@02 Int) (unknown1@92@02 Int)) (!
  (implies
    (and
      (and
        (and
          (and (< unknown1@92@02 V@5@02) (<= 0 unknown1@92@02))
          (< unknown@91@02 V@5@02))
        (<= 0 unknown@91@02))
      (< $Perm.No $k@95@02))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@93@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@92@02))) unknown@91@02))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@98@02 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (ite
      (and
        (and
          (and (< (inv@97@02 r) V@5@02) (<= 0 (inv@97@02 r)))
          (< (inv@96@02 r) V@5@02))
        (<= 0 (inv@96@02 r)))
      (< $Perm.No $k@95@02)
      false)
    (=
      ($FVF.lookup_int (as sm@98@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@98@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))))) r))
  :qid |qp.fvfValDef39|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@89@02 r) V@5@02) (<= 0 (inv@89@02 r)))
        (< (inv@88@02 r) V@5@02))
      (<= 0 (inv@88@02 r)))
    (=
      ($FVF.lookup_int (as sm@98@02  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))) r)))
  :pattern (($FVF.lookup_int (as sm@98@02  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))) r))
  :qid |qp.fvfValDef40|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))))) r) r)
    ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02))))))))))))))) r) r))
  :pattern (($FVF.lookup_int (as sm@98@02  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef41|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and
      (and
        (and (< (inv@97@02 r) V@5@02) (<= 0 (inv@97@02 r)))
        (< (inv@96@02 r) V@5@02))
      (<= 0 (inv@96@02 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) r) r))
  :pattern ((inv@96@02 r) (inv@97@02 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@02)))))))))))))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: 0 <= unknown && unknown < V ==> (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int))
; [eval] exc == null
(push) ; 9
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= exc@8@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1767
;  :arith-assert-diseq      66
;  :arith-assert-lower      1973
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         207
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            711
;  :arith-pseudo-nonlinear  4
;  :conflicts               474
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7046
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10719
;  :mk-clause               7054
;  :num-allocs              264023
;  :num-checks              187
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            468212)
; [then-branch: 142 | exc@8@02 == Null | live]
; [else-branch: 142 | exc@8@02 != Null | dead]
(push) ; 10
; [then-branch: 142 | exc@8@02 == Null]
; [eval] (forall unknown: Int :: 0 <= unknown && unknown < V ==> (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int))
(declare-const unknown@99@02 Int)
(push) ; 11
; [eval] 0 <= unknown && unknown < V ==> (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int)
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 12
; [then-branch: 143 | 0 <= unknown@99@02 | live]
; [else-branch: 143 | !(0 <= unknown@99@02) | live]
(push) ; 13
; [then-branch: 143 | 0 <= unknown@99@02]
(assert (<= 0 unknown@99@02))
; [eval] unknown < V
(pop) ; 13
(push) ; 13
; [else-branch: 143 | !(0 <= unknown@99@02)]
(assert (not (<= 0 unknown@99@02)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(push) ; 12
; [then-branch: 144 | unknown@99@02 < V@5@02 && 0 <= unknown@99@02 | live]
; [else-branch: 144 | !(unknown@99@02 < V@5@02 && 0 <= unknown@99@02) | live]
(push) ; 13
; [then-branch: 144 | unknown@99@02 < V@5@02 && 0 <= unknown@99@02]
(assert (and (< unknown@99@02 V@5@02) (<= 0 unknown@99@02)))
; [eval] (forall unknown1: Int :: { aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown) } { aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown) } 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int)
(declare-const unknown1@100@02 Int)
(push) ; 14
; [eval] 0 <= unknown1 && unknown1 < V ==> aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int
; [eval] 0 <= unknown1 && unknown1 < V
; [eval] 0 <= unknown1
(push) ; 15
; [then-branch: 145 | 0 <= unknown1@100@02 | live]
; [else-branch: 145 | !(0 <= unknown1@100@02) | live]
(push) ; 16
; [then-branch: 145 | 0 <= unknown1@100@02]
(assert (<= 0 unknown1@100@02))
; [eval] unknown1 < V
(pop) ; 16
(push) ; 16
; [else-branch: 145 | !(0 <= unknown1@100@02)]
(assert (not (<= 0 unknown1@100@02)))
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(push) ; 15
; [then-branch: 146 | unknown1@100@02 < V@5@02 && 0 <= unknown1@100@02 | live]
; [else-branch: 146 | !(unknown1@100@02 < V@5@02 && 0 <= unknown1@100@02) | live]
(push) ; 16
; [then-branch: 146 | unknown1@100@02 < V@5@02 && 0 <= unknown1@100@02]
(assert (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02)))
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown).int == aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown).int
; [eval] aloc(opt_get1(aloc(opt_get1(target), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(target), unknown1).option$array$)
; [eval] aloc(opt_get1(target), unknown1)
; [eval] opt_get1(target)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 18
(assert (not (not (= target@7@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1767
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               476
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7046
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10724
;  :mk-clause               7054
;  :num-allocs              264256
;  :num-checks              188
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            468562)
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not (= target@7@02 (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1767
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               477
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7046
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10726
;  :mk-clause               7054
;  :num-allocs              264400
;  :num-checks              189
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            468707)
(assert (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(pop) ; 17
; Joined path conditions
(assert (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02))))
(declare-const sm@101@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@102@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@102@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resPrmSumDef43|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resTrgDef44|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@102@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1767
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               478
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7046
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10731
;  :mk-clause               7054
;  :num-allocs              264776
;  :num-checks              190
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            469160)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 18
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1767
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               479
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7046
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10732
;  :mk-clause               7054
;  :num-allocs              264866
;  :num-checks              191
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            469249)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
    (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
    (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (<
  unknown@99@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1768
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               480
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7046
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.59
;  :minimized-lits          3
;  :mk-bool-var             10734
;  :mk-clause               7054
;  :num-allocs              265011
;  :num-checks              192
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            469499)
(assert (<
  unknown@99@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))))))
(pop) ; 17
; Joined path conditions
(assert (<
  unknown@99@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (and
          (and
            (<
              (inv@97@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
              V@5@02)
            (<=
              0
              (inv@97@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))))
          (<
            (inv@96@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
            V@5@02))
        (<=
          0
          (inv@96@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))))
      $k@95@02
      $Perm.No)
    (ite
      (and
        (and
          (and
            (<
              (inv@89@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
              V@5@02)
            (<=
              0
              (inv@89@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))))
          (<
            (inv@88@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
            V@5@02))
        (<=
          0
          (inv@88@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))))
      $Perm.Write
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1769
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               481
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7060
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10751
;  :mk-clause               7068
;  :num-allocs              265308
;  :num-checks              193
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            470303)
; [eval] aloc(opt_get1(aloc(opt_get1(source), unknown1).option$array$), unknown)
; [eval] opt_get1(aloc(opt_get1(source), unknown1).option$array$)
; [eval] aloc(opt_get1(source), unknown1)
; [eval] opt_get1(source)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 18
(assert (not (not (= source@6@02 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1769
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               482
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7060
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10751
;  :mk-clause               7068
;  :num-allocs              265385
;  :num-checks              194
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            470348)
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not (= source@6@02 (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1769
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               483
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7060
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10752
;  :mk-clause               7068
;  :num-allocs              265529
;  :num-checks              195
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            470489)
(assert (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(pop) ; 17
; Joined path conditions
(assert (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02))))
(declare-const sm@103@02 $FVF<option<array>>)
; Definitional axioms for snapshot map values
(declare-const pm@104@02 $FPM)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@104@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resPrmSumDef46|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resTrgDef47|)))
(assert ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  ($FVF.perm_option$array$ (as pm@104@02  $FPM) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1769
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               484
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7060
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10757
;  :mk-clause               7068
;  :num-allocs              265905
;  :num-checks              196
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            470942)
(push) ; 17
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(push) ; 18
(assert (not (not
  (=
    ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
    (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1769
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               485
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7060
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10758
;  :mk-clause               7068
;  :num-allocs              265995
;  :num-checks              197
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            471031)
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
    (as None<option<array>>  option<array>))))
(pop) ; 17
; Joined path conditions
(assert (not
  (=
    ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
    (as None<option<array>>  option<array>))))
(push) ; 17
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 18
(assert (not (<
  unknown@99@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))))))
(check-sat)
; unsat
(pop) ; 18
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1770
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               486
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7060
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10760
;  :mk-clause               7068
;  :num-allocs              266142
;  :num-checks              198
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            471277)
(assert (<
  unknown@99@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))))))
(pop) ; 17
; Joined path conditions
(assert (<
  unknown@99@02
  (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)))
(push) ; 17
(assert (not (<
  $Perm.No
  (+
    (ite
      (and
        (and
          (and
            (<
              (inv@97@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))
              V@5@02)
            (<=
              0
              (inv@97@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
          (<
            (inv@96@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))
            V@5@02))
        (<=
          0
          (inv@96@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
      $k@95@02
      $Perm.No)
    (ite
      (and
        (and
          (and
            (<
              (inv@89@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))
              V@5@02)
            (<=
              0
              (inv@89@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
          (<
            (inv@88@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))
            V@5@02))
        (<=
          0
          (inv@88@02 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
      $Perm.Write
      $Perm.No)))))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6268
;  :arith-add-rows          1771
;  :arith-assert-diseq      66
;  :arith-assert-lower      1975
;  :arith-assert-upper      1496
;  :arith-bound-prop        147
;  :arith-conflicts         208
;  :arith-eq-adapter        444
;  :arith-fixed-eqs         436
;  :arith-grobner           95
;  :arith-max-min           1815
;  :arith-nonlinear-bounds  246
;  :arith-nonlinear-horner  75
;  :arith-offset-eqs        428
;  :arith-pivots            712
;  :arith-pseudo-nonlinear  4
;  :conflicts               487
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 587
;  :datatype-occurs-check   348
;  :datatype-splits         469
;  :decisions               2116
;  :del-clause              7074
;  :final-checks            354
;  :interface-eqs           51
;  :max-generation          5
;  :max-memory              5.62
;  :memory                  5.60
;  :minimized-lits          3
;  :mk-bool-var             10777
;  :mk-clause               7082
;  :num-allocs              266417
;  :num-checks              199
;  :propagations            3336
;  :quant-instantiations    1885
;  :rlimit-count            472081)
(pop) ; 16
(push) ; 16
; [else-branch: 146 | !(unknown1@100@02 < V@5@02 && 0 <= unknown1@100@02)]
(assert (not (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02))))
(pop) ; 16
(pop) ; 15
; Joined path conditions
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@102@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resPrmSumDef43|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resTrgDef44|)))
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@104@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resPrmSumDef46|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resTrgDef47|)))
(assert (implies
  (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02))
  (and
    (< unknown1@100@02 V@5@02)
    (<= 0 unknown1@100@02)
    (not (= target@7@02 (as None<option<array>>  option<array>)))
    (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@99@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))))
    ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
    (not (= source@6@02 (as None<option<array>>  option<array>)))
    (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
    ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
    (not
      (=
        ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
        (as None<option<array>>  option<array>)))
    (<
      unknown@99@02
      (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))))
    ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)))))
; Joined path conditions
(pop) ; 14
; Nested auxiliary terms: globals (aux)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@102@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resPrmSumDef43|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resTrgDef44|)))
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@104@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resPrmSumDef46|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resTrgDef47|)))
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown1@100@02 Int)) (!
  (implies
    (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02))
    (and
      (< unknown1@100@02 V@5@02)
      (<= 0 unknown1@100@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@99@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@99@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
  :qid |prog.l<no position>-aux|)))
(assert (forall ((unknown1@100@02 Int)) (!
  (implies
    (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02))
    (and
      (< unknown1@100@02 V@5@02)
      (<= 0 unknown1@100@02)
      (not (= target@7@02 (as None<option<array>>  option<array>)))
      (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@99@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
      (not (= source@6@02 (as None<option<array>>  option<array>)))
      (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
      ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
      (not
        (=
          ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
          (as None<option<array>>  option<array>)))
      (<
        unknown@99@02
        (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))))
      ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 13
(push) ; 13
; [else-branch: 144 | !(unknown@99@02 < V@5@02 && 0 <= unknown@99@02)]
(assert (not (and (< unknown@99@02 V@5@02) (<= 0 unknown@99@02))))
(pop) ; 13
(pop) ; 12
; Joined path conditions
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@102@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resPrmSumDef43|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resTrgDef44|)))
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@104@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resPrmSumDef46|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resTrgDef47|)))
(assert (implies
  (and (< unknown@99@02 V@5@02) (<= 0 unknown@99@02))
  (and
    (< unknown@99@02 V@5@02)
    (<= 0 unknown@99@02)
    (forall ((unknown1@100@02 Int)) (!
      (implies
        (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02))
        (and
          (< unknown1@100@02 V@5@02)
          (<= 0 unknown1@100@02)
          (not (= target@7@02 (as None<option<array>>  option<array>)))
          (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@99@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
          (not (= source@6@02 (as None<option<array>>  option<array>)))
          (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@99@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
      :qid |prog.l<no position>-aux|))
    (forall ((unknown1@100@02 Int)) (!
      (implies
        (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02))
        (and
          (< unknown1@100@02 V@5@02)
          (<= 0 unknown1@100@02)
          (not (= target@7@02 (as None<option<array>>  option<array>)))
          (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit target@7@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@99@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
          (not (= source@6@02 (as None<option<array>>  option<array>)))
          (< unknown1@100@02 (alen<Int> (opt_get1 $Snap.unit source@6@02)))
          ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
          (not
            (=
              ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
                $Snap.unit
                $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))
              (as None<option<array>>  option<array>)))
          (<
            unknown@99@02
            (alen<Int> (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02)))))
          ($FVF.loc_int ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02)) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
            $Snap.unit
            $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
      :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))
      :qid |prog.l<no position>-aux|)))))
; Joined path conditions
(pop) ; 11
; Nested auxiliary terms: globals (aux)
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@102@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resPrmSumDef43|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resTrgDef44|)))
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@104@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resPrmSumDef46|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resTrgDef47|)))
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@102@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resPrmSumDef43|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@102@02  $FPM) r))
  :qid |qp.resTrgDef44|)))
(assert (forall ((r $Ref)) (!
  (= ($FVF.perm_option$array$ (as pm@104@02  $FPM) r) $Perm.No)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resPrmSumDef46|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_option$array$ ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) r) r)
  :pattern (($FVF.perm_option$array$ (as pm@104@02  $FPM) r))
  :qid |qp.resTrgDef47|)))
(assert (implies
  (= exc@8@02 $Ref.null)
  (forall ((unknown@99@02 Int)) (!
    (implies
      (and (< unknown@99@02 V@5@02) (<= 0 unknown@99@02))
      (forall ((unknown1@100@02 Int)) (!
        (implies
          (and (< unknown1@100@02 V@5@02) (<= 0 unknown1@100@02))
          (=
            ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
            ($FVF.lookup_int (as sm@98@02  $FVF<Int>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
              $Snap.unit
              $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@101@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit target@7@02) unknown1@100@02))) unknown@99@02))
        :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit ($FVF.lookup_option$array$ (as sm@103@02  $FVF<option<array>>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit source@6@02) unknown1@100@02))) unknown@99@02))
        :qid |prog.l<no position>|)))
    
    :qid |prog.l<no position>|))))
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
