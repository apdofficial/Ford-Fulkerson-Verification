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
; ---------- make_array2 ----------
(declare-const tid@0@05 Int)
(declare-const dim0@1@05 Int)
(declare-const exc@2@05 $Ref)
(declare-const res@3@05 option<array>)
(declare-const tid@4@05 Int)
(declare-const dim0@5@05 Int)
(declare-const exc@6@05 $Ref)
(declare-const res@7@05 option<array>)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@8@05 $Snap)
(assert (= $t@8@05 ($Snap.combine ($Snap.first $t@8@05) ($Snap.second $t@8@05))))
(assert (= ($Snap.first $t@8@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@6@05 $Ref.null))
(assert (=
  ($Snap.second $t@8@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@8@05))
    ($Snap.second ($Snap.second $t@8@05)))))
(assert (= ($Snap.first ($Snap.second $t@8@05)) $Snap.unit))
; [eval] exc == null ==> res != (None(): option[array])
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@6@05 $Ref.null))))
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
;  :max-memory              4.38
;  :memory                  4.18
;  :mk-bool-var             415
;  :num-allocs              158378
;  :num-checks              2
;  :quant-instantiations    2
;  :rlimit-count            180702)
; [then-branch: 0 | exc@6@05 == Null | live]
; [else-branch: 0 | exc@6@05 != Null | dead]
(push) ; 4
; [then-branch: 0 | exc@6@05 == Null]
; [eval] res != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@6@05 $Ref.null)
  (not (= res@7@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@8@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@8@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@8@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@8@05))) $Snap.unit))
; [eval] exc == null ==> alen(opt_get1(res)) == dim0
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@6@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :final-checks            5
;  :max-generation          1
;  :max-memory              4.38
;  :memory                  4.19
;  :mk-bool-var             419
;  :num-allocs              158860
;  :num-checks              3
;  :quant-instantiations    2
;  :rlimit-count            181381)
; [then-branch: 1 | exc@6@05 == Null | live]
; [else-branch: 1 | exc@6@05 != Null | dead]
(push) ; 4
; [then-branch: 1 | exc@6@05 == Null]
; [eval] alen(opt_get1(res)) == dim0
; [eval] alen(opt_get1(res))
; [eval] opt_get1(res)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= res@7@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25
;  :arith-assert-lower      2
;  :arith-assert-upper      2
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    4
;  :datatype-constructor-ax 2
;  :datatype-occurs-check   4
;  :datatype-splits         2
;  :decisions               2
;  :final-checks            5
;  :max-generation          1
;  :max-memory              4.38
;  :memory                  4.20
;  :mk-bool-var             419
;  :num-allocs              158933
;  :num-checks              4
;  :quant-instantiations    2
;  :rlimit-count            181402)
(assert (not (= res@7@05 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= res@7@05 (as None<option<array>>  option<array>))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@6@05 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit res@7@05)) dim0@5@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@8@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@8@05)))))))
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
; (:added-eqs               38
;  :arith-assert-lower      3
;  :arith-assert-upper      2
;  :arith-eq-adapter        2
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   6
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            7
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.21
;  :mk-bool-var             428
;  :num-allocs              159567
;  :num-checks              5
;  :quant-instantiations    7
;  :rlimit-count            182172)
; [then-branch: 2 | exc@6@05 == Null | live]
; [else-branch: 2 | exc@6@05 != Null | dead]
(push) ; 3
; [then-branch: 2 | exc@6@05 == Null]
(declare-const i0@9@05 Int)
(push) ; 4
; [eval] 0 <= i0 && i0 < dim0
; [eval] 0 <= i0
(push) ; 5
; [then-branch: 3 | 0 <= i0@9@05 | live]
; [else-branch: 3 | !(0 <= i0@9@05) | live]
(push) ; 6
; [then-branch: 3 | 0 <= i0@9@05]
(assert (<= 0 i0@9@05))
; [eval] i0 < dim0
(pop) ; 6
(push) ; 6
; [else-branch: 3 | !(0 <= i0@9@05)]
(assert (not (<= 0 i0@9@05)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< i0@9@05 dim0@5@05) (<= 0 i0@9@05)))
; [eval] aloc(opt_get1(res), i0)
; [eval] opt_get1(res)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= res@7@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   6
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            7
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.22
;  :mk-bool-var             432
;  :num-allocs              159735
;  :num-checks              6
;  :quant-instantiations    7
;  :rlimit-count            182360)
(assert (not (= res@7@05 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= res@7@05 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i0@9@05 (alen<Int> (opt_get1 $Snap.unit res@7@05)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               39
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :arith-fixed-eqs         1
;  :arith-pivots            1
;  :datatype-accessor-ax    5
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   6
;  :datatype-splits         4
;  :decisions               4
;  :final-checks            7
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.22
;  :mk-bool-var             432
;  :num-allocs              159758
;  :num-checks              7
;  :quant-instantiations    7
;  :rlimit-count            182391)
(assert (< i0@9@05 (alen<Int> (opt_get1 $Snap.unit res@7@05))))
(pop) ; 5
; Joined path conditions
(assert (< i0@9@05 (alen<Int> (opt_get1 $Snap.unit res@7@05))))
(declare-const sm@10@05 $FVF<Bool>)
; Definitional axioms for snapshot map values
; [eval] aloc(opt_get1(res), i0)
; [eval] opt_get1(res)
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
(pop) ; 4
(declare-fun inv@11@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i0@9@05 Int)) (!
  (and
    (not (= res@7@05 (as None<option<array>>  option<array>)))
    (< i0@9@05 (alen<Int> (opt_get1 $Snap.unit res@7@05))))
  :pattern (($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@05))))) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05)))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((i01@9@05 Int) (i02@9@05 Int)) (!
  (implies
    (and
      (and (< i01@9@05 dim0@5@05) (<= 0 i01@9@05))
      (and (< i02@9@05 dim0@5@05) (<= 0 i02@9@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@05) i01@9@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@05) i02@9@05)))
    (= i01@9@05 i02@9@05))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               70
;  :arith-add-rows          14
;  :arith-assert-diseq      3
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-conflicts         2
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               3
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   6
;  :datatype-splits         4
;  :decisions               6
;  :del-clause              18
;  :final-checks            7
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.25
;  :mk-bool-var             460
;  :mk-clause               18
;  :num-allocs              160525
;  :num-checks              8
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            183800)
; Definitional axioms for inverse functions
(assert (forall ((i0@9@05 Int)) (!
  (implies
    (and (< i0@9@05 dim0@5@05) (<= 0 i0@9@05))
    (=
      (inv@11@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05))
      i0@9@05))
  :pattern (($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@05))))) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05)))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@11@05 r) dim0@5@05) (<= 0 (inv@11@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@05) (inv@11@05 r))
      r))
  :pattern ((inv@11@05 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((i0@9@05 Int)) (!
  (implies
    (and (< i0@9@05 dim0@5@05) (<= 0 i0@9@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05)
        $Ref.null)))
  :pattern (($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@05))))) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@9@05)))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@12@05 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@11@05 r) dim0@5@05) (<= 0 (inv@11@05 r)))
    (=
      ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@05))))) r)))
  :pattern (($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@05))))) r))
  :qid |qp.fvfValDef1|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@05))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef2|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@11@05 r) dim0@5@05) (<= 0 (inv@11@05 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) r) r))
  :pattern ((inv@11@05 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@8@05))))
  $Snap.unit))
; [eval] exc == null ==> (forall i0: Int :: { aloc(opt_get1(res), i0).bool } 0 <= i0 && i0 < dim0 ==> aloc(opt_get1(res), i0).bool == false)
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
; (:added-eqs               74
;  :arith-add-rows          14
;  :arith-assert-diseq      3
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-conflicts         2
;  :arith-eq-adapter        5
;  :arith-fixed-eqs         2
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :conflicts               3
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   9
;  :datatype-splits         5
;  :decisions               7
;  :del-clause              18
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.27
;  :mk-bool-var             468
;  :mk-clause               18
;  :num-allocs              161853
;  :num-checks              9
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            186193)
; [then-branch: 4 | exc@6@05 == Null | live]
; [else-branch: 4 | exc@6@05 != Null | dead]
(push) ; 5
; [then-branch: 4 | exc@6@05 == Null]
; [eval] (forall i0: Int :: { aloc(opt_get1(res), i0).bool } 0 <= i0 && i0 < dim0 ==> aloc(opt_get1(res), i0).bool == false)
(declare-const i0@13@05 Int)
(push) ; 6
; [eval] 0 <= i0 && i0 < dim0 ==> aloc(opt_get1(res), i0).bool == false
; [eval] 0 <= i0 && i0 < dim0
; [eval] 0 <= i0
(push) ; 7
; [then-branch: 5 | 0 <= i0@13@05 | live]
; [else-branch: 5 | !(0 <= i0@13@05) | live]
(push) ; 8
; [then-branch: 5 | 0 <= i0@13@05]
(assert (<= 0 i0@13@05))
; [eval] i0 < dim0
(pop) ; 8
(push) ; 8
; [else-branch: 5 | !(0 <= i0@13@05)]
(assert (not (<= 0 i0@13@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 6 | i0@13@05 < dim0@5@05 && 0 <= i0@13@05 | live]
; [else-branch: 6 | !(i0@13@05 < dim0@5@05 && 0 <= i0@13@05) | live]
(push) ; 8
; [then-branch: 6 | i0@13@05 < dim0@5@05 && 0 <= i0@13@05]
(assert (and (< i0@13@05 dim0@5@05) (<= 0 i0@13@05)))
; [eval] aloc(opt_get1(res), i0).bool == false
; [eval] aloc(opt_get1(res), i0)
; [eval] opt_get1(res)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= res@7@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               75
;  :arith-add-rows          15
;  :arith-assert-diseq      3
;  :arith-assert-lower      14
;  :arith-assert-upper      10
;  :arith-conflicts         2
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            12
;  :conflicts               3
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   9
;  :datatype-splits         5
;  :decisions               7
;  :del-clause              18
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.27
;  :mk-bool-var             472
;  :mk-clause               18
;  :num-allocs              162030
;  :num-checks              10
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            186405)
(assert (not (= res@7@05 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= res@7@05 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i0@13@05 (alen<Int> (opt_get1 $Snap.unit res@7@05)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               75
;  :arith-add-rows          15
;  :arith-assert-diseq      3
;  :arith-assert-lower      14
;  :arith-assert-upper      10
;  :arith-conflicts         2
;  :arith-eq-adapter        6
;  :arith-fixed-eqs         3
;  :arith-offset-eqs        1
;  :arith-pivots            12
;  :conflicts               3
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   9
;  :datatype-splits         5
;  :decisions               7
;  :del-clause              18
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.27
;  :mk-bool-var             472
;  :mk-clause               18
;  :num-allocs              162055
;  :num-checks              11
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            186436)
(assert (< i0@13@05 (alen<Int> (opt_get1 $Snap.unit res@7@05))))
(pop) ; 9
; Joined path conditions
(assert (< i0@13@05 (alen<Int> (opt_get1 $Snap.unit res@7@05))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)))
(push) ; 9
(assert (not (and
  (<
    (inv@11@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05))
    dim0@5@05)
  (<=
    0
    (inv@11@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               85
;  :arith-add-rows          18
;  :arith-assert-diseq      3
;  :arith-assert-lower      15
;  :arith-assert-upper      11
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        4
;  :arith-pivots            13
;  :conflicts               4
;  :datatype-accessor-ax    6
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   9
;  :datatype-splits         5
;  :decisions               7
;  :del-clause              18
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             491
;  :mk-clause               33
;  :num-allocs              162378
;  :num-checks              12
;  :propagations            26
;  :quant-instantiations    26
;  :rlimit-count            187030)
(pop) ; 8
(push) ; 8
; [else-branch: 6 | !(i0@13@05 < dim0@5@05 && 0 <= i0@13@05)]
(assert (not (and (< i0@13@05 dim0@5@05) (<= 0 i0@13@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i0@13@05 dim0@5@05) (<= 0 i0@13@05))
  (and
    (< i0@13@05 dim0@5@05)
    (<= 0 i0@13@05)
    (not (= res@7@05 (as None<option<array>>  option<array>)))
    (< i0@13@05 (alen<Int> (opt_get1 $Snap.unit res@7@05)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)))))
; Joined path conditions
; Definitional axioms for snapshot map values
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i0@13@05 Int)) (!
  (implies
    (and (< i0@13@05 dim0@5@05) (<= 0 i0@13@05))
    (and
      (< i0@13@05 dim0@5@05)
      (<= 0 i0@13@05)
      (not (= res@7@05 (as None<option<array>>  option<array>)))
      (< i0@13@05 (alen<Int> (opt_get1 $Snap.unit res@7@05)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05))))
  :pattern (($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@6@05 $Ref.null)
  (forall ((i0@13@05 Int)) (!
    (implies
      (and (< i0@13@05 dim0@5@05) (<= 0 i0@13@05))
      (and
        (< i0@13@05 dim0@5@05)
        (<= 0 i0@13@05)
        (not (= res@7@05 (as None<option<array>>  option<array>)))
        (< i0@13@05 (alen<Int> (opt_get1 $Snap.unit res@7@05)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05))))
    :pattern (($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@6@05 $Ref.null)
  (forall ((i0@13@05 Int)) (!
    (implies
      (and (< i0@13@05 dim0@5@05) (<= 0 i0@13@05))
      (=
        ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05))
        false))
    :pattern (($FVF.loc_bool ($FVF.lookup_bool (as sm@12@05  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@05) i0@13@05)))
    :qid |prog.l<no position>|))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- check_unknown2 ----------
(declare-const V@14@05 Int)
(declare-const i1@15@05 Int)
(declare-const visited@16@05 option<array>)
(declare-const s@17@05 Int)
(declare-const exc@18@05 $Ref)
(declare-const res@19@05 void)
(declare-const V@20@05 Int)
(declare-const i1@21@05 Int)
(declare-const visited@22@05 option<array>)
(declare-const s@23@05 Int)
(declare-const exc@24@05 $Ref)
(declare-const res@25@05 void)
(push) ; 1
(declare-const $t@26@05 $Snap)
(assert (= $t@26@05 ($Snap.combine ($Snap.first $t@26@05) ($Snap.second $t@26@05))))
(assert (= ($Snap.first $t@26@05) $Snap.unit))
; [eval] 0 < V ==> visited != (None(): option[array])
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               93
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      16
;  :arith-assert-upper      11
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        4
;  :arith-pivots            16
;  :conflicts               4
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   11
;  :datatype-splits         6
;  :decisions               8
;  :del-clause              33
;  :final-checks            11
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             495
;  :mk-clause               33
;  :num-allocs              162984
;  :num-checks              13
;  :propagations            26
;  :quant-instantiations    26
;  :rlimit-count            187858)
(push) ; 3
(assert (not (< 0 V@20@05)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               95
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      16
;  :arith-assert-upper      12
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        4
;  :arith-pivots            16
;  :conflicts               4
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 7
;  :datatype-occurs-check   13
;  :datatype-splits         7
;  :decisions               9
;  :del-clause              33
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             497
;  :mk-clause               33
;  :num-allocs              163357
;  :num-checks              14
;  :propagations            26
;  :quant-instantiations    26
;  :rlimit-count            188354)
; [then-branch: 7 | 0 < V@20@05 | live]
; [else-branch: 7 | !(0 < V@20@05) | live]
(push) ; 3
; [then-branch: 7 | 0 < V@20@05]
(assert (< 0 V@20@05))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 3
(push) ; 3
; [else-branch: 7 | !(0 < V@20@05)]
(assert (not (< 0 V@20@05)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies
  (< 0 V@20@05)
  (not (= visited@22@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second $t@26@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@26@05))
    ($Snap.second ($Snap.second $t@26@05)))))
(assert (= ($Snap.first ($Snap.second $t@26@05)) $Snap.unit))
; [eval] 0 < V ==> alen(opt_get1(visited)) == V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               103
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      17
;  :arith-assert-upper      12
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        4
;  :arith-pivots            16
;  :conflicts               4
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         8
;  :decisions               10
;  :del-clause              33
;  :final-checks            15
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             502
;  :mk-clause               34
;  :num-allocs              163864
;  :num-checks              15
;  :propagations            27
;  :quant-instantiations    26
;  :rlimit-count            189121)
(push) ; 3
(assert (not (< 0 V@20@05)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               105
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      17
;  :arith-assert-upper      13
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        4
;  :arith-pivots            16
;  :conflicts               4
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         9
;  :decisions               11
;  :del-clause              33
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             503
;  :mk-clause               34
;  :num-allocs              164236
;  :num-checks              16
;  :propagations            27
;  :quant-instantiations    26
;  :rlimit-count            189621)
; [then-branch: 8 | 0 < V@20@05 | live]
; [else-branch: 8 | !(0 < V@20@05) | live]
(push) ; 3
; [then-branch: 8 | 0 < V@20@05]
(assert (< 0 V@20@05))
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 4
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 5
(assert (not (not (= visited@22@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               105
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      18
;  :arith-assert-upper      13
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         4
;  :arith-offset-eqs        4
;  :arith-pivots            16
;  :conflicts               5
;  :datatype-accessor-ax    9
;  :datatype-constructor-ax 9
;  :datatype-occurs-check   17
;  :datatype-splits         9
;  :decisions               11
;  :del-clause              33
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             503
;  :mk-clause               34
;  :num-allocs              164372
;  :num-checks              17
;  :propagations            28
;  :quant-instantiations    26
;  :rlimit-count            189729)
(assert (not (= visited@22@05 (as None<option<array>>  option<array>))))
(pop) ; 4
; Joined path conditions
(assert (not (= visited@22@05 (as None<option<array>>  option<array>))))
(pop) ; 3
(push) ; 3
; [else-branch: 8 | !(0 < V@20@05)]
(assert (not (< 0 V@20@05)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 V@20@05)
  (and
    (< 0 V@20@05)
    (not (= visited@22@05 (as None<option<array>>  option<array>))))))
; Joined path conditions
(assert (implies
  (< 0 V@20@05)
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@05)) V@20@05)))
(assert (=
  ($Snap.second ($Snap.second $t@26@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@26@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@26@05))) $Snap.unit))
; [eval] 0 < V ==> 0 <= s
; [eval] 0 < V
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               119
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      21
;  :arith-assert-upper      14
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        4
;  :arith-pivots            18
;  :conflicts               5
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   19
;  :datatype-splits         10
;  :decisions               12
;  :del-clause              34
;  :final-checks            19
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             516
;  :mk-clause               40
;  :num-allocs              165010
;  :num-checks              18
;  :propagations            31
;  :quant-instantiations    31
;  :rlimit-count            190722)
(push) ; 3
(assert (not (< 0 V@20@05)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               121
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      21
;  :arith-assert-upper      15
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        4
;  :arith-pivots            18
;  :conflicts               5
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 11
;  :datatype-occurs-check   21
;  :datatype-splits         11
;  :decisions               13
;  :del-clause              34
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             517
;  :mk-clause               40
;  :num-allocs              165388
;  :num-checks              19
;  :propagations            32
;  :quant-instantiations    31
;  :rlimit-count            191227)
; [then-branch: 9 | 0 < V@20@05 | live]
; [else-branch: 9 | !(0 < V@20@05) | live]
(push) ; 3
; [then-branch: 9 | 0 < V@20@05]
(assert (< 0 V@20@05))
; [eval] 0 <= s
(pop) ; 3
(push) ; 3
; [else-branch: 9 | !(0 < V@20@05)]
(assert (not (< 0 V@20@05)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (< 0 V@20@05) (<= 0 s@23@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@26@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@05))))
  $Snap.unit))
; [eval] 0 < V ==> s < V
; [eval] 0 < V
(push) ; 2
(push) ; 3
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               135
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      25
;  :arith-assert-upper      16
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        4
;  :arith-pivots            20
;  :conflicts               5
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   23
;  :datatype-splits         12
;  :decisions               14
;  :del-clause              35
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             529
;  :mk-clause               42
;  :num-allocs              166015
;  :num-checks              20
;  :propagations            36
;  :quant-instantiations    36
;  :rlimit-count            192106)
(push) ; 3
(assert (not (< 0 V@20@05)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               137
;  :arith-add-rows          19
;  :arith-assert-diseq      3
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        4
;  :arith-pivots            20
;  :conflicts               5
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   25
;  :datatype-splits         13
;  :decisions               15
;  :del-clause              35
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             530
;  :mk-clause               42
;  :num-allocs              166401
;  :num-checks              21
;  :propagations            37
;  :quant-instantiations    36
;  :rlimit-count            192614)
; [then-branch: 10 | 0 < V@20@05 | live]
; [else-branch: 10 | !(0 < V@20@05) | live]
(push) ; 3
; [then-branch: 10 | 0 < V@20@05]
(assert (< 0 V@20@05))
; [eval] s < V
(pop) ; 3
(push) ; 3
; [else-branch: 10 | !(0 < V@20@05)]
(assert (not (< 0 V@20@05)))
(pop) ; 3
(pop) ; 2
; Joined path conditions
; Joined path conditions
(assert (implies (< 0 V@20@05) (< s@23@05 V@20@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
  $Snap.unit))
; [eval] 0 <= i1
(assert (<= 0 i1@21@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@05))))))
  $Snap.unit))
; [eval] i1 < V
(assert (< i1@21@05 V@20@05))
; [eval] aloc(opt_get1(visited), i1)
; [eval] opt_get1(visited)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= visited@22@05 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               155
;  :arith-add-rows          21
;  :arith-assert-diseq      3
;  :arith-assert-lower      32
;  :arith-assert-upper      18
;  :arith-bound-prop        4
;  :arith-conflicts         2
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        4
;  :arith-pivots            22
;  :conflicts               6
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   25
;  :datatype-splits         13
;  :decisions               15
;  :del-clause              35
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             545
;  :mk-clause               44
;  :num-allocs              166716
;  :num-checks              22
;  :propagations            42
;  :quant-instantiations    41
;  :rlimit-count            193355)
(assert (not (= visited@22@05 (as None<option<array>>  option<array>))))
(pop) ; 2
; Joined path conditions
(assert (not (= visited@22@05 (as None<option<array>>  option<array>))))
(push) ; 2
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 3
(assert (not (< i1@21@05 (alen<Int> (opt_get1 $Snap.unit visited@22@05)))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               155
;  :arith-add-rows          22
;  :arith-assert-diseq      3
;  :arith-assert-lower      32
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        4
;  :arith-pivots            22
;  :conflicts               7
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 13
;  :datatype-occurs-check   25
;  :datatype-splits         13
;  :decisions               15
;  :del-clause              35
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             546
;  :mk-clause               44
;  :num-allocs              166860
;  :num-checks              23
;  :propagations            42
;  :quant-instantiations    41
;  :rlimit-count            193517)
(assert (< i1@21@05 (alen<Int> (opt_get1 $Snap.unit visited@22@05))))
(pop) ; 2
; Joined path conditions
(assert (< i1@21@05 (alen<Int> (opt_get1 $Snap.unit visited@22@05))))
(assert (not
  (=
    (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@22@05) i1@21@05)
    $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@27@05 $Snap)
(assert (= $t@27@05 ($Snap.combine ($Snap.first $t@27@05) ($Snap.second $t@27@05))))
(assert (= ($Snap.first $t@27@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@24@05 $Ref.null))
(assert (=
  ($Snap.second $t@27@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@27@05))
    ($Snap.second ($Snap.second $t@27@05)))))
(assert (= ($Snap.first ($Snap.second $t@27@05)) $Snap.unit))
; [eval] exc == null && 0 < V ==> visited != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 11 | exc@24@05 == Null | live]
; [else-branch: 11 | exc@24@05 != Null | live]
(push) ; 4
; [then-branch: 11 | exc@24@05 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 11 | exc@24@05 != Null]
(assert (not (= exc@24@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               189
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               7
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   31
;  :datatype-splits         15
;  :decisions               18
;  :del-clause              50
;  :final-checks            29
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             564
;  :mk-clause               50
;  :num-allocs              168234
;  :num-checks              25
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            195217)
(push) ; 4
(assert (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               189
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               8
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   31
;  :datatype-splits         15
;  :decisions               18
;  :del-clause              50
;  :final-checks            29
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             564
;  :mk-clause               50
;  :num-allocs              168305
;  :num-checks              26
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            195269)
; [then-branch: 12 | 0 < V@20@05 && exc@24@05 == Null | live]
; [else-branch: 12 | !(0 < V@20@05 && exc@24@05 == Null) | dead]
(push) ; 4
; [then-branch: 12 | 0 < V@20@05 && exc@24@05 == Null]
(assert (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@20@05) (= exc@24@05 $Ref.null))
  (not (= visited@22@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@27@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@27@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@27@05))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(visited)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 13 | exc@24@05 == Null | live]
; [else-branch: 13 | exc@24@05 != Null | live]
(push) ; 4
; [then-branch: 13 | exc@24@05 == Null]
(assert (= exc@24@05 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 13 | exc@24@05 != Null]
(assert (not (= exc@24@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               203
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               8
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   34
;  :datatype-splits         16
;  :decisions               20
;  :del-clause              50
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             567
;  :mk-clause               50
;  :num-allocs              168985
;  :num-checks              27
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            196026)
(push) ; 4
(assert (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               203
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               9
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 18
;  :datatype-occurs-check   34
;  :datatype-splits         16
;  :decisions               20
;  :del-clause              50
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             567
;  :mk-clause               50
;  :num-allocs              169056
;  :num-checks              28
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            196078)
; [then-branch: 14 | 0 < V@20@05 && exc@24@05 == Null | live]
; [else-branch: 14 | !(0 < V@20@05 && exc@24@05 == Null) | dead]
(push) ; 4
; [then-branch: 14 | 0 < V@20@05 && exc@24@05 == Null]
(assert (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))
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
  (and (< 0 V@20@05) (= exc@24@05 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit visited@22@05)) V@20@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@27@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@27@05))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> 0 <= s
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 15 | exc@24@05 == Null | live]
; [else-branch: 15 | exc@24@05 != Null | live]
(push) ; 4
; [then-branch: 15 | exc@24@05 == Null]
(assert (= exc@24@05 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 15 | exc@24@05 != Null]
(assert (not (= exc@24@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               218
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               9
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   37
;  :datatype-splits         17
;  :decisions               22
;  :del-clause              50
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             570
;  :mk-clause               50
;  :num-allocs              169801
;  :num-checks              29
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            196904)
(push) ; 4
(assert (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               218
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               10
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   37
;  :datatype-splits         17
;  :decisions               22
;  :del-clause              50
;  :final-checks            33
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             570
;  :mk-clause               50
;  :num-allocs              169872
;  :num-checks              30
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            196956)
; [then-branch: 16 | 0 < V@20@05 && exc@24@05 == Null | live]
; [else-branch: 16 | !(0 < V@20@05 && exc@24@05 == Null) | dead]
(push) ; 4
; [then-branch: 16 | 0 < V@20@05 && exc@24@05 == Null]
(assert (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@20@05) (= exc@24@05 $Ref.null)) (<= 0 s@23@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> s < V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 17 | exc@24@05 == Null | live]
; [else-branch: 17 | exc@24@05 != Null | live]
(push) ; 4
; [then-branch: 17 | exc@24@05 == Null]
(assert (= exc@24@05 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 17 | exc@24@05 != Null]
(assert (not (= exc@24@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               234
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               10
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   40
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              50
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             573
;  :mk-clause               50
;  :num-allocs              170568
;  :num-checks              31
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            197746)
(push) ; 4
(assert (not (and (< 0 V@20@05) (= exc@24@05 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               234
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   40
;  :datatype-splits         18
;  :decisions               24
;  :del-clause              50
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             573
;  :mk-clause               50
;  :num-allocs              170639
;  :num-checks              32
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            197798)
; [then-branch: 18 | 0 < V@20@05 && exc@24@05 == Null | live]
; [else-branch: 18 | !(0 < V@20@05 && exc@24@05 == Null) | dead]
(push) ; 4
; [then-branch: 18 | 0 < V@20@05 && exc@24@05 == Null]
(assert (and (< 0 V@20@05) (= exc@24@05 $Ref.null)))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@20@05) (= exc@24@05 $Ref.null)) (< s@23@05 V@20@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= i1
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@24@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               251
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   45
;  :datatype-splits         19
;  :decisions               26
;  :del-clause              50
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             576
;  :mk-clause               50
;  :num-allocs              171293
;  :num-checks              33
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            198533)
(push) ; 4
(assert (not (= exc@24@05 $Ref.null)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               251
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   45
;  :datatype-splits         19
;  :decisions               26
;  :del-clause              50
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             576
;  :mk-clause               50
;  :num-allocs              171309
;  :num-checks              34
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            198544)
; [then-branch: 19 | exc@24@05 == Null | live]
; [else-branch: 19 | exc@24@05 != Null | dead]
(push) ; 4
; [then-branch: 19 | exc@24@05 == Null]
(assert (= exc@24@05 $Ref.null))
; [eval] 0 <= i1
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@24@05 $Ref.null) (<= 0 i1@21@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))))
  $Snap.unit))
; [eval] exc == null ==> i1 < V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@24@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               268
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   50
;  :datatype-splits         20
;  :decisions               28
;  :del-clause              50
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             579
;  :mk-clause               50
;  :num-allocs              171954
;  :num-checks              35
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            199271)
(push) ; 4
(assert (not (= exc@24@05 $Ref.null)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               268
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   50
;  :datatype-splits         20
;  :decisions               28
;  :del-clause              50
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             579
;  :mk-clause               50
;  :num-allocs              171970
;  :num-checks              36
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            199282)
; [then-branch: 20 | exc@24@05 == Null | live]
; [else-branch: 20 | exc@24@05 != Null | dead]
(push) ; 4
; [then-branch: 20 | exc@24@05 == Null]
(assert (= exc@24@05 $Ref.null))
; [eval] i1 < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@24@05 $Ref.null) (< i1@21@05 V@20@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@24@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   55
;  :datatype-splits         22
;  :decisions               31
;  :del-clause              50
;  :final-checks            41
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             582
;  :mk-clause               50
;  :num-allocs              172620
;  :num-checks              37
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            200009)
(push) ; 3
(assert (not (= exc@24@05 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   55
;  :datatype-splits         22
;  :decisions               31
;  :del-clause              50
;  :final-checks            41
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             582
;  :mk-clause               50
;  :num-allocs              172636
;  :num-checks              38
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            200020)
; [then-branch: 21 | exc@24@05 == Null | live]
; [else-branch: 21 | exc@24@05 != Null | dead]
(push) ; 3
; [then-branch: 21 | exc@24@05 == Null]
(assert (= exc@24@05 $Ref.null))
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
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05))))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(visited), i1).bool == false
; [eval] exc == null
(push) ; 4
(push) ; 5
(assert (not (not (= exc@24@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               298
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 31
;  :datatype-occurs-check   60
;  :datatype-splits         23
;  :decisions               33
;  :del-clause              50
;  :final-checks            43
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              173261
;  :num-checks              39
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            200679)
; [then-branch: 22 | exc@24@05 == Null | live]
; [else-branch: 22 | exc@24@05 != Null | dead]
(push) ; 5
; [then-branch: 22 | exc@24@05 == Null]
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
  (= exc@24@05 $Ref.null)
  (=
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@27@05)))))))))
    false)))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@28@05 void)
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
; [then-branch: 23 | True | live]
; [else-branch: 23 | False | live]
(push) ; 4
; [then-branch: 23 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 23 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               301
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               11
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 32
;  :datatype-occurs-check   61
;  :datatype-splits         23
;  :decisions               34
;  :del-clause              50
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              173829
;  :num-checks              40
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            201268)
(push) ; 4
(assert (not (< 0 V@20@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               301
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               12
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 32
;  :datatype-occurs-check   61
;  :datatype-splits         23
;  :decisions               34
;  :del-clause              50
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              173900
;  :num-checks              41
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            201316)
; [then-branch: 24 | 0 < V@20@05 | live]
; [else-branch: 24 | !(0 < V@20@05) | dead]
(push) ; 4
; [then-branch: 24 | 0 < V@20@05]
(assert (< 0 V@20@05))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null && 0 < V ==> alen(opt_get1(visited)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 25 | True | live]
; [else-branch: 25 | False | live]
(push) ; 4
; [then-branch: 25 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 25 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               12
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   62
;  :datatype-splits         23
;  :decisions               35
;  :del-clause              50
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              174473
;  :num-checks              42
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            201862)
(push) ; 4
(assert (not (< 0 V@20@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               13
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   62
;  :datatype-splits         23
;  :decisions               35
;  :del-clause              50
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              174544
;  :num-checks              43
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            201910)
; [then-branch: 26 | 0 < V@20@05 | live]
; [else-branch: 26 | !(0 < V@20@05) | dead]
(push) ; 4
; [then-branch: 26 | 0 < V@20@05]
(assert (< 0 V@20@05))
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
; [then-branch: 27 | True | live]
; [else-branch: 27 | False | live]
(push) ; 4
; [then-branch: 27 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 27 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               13
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   63
;  :datatype-splits         23
;  :decisions               36
;  :del-clause              50
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              175176
;  :num-checks              44
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            202501)
(push) ; 4
(assert (not (< 0 V@20@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               14
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   63
;  :datatype-splits         23
;  :decisions               36
;  :del-clause              50
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              175247
;  :num-checks              45
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            202549)
; [then-branch: 28 | 0 < V@20@05 | live]
; [else-branch: 28 | !(0 < V@20@05) | dead]
(push) ; 4
; [then-branch: 28 | 0 < V@20@05]
(assert (< 0 V@20@05))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
; [eval] exc == null && 0 < V ==> s < V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 29 | True | live]
; [else-branch: 29 | False | live]
(push) ; 4
; [then-branch: 29 | True]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 29 | False]
(assert false)
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (< 0 V@20@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               310
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               14
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 35
;  :datatype-occurs-check   64
;  :datatype-splits         23
;  :decisions               37
;  :del-clause              50
;  :final-checks            47
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              175820
;  :num-checks              46
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            203095)
(push) ; 4
(assert (not (< 0 V@20@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               310
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               15
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 35
;  :datatype-occurs-check   64
;  :datatype-splits         23
;  :decisions               37
;  :del-clause              50
;  :final-checks            47
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              175891
;  :num-checks              47
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            203143)
; [then-branch: 30 | 0 < V@20@05 | live]
; [else-branch: 30 | !(0 < V@20@05) | dead]
(push) ; 4
; [then-branch: 30 | 0 < V@20@05]
(assert (< 0 V@20@05))
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
; (:added-eqs               313
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               15
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   65
;  :datatype-splits         23
;  :decisions               38
;  :del-clause              50
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              176410
;  :num-checks              48
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            203623)
; [then-branch: 31 | True | live]
; [else-branch: 31 | False | dead]
(push) ; 4
; [then-branch: 31 | True]
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
; (:added-eqs               316
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               15
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 37
;  :datatype-occurs-check   66
;  :datatype-splits         23
;  :decisions               39
;  :del-clause              50
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              176922
;  :num-checks              49
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            204096)
; [then-branch: 32 | True | live]
; [else-branch: 32 | False | dead]
(push) ; 4
; [then-branch: 32 | True]
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
; (:added-eqs               319
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               15
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 38
;  :datatype-occurs-check   67
;  :datatype-splits         23
;  :decisions               40
;  :del-clause              50
;  :final-checks            50
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              177434
;  :num-checks              50
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            204564)
; [then-branch: 33 | True | live]
; [else-branch: 33 | False | dead]
(push) ; 3
; [then-branch: 33 | True]
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
; (:added-eqs               322
;  :arith-add-rows          23
;  :arith-assert-diseq      3
;  :arith-assert-lower      33
;  :arith-assert-upper      19
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            22
;  :conflicts               15
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   68
;  :datatype-splits         23
;  :decisions               41
;  :del-clause              50
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             584
;  :mk-clause               50
;  :num-allocs              177946
;  :num-checks              51
;  :propagations            46
;  :quant-instantiations    46
;  :rlimit-count            205047)
; [then-branch: 34 | True | live]
; [else-branch: 34 | False | dead]
(push) ; 5
; [then-branch: 34 | True]
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
; ---------- initializeWithZeros ----------
(declare-const this@29@05 $Ref)
(declare-const tid@30@05 Int)
(declare-const P@31@05 option<array>)
(declare-const V@32@05 Int)
(declare-const exc@33@05 $Ref)
(declare-const res@34@05 void)
(declare-const this@35@05 $Ref)
(declare-const tid@36@05 Int)
(declare-const P@37@05 option<array>)
(declare-const V@38@05 Int)
(declare-const exc@39@05 $Ref)
(declare-const res@40@05 void)
(push) ; 1
(declare-const $t@41@05 $Snap)
(assert (= $t@41@05 ($Snap.combine ($Snap.first $t@41@05) ($Snap.second $t@41@05))))
(assert (= ($Snap.first $t@41@05) $Snap.unit))
; [eval] this != null
(assert (not (= this@35@05 $Ref.null)))
(assert (=
  ($Snap.second $t@41@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@41@05))
    ($Snap.second ($Snap.second $t@41@05)))))
(assert (= ($Snap.first ($Snap.second $t@41@05)) $Snap.unit))
; [eval] P != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= P@37@05 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second $t@41@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@41@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@41@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@41@05))) $Snap.unit))
; [eval] alen(opt_get1(P)) == V
; [eval] alen(opt_get1(P))
; [eval] opt_get1(P)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (opt_get1 $Snap.unit P@37@05)) V@38@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@41@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))
  $Snap.unit))
; [eval] |this.P_seq| == V
; [eval] |this.P_seq|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05))))))
  V@38@05))
(declare-const k@42@05 Int)
(push) ; 2
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 3
; [then-branch: 35 | 0 <= k@42@05 | live]
; [else-branch: 35 | !(0 <= k@42@05) | live]
(push) ; 4
; [then-branch: 35 | 0 <= k@42@05]
(assert (<= 0 k@42@05))
; [eval] k < V
(pop) ; 4
(push) ; 4
; [else-branch: 35 | !(0 <= k@42@05)]
(assert (not (<= 0 k@42@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< k@42@05 V@38@05) (<= 0 k@42@05)))
; [eval] aloc(opt_get1(P), k)
; [eval] opt_get1(P)
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
(assert (not (< k@42@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               361
;  :arith-add-rows          25
;  :arith-assert-diseq      3
;  :arith-assert-lower      39
;  :arith-assert-upper      21
;  :arith-bound-prop        4
;  :arith-conflicts         3
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        5
;  :arith-pivots            26
;  :conflicts               15
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   68
;  :datatype-splits         23
;  :decisions               41
;  :del-clause              50
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             615
;  :mk-clause               53
;  :num-allocs              178500
;  :num-checks              52
;  :propagations            46
;  :quant-instantiations    54
;  :rlimit-count            206344)
(assert (< k@42@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 3
; Joined path conditions
(assert (< k@42@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 2
(declare-fun inv@43@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@42@05 Int)) (!
  (< k@42@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@42@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((k1@42@05 Int) (k2@42@05 Int)) (!
  (implies
    (and
      (and (< k1@42@05 V@38@05) (<= 0 k1@42@05))
      (and (< k2@42@05 V@38@05) (<= 0 k2@42@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k1@42@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k2@42@05)))
    (= k1@42@05 k2@42@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-add-rows          43
;  :arith-assert-diseq      8
;  :arith-assert-lower      48
;  :arith-assert-upper      24
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            35
;  :conflicts               19
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   68
;  :datatype-splits         23
;  :decisions               44
;  :del-clause              68
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             645
;  :mk-clause               71
;  :num-allocs              179036
;  :num-checks              53
;  :propagations            67
;  :quant-instantiations    65
;  :rlimit-count            207682)
; Definitional axioms for inverse functions
(assert (forall ((k@42@05 Int)) (!
  (implies
    (and (< k@42@05 V@38@05) (<= 0 k@42@05))
    (=
      (inv@43@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@42@05))
      k@42@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@42@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@43@05 r) V@38@05) (<= 0 (inv@43@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) (inv@43@05 r))
      r))
  :pattern ((inv@43@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@42@05 Int)) (!
  (implies
    (and (< k@42@05 V@38@05) (<= 0 k@42@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@42@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@42@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@44@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@43@05 r) V@38@05) (<= 0 (inv@43@05 r)))
    (=
      ($FVF.lookup_int (as sm@44@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))) r)))
  :pattern (($FVF.lookup_int (as sm@44@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))) r))
  :qid |qp.fvfValDef3|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))) r) r)
  :pattern (($FVF.lookup_int (as sm@44@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef4|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@43@05 r) V@38@05) (<= 0 (inv@43@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@44@05  $FVF<Int>) r) r))
  :pattern ((inv@43@05 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@45@05 $Snap)
(assert (= $t@45@05 ($Snap.combine ($Snap.first $t@45@05) ($Snap.second $t@45@05))))
(assert (= ($Snap.first $t@45@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@39@05 $Ref.null))
(assert (=
  ($Snap.second $t@45@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@45@05))
    ($Snap.second ($Snap.second $t@45@05)))))
(assert (= ($Snap.first ($Snap.second $t@45@05)) $Snap.unit))
; [eval] exc == null ==> P != (None(): option[array])
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@39@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               420
;  :arith-add-rows          43
;  :arith-assert-diseq      10
;  :arith-assert-lower      50
;  :arith-assert-upper      24
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            35
;  :conflicts               19
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 44
;  :datatype-occurs-check   75
;  :datatype-splits         28
;  :decisions               51
;  :del-clause              68
;  :final-checks            55
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.34
;  :mk-bool-var             661
;  :mk-clause               71
;  :num-allocs              180969
;  :num-checks              55
;  :propagations            69
;  :quant-instantiations    65
;  :rlimit-count            210609
;  :time                    0.00)
; [then-branch: 36 | exc@39@05 == Null | live]
; [else-branch: 36 | exc@39@05 != Null | dead]
(push) ; 4
; [then-branch: 36 | exc@39@05 == Null]
; [eval] P != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@39@05 $Ref.null)
  (not (= P@37@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@45@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@45@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@45@05))) $Snap.unit))
; [eval] exc == null ==> alen(opt_get1(P)) == V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@39@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               436
;  :arith-add-rows          43
;  :arith-assert-diseq      11
;  :arith-assert-lower      51
;  :arith-assert-upper      24
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            35
;  :conflicts               19
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 47
;  :datatype-occurs-check   79
;  :datatype-splits         31
;  :decisions               55
;  :del-clause              68
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.34
;  :mk-bool-var             666
;  :mk-clause               71
;  :num-allocs              181541
;  :num-checks              56
;  :propagations            70
;  :quant-instantiations    65
;  :rlimit-count            211298)
; [then-branch: 37 | exc@39@05 == Null | live]
; [else-branch: 37 | exc@39@05 != Null | dead]
(push) ; 4
; [then-branch: 37 | exc@39@05 == Null]
; [eval] alen(opt_get1(P)) == V
; [eval] alen(opt_get1(P))
; [eval] opt_get1(P)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@39@05 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit P@37@05)) V@38@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@45@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@39@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               454
;  :arith-add-rows          43
;  :arith-assert-diseq      12
;  :arith-assert-lower      52
;  :arith-assert-upper      24
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            35
;  :conflicts               19
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 51
;  :datatype-occurs-check   83
;  :datatype-splits         35
;  :decisions               60
;  :del-clause              68
;  :final-checks            59
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.34
;  :mk-bool-var             671
;  :mk-clause               71
;  :num-allocs              182112
;  :num-checks              57
;  :propagations            71
;  :quant-instantiations    65
;  :rlimit-count            211979)
; [then-branch: 38 | exc@39@05 == Null | live]
; [else-branch: 38 | exc@39@05 != Null | dead]
(push) ; 3
; [then-branch: 38 | exc@39@05 == Null]
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))
  $Snap.unit))
; [eval] exc == null ==> |this.P_seq| == V
; [eval] exc == null
(push) ; 4
(push) ; 5
(assert (not (not (= exc@39@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               474
;  :arith-add-rows          43
;  :arith-assert-diseq      13
;  :arith-assert-lower      53
;  :arith-assert-upper      24
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        5
;  :arith-pivots            35
;  :conflicts               19
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 55
;  :datatype-occurs-check   89
;  :datatype-splits         39
;  :decisions               65
;  :del-clause              68
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.34
;  :mk-bool-var             677
;  :mk-clause               71
;  :num-allocs              182695
;  :num-checks              58
;  :propagations            72
;  :quant-instantiations    65
;  :rlimit-count            212702)
; [then-branch: 39 | exc@39@05 == Null | live]
; [else-branch: 39 | exc@39@05 != Null | dead]
(push) ; 5
; [then-branch: 39 | exc@39@05 == Null]
; [eval] |this.P_seq| == V
; [eval] |this.P_seq|
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@39@05 $Ref.null)
  (=
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))
    V@38@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))))))
; [eval] exc == null
(push) ; 4
(assert (not (not (= exc@39@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               502
;  :arith-add-rows          43
;  :arith-assert-diseq      15
;  :arith-assert-lower      57
;  :arith-assert-upper      25
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        5
;  :arith-pivots            36
;  :conflicts               19
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   95
;  :datatype-splits         44
;  :decisions               71
;  :del-clause              68
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.35
;  :mk-bool-var             692
;  :mk-clause               74
;  :num-allocs              183332
;  :num-checks              59
;  :propagations            74
;  :quant-instantiations    68
;  :rlimit-count            213593)
; [then-branch: 40 | exc@39@05 == Null | live]
; [else-branch: 40 | exc@39@05 != Null | dead]
(push) ; 4
; [then-branch: 40 | exc@39@05 == Null]
(declare-const k@46@05 Int)
(push) ; 5
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 6
; [then-branch: 41 | 0 <= k@46@05 | live]
; [else-branch: 41 | !(0 <= k@46@05) | live]
(push) ; 7
; [then-branch: 41 | 0 <= k@46@05]
(assert (<= 0 k@46@05))
; [eval] k < V
(pop) ; 7
(push) ; 7
; [else-branch: 41 | !(0 <= k@46@05)]
(assert (not (<= 0 k@46@05)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (and (< k@46@05 V@38@05) (<= 0 k@46@05)))
; [eval] aloc(opt_get1(P), k)
; [eval] opt_get1(P)
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
(assert (not (< k@46@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               504
;  :arith-add-rows          45
;  :arith-assert-diseq      15
;  :arith-assert-lower      59
;  :arith-assert-upper      27
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        5
;  :arith-pivots            38
;  :conflicts               19
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   95
;  :datatype-splits         44
;  :decisions               71
;  :del-clause              68
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.35
;  :mk-bool-var             697
;  :mk-clause               74
;  :num-allocs              183465
;  :num-checks              60
;  :propagations            74
;  :quant-instantiations    68
;  :rlimit-count            213824)
(assert (< k@46@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 6
; Joined path conditions
(assert (< k@46@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 5
(declare-fun inv@47@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@46@05 Int)) (!
  (< k@46@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@46@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 5
(assert (not (forall ((k1@46@05 Int) (k2@46@05 Int)) (!
  (implies
    (and
      (and (< k1@46@05 V@38@05) (<= 0 k1@46@05))
      (and (< k2@46@05 V@38@05) (<= 0 k2@46@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k1@46@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k2@46@05)))
    (= k1@46@05 k2@46@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               512
;  :arith-add-rows          50
;  :arith-assert-diseq      16
;  :arith-assert-lower      63
;  :arith-assert-upper      27
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        5
;  :arith-pivots            44
;  :conflicts               20
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 60
;  :datatype-occurs-check   95
;  :datatype-splits         44
;  :decisions               71
;  :del-clause              75
;  :final-checks            63
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             719
;  :mk-clause               81
;  :num-allocs              184024
;  :num-checks              61
;  :propagations            74
;  :quant-instantiations    79
;  :rlimit-count            214764)
; Definitional axioms for inverse functions
(assert (forall ((k@46@05 Int)) (!
  (implies
    (and (< k@46@05 V@38@05) (<= 0 k@46@05))
    (=
      (inv@47@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@46@05))
      k@46@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@46@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@47@05 r) V@38@05) (<= 0 (inv@47@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) (inv@47@05 r))
      r))
  :pattern ((inv@47@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@46@05 Int)) (!
  (implies
    (and (< k@46@05 V@38@05) (<= 0 k@46@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@46@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@46@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@48@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@47@05 r) V@38@05) (<= 0 (inv@47@05 r)))
    (=
      ($FVF.lookup_int (as sm@48@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))) r)))
  :pattern (($FVF.lookup_int (as sm@48@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))) r))
  :qid |qp.fvfValDef5|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))) r) r)
  :pattern (($FVF.lookup_int (as sm@48@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef6|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@47@05 r) V@38@05) (<= 0 (inv@47@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@48@05  $FVF<Int>) r) r))
  :pattern ((inv@47@05 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))))
  $Snap.unit))
; [eval] exc == null ==> (forall i1: Int :: { aloc(opt_get1(P), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(P), i1).int == 0)
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@39@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               537
;  :arith-add-rows          50
;  :arith-assert-diseq      18
;  :arith-assert-lower      65
;  :arith-assert-upper      27
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        5
;  :arith-pivots            44
;  :conflicts               20
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   101
;  :datatype-splits         49
;  :decisions               77
;  :del-clause              75
;  :final-checks            65
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.37
;  :mk-bool-var             732
;  :mk-clause               81
;  :num-allocs              185498
;  :num-checks              62
;  :propagations            76
;  :quant-instantiations    79
;  :rlimit-count            217378)
; [then-branch: 42 | exc@39@05 == Null | live]
; [else-branch: 42 | exc@39@05 != Null | dead]
(push) ; 6
; [then-branch: 42 | exc@39@05 == Null]
; [eval] (forall i1: Int :: { aloc(opt_get1(P), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(P), i1).int == 0)
(declare-const i1@49@05 Int)
(push) ; 7
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(P), i1).int == 0
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 8
; [then-branch: 43 | 0 <= i1@49@05 | live]
; [else-branch: 43 | !(0 <= i1@49@05) | live]
(push) ; 9
; [then-branch: 43 | 0 <= i1@49@05]
(assert (<= 0 i1@49@05))
; [eval] i1 < V
(pop) ; 9
(push) ; 9
; [else-branch: 43 | !(0 <= i1@49@05)]
(assert (not (<= 0 i1@49@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 44 | i1@49@05 < V@38@05 && 0 <= i1@49@05 | live]
; [else-branch: 44 | !(i1@49@05 < V@38@05 && 0 <= i1@49@05) | live]
(push) ; 9
; [then-branch: 44 | i1@49@05 < V@38@05 && 0 <= i1@49@05]
(assert (and (< i1@49@05 V@38@05) (<= 0 i1@49@05)))
; [eval] aloc(opt_get1(P), i1).int == 0
; [eval] aloc(opt_get1(P), i1)
; [eval] opt_get1(P)
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
(assert (not (< i1@49@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               539
;  :arith-add-rows          52
;  :arith-assert-diseq      18
;  :arith-assert-lower      68
;  :arith-assert-upper      28
;  :arith-bound-prop        4
;  :arith-conflicts         5
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        5
;  :arith-pivots            46
;  :conflicts               20
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   101
;  :datatype-splits         49
;  :decisions               77
;  :del-clause              75
;  :final-checks            65
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.37
;  :mk-bool-var             737
;  :mk-clause               81
;  :num-allocs              185613
;  :num-checks              63
;  :propagations            76
;  :quant-instantiations    79
;  :rlimit-count            217627)
(assert (< i1@49@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 10
; Joined path conditions
(assert (< i1@49@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@48@05  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05)))
(push) ; 10
(assert (not (and
  (<
    (inv@47@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))
    V@38@05)
  (<=
    0
    (inv@47@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               555
;  :arith-add-rows          64
;  :arith-assert-diseq      18
;  :arith-assert-lower      70
;  :arith-assert-upper      31
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        10
;  :arith-pivots            49
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 65
;  :datatype-occurs-check   101
;  :datatype-splits         49
;  :decisions               77
;  :del-clause              75
;  :final-checks            65
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             762
;  :mk-clause               90
;  :num-allocs              185975
;  :num-checks              64
;  :propagations            79
;  :quant-instantiations    92
;  :rlimit-count            218449)
(pop) ; 9
(push) ; 9
; [else-branch: 44 | !(i1@49@05 < V@38@05 && 0 <= i1@49@05)]
(assert (not (and (< i1@49@05 V@38@05) (<= 0 i1@49@05))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (and (< i1@49@05 V@38@05) (<= 0 i1@49@05))
  (and
    (< i1@49@05 V@38@05)
    (<= 0 i1@49@05)
    (< i1@49@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@48@05  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05)))))
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@49@05 Int)) (!
  (implies
    (and (< i1@49@05 V@38@05) (<= 0 i1@49@05))
    (and
      (< i1@49@05 V@38@05)
      (<= 0 i1@49@05)
      (< i1@49@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@48@05  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (= exc@39@05 $Ref.null)
  (forall ((i1@49@05 Int)) (!
    (implies
      (and (< i1@49@05 V@38@05) (<= 0 i1@49@05))
      (and
        (< i1@49@05 V@38@05)
        (<= 0 i1@49@05)
        (< i1@49@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@48@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@39@05 $Ref.null)
  (forall ((i1@49@05 Int)) (!
    (implies
      (and (< i1@49@05 V@38@05) (<= 0 i1@49@05))
      (=
        ($FVF.lookup_int (as sm@48@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@49@05))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))))
  $Snap.unit))
; [eval] exc == null ==> (forall i1: Int :: { this.P_seq[i1] } 0 <= i1 && i1 < V ==> this.P_seq[i1] == 0)
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@39@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-add-rows          68
;  :arith-assert-diseq      20
;  :arith-assert-lower      72
;  :arith-assert-upper      31
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         15
;  :arith-offset-eqs        10
;  :arith-pivots            53
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   105
;  :datatype-splits         53
;  :decisions               82
;  :del-clause              84
;  :final-checks            67
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.38
;  :mk-bool-var             769
;  :mk-clause               90
;  :num-allocs              186881
;  :num-checks              65
;  :propagations            81
;  :quant-instantiations    92
;  :rlimit-count            219894
;  :time                    0.01)
; [then-branch: 45 | exc@39@05 == Null | live]
; [else-branch: 45 | exc@39@05 != Null | dead]
(push) ; 6
; [then-branch: 45 | exc@39@05 == Null]
; [eval] (forall i1: Int :: { this.P_seq[i1] } 0 <= i1 && i1 < V ==> this.P_seq[i1] == 0)
(declare-const i1@50@05 Int)
(push) ; 7
; [eval] 0 <= i1 && i1 < V ==> this.P_seq[i1] == 0
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 8
; [then-branch: 46 | 0 <= i1@50@05 | live]
; [else-branch: 46 | !(0 <= i1@50@05) | live]
(push) ; 9
; [then-branch: 46 | 0 <= i1@50@05]
(assert (<= 0 i1@50@05))
; [eval] i1 < V
(pop) ; 9
(push) ; 9
; [else-branch: 46 | !(0 <= i1@50@05)]
(assert (not (<= 0 i1@50@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 47 | i1@50@05 < V@38@05 && 0 <= i1@50@05 | live]
; [else-branch: 47 | !(i1@50@05 < V@38@05 && 0 <= i1@50@05) | live]
(push) ; 9
; [then-branch: 47 | i1@50@05 < V@38@05 && 0 <= i1@50@05]
(assert (and (< i1@50@05 V@38@05) (<= 0 i1@50@05)))
; [eval] this.P_seq[i1] == 0
; [eval] this.P_seq[i1]
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i1@50@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               575
;  :arith-add-rows          70
;  :arith-assert-diseq      20
;  :arith-assert-lower      75
;  :arith-assert-upper      32
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        10
;  :arith-pivots            55
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   105
;  :datatype-splits         53
;  :decisions               82
;  :del-clause              84
;  :final-checks            67
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.38
;  :mk-bool-var             774
;  :mk-clause               90
;  :num-allocs              186991
;  :num-checks              66
;  :propagations            81
;  :quant-instantiations    92
;  :rlimit-count            220122)
(push) ; 10
(assert (not (<
  i1@50@05
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               575
;  :arith-add-rows          70
;  :arith-assert-diseq      20
;  :arith-assert-lower      75
;  :arith-assert-upper      32
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        10
;  :arith-pivots            55
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 69
;  :datatype-occurs-check   105
;  :datatype-splits         53
;  :decisions               82
;  :del-clause              84
;  :final-checks            67
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.38
;  :mk-bool-var             774
;  :mk-clause               90
;  :num-allocs              187010
;  :num-checks              67
;  :propagations            81
;  :quant-instantiations    92
;  :rlimit-count            220142)
(pop) ; 9
(push) ; 9
; [else-branch: 47 | !(i1@50@05 < V@38@05 && 0 <= i1@50@05)]
(assert (not (and (< i1@50@05 V@38@05) (<= 0 i1@50@05))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  (= exc@39@05 $Ref.null)
  (forall ((i1@50@05 Int)) (!
    (implies
      (and (< i1@50@05 V@38@05) (<= 0 i1@50@05))
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))
          i1@50@05)
        0))
    :pattern ((Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@05)))))
      i1@50@05))
    :qid |prog.l<no position>|))))
(pop) ; 4
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@51@05 void)
; [exec]
; var res1: void
(declare-const res1@52@05 void)
; [exec]
; var evaluationDummy: void
(declare-const evaluationDummy@53@05 void)
; [exec]
; var evaluationDummy1: Seq[Int]
(declare-const evaluationDummy1@54@05 Seq<Int>)
; [exec]
; exc := null
; [exec]
; exc, res1 := do_par_$unknown$(P, V)
; [eval] 0 < V ==> P != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@38@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               582
;  :arith-add-rows          71
;  :arith-assert-diseq      21
;  :arith-assert-lower      78
;  :arith-assert-upper      33
;  :arith-bound-prop        7
;  :arith-conflicts         6
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         17
;  :arith-offset-eqs        10
;  :arith-pivots            60
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 71
;  :datatype-occurs-check   108
;  :datatype-splits         55
;  :decisions               85
;  :del-clause              88
;  :final-checks            69
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             780
;  :mk-clause               91
;  :num-allocs              187582
;  :num-checks              68
;  :propagations            82
;  :quant-instantiations    92
;  :rlimit-count            220811)
(push) ; 4
(assert (not (< 0 V@38@05)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               591
;  :arith-add-rows          73
;  :arith-assert-diseq      21
;  :arith-assert-lower      79
;  :arith-assert-upper      36
;  :arith-bound-prop        8
;  :arith-conflicts         6
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            64
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   111
;  :datatype-splits         57
;  :decisions               87
;  :del-clause              90
;  :final-checks            71
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             786
;  :mk-clause               93
;  :num-allocs              188107
;  :num-checks              69
;  :propagations            84
;  :quant-instantiations    92
;  :rlimit-count            221410)
; [then-branch: 48 | 0 < V@38@05 | live]
; [else-branch: 48 | !(0 < V@38@05) | live]
(push) ; 4
; [then-branch: 48 | 0 < V@38@05]
(assert (< 0 V@38@05))
; [eval] P != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(push) ; 4
; [else-branch: 48 | !(0 < V@38@05)]
(assert (not (< 0 V@38@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@38@05) (not (= P@37@05 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               591
;  :arith-add-rows          73
;  :arith-assert-diseq      21
;  :arith-assert-lower      79
;  :arith-assert-upper      36
;  :arith-bound-prop        8
;  :arith-conflicts         6
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         18
;  :arith-offset-eqs        10
;  :arith-pivots            64
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 73
;  :datatype-occurs-check   111
;  :datatype-splits         57
;  :decisions               87
;  :del-clause              90
;  :final-checks            71
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             786
;  :mk-clause               93
;  :num-allocs              188138
;  :num-checks              70
;  :propagations            84
;  :quant-instantiations    92
;  :rlimit-count            221455)
(assert (implies (< 0 V@38@05) (not (= P@37@05 (as None<option<array>>  option<array>)))))
; [eval] 0 < V ==> alen(opt_get1(P)) == V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@38@05))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               598
;  :arith-add-rows          76
;  :arith-assert-diseq      22
;  :arith-assert-lower      82
;  :arith-assert-upper      37
;  :arith-bound-prop        9
;  :arith-conflicts         6
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         19
;  :arith-offset-eqs        10
;  :arith-pivots            66
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 75
;  :datatype-occurs-check   114
;  :datatype-splits         59
;  :decisions               89
;  :del-clause              92
;  :final-checks            73
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             792
;  :mk-clause               95
;  :num-allocs              188657
;  :num-checks              71
;  :propagations            85
;  :quant-instantiations    92
;  :rlimit-count            222074)
(push) ; 4
(assert (not (< 0 V@38@05)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               607
;  :arith-add-rows          79
;  :arith-assert-diseq      22
;  :arith-assert-lower      83
;  :arith-assert-upper      40
;  :arith-bound-prop        10
;  :arith-conflicts         6
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         20
;  :arith-offset-eqs        10
;  :arith-pivots            69
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   117
;  :datatype-splits         61
;  :decisions               91
;  :del-clause              94
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             798
;  :mk-clause               97
;  :num-allocs              189178
;  :num-checks              72
;  :propagations            87
;  :quant-instantiations    92
;  :rlimit-count            222671)
; [then-branch: 49 | 0 < V@38@05 | live]
; [else-branch: 49 | !(0 < V@38@05) | live]
(push) ; 4
; [then-branch: 49 | 0 < V@38@05]
(assert (< 0 V@38@05))
; [eval] alen(opt_get1(P)) == V
; [eval] alen(opt_get1(P))
; [eval] opt_get1(P)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 49 | !(0 < V@38@05)]
(assert (not (< 0 V@38@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@38@05) (= (alen<Int> (opt_get1 $Snap.unit P@37@05)) V@38@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               609
;  :arith-add-rows          82
;  :arith-assert-diseq      23
;  :arith-assert-lower      86
;  :arith-assert-upper      41
;  :arith-bound-prop        11
;  :arith-conflicts         6
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        10
;  :arith-pivots            72
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   117
;  :datatype-splits         61
;  :decisions               91
;  :del-clause              95
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             802
;  :mk-clause               98
;  :num-allocs              189281
;  :num-checks              73
;  :propagations            88
;  :quant-instantiations    92
;  :rlimit-count            222836)
(assert (implies (< 0 V@38@05) (= (alen<Int> (opt_get1 $Snap.unit P@37@05)) V@38@05)))
(declare-const i1@55@05 Int)
(push) ; 3
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 4
; [then-branch: 50 | 0 <= i1@55@05 | live]
; [else-branch: 50 | !(0 <= i1@55@05) | live]
(push) ; 5
; [then-branch: 50 | 0 <= i1@55@05]
(assert (<= 0 i1@55@05))
; [eval] i1 < V
(pop) ; 5
(push) ; 5
; [else-branch: 50 | !(0 <= i1@55@05)]
(assert (not (<= 0 i1@55@05)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i1@55@05 V@38@05) (<= 0 i1@55@05)))
; [eval] aloc(opt_get1(P), i1)
; [eval] opt_get1(P)
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
(assert (not (< i1@55@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               611
;  :arith-add-rows          84
;  :arith-assert-diseq      24
;  :arith-assert-lower      89
;  :arith-assert-upper      43
;  :arith-bound-prop        12
;  :arith-conflicts         6
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        10
;  :arith-pivots            73
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   117
;  :datatype-splits         61
;  :decisions               91
;  :del-clause              95
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.37
;  :mk-bool-var             807
;  :mk-clause               99
;  :num-allocs              189406
;  :num-checks              74
;  :propagations            89
;  :quant-instantiations    92
;  :rlimit-count            223060)
(assert (< i1@55@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 4
; Joined path conditions
(assert (< i1@55@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 3
(declare-fun inv@56@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@55@05 Int)) (!
  (< i1@55@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@55@05))
  :qid |int-aux|)))
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i11@55@05 Int) (i12@55@05 Int)) (!
  (implies
    (and
      (and
        (and (< i11@55@05 V@38@05) (<= 0 i11@55@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@44@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i11@55@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i11@55@05)))
      (and
        (and (< i12@55@05 V@38@05) (<= 0 i12@55@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@44@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i12@55@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i12@55@05)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i11@55@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i12@55@05)))
    (= i11@55@05 i12@55@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               620
;  :arith-add-rows          92
;  :arith-assert-diseq      25
;  :arith-assert-lower      93
;  :arith-assert-upper      43
;  :arith-bound-prop        12
;  :arith-conflicts         6
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        10
;  :arith-pivots            77
;  :conflicts               22
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   117
;  :datatype-splits         61
;  :decisions               91
;  :del-clause              104
;  :final-checks            75
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.38
;  :mk-bool-var             834
;  :mk-clause               107
;  :num-allocs              189970
;  :num-checks              75
;  :propagations            89
;  :quant-instantiations    105
;  :rlimit-count            224145)
; Definitional axioms for inverse functions
(assert (forall ((i1@55@05 Int)) (!
  (implies
    (and (< i1@55@05 V@38@05) (<= 0 i1@55@05))
    (=
      (inv@56@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@55@05))
      i1@55@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@55@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@56@05 r) V@38@05) (<= 0 (inv@56@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) (inv@56@05 r))
      r))
  :pattern ((inv@56@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@56@05 r) V@38@05) (<= 0 (inv@56@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@44@05  $FVF<Int>) r) r))
  :pattern ((inv@56@05 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@57@05 ((r $Ref)) $Perm
  (ite
    (and (< (inv@56@05 r) V@38@05) (<= 0 (inv@56@05 r)))
    ($Perm.min
      (ite
        (and (< (inv@43@05 r) V@38@05) (<= 0 (inv@43@05 r)))
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
        (and (< (inv@43@05 r) V@38@05) (<= 0 (inv@43@05 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@57@05 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               687
;  :arith-add-rows          117
;  :arith-assert-diseq      35
;  :arith-assert-lower      118
;  :arith-assert-upper      57
;  :arith-bound-prop        14
;  :arith-conflicts         10
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        13
;  :arith-pivots            89
;  :conflicts               30
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 79
;  :datatype-occurs-check   120
;  :datatype-splits         63
;  :decisions               101
;  :del-clause              153
;  :final-checks            77
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :minimized-lits          1
;  :mk-bool-var             930
;  :mk-clause               156
;  :num-allocs              191604
;  :num-checks              77
;  :propagations            132
;  :quant-instantiations    143
;  :rlimit-count            227228
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 3
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@56@05 r) V@38@05) (<= 0 (inv@56@05 r)))
    (= (- $Perm.Write (pTaken@57@05 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               703
;  :arith-add-rows          129
;  :arith-assert-diseq      38
;  :arith-assert-lower      124
;  :arith-assert-upper      63
;  :arith-bound-prop        16
;  :arith-conflicts         11
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        13
;  :arith-pivots            95
;  :conflicts               31
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 79
;  :datatype-occurs-check   120
;  :datatype-splits         63
;  :decisions               101
;  :del-clause              171
;  :final-checks            77
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :minimized-lits          1
;  :mk-bool-var             967
;  :mk-clause               174
;  :num-allocs              192021
;  :num-checks              78
;  :propagations            138
;  :quant-instantiations    156
;  :rlimit-count            228318)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
(declare-const exc@58@05 $Ref)
(declare-const res@59@05 void)
(declare-const $t@60@05 $Snap)
(assert (= $t@60@05 ($Snap.combine ($Snap.first $t@60@05) ($Snap.second $t@60@05))))
(assert (= ($Snap.first $t@60@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@58@05 $Ref.null))
(assert (=
  ($Snap.second $t@60@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@60@05))
    ($Snap.second ($Snap.second $t@60@05)))))
(assert (= ($Snap.first ($Snap.second $t@60@05)) $Snap.unit))
; [eval] exc == null && 0 < V ==> P != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 51 | exc@58@05 == Null | live]
; [else-branch: 51 | exc@58@05 != Null | live]
(push) ; 4
; [then-branch: 51 | exc@58@05 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 51 | exc@58@05 != Null]
(assert (not (= exc@58@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@38@05) (= exc@58@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               727
;  :arith-add-rows          130
;  :arith-assert-diseq      39
;  :arith-assert-lower      127
;  :arith-assert-upper      64
;  :arith-bound-prop        17
;  :arith-conflicts         11
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        13
;  :arith-pivots            97
;  :conflicts               31
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 82
;  :datatype-occurs-check   124
;  :datatype-splits         66
;  :decisions               104
;  :del-clause              173
;  :final-checks            79
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             979
;  :mk-clause               176
;  :num-allocs              192715
;  :num-checks              79
;  :propagations            139
;  :quant-instantiations    156
;  :rlimit-count            229227)
(push) ; 4
(assert (not (and (< 0 V@38@05) (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               740
;  :arith-add-rows          133
;  :arith-assert-diseq      39
;  :arith-assert-lower      128
;  :arith-assert-upper      67
;  :arith-bound-prop        18
;  :arith-conflicts         11
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         30
;  :arith-offset-eqs        13
;  :arith-pivots            101
;  :conflicts               31
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 85
;  :datatype-occurs-check   128
;  :datatype-splits         69
;  :decisions               107
;  :del-clause              175
;  :final-checks            81
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             986
;  :mk-clause               178
;  :num-allocs              193249
;  :num-checks              80
;  :propagations            141
;  :quant-instantiations    156
;  :rlimit-count            229856)
; [then-branch: 52 | 0 < V@38@05 && exc@58@05 == Null | live]
; [else-branch: 52 | !(0 < V@38@05 && exc@58@05 == Null) | live]
(push) ; 4
; [then-branch: 52 | 0 < V@38@05 && exc@58@05 == Null]
(assert (and (< 0 V@38@05) (= exc@58@05 $Ref.null)))
; [eval] P != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(push) ; 4
; [else-branch: 52 | !(0 < V@38@05 && exc@58@05 == Null)]
(assert (not (and (< 0 V@38@05) (= exc@58@05 $Ref.null))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and (< 0 V@38@05) (= exc@58@05 $Ref.null))
  (not (= P@37@05 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@60@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@60@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@60@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@60@05))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(P)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 53 | exc@58@05 == Null | live]
; [else-branch: 53 | exc@58@05 != Null | live]
(push) ; 4
; [then-branch: 53 | exc@58@05 == Null]
(assert (= exc@58@05 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 53 | exc@58@05 != Null]
(assert (not (= exc@58@05 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@38@05) (= exc@58@05 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               758
;  :arith-add-rows          136
;  :arith-assert-diseq      40
;  :arith-assert-lower      131
;  :arith-assert-upper      68
;  :arith-bound-prop        19
;  :arith-conflicts         11
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        13
;  :arith-pivots            104
;  :conflicts               31
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 88
;  :datatype-occurs-check   132
;  :datatype-splits         72
;  :decisions               110
;  :del-clause              177
;  :final-checks            83
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             995
;  :mk-clause               180
;  :num-allocs              193890
;  :num-checks              81
;  :propagations            142
;  :quant-instantiations    156
;  :rlimit-count            230722)
(push) ; 4
(assert (not (and (< 0 V@38@05) (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               772
;  :arith-add-rows          139
;  :arith-assert-diseq      40
;  :arith-assert-lower      132
;  :arith-assert-upper      71
;  :arith-bound-prop        20
;  :arith-conflicts         11
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         32
;  :arith-offset-eqs        13
;  :arith-pivots            108
;  :conflicts               31
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 91
;  :datatype-occurs-check   136
;  :datatype-splits         75
;  :decisions               113
;  :del-clause              179
;  :final-checks            85
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             1002
;  :mk-clause               182
;  :num-allocs              194428
;  :num-checks              82
;  :propagations            144
;  :quant-instantiations    156
;  :rlimit-count            231354)
; [then-branch: 54 | 0 < V@38@05 && exc@58@05 == Null | live]
; [else-branch: 54 | !(0 < V@38@05 && exc@58@05 == Null) | live]
(push) ; 4
; [then-branch: 54 | 0 < V@38@05 && exc@58@05 == Null]
(assert (and (< 0 V@38@05) (= exc@58@05 $Ref.null)))
; [eval] alen(opt_get1(P)) == V
; [eval] alen(opt_get1(P))
; [eval] opt_get1(P)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 5
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 54 | !(0 < V@38@05 && exc@58@05 == Null)]
(assert (not (and (< 0 V@38@05) (= exc@58@05 $Ref.null))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (and (< 0 V@38@05) (= exc@58@05 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit P@37@05)) V@38@05)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@60@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05)))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               792
;  :arith-add-rows          142
;  :arith-assert-diseq      42
;  :arith-assert-lower      136
;  :arith-assert-upper      72
;  :arith-bound-prop        21
;  :arith-conflicts         11
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        13
;  :arith-pivots            110
;  :conflicts               31
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   140
;  :datatype-splits         79
;  :decisions               118
;  :del-clause              180
;  :final-checks            87
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             1011
;  :mk-clause               183
;  :num-allocs              195075
;  :num-checks              83
;  :propagations            146
;  :quant-instantiations    156
;  :rlimit-count            232186)
(push) ; 3
(assert (not (= exc@58@05 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               792
;  :arith-add-rows          142
;  :arith-assert-diseq      42
;  :arith-assert-lower      136
;  :arith-assert-upper      72
;  :arith-bound-prop        21
;  :arith-conflicts         11
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         33
;  :arith-offset-eqs        13
;  :arith-pivots            110
;  :conflicts               31
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   140
;  :datatype-splits         79
;  :decisions               118
;  :del-clause              180
;  :final-checks            87
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             1011
;  :mk-clause               183
;  :num-allocs              195092
;  :num-checks              84
;  :propagations            146
;  :quant-instantiations    156
;  :rlimit-count            232197)
; [then-branch: 55 | exc@58@05 == Null | live]
; [else-branch: 55 | exc@58@05 != Null | dead]
(push) ; 3
; [then-branch: 55 | exc@58@05 == Null]
(assert (= exc@58@05 $Ref.null))
(declare-const unknown@61@05 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 56 | 0 <= unknown@61@05 | live]
; [else-branch: 56 | !(0 <= unknown@61@05) | live]
(push) ; 6
; [then-branch: 56 | 0 <= unknown@61@05]
(assert (<= 0 unknown@61@05))
; [eval] unknown < V
(pop) ; 6
(push) ; 6
; [else-branch: 56 | !(0 <= unknown@61@05)]
(assert (not (<= 0 unknown@61@05)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< unknown@61@05 V@38@05) (<= 0 unknown@61@05)))
; [eval] aloc(opt_get1(P), unknown)
; [eval] opt_get1(P)
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
(assert (not (< unknown@61@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               794
;  :arith-add-rows          145
;  :arith-assert-diseq      43
;  :arith-assert-lower      140
;  :arith-assert-upper      73
;  :arith-bound-prop        22
;  :arith-conflicts         11
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        13
;  :arith-pivots            112
;  :conflicts               31
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   140
;  :datatype-splits         79
;  :decisions               118
;  :del-clause              180
;  :final-checks            87
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             1016
;  :mk-clause               184
;  :num-allocs              195208
;  :num-checks              85
;  :propagations            147
;  :quant-instantiations    156
;  :rlimit-count            232451)
(assert (< unknown@61@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 5
; Joined path conditions
(assert (< unknown@61@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 4
(declare-fun inv@62@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@61@05 Int)) (!
  (< unknown@61@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@61@05))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@61@05 Int) (unknown2@61@05 Int)) (!
  (implies
    (and
      (and (< unknown1@61@05 V@38@05) (<= 0 unknown1@61@05))
      (and (< unknown2@61@05 V@38@05) (<= 0 unknown2@61@05))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown1@61@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown2@61@05)))
    (= unknown1@61@05 unknown2@61@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               803
;  :arith-add-rows          149
;  :arith-assert-diseq      44
;  :arith-assert-lower      144
;  :arith-assert-upper      73
;  :arith-bound-prop        22
;  :arith-conflicts         11
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        13
;  :arith-pivots            114
;  :conflicts               32
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 95
;  :datatype-occurs-check   140
;  :datatype-splits         79
;  :decisions               118
;  :del-clause              188
;  :final-checks            87
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.40
;  :minimized-lits          1
;  :mk-bool-var             1039
;  :mk-clause               191
;  :num-allocs              195737
;  :num-checks              86
;  :propagations            147
;  :quant-instantiations    171
;  :rlimit-count            233396)
; Definitional axioms for inverse functions
(assert (forall ((unknown@61@05 Int)) (!
  (implies
    (and (< unknown@61@05 V@38@05) (<= 0 unknown@61@05))
    (=
      (inv@62@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@61@05))
      unknown@61@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@61@05))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@62@05 r) V@38@05) (<= 0 (inv@62@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) (inv@62@05 r))
      r))
  :pattern ((inv@62@05 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@61@05 Int)) (!
  (implies
    (and (< unknown@61@05 V@38@05) (<= 0 unknown@61@05))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@61@05)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@61@05))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@63@05 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@62@05 r) V@38@05) (<= 0 (inv@62@05 r)))
    (=
      ($FVF.lookup_int (as sm@63@05  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05))))) r)))
  :pattern (($FVF.lookup_int (as sm@63@05  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05))))) r))
  :qid |qp.fvfValDef7|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@05))))) r) r)
  :pattern (($FVF.lookup_int (as sm@63@05  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef8|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@62@05 r) V@38@05) (<= 0 (inv@62@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) r) r))
  :pattern ((inv@62@05 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@05))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(P), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(P), unknown).int == 0)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               816
;  :arith-add-rows          149
;  :arith-assert-diseq      45
;  :arith-assert-lower      145
;  :arith-assert-upper      73
;  :arith-bound-prop        22
;  :arith-conflicts         11
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        13
;  :arith-pivots            114
;  :conflicts               32
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   144
;  :datatype-splits         82
;  :decisions               122
;  :del-clause              188
;  :final-checks            89
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             1049
;  :mk-clause               191
;  :num-allocs              197073
;  :num-checks              87
;  :propagations            148
;  :quant-instantiations    171
;  :rlimit-count            235601)
; [then-branch: 57 | exc@58@05 == Null | live]
; [else-branch: 57 | exc@58@05 != Null | dead]
(push) ; 5
; [then-branch: 57 | exc@58@05 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(P), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(P), unknown).int == 0)
(declare-const unknown@64@05 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V ==> aloc(opt_get1(P), unknown).int == 0
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 58 | 0 <= unknown@64@05 | live]
; [else-branch: 58 | !(0 <= unknown@64@05) | live]
(push) ; 8
; [then-branch: 58 | 0 <= unknown@64@05]
(assert (<= 0 unknown@64@05))
; [eval] unknown < V
(pop) ; 8
(push) ; 8
; [else-branch: 58 | !(0 <= unknown@64@05)]
(assert (not (<= 0 unknown@64@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 59 | unknown@64@05 < V@38@05 && 0 <= unknown@64@05 | live]
; [else-branch: 59 | !(unknown@64@05 < V@38@05 && 0 <= unknown@64@05) | live]
(push) ; 8
; [then-branch: 59 | unknown@64@05 < V@38@05 && 0 <= unknown@64@05]
(assert (and (< unknown@64@05 V@38@05) (<= 0 unknown@64@05)))
; [eval] aloc(opt_get1(P), unknown).int == 0
; [eval] aloc(opt_get1(P), unknown)
; [eval] opt_get1(P)
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
(assert (not (< unknown@64@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               818
;  :arith-add-rows          152
;  :arith-assert-diseq      46
;  :arith-assert-lower      149
;  :arith-assert-upper      74
;  :arith-bound-prop        23
;  :arith-conflicts         11
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         35
;  :arith-offset-eqs        13
;  :arith-pivots            116
;  :conflicts               32
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   144
;  :datatype-splits         82
;  :decisions               122
;  :del-clause              188
;  :final-checks            89
;  :max-generation          3
;  :max-memory              4.42
;  :memory                  4.41
;  :minimized-lits          1
;  :mk-bool-var             1054
;  :mk-clause               192
;  :num-allocs              197189
;  :num-checks              88
;  :propagations            149
;  :quant-instantiations    171
;  :rlimit-count            235862)
(assert (< unknown@64@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@64@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05)))
(push) ; 9
(assert (not (and
  (<
    (inv@62@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))
    V@38@05)
  (<=
    0
    (inv@62@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               839
;  :arith-add-rows          170
;  :arith-assert-diseq      46
;  :arith-assert-lower      152
;  :arith-assert-upper      78
;  :arith-bound-prop        27
;  :arith-conflicts         12
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        20
;  :arith-pivots            120
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   144
;  :datatype-splits         82
;  :decisions               122
;  :del-clause              188
;  :final-checks            89
;  :max-generation          3
;  :max-memory              4.46
;  :memory                  4.45
;  :minimized-lits          1
;  :mk-bool-var             1085
;  :mk-clause               203
;  :num-allocs              197551
;  :num-checks              89
;  :propagations            152
;  :quant-instantiations    187
;  :rlimit-count            236865)
(pop) ; 8
(push) ; 8
; [else-branch: 59 | !(unknown@64@05 < V@38@05 && 0 <= unknown@64@05)]
(assert (not (and (< unknown@64@05 V@38@05) (<= 0 unknown@64@05))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< unknown@64@05 V@38@05) (<= 0 unknown@64@05))
  (and
    (< unknown@64@05 V@38@05)
    (<= 0 unknown@64@05)
    (< unknown@64@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@64@05 Int)) (!
  (implies
    (and (< unknown@64@05 V@38@05) (<= 0 unknown@64@05))
    (and
      (< unknown@64@05 V@38@05)
      (<= 0 unknown@64@05)
      (< unknown@64@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@58@05 $Ref.null)
  (forall ((unknown@64@05 Int)) (!
    (implies
      (and (< unknown@64@05 V@38@05) (<= 0 unknown@64@05))
      (and
        (< unknown@64@05 V@38@05)
        (<= 0 unknown@64@05)
        (< unknown@64@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@58@05 $Ref.null)
  (forall ((unknown@64@05 Int)) (!
    (implies
      (and (< unknown@64@05 V@38@05) (<= 0 unknown@64@05))
      (=
        ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) unknown@64@05))
    :qid |prog.l<no position>|))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] exc != null
; [then-branch: 60 | exc@58@05 != Null | dead]
; [else-branch: 60 | exc@58@05 == Null | live]
(push) ; 4
; [else-branch: 60 | exc@58@05 == Null]
(pop) ; 4
; [eval] !(exc != null)
; [eval] exc != null
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               863
;  :arith-add-rows          175
;  :arith-assert-diseq      48
;  :arith-assert-lower      154
;  :arith-assert-upper      78
;  :arith-bound-prop        27
;  :arith-conflicts         12
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        20
;  :arith-pivots            125
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 104
;  :datatype-occurs-check   152
;  :datatype-splits         88
;  :decisions               130
;  :del-clause              200
;  :final-checks            93
;  :max-generation          3
;  :max-memory              4.47
;  :memory                  4.46
;  :minimized-lits          1
;  :mk-bool-var             1093
;  :mk-clause               203
;  :num-allocs              198868
;  :num-checks              91
;  :propagations            154
;  :quant-instantiations    187
;  :rlimit-count            238751)
; [then-branch: 61 | exc@58@05 == Null | live]
; [else-branch: 61 | exc@58@05 != Null | dead]
(push) ; 4
; [then-branch: 61 | exc@58@05 == Null]
; [exec]
; evaluationDummy := res1
; [exec]
; evaluationDummy1 := initializeSeqWithZeros(this, this.P_seq, V)
; [eval] initializeSeqWithZeros(this, this.P_seq, V)
(push) ; 5
; [eval] this != null
; [eval] n <= |p|
; [eval] |p|
(set-option :timeout 0)
(push) ; 6
(assert (not (<=
  V@38@05
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               863
;  :arith-add-rows          175
;  :arith-assert-diseq      48
;  :arith-assert-lower      154
;  :arith-assert-upper      78
;  :arith-bound-prop        27
;  :arith-conflicts         12
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        20
;  :arith-pivots            125
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 104
;  :datatype-occurs-check   152
;  :datatype-splits         88
;  :decisions               130
;  :del-clause              200
;  :final-checks            93
;  :max-generation          3
;  :max-memory              4.47
;  :memory                  4.46
;  :minimized-lits          1
;  :mk-bool-var             1093
;  :mk-clause               203
;  :num-allocs              198891
;  :num-checks              92
;  :propagations            154
;  :quant-instantiations    187
;  :rlimit-count            238772)
(assert (<=
  V@38@05
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05))))))))
(pop) ; 5
; Joined path conditions
(assert (<=
  V@38@05
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05))))))))
(declare-const evaluationDummy1@65@05 Seq<Int>)
(assert (Seq_equal
  evaluationDummy1@65@05
  (initializeSeqWithZeros ($Snap.combine $Snap.unit $Snap.unit) this@35@05 ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05))))) V@38@05)))
; [exec]
; label end
; [exec]
; res := return
; [exec]
; label bubble
; [eval] exc == null
; [eval] exc == null ==> P != (None(): option[array])
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               927
;  :arith-add-rows          219
;  :arith-assert-diseq      51
;  :arith-assert-lower      173
;  :arith-assert-upper      88
;  :arith-bound-prop        35
;  :arith-conflicts         12
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         48
;  :arith-offset-eqs        22
;  :arith-pivots            135
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 107
;  :datatype-occurs-check   156
;  :datatype-splits         91
;  :decisions               135
;  :del-clause              227
;  :final-checks            95
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1205
;  :mk-clause               292
;  :num-allocs              200355
;  :num-checks              93
;  :propagations            187
;  :quant-instantiations    206
;  :rlimit-count            241653
;  :time                    0.00)
; [then-branch: 62 | exc@58@05 == Null | live]
; [else-branch: 62 | exc@58@05 != Null | dead]
(push) ; 6
; [then-branch: 62 | exc@58@05 == Null]
; [eval] P != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies
  (= exc@58@05 $Ref.null)
  (not (= P@37@05 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               927
;  :arith-add-rows          219
;  :arith-assert-diseq      51
;  :arith-assert-lower      173
;  :arith-assert-upper      88
;  :arith-bound-prop        35
;  :arith-conflicts         12
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         48
;  :arith-offset-eqs        22
;  :arith-pivots            135
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 107
;  :datatype-occurs-check   156
;  :datatype-splits         91
;  :decisions               135
;  :del-clause              227
;  :final-checks            95
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1205
;  :mk-clause               292
;  :num-allocs              200379
;  :num-checks              94
;  :propagations            187
;  :quant-instantiations    206
;  :rlimit-count            241673)
(assert (implies
  (= exc@58@05 $Ref.null)
  (not (= P@37@05 (as None<option<array>>  option<array>)))))
; [eval] exc == null ==> alen(opt_get1(P)) == V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               948
;  :arith-add-rows          244
;  :arith-assert-diseq      56
;  :arith-assert-lower      186
;  :arith-assert-upper      92
;  :arith-bound-prop        39
;  :arith-conflicts         12
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        23
;  :arith-pivots            142
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   160
;  :datatype-splits         94
;  :decisions               142
;  :del-clause              261
;  :final-checks            97
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1237
;  :mk-clause               326
;  :num-allocs              201145
;  :num-checks              95
;  :propagations            200
;  :quant-instantiations    214
;  :rlimit-count            243072)
; [then-branch: 63 | exc@58@05 == Null | live]
; [else-branch: 63 | exc@58@05 != Null | dead]
(push) ; 6
; [then-branch: 63 | exc@58@05 == Null]
; [eval] alen(opt_get1(P)) == V
; [eval] alen(opt_get1(P))
; [eval] opt_get1(P)
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
  (= exc@58@05 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit P@37@05)) V@38@05))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               948
;  :arith-add-rows          244
;  :arith-assert-diseq      56
;  :arith-assert-lower      186
;  :arith-assert-upper      92
;  :arith-bound-prop        39
;  :arith-conflicts         12
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        23
;  :arith-pivots            142
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   160
;  :datatype-splits         94
;  :decisions               142
;  :del-clause              261
;  :final-checks            97
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1237
;  :mk-clause               326
;  :num-allocs              201163
;  :num-checks              96
;  :propagations            200
;  :quant-instantiations    214
;  :rlimit-count            243097)
(assert (implies
  (= exc@58@05 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit P@37@05)) V@38@05)))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               969
;  :arith-add-rows          249
;  :arith-assert-diseq      61
;  :arith-assert-lower      199
;  :arith-assert-upper      96
;  :arith-bound-prop        42
;  :arith-conflicts         12
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         52
;  :arith-offset-eqs        24
;  :arith-pivots            148
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 113
;  :datatype-occurs-check   164
;  :datatype-splits         97
;  :decisions               149
;  :del-clause              290
;  :final-checks            99
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1267
;  :mk-clause               355
;  :num-allocs              201852
;  :num-checks              97
;  :propagations            212
;  :quant-instantiations    222
;  :rlimit-count            244094)
; [then-branch: 64 | exc@58@05 == Null | live]
; [else-branch: 64 | exc@58@05 != Null | dead]
(push) ; 5
; [then-branch: 64 | exc@58@05 == Null]
; [eval] exc == null ==> |this.P_seq| == V
; [eval] exc == null
(push) ; 6
(push) ; 7
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-add-rows          255
;  :arith-assert-diseq      66
;  :arith-assert-lower      212
;  :arith-assert-upper      100
;  :arith-bound-prop        46
;  :arith-conflicts         12
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        25
;  :arith-pivots            154
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 116
;  :datatype-occurs-check   168
;  :datatype-splits         100
;  :decisions               156
;  :del-clause              324
;  :final-checks            101
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1299
;  :mk-clause               389
;  :num-allocs              202545
;  :num-checks              98
;  :propagations            225
;  :quant-instantiations    230
;  :rlimit-count            245093
;  :time                    0.00)
; [then-branch: 65 | exc@58@05 == Null | live]
; [else-branch: 65 | exc@58@05 != Null | dead]
(push) ; 7
; [then-branch: 65 | exc@58@05 == Null]
; [eval] |this.P_seq| == V
; [eval] |this.P_seq|
(pop) ; 7
(pop) ; 6
; Joined path conditions
(set-option :timeout 0)
(push) ; 6
(assert (not (implies
  (= exc@58@05 $Ref.null)
  (=
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05))))))
    V@38@05))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-add-rows          255
;  :arith-assert-diseq      66
;  :arith-assert-lower      212
;  :arith-assert-upper      100
;  :arith-bound-prop        46
;  :arith-conflicts         12
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        25
;  :arith-pivots            154
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 116
;  :datatype-occurs-check   168
;  :datatype-splits         100
;  :decisions               156
;  :del-clause              324
;  :final-checks            101
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1299
;  :mk-clause               389
;  :num-allocs              202563
;  :num-checks              99
;  :propagations            225
;  :quant-instantiations    230
;  :rlimit-count            245113)
(assert (implies
  (= exc@58@05 $Ref.null)
  (=
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05))))))
    V@38@05)))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1011
;  :arith-add-rows          261
;  :arith-assert-diseq      71
;  :arith-assert-lower      225
;  :arith-assert-upper      104
;  :arith-bound-prop        50
;  :arith-conflicts         12
;  :arith-eq-adapter        103
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        26
;  :arith-pivots            160
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 119
;  :datatype-occurs-check   172
;  :datatype-splits         103
;  :decisions               163
;  :del-clause              358
;  :final-checks            103
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.69
;  :minimized-lits          1
;  :mk-bool-var             1331
;  :mk-clause               423
;  :num-allocs              203255
;  :num-checks              100
;  :propagations            238
;  :quant-instantiations    238
;  :rlimit-count            246107)
; [then-branch: 66 | exc@58@05 == Null | live]
; [else-branch: 66 | exc@58@05 != Null | dead]
(push) ; 6
; [then-branch: 66 | exc@58@05 == Null]
(declare-const k@66@05 Int)
(push) ; 7
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 8
; [then-branch: 67 | 0 <= k@66@05 | live]
; [else-branch: 67 | !(0 <= k@66@05) | live]
(push) ; 9
; [then-branch: 67 | 0 <= k@66@05]
(assert (<= 0 k@66@05))
; [eval] k < V
(pop) ; 9
(push) ; 9
; [else-branch: 67 | !(0 <= k@66@05)]
(assert (not (<= 0 k@66@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (and (< k@66@05 V@38@05) (<= 0 k@66@05)))
; [eval] aloc(opt_get1(P), k)
; [eval] opt_get1(P)
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
(assert (not (< k@66@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 9
; 0.05s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1017
;  :arith-add-rows          266
;  :arith-assert-diseq      74
;  :arith-assert-lower      235
;  :arith-assert-upper      106
;  :arith-bound-prop        54
;  :arith-conflicts         12
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        27
;  :arith-pivots            162
;  :conflicts               33
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 119
;  :datatype-occurs-check   172
;  :datatype-splits         103
;  :decisions               163
;  :del-clause              358
;  :final-checks            103
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.70
;  :minimized-lits          1
;  :mk-bool-var             1353
;  :mk-clause               448
;  :num-allocs              203457
;  :num-checks              101
;  :propagations            247
;  :quant-instantiations    243
;  :rlimit-count            246498)
(assert (< k@66@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 8
; Joined path conditions
(assert (< k@66@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 7
(declare-fun inv@67@05 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@66@05 Int)) (!
  (< k@66@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@66@05))
  :qid |int-aux|)))
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 7
(assert (not (forall ((k1@66@05 Int) (k2@66@05 Int)) (!
  (implies
    (and
      (and
        (and (< k1@66@05 V@38@05) (<= 0 k1@66@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) k1@66@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) k1@66@05)))
      (and
        (and (< k2@66@05 V@38@05) (<= 0 k2@66@05))
        ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) k2@66@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) k2@66@05)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k1@66@05)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k2@66@05)))
    (= k1@66@05 k2@66@05))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1030
;  :arith-add-rows          272
;  :arith-assert-diseq      75
;  :arith-assert-lower      239
;  :arith-assert-upper      106
;  :arith-bound-prop        55
;  :arith-conflicts         12
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         57
;  :arith-offset-eqs        27
;  :arith-pivots            164
;  :conflicts               34
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 119
;  :datatype-occurs-check   172
;  :datatype-splits         103
;  :decisions               163
;  :del-clause              391
;  :final-checks            103
;  :max-generation          3
;  :max-memory              4.84
;  :memory                  4.70
;  :minimized-lits          1
;  :mk-bool-var             1382
;  :mk-clause               456
;  :num-allocs              204026
;  :num-checks              102
;  :propagations            248
;  :quant-instantiations    264
;  :rlimit-count            247690)
; Definitional axioms for inverse functions
(assert (forall ((k@66@05 Int)) (!
  (implies
    (and (< k@66@05 V@38@05) (<= 0 k@66@05))
    (=
      (inv@67@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@66@05))
      k@66@05))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) k@66@05))
  :qid |int-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@67@05 r) V@38@05) (<= 0 (inv@67@05 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) (inv@67@05 r))
      r))
  :pattern ((inv@67@05 r))
  :qid |int-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@67@05 r) V@38@05) (<= 0 (inv@67@05 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) r) r))
  :pattern ((inv@67@05 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@68@05 ((r $Ref)) $Perm
  (ite
    (and (< (inv@67@05 r) V@38@05) (<= 0 (inv@67@05 r)))
    ($Perm.min
      (ite
        (and (< (inv@62@05 r) V@38@05) (<= 0 (inv@62@05 r)))
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
(push) ; 7
(assert (not (forall ((r $Ref)) (!
  (=
    (-
      (ite
        (and (< (inv@62@05 r) V@38@05) (<= 0 (inv@62@05 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@68@05 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1136
;  :arith-add-rows          318
;  :arith-assert-diseq      91
;  :arith-assert-lower      287
;  :arith-assert-upper      126
;  :arith-bound-prop        65
;  :arith-conflicts         15
;  :arith-eq-adapter        137
;  :arith-fixed-eqs         67
;  :arith-offset-eqs        29
;  :arith-pivots            193
;  :conflicts               41
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 122
;  :datatype-occurs-check   176
;  :datatype-splits         106
;  :decisions               176
;  :del-clause              506
;  :final-checks            105
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1568
;  :mk-clause               575
;  :num-allocs              206252
;  :num-checks              104
;  :propagations            311
;  :quant-instantiations    335
;  :rlimit-count            252262
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 7
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@67@05 r) V@38@05) (<= 0 (inv@67@05 r)))
    (= (- $Perm.Write (pTaken@68@05 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 7
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1171
;  :arith-add-rows          339
;  :arith-assert-diseq      96
;  :arith-assert-lower      301
;  :arith-assert-upper      135
;  :arith-bound-prop        68
;  :arith-conflicts         16
;  :arith-eq-adapter        146
;  :arith-fixed-eqs         71
;  :arith-offset-eqs        33
;  :arith-pivots            200
;  :conflicts               42
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 122
;  :datatype-occurs-check   176
;  :datatype-splits         106
;  :decisions               176
;  :del-clause              549
;  :final-checks            105
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1637
;  :mk-clause               618
;  :num-allocs              206809
;  :num-checks              105
;  :propagations            333
;  :quant-instantiations    361
;  :rlimit-count            253873
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null ==> (forall i1: Int :: { aloc(opt_get1(P), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(P), i1).int == 0)
; [eval] exc == null
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1211
;  :arith-add-rows          358
;  :arith-assert-diseq      99
;  :arith-assert-lower      313
;  :arith-assert-upper      142
;  :arith-bound-prop        70
;  :arith-conflicts         16
;  :arith-eq-adapter        153
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        35
;  :arith-pivots            203
;  :conflicts               42
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 125
;  :datatype-occurs-check   180
;  :datatype-splits         109
;  :decisions               181
;  :del-clause              577
;  :final-checks            107
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.77
;  :minimized-lits          1
;  :mk-bool-var             1676
;  :mk-clause               646
;  :num-allocs              207521
;  :num-checks              106
;  :propagations            350
;  :quant-instantiations    368
;  :rlimit-count            255085)
; [then-branch: 68 | exc@58@05 == Null | live]
; [else-branch: 68 | exc@58@05 != Null | dead]
(push) ; 8
; [then-branch: 68 | exc@58@05 == Null]
; [eval] (forall i1: Int :: { aloc(opt_get1(P), i1) } 0 <= i1 && i1 < V ==> aloc(opt_get1(P), i1).int == 0)
(declare-const i1@69@05 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V ==> aloc(opt_get1(P), i1).int == 0
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 69 | 0 <= i1@69@05 | live]
; [else-branch: 69 | !(0 <= i1@69@05) | live]
(push) ; 11
; [then-branch: 69 | 0 <= i1@69@05]
(assert (<= 0 i1@69@05))
; [eval] i1 < V
(pop) ; 11
(push) ; 11
; [else-branch: 69 | !(0 <= i1@69@05)]
(assert (not (<= 0 i1@69@05)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 70 | i1@69@05 < V@38@05 && 0 <= i1@69@05 | live]
; [else-branch: 70 | !(i1@69@05 < V@38@05 && 0 <= i1@69@05) | live]
(push) ; 11
; [then-branch: 70 | i1@69@05 < V@38@05 && 0 <= i1@69@05]
(assert (and (< i1@69@05 V@38@05) (<= 0 i1@69@05)))
; [eval] aloc(opt_get1(P), i1).int == 0
; [eval] aloc(opt_get1(P), i1)
; [eval] opt_get1(P)
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
(assert (not (< i1@69@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1211
;  :arith-add-rows          359
;  :arith-assert-diseq      99
;  :arith-assert-lower      315
;  :arith-assert-upper      142
;  :arith-bound-prop        70
;  :arith-conflicts         16
;  :arith-eq-adapter        153
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        35
;  :arith-pivots            204
;  :conflicts               42
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 125
;  :datatype-occurs-check   180
;  :datatype-splits         109
;  :decisions               181
;  :del-clause              577
;  :final-checks            107
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.77
;  :minimized-lits          1
;  :mk-bool-var             1678
;  :mk-clause               646
;  :num-allocs              207630
;  :num-checks              107
;  :propagations            350
;  :quant-instantiations    368
;  :rlimit-count            255286)
(assert (< i1@69@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(pop) ; 12
; Joined path conditions
(assert (< i1@69@05 (alen<Int> (opt_get1 $Snap.unit P@37@05))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05)))
(push) ; 12
(assert (not (and
  (<
    (inv@62@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))
    V@38@05)
  (<=
    0
    (inv@62@05 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1232
;  :arith-add-rows          377
;  :arith-assert-diseq      99
;  :arith-assert-lower      318
;  :arith-assert-upper      146
;  :arith-bound-prop        74
;  :arith-conflicts         17
;  :arith-eq-adapter        156
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        42
;  :arith-pivots            208
;  :conflicts               43
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 125
;  :datatype-occurs-check   180
;  :datatype-splits         109
;  :decisions               181
;  :del-clause              577
;  :final-checks            107
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1710
;  :mk-clause               657
;  :num-allocs              207980
;  :num-checks              108
;  :propagations            353
;  :quant-instantiations    388
;  :rlimit-count            256333)
(pop) ; 11
(push) ; 11
; [else-branch: 70 | !(i1@69@05 < V@38@05 && 0 <= i1@69@05)]
(assert (not (and (< i1@69@05 V@38@05) (<= 0 i1@69@05))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
(assert (implies
  (and (< i1@69@05 V@38@05) (<= 0 i1@69@05))
  (and
    (< i1@69@05 V@38@05)
    (<= 0 i1@69@05)
    (< i1@69@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05)))))
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i1@69@05 Int)) (!
  (implies
    (and (< i1@69@05 V@38@05) (<= 0 i1@69@05))
    (and
      (< i1@69@05 V@38@05)
      (<= 0 i1@69@05)
      (< i1@69@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (= exc@58@05 $Ref.null)
  (forall ((i1@69@05 Int)) (!
    (implies
      (and (< i1@69@05 V@38@05) (<= 0 i1@69@05))
      (and
        (< i1@69@05 V@38@05)
        (<= 0 i1@69@05)
        (< i1@69@05 (alen<Int> (opt_get1 $Snap.unit P@37@05)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))
    :qid |prog.l<no position>-aux|))))
(push) ; 7
(assert (not (implies
  (= exc@58@05 $Ref.null)
  (forall ((i1@69@05 Int)) (!
    (implies
      (and (< i1@69@05 V@38@05) (<= 0 i1@69@05))
      (=
        ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1237
;  :arith-add-rows          391
;  :arith-assert-diseq      99
;  :arith-assert-lower      321
;  :arith-assert-upper      147
;  :arith-bound-prop        76
;  :arith-conflicts         17
;  :arith-eq-adapter        157
;  :arith-fixed-eqs         86
;  :arith-offset-eqs        45
;  :arith-pivots            216
;  :conflicts               44
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 125
;  :datatype-occurs-check   180
;  :datatype-splits         109
;  :decisions               181
;  :del-clause              605
;  :final-checks            107
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1742
;  :mk-clause               674
;  :num-allocs              208571
;  :num-checks              109
;  :propagations            355
;  :quant-instantiations    411
;  :rlimit-count            257749)
(assert (implies
  (= exc@58@05 $Ref.null)
  (forall ((i1@69@05 Int)) (!
    (implies
      (and (< i1@69@05 V@38@05) (<= 0 i1@69@05))
      (=
        ($FVF.lookup_int (as sm@63@05  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))
        0))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit P@37@05) i1@69@05))
    :qid |prog.l<no position>|))))
; [eval] exc == null ==> (forall i1: Int :: { this.P_seq[i1] } 0 <= i1 && i1 < V ==> this.P_seq[i1] == 0)
; [eval] exc == null
(push) ; 7
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= exc@58@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1277
;  :arith-add-rows          396
;  :arith-assert-diseq      102
;  :arith-assert-lower      333
;  :arith-assert-upper      154
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            218
;  :conflicts               44
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 128
;  :datatype-occurs-check   184
;  :datatype-splits         112
;  :decisions               186
;  :del-clause              633
;  :final-checks            109
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.78
;  :minimized-lits          1
;  :mk-bool-var             1782
;  :mk-clause               702
;  :num-allocs              209454
;  :num-checks              110
;  :propagations            372
;  :quant-instantiations    418
;  :rlimit-count            258994)
; [then-branch: 71 | exc@58@05 == Null | live]
; [else-branch: 71 | exc@58@05 != Null | dead]
(push) ; 8
; [then-branch: 71 | exc@58@05 == Null]
; [eval] (forall i1: Int :: { this.P_seq[i1] } 0 <= i1 && i1 < V ==> this.P_seq[i1] == 0)
(declare-const i1@70@05 Int)
(push) ; 9
; [eval] 0 <= i1 && i1 < V ==> this.P_seq[i1] == 0
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 10
; [then-branch: 72 | 0 <= i1@70@05 | live]
; [else-branch: 72 | !(0 <= i1@70@05) | live]
(push) ; 11
; [then-branch: 72 | 0 <= i1@70@05]
(assert (<= 0 i1@70@05))
; [eval] i1 < V
(pop) ; 11
(push) ; 11
; [else-branch: 72 | !(0 <= i1@70@05)]
(assert (not (<= 0 i1@70@05)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 73 | i1@70@05 < V@38@05 && 0 <= i1@70@05 | live]
; [else-branch: 73 | !(i1@70@05 < V@38@05 && 0 <= i1@70@05) | live]
(push) ; 11
; [then-branch: 73 | i1@70@05 < V@38@05 && 0 <= i1@70@05]
(assert (and (< i1@70@05 V@38@05) (<= 0 i1@70@05)))
; [eval] this.P_seq[i1] == 0
; [eval] this.P_seq[i1]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i1@70@05 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1277
;  :arith-add-rows          397
;  :arith-assert-diseq      102
;  :arith-assert-lower      335
;  :arith-assert-upper      154
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            219
;  :conflicts               44
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 128
;  :datatype-occurs-check   184
;  :datatype-splits         112
;  :decisions               186
;  :del-clause              633
;  :final-checks            109
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.78
;  :minimized-lits          1
;  :mk-bool-var             1784
;  :mk-clause               702
;  :num-allocs              209552
;  :num-checks              111
;  :propagations            372
;  :quant-instantiations    418
;  :rlimit-count            259174)
(push) ; 12
(assert (not (<
  i1@70@05
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1277
;  :arith-add-rows          397
;  :arith-assert-diseq      102
;  :arith-assert-lower      335
;  :arith-assert-upper      154
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            219
;  :conflicts               44
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 128
;  :datatype-occurs-check   184
;  :datatype-splits         112
;  :decisions               186
;  :del-clause              633
;  :final-checks            109
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.78
;  :minimized-lits          1
;  :mk-bool-var             1784
;  :mk-clause               702
;  :num-allocs              209572
;  :num-checks              112
;  :propagations            372
;  :quant-instantiations    418
;  :rlimit-count            259194)
(pop) ; 11
(push) ; 11
; [else-branch: 73 | !(i1@70@05 < V@38@05 && 0 <= i1@70@05)]
(assert (not (and (< i1@70@05 V@38@05) (<= 0 i1@70@05))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 8
(pop) ; 7
; Joined path conditions
(push) ; 7
(assert (not (implies
  (= exc@58@05 $Ref.null)
  (forall ((i1@70@05 Int)) (!
    (implies
      (and (< i1@70@05 V@38@05) (<= 0 i1@70@05))
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))
          i1@70@05)
        0))
    :pattern ((Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))
      i1@70@05))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1277
;  :arith-add-rows          398
;  :arith-assert-diseq      102
;  :arith-assert-lower      337
;  :arith-assert-upper      154
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            220
;  :conflicts               45
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 128
;  :datatype-occurs-check   184
;  :datatype-splits         112
;  :decisions               186
;  :del-clause              633
;  :final-checks            109
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.77
;  :minimized-lits          1
;  :mk-bool-var             1787
;  :mk-clause               702
;  :num-allocs              209783
;  :num-checks              113
;  :propagations            372
;  :quant-instantiations    419
;  :rlimit-count            259547)
(assert (implies
  (= exc@58@05 $Ref.null)
  (forall ((i1@70@05 Int)) (!
    (implies
      (and (< i1@70@05 V@38@05) (<= 0 i1@70@05))
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))
          i1@70@05)
        0))
    :pattern ((Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@05)))))
      i1@70@05))
    :qid |prog.l<no position>|))))
(pop) ; 6
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- Object ----------
(declare-const tid@71@05 Int)
(declare-const exc@72@05 $Ref)
(declare-const res@73@05 $Ref)
(declare-const tid@74@05 Int)
(declare-const exc@75@05 $Ref)
(declare-const res@76@05 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@77@05 $Snap)
(assert (= $t@77@05 ($Snap.combine ($Snap.first $t@77@05) ($Snap.second $t@77@05))))
(assert (= ($Snap.first $t@77@05) $Snap.unit))
; [eval] exc == null
(assert (= exc@75@05 $Ref.null))
(assert (=
  ($Snap.second $t@77@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@77@05))
    ($Snap.second ($Snap.second $t@77@05)))))
(assert (= ($Snap.first ($Snap.second $t@77@05)) $Snap.unit))
; [eval] exc == null ==> res != null
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@75@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1292
;  :arith-add-rows          412
;  :arith-assert-diseq      102
;  :arith-assert-lower      337
;  :arith-assert-upper      154
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            228
;  :conflicts               45
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 129
;  :datatype-occurs-check   186
;  :datatype-splits         113
;  :decisions               187
;  :del-clause              702
;  :final-checks            112
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1793
;  :mk-clause               702
;  :num-allocs              210590
;  :num-checks              115
;  :propagations            372
;  :quant-instantiations    419
;  :rlimit-count            261085)
; [then-branch: 74 | exc@75@05 == Null | live]
; [else-branch: 74 | exc@75@05 != Null | dead]
(push) ; 4
; [then-branch: 74 | exc@75@05 == Null]
; [eval] res != null
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@75@05 $Ref.null) (not (= res@76@05 $Ref.null))))
(assert (= ($Snap.second ($Snap.second $t@77@05)) $Snap.unit))
; [eval] exc == null ==> type(res) == 2
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@75@05 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1293
;  :arith-add-rows          412
;  :arith-assert-diseq      102
;  :arith-assert-lower      337
;  :arith-assert-upper      154
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        164
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            228
;  :conflicts               45
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 129
;  :datatype-occurs-check   187
;  :datatype-splits         113
;  :decisions               187
;  :del-clause              702
;  :final-checks            113
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1795
;  :mk-clause               702
;  :num-allocs              210999
;  :num-checks              116
;  :propagations            372
;  :quant-instantiations    419
;  :rlimit-count            261643)
; [then-branch: 75 | exc@75@05 == Null | live]
; [else-branch: 75 | exc@75@05 != Null | dead]
(push) ; 4
; [then-branch: 75 | exc@75@05 == Null]
; [eval] type(res) == 2
; [eval] type(res)
(push) ; 5
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@75@05 $Ref.null) (= (type $Snap.unit res@76@05) 2)))
(pop) ; 2
(push) ; 2
; [exec]
; var return: Ref
(declare-const return@78@05 $Ref)
; [exec]
; var this: Ref
(declare-const this@79@05 $Ref)
; [exec]
; exc := null
; [exec]
; this := new()
(declare-const this@80@05 $Ref)
(assert (not (= this@80@05 $Ref.null)))
(assert (not (= this@80@05 return@78@05)))
(assert (not (= this@80@05 res@76@05)))
(assert (not (= this@80@05 this@79@05)))
; [exec]
; inhale type(this) == 2
(declare-const $t@81@05 $Snap)
(assert (= $t@81@05 $Snap.unit))
; [eval] type(this) == 2
; [eval] type(this)
(push) ; 3
(pop) ; 3
; Joined path conditions
(assert (= (type $Snap.unit this@80@05) 2))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; fold acc(lock_inv_Object(this), write)
(assert (lock_inv_Object%trigger $Snap.unit this@80@05))
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
; (:added-eqs               1297
;  :arith-add-rows          412
;  :arith-assert-diseq      103
;  :arith-assert-lower      340
;  :arith-assert-upper      156
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            228
;  :conflicts               45
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 129
;  :datatype-occurs-check   189
;  :datatype-splits         113
;  :decisions               187
;  :del-clause              713
;  :final-checks            115
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1814
;  :mk-clause               713
;  :num-allocs              212026
;  :num-checks              118
;  :propagations            377
;  :quant-instantiations    422
;  :rlimit-count            262970)
; [then-branch: 76 | True | live]
; [else-branch: 76 | False | dead]
(push) ; 4
; [then-branch: 76 | True]
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
; (:added-eqs               1297
;  :arith-add-rows          412
;  :arith-assert-diseq      103
;  :arith-assert-lower      340
;  :arith-assert-upper      156
;  :arith-bound-prop        78
;  :arith-conflicts         17
;  :arith-eq-adapter        166
;  :arith-fixed-eqs         97
;  :arith-offset-eqs        47
;  :arith-pivots            228
;  :conflicts               45
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 129
;  :datatype-occurs-check   190
;  :datatype-splits         113
;  :decisions               187
;  :del-clause              713
;  :final-checks            116
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.76
;  :minimized-lits          1
;  :mk-bool-var             1814
;  :mk-clause               713
;  :num-allocs              212409
;  :num-checks              119
;  :propagations            377
;  :quant-instantiations    422
;  :rlimit-count            263415)
; [then-branch: 77 | True | live]
; [else-branch: 77 | False | dead]
(push) ; 4
; [then-branch: 77 | True]
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
