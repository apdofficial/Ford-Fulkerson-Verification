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
; ---------- make_array1 ----------
(declare-const tid@0@06 Int)
(declare-const dim0@1@06 Int)
(declare-const exc@2@06 $Ref)
(declare-const res@3@06 option<array>)
(declare-const tid@4@06 Int)
(declare-const dim0@5@06 Int)
(declare-const exc@6@06 $Ref)
(declare-const res@7@06 option<array>)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@8@06 $Snap)
(assert (= $t@8@06 ($Snap.combine ($Snap.first $t@8@06) ($Snap.second $t@8@06))))
(assert (= ($Snap.first $t@8@06) $Snap.unit))
; [eval] exc == null
(assert (= exc@6@06 $Ref.null))
(assert (=
  ($Snap.second $t@8@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@8@06))
    ($Snap.second ($Snap.second $t@8@06)))))
(assert (= ($Snap.first ($Snap.second $t@8@06)) $Snap.unit))
; [eval] exc == null ==> res != (None(): option[array])
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@6@06 $Ref.null))))
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
; [then-branch: 0 | exc@6@06 == Null | live]
; [else-branch: 0 | exc@6@06 != Null | dead]
(push) ; 4
; [then-branch: 0 | exc@6@06 == Null]
; [eval] res != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@6@06 $Ref.null)
  (not (= res@7@06 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@8@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@8@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@8@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@8@06))) $Snap.unit))
; [eval] exc == null ==> alen(opt_get1(res)) == dim0
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@6@06 $Ref.null))))
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
; [then-branch: 1 | exc@6@06 == Null | live]
; [else-branch: 1 | exc@6@06 != Null | dead]
(push) ; 4
; [then-branch: 1 | exc@6@06 == Null]
; [eval] alen(opt_get1(res)) == dim0
; [eval] alen(opt_get1(res))
; [eval] opt_get1(res)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= res@7@06 (as None<option<array>>  option<array>)))))
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
(assert (not (= res@7@06 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= res@7@06 (as None<option<array>>  option<array>))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@6@06 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit res@7@06)) dim0@5@06)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@8@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@8@06)))))))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= exc@6@06 $Ref.null))))
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
;  :num-allocs              159568
;  :num-checks              5
;  :quant-instantiations    7
;  :rlimit-count            182172)
; [then-branch: 2 | exc@6@06 == Null | live]
; [else-branch: 2 | exc@6@06 != Null | dead]
(push) ; 3
; [then-branch: 2 | exc@6@06 == Null]
(declare-const i0@9@06 Int)
(push) ; 4
; [eval] 0 <= i0 && i0 < dim0
; [eval] 0 <= i0
(push) ; 5
; [then-branch: 3 | 0 <= i0@9@06 | live]
; [else-branch: 3 | !(0 <= i0@9@06) | live]
(push) ; 6
; [then-branch: 3 | 0 <= i0@9@06]
(assert (<= 0 i0@9@06))
; [eval] i0 < dim0
(pop) ; 6
(push) ; 6
; [else-branch: 3 | !(0 <= i0@9@06)]
(assert (not (<= 0 i0@9@06)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< i0@9@06 dim0@5@06) (<= 0 i0@9@06)))
; [eval] aloc(opt_get1(res), i0)
; [eval] opt_get1(res)
(push) ; 5
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= res@7@06 (as None<option<array>>  option<array>)))))
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
;  :num-allocs              159736
;  :num-checks              6
;  :quant-instantiations    7
;  :rlimit-count            182360)
(assert (not (= res@7@06 (as None<option<array>>  option<array>))))
(pop) ; 5
; Joined path conditions
(assert (not (= res@7@06 (as None<option<array>>  option<array>))))
(push) ; 5
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 6
(assert (not (< i0@9@06 (alen<Int> (opt_get1 $Snap.unit res@7@06)))))
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
;  :num-allocs              159759
;  :num-checks              7
;  :quant-instantiations    7
;  :rlimit-count            182391)
(assert (< i0@9@06 (alen<Int> (opt_get1 $Snap.unit res@7@06))))
(pop) ; 5
; Joined path conditions
(assert (< i0@9@06 (alen<Int> (opt_get1 $Snap.unit res@7@06))))
(declare-const sm@10@06 $FVF<Int>)
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
(declare-fun inv@11@06 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i0@9@06 Int)) (!
  (and
    (not (= res@7@06 (as None<option<array>>  option<array>)))
    (< i0@9@06 (alen<Int> (opt_get1 $Snap.unit res@7@06))))
  :pattern (($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@06))))) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06)))
  :qid |int-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((i01@9@06 Int) (i02@9@06 Int)) (!
  (implies
    (and
      (and (< i01@9@06 dim0@5@06) (<= 0 i01@9@06))
      (and (< i02@9@06 dim0@5@06) (<= 0 i02@9@06))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@06) i01@9@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@06) i02@9@06)))
    (= i01@9@06 i02@9@06))
  
  :qid |int-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               71
;  :arith-add-rows          17
;  :arith-assert-diseq      4
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
;  :mk-bool-var             461
;  :mk-clause               18
;  :num-allocs              160527
;  :num-checks              8
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            183849)
; Definitional axioms for inverse functions
(assert (forall ((i0@9@06 Int)) (!
  (implies
    (and (< i0@9@06 dim0@5@06) (<= 0 i0@9@06))
    (=
      (inv@11@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06))
      i0@9@06))
  :pattern (($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@06))))) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06)))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@11@06 r) dim0@5@06) (<= 0 (inv@11@06 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@06) (inv@11@06 r))
      r))
  :pattern ((inv@11@06 r))
  :qid |int-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((i0@9@06 Int)) (!
  (implies
    (and (< i0@9@06 dim0@5@06) (<= 0 i0@9@06))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06)
        $Ref.null)))
  :pattern (($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@06))))) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@9@06)))
  :qid |int-permImpliesNonNull|)))
(declare-const sm@12@06 $FVF<Int>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@11@06 r) dim0@5@06) (<= 0 (inv@11@06 r)))
    (=
      ($FVF.lookup_int (as sm@12@06  $FVF<Int>) r)
      ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@06))))) r)))
  :pattern (($FVF.lookup_int (as sm@12@06  $FVF<Int>) r))
  :pattern (($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@06))))) r))
  :qid |qp.fvfValDef1|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_int ($FVF.lookup_int ($SortWrappers.$SnapTo$FVF<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@8@06))))) r) r)
  :pattern (($FVF.lookup_int (as sm@12@06  $FVF<Int>) r))
  :qid |qp.fvfResTrgDef2|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@11@06 r) dim0@5@06) (<= 0 (inv@11@06 r)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) r) r))
  :pattern ((inv@11@06 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@8@06))))
  $Snap.unit))
; [eval] exc == null ==> (forall i0: Int :: { aloc(opt_get1(res), i0).int } 0 <= i0 && i0 < dim0 ==> aloc(opt_get1(res), i0).int == 0)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@6@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               75
;  :arith-add-rows          17
;  :arith-assert-diseq      4
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
;  :mk-bool-var             469
;  :mk-clause               18
;  :num-allocs              161868
;  :num-checks              9
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            186242)
; [then-branch: 4 | exc@6@06 == Null | live]
; [else-branch: 4 | exc@6@06 != Null | dead]
(push) ; 5
; [then-branch: 4 | exc@6@06 == Null]
; [eval] (forall i0: Int :: { aloc(opt_get1(res), i0).int } 0 <= i0 && i0 < dim0 ==> aloc(opt_get1(res), i0).int == 0)
(declare-const i0@13@06 Int)
(push) ; 6
; [eval] 0 <= i0 && i0 < dim0 ==> aloc(opt_get1(res), i0).int == 0
; [eval] 0 <= i0 && i0 < dim0
; [eval] 0 <= i0
(push) ; 7
; [then-branch: 5 | 0 <= i0@13@06 | live]
; [else-branch: 5 | !(0 <= i0@13@06) | live]
(push) ; 8
; [then-branch: 5 | 0 <= i0@13@06]
(assert (<= 0 i0@13@06))
; [eval] i0 < dim0
(pop) ; 8
(push) ; 8
; [else-branch: 5 | !(0 <= i0@13@06)]
(assert (not (<= 0 i0@13@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 6 | i0@13@06 < dim0@5@06 && 0 <= i0@13@06 | live]
; [else-branch: 6 | !(i0@13@06 < dim0@5@06 && 0 <= i0@13@06) | live]
(push) ; 8
; [then-branch: 6 | i0@13@06 < dim0@5@06 && 0 <= i0@13@06]
(assert (and (< i0@13@06 dim0@5@06) (<= 0 i0@13@06)))
; [eval] aloc(opt_get1(res), i0).int == 0
; [eval] aloc(opt_get1(res), i0)
; [eval] opt_get1(res)
(push) ; 9
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= res@7@06 (as None<option<array>>  option<array>)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               76
;  :arith-add-rows          18
;  :arith-assert-diseq      4
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
;  :mk-bool-var             473
;  :mk-clause               18
;  :num-allocs              162046
;  :num-checks              10
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            186454)
(assert (not (= res@7@06 (as None<option<array>>  option<array>))))
(pop) ; 9
; Joined path conditions
(assert (not (= res@7@06 (as None<option<array>>  option<array>))))
(push) ; 9
; [eval] 0 <= i1
; [eval] i1 < alen(a2)
; [eval] alen(a2)
(push) ; 10
(assert (not (< i0@13@06 (alen<Int> (opt_get1 $Snap.unit res@7@06)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               76
;  :arith-add-rows          18
;  :arith-assert-diseq      4
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
;  :mk-bool-var             473
;  :mk-clause               18
;  :num-allocs              162071
;  :num-checks              11
;  :propagations            20
;  :quant-instantiations    16
;  :rlimit-count            186485)
(assert (< i0@13@06 (alen<Int> (opt_get1 $Snap.unit res@7@06))))
(pop) ; 9
; Joined path conditions
(assert (< i0@13@06 (alen<Int> (opt_get1 $Snap.unit res@7@06))))
(assert ($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)))
(push) ; 9
(assert (not (and
  (<
    (inv@11@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06))
    dim0@5@06)
  (<=
    0
    (inv@11@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               88
;  :arith-add-rows          21
;  :arith-assert-diseq      4
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
;  :mk-bool-var             490
;  :mk-clause               29
;  :num-allocs              162390
;  :num-checks              12
;  :propagations            26
;  :quant-instantiations    26
;  :rlimit-count            187088)
(pop) ; 8
(push) ; 8
; [else-branch: 6 | !(i0@13@06 < dim0@5@06 && 0 <= i0@13@06)]
(assert (not (and (< i0@13@06 dim0@5@06) (<= 0 i0@13@06))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< i0@13@06 dim0@5@06) (<= 0 i0@13@06))
  (and
    (< i0@13@06 dim0@5@06)
    (<= 0 i0@13@06)
    (not (= res@7@06 (as None<option<array>>  option<array>)))
    (< i0@13@06 (alen<Int> (opt_get1 $Snap.unit res@7@06)))
    ($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)))))
; Joined path conditions
; Definitional axioms for snapshot map values
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i0@13@06 Int)) (!
  (implies
    (and (< i0@13@06 dim0@5@06) (<= 0 i0@13@06))
    (and
      (< i0@13@06 dim0@5@06)
      (<= 0 i0@13@06)
      (not (= res@7@06 (as None<option<array>>  option<array>)))
      (< i0@13@06 (alen<Int> (opt_get1 $Snap.unit res@7@06)))
      ($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06))))
  :pattern (($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@6@06 $Ref.null)
  (forall ((i0@13@06 Int)) (!
    (implies
      (and (< i0@13@06 dim0@5@06) (<= 0 i0@13@06))
      (and
        (< i0@13@06 dim0@5@06)
        (<= 0 i0@13@06)
        (not (= res@7@06 (as None<option<array>>  option<array>)))
        (< i0@13@06 (alen<Int> (opt_get1 $Snap.unit res@7@06)))
        ($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06))))
    :pattern (($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@6@06 $Ref.null)
  (forall ((i0@13@06 Int)) (!
    (implies
      (and (< i0@13@06 dim0@5@06) (<= 0 i0@13@06))
      (=
        ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06))
        0))
    :pattern (($FVF.loc_int ($FVF.lookup_int (as sm@12@06  $FVF<Int>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit res@7@06) i0@13@06)))
    :qid |prog.l<no position>|))))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- initializeVisited ----------
(declare-const this@14@06 $Ref)
(declare-const tid@15@06 Int)
(declare-const visited@16@06 option<array>)
(declare-const s@17@06 Int)
(declare-const V@18@06 Int)
(declare-const exc@19@06 $Ref)
(declare-const res@20@06 void)
(declare-const this@21@06 $Ref)
(declare-const tid@22@06 Int)
(declare-const visited@23@06 option<array>)
(declare-const s@24@06 Int)
(declare-const V@25@06 Int)
(declare-const exc@26@06 $Ref)
(declare-const res@27@06 void)
(push) ; 1
(declare-const $t@28@06 $Snap)
(assert (= $t@28@06 ($Snap.combine ($Snap.first $t@28@06) ($Snap.second $t@28@06))))
(assert (= ($Snap.first $t@28@06) $Snap.unit))
; [eval] this != null
(assert (not (= this@21@06 $Ref.null)))
(assert (=
  ($Snap.second $t@28@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@28@06))
    ($Snap.second ($Snap.second $t@28@06)))))
(assert (= ($Snap.first ($Snap.second $t@28@06)) $Snap.unit))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(assert (not (= visited@23@06 (as None<option<array>>  option<array>))))
(assert (=
  ($Snap.second ($Snap.second $t@28@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@28@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@28@06))) $Snap.unit))
; [eval] alen(opt_get1(visited)) == V
; [eval] alen(opt_get1(visited))
; [eval] opt_get1(visited)
(push) ; 2
; [eval] opt1 != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 2
; Joined path conditions
(assert (= (alen<Int> (opt_get1 $Snap.unit visited@23@06)) V@25@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@28@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@06))))
  $Snap.unit))
; [eval] 0 <= s
(assert (<= 0 s@24@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))
  $Snap.unit))
; [eval] s < V
(assert (< s@24@06 V@25@06))
(declare-const k@29@06 Int)
(push) ; 2
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 3
; [then-branch: 7 | 0 <= k@29@06 | live]
; [else-branch: 7 | !(0 <= k@29@06) | live]
(push) ; 4
; [then-branch: 7 | 0 <= k@29@06]
(assert (<= 0 k@29@06))
; [eval] k < V
(pop) ; 4
(push) ; 4
; [else-branch: 7 | !(0 <= k@29@06)]
(assert (not (<= 0 k@29@06)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (and (< k@29@06 V@25@06) (<= 0 k@29@06)))
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
(push) ; 4
(assert (not (< k@29@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               124
;  :arith-add-rows          24
;  :arith-assert-diseq      4
;  :arith-assert-lower      21
;  :arith-assert-upper      12
;  :arith-bound-prop        3
;  :arith-conflicts         2
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        4
;  :arith-pivots            18
;  :conflicts               4
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   9
;  :datatype-splits         5
;  :decisions               7
;  :del-clause              29
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.28
;  :mk-bool-var             515
;  :mk-clause               29
;  :num-allocs              163063
;  :num-checks              13
;  :propagations            26
;  :quant-instantiations    31
;  :rlimit-count            188524)
(assert (< k@29@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 3
; Joined path conditions
(assert (< k@29@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 2
(declare-fun inv@30@06 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@29@06 Int)) (!
  (< k@29@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@29@06))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((k1@29@06 Int) (k2@29@06 Int)) (!
  (implies
    (and
      (and (< k1@29@06 V@25@06) (<= 0 k1@29@06))
      (and (< k2@29@06 V@25@06) (<= 0 k2@29@06))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k1@29@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k2@29@06)))
    (= k1@29@06 k2@29@06))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               155
;  :arith-add-rows          41
;  :arith-assert-diseq      8
;  :arith-assert-lower      27
;  :arith-assert-upper      15
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               7
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 5
;  :datatype-occurs-check   9
;  :datatype-splits         5
;  :decisions               9
;  :del-clause              46
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             542
;  :mk-clause               46
;  :num-allocs              163585
;  :num-checks              14
;  :propagations            46
;  :quant-instantiations    42
;  :rlimit-count            189810
;  :time                    0.00)
; Definitional axioms for inverse functions
(assert (forall ((k@29@06 Int)) (!
  (implies
    (and (< k@29@06 V@25@06) (<= 0 k@29@06))
    (=
      (inv@30@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@29@06))
      k@29@06))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@29@06))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@30@06 r) V@25@06) (<= 0 (inv@30@06 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) (inv@30@06 r))
      r))
  :pattern ((inv@30@06 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@29@06 Int)) (!
  (implies
    (and (< k@29@06 V@25@06) (<= 0 k@29@06))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@29@06)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@29@06))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@31@06 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@30@06 r) V@25@06) (<= 0 (inv@30@06 r)))
    (=
      ($FVF.lookup_bool (as sm@31@06  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))) r)))
  :pattern (($FVF.lookup_bool (as sm@31@06  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))) r))
  :qid |qp.fvfValDef3|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@06)))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@31@06  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef4|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@30@06 r) V@25@06) (<= 0 (inv@30@06 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@31@06  $FVF<Bool>) r) r))
  :pattern ((inv@30@06 r))
  )))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@32@06 $Snap)
(assert (= $t@32@06 ($Snap.combine ($Snap.first $t@32@06) ($Snap.second $t@32@06))))
(assert (= ($Snap.first $t@32@06) $Snap.unit))
; [eval] exc == null
(assert (= exc@26@06 $Ref.null))
(assert (=
  ($Snap.second $t@32@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@32@06))
    ($Snap.second ($Snap.second $t@32@06)))))
(assert (= ($Snap.first ($Snap.second $t@32@06)) $Snap.unit))
; [eval] exc == null ==> visited != (None(): option[array])
; [eval] exc == null
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@26@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               178
;  :arith-add-rows          41
;  :arith-assert-diseq      8
;  :arith-assert-lower      27
;  :arith-assert-upper      15
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               7
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 8
;  :datatype-occurs-check   15
;  :datatype-splits         7
;  :decisions               12
;  :del-clause              46
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.29
;  :mk-bool-var             555
;  :mk-clause               46
;  :num-allocs              165485
;  :num-checks              16
;  :propagations            46
;  :quant-instantiations    42
;  :rlimit-count            192691)
; [then-branch: 8 | exc@26@06 == Null | live]
; [else-branch: 8 | exc@26@06 != Null | dead]
(push) ; 4
; [then-branch: 8 | exc@26@06 == Null]
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (= exc@26@06 $Ref.null)
  (not (= visited@23@06 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@32@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@32@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@32@06))) $Snap.unit))
; [eval] exc == null ==> alen(opt_get1(visited)) == V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@26@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               192
;  :arith-add-rows          41
;  :arith-assert-diseq      8
;  :arith-assert-lower      27
;  :arith-assert-upper      15
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               7
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 10
;  :datatype-occurs-check   18
;  :datatype-splits         8
;  :decisions               14
;  :del-clause              46
;  :final-checks            15
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             558
;  :mk-clause               46
;  :num-allocs              166059
;  :num-checks              17
;  :propagations            46
;  :quant-instantiations    42
;  :rlimit-count            193357)
; [then-branch: 9 | exc@26@06 == Null | live]
; [else-branch: 9 | exc@26@06 != Null | dead]
(push) ; 4
; [then-branch: 9 | exc@26@06 == Null]
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
  (= exc@26@06 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@23@06)) V@25@06)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@32@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@32@06))))
  $Snap.unit))
; [eval] exc == null ==> 0 <= s
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@26@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               207
;  :arith-add-rows          41
;  :arith-assert-diseq      8
;  :arith-assert-lower      27
;  :arith-assert-upper      15
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               7
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   21
;  :datatype-splits         9
;  :decisions               16
;  :del-clause              46
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             561
;  :mk-clause               46
;  :num-allocs              166637
;  :num-checks              18
;  :propagations            46
;  :quant-instantiations    42
;  :rlimit-count            194041)
; [then-branch: 10 | exc@26@06 == Null | live]
; [else-branch: 10 | exc@26@06 != Null | dead]
(push) ; 4
; [then-branch: 10 | exc@26@06 == Null]
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@26@06 $Ref.null) (<= 0 s@24@06)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
  $Snap.unit))
; [eval] exc == null ==> s < V
; [eval] exc == null
(push) ; 3
(push) ; 4
(assert (not (not (= exc@26@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               223
;  :arith-add-rows          41
;  :arith-assert-diseq      8
;  :arith-assert-lower      27
;  :arith-assert-upper      15
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               7
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 14
;  :datatype-occurs-check   26
;  :datatype-splits         10
;  :decisions               18
;  :del-clause              46
;  :final-checks            19
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.30
;  :mk-bool-var             564
;  :mk-clause               46
;  :num-allocs              167219
;  :num-checks              19
;  :propagations            46
;  :quant-instantiations    42
;  :rlimit-count            194740)
; [then-branch: 11 | exc@26@06 == Null | live]
; [else-branch: 11 | exc@26@06 != Null | dead]
(push) ; 4
; [then-branch: 11 | exc@26@06 == Null]
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (= exc@26@06 $Ref.null) (< s@24@06 V@25@06)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@26@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-add-rows          41
;  :arith-assert-diseq      8
;  :arith-assert-lower      27
;  :arith-assert-upper      15
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               7
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   31
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              46
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.31
;  :mk-bool-var             567
;  :mk-clause               46
;  :num-allocs              167806
;  :num-checks              20
;  :propagations            46
;  :quant-instantiations    42
;  :rlimit-count            195439)
; [then-branch: 12 | exc@26@06 == Null | live]
; [else-branch: 12 | exc@26@06 != Null | dead]
(push) ; 3
; [then-branch: 12 | exc@26@06 == Null]
(declare-const k@33@06 Int)
(push) ; 4
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 5
; [then-branch: 13 | 0 <= k@33@06 | live]
; [else-branch: 13 | !(0 <= k@33@06) | live]
(push) ; 6
; [then-branch: 13 | 0 <= k@33@06]
(assert (<= 0 k@33@06))
; [eval] k < V
(pop) ; 6
(push) ; 6
; [else-branch: 13 | !(0 <= k@33@06)]
(assert (not (<= 0 k@33@06)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< k@33@06 V@25@06) (<= 0 k@33@06)))
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
(assert (not (< k@33@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-add-rows          42
;  :arith-assert-diseq      8
;  :arith-assert-lower      28
;  :arith-assert-upper      16
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               7
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   31
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              46
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             569
;  :mk-clause               46
;  :num-allocs              167928
;  :num-checks              21
;  :propagations            46
;  :quant-instantiations    42
;  :rlimit-count            195615)
(assert (< k@33@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 5
; Joined path conditions
(assert (< k@33@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 4
(declare-fun inv@34@06 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@33@06 Int)) (!
  (< k@33@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@33@06))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((k1@33@06 Int) (k2@33@06 Int)) (!
  (implies
    (and
      (and (< k1@33@06 V@25@06) (<= 0 k1@33@06))
      (and (< k2@33@06 V@25@06) (<= 0 k2@33@06))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k1@33@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k2@33@06)))
    (= k1@33@06 k2@33@06))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               247
;  :arith-add-rows          46
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      18
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               8
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 17
;  :datatype-occurs-check   31
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              52
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.32
;  :mk-bool-var             588
;  :mk-clause               52
;  :num-allocs              168426
;  :num-checks              22
;  :propagations            46
;  :quant-instantiations    53
;  :rlimit-count            196448)
; Definitional axioms for inverse functions
(assert (forall ((k@33@06 Int)) (!
  (implies
    (and (< k@33@06 V@25@06) (<= 0 k@33@06))
    (=
      (inv@34@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@33@06))
      k@33@06))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@33@06))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@34@06 r) V@25@06) (<= 0 (inv@34@06 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) (inv@34@06 r))
      r))
  :pattern ((inv@34@06 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((k@33@06 Int)) (!
  (implies
    (and (< k@33@06 V@25@06) (<= 0 k@33@06))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@33@06)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@33@06))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@35@06 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@34@06 r) V@25@06) (<= 0 (inv@34@06 r)))
    (=
      ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))) r))
  :qid |qp.fvfValDef5|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef6|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@34@06 r) V@25@06) (<= 0 (inv@34@06 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) r) r))
  :pattern ((inv@34@06 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@26@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-add-rows          46
;  :arith-assert-diseq      9
;  :arith-assert-lower      30
;  :arith-assert-upper      18
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               8
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   36
;  :datatype-splits         14
;  :decisions               24
;  :del-clause              52
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             598
;  :mk-clause               52
;  :num-allocs              169907
;  :num-checks              23
;  :propagations            46
;  :quant-instantiations    53
;  :rlimit-count            199016)
; [then-branch: 14 | exc@26@06 == Null | live]
; [else-branch: 14 | exc@26@06 != Null | dead]
(push) ; 5
; [then-branch: 14 | exc@26@06 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
(declare-const unknown@36@06 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false
; [eval] 0 <= unknown && unknown < V && unknown != s
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 15 | 0 <= unknown@36@06 | live]
; [else-branch: 15 | !(0 <= unknown@36@06) | live]
(push) ; 8
; [then-branch: 15 | 0 <= unknown@36@06]
(assert (<= 0 unknown@36@06))
; [eval] unknown < V
(push) ; 9
; [then-branch: 16 | unknown@36@06 < V@25@06 | live]
; [else-branch: 16 | !(unknown@36@06 < V@25@06) | live]
(push) ; 10
; [then-branch: 16 | unknown@36@06 < V@25@06]
(assert (< unknown@36@06 V@25@06))
; [eval] unknown != s
(pop) ; 10
(push) ; 10
; [else-branch: 16 | !(unknown@36@06 < V@25@06)]
(assert (not (< unknown@36@06 V@25@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 15 | !(0 <= unknown@36@06)]
(assert (not (<= 0 unknown@36@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 17 | unknown@36@06 != s@24@06 && unknown@36@06 < V@25@06 && 0 <= unknown@36@06 | live]
; [else-branch: 17 | !(unknown@36@06 != s@24@06 && unknown@36@06 < V@25@06 && 0 <= unknown@36@06) | live]
(push) ; 8
; [then-branch: 17 | unknown@36@06 != s@24@06 && unknown@36@06 < V@25@06 && 0 <= unknown@36@06]
(assert (and
  (and (not (= unknown@36@06 s@24@06)) (< unknown@36@06 V@25@06))
  (<= 0 unknown@36@06)))
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
(assert (not (< unknown@36@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-add-rows          47
;  :arith-assert-diseq      11
;  :arith-assert-lower      32
;  :arith-assert-upper      19
;  :arith-bound-prop        3
;  :arith-conflicts         4
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         5
;  :arith-offset-eqs        5
;  :arith-pivots            24
;  :conflicts               8
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   36
;  :datatype-splits         14
;  :decisions               24
;  :del-clause              52
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.33
;  :mk-bool-var             604
;  :mk-clause               54
;  :num-allocs              170127
;  :num-checks              24
;  :propagations            46
;  :quant-instantiations    53
;  :rlimit-count            199322)
(assert (< unknown@36@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@36@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06)))
(push) ; 9
(assert (not (and
  (<
    (inv@34@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))
    V@25@06)
  (<=
    0
    (inv@34@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-add-rows          58
;  :arith-assert-diseq      11
;  :arith-assert-lower      34
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            27
;  :conflicts               9
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   36
;  :datatype-splits         14
;  :decisions               24
;  :del-clause              52
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             632
;  :mk-clause               67
;  :num-allocs              170503
;  :num-checks              25
;  :propagations            46
;  :quant-instantiations    66
;  :rlimit-count            200150)
(pop) ; 8
(push) ; 8
; [else-branch: 17 | !(unknown@36@06 != s@24@06 && unknown@36@06 < V@25@06 && 0 <= unknown@36@06)]
(assert (not
  (and
    (and (not (= unknown@36@06 s@24@06)) (< unknown@36@06 V@25@06))
    (<= 0 unknown@36@06))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and
    (and (not (= unknown@36@06 s@24@06)) (< unknown@36@06 V@25@06))
    (<= 0 unknown@36@06))
  (and
    (not (= unknown@36@06 s@24@06))
    (< unknown@36@06 V@25@06)
    (<= 0 unknown@36@06)
    (< unknown@36@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@36@06 Int)) (!
  (implies
    (and
      (and (not (= unknown@36@06 s@24@06)) (< unknown@36@06 V@25@06))
      (<= 0 unknown@36@06))
    (and
      (not (= unknown@36@06 s@24@06))
      (< unknown@36@06 V@25@06)
      (<= 0 unknown@36@06)
      (< unknown@36@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@26@06 $Ref.null)
  (forall ((unknown@36@06 Int)) (!
    (implies
      (and
        (and (not (= unknown@36@06 s@24@06)) (< unknown@36@06 V@25@06))
        (<= 0 unknown@36@06))
      (and
        (not (= unknown@36@06 s@24@06))
        (< unknown@36@06 V@25@06)
        (<= 0 unknown@36@06)
        (< unknown@36@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@26@06 $Ref.null)
  (forall ((unknown@36@06 Int)) (!
    (implies
      (and
        (and (not (= unknown@36@06 s@24@06)) (< unknown@36@06 V@25@06))
        (<= 0 unknown@36@06))
      (=
        ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@36@06))
    :qid |prog.l<no position>|))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@32@06)))))))
  $Snap.unit))
; [eval] exc == null ==> aloc(opt_get1(visited), s).bool == true
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@26@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-add-rows          62
;  :arith-assert-diseq      11
;  :arith-assert-lower      34
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            30
;  :conflicts               9
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   40
;  :datatype-splits         15
;  :decisions               26
;  :del-clause              67
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             636
;  :mk-clause               67
;  :num-allocs              171415
;  :num-checks              26
;  :propagations            46
;  :quant-instantiations    66
;  :rlimit-count            201645)
; [then-branch: 18 | exc@26@06 == Null | live]
; [else-branch: 18 | exc@26@06 != Null | dead]
(push) ; 5
; [then-branch: 18 | exc@26@06 == Null]
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
(assert (not (< s@24@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               286
;  :arith-add-rows          62
;  :arith-assert-diseq      11
;  :arith-assert-lower      34
;  :arith-assert-upper      22
;  :arith-bound-prop        5
;  :arith-conflicts         5
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        5
;  :arith-pivots            30
;  :conflicts               9
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   40
;  :datatype-splits         15
;  :decisions               26
;  :del-clause              67
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.38
;  :memory                  4.36
;  :mk-bool-var             636
;  :mk-clause               67
;  :num-allocs              171442
;  :num-checks              27
;  :propagations            46
;  :quant-instantiations    66
;  :rlimit-count            201680)
(assert (< s@24@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 6
; Joined path conditions
(assert (< s@24@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)))
(push) ; 6
(assert (not (and
  (<
    (inv@34@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
    V@25@06)
  (<=
    0
    (inv@34@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-add-rows          67
;  :arith-assert-diseq      11
;  :arith-assert-lower      36
;  :arith-assert-upper      24
;  :arith-bound-prop        10
;  :arith-conflicts         5
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            32
;  :conflicts               10
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 22
;  :datatype-occurs-check   40
;  :datatype-splits         15
;  :decisions               26
;  :del-clause              67
;  :final-checks            25
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             682
;  :mk-clause               102
;  :num-allocs              171826
;  :num-checks              28
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            202582)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@26@06 $Ref.null)
  (and
    (< s@24@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)))))
(assert (implies
  (= exc@26@06 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@35@06  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
    true)))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [exec]
; var return: void
(declare-const return@37@06 void)
; [exec]
; var res1: void
(declare-const res1@38@06 void)
; [exec]
; var evaluationDummy: void
(declare-const evaluationDummy@39@06 void)
; [exec]
; exc := null
; [exec]
; exc, res1 := do_par_$unknown$2(V, visited, s)
; [eval] 0 < V ==> visited != (None(): option[array])
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@25@06))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-add-rows          69
;  :arith-assert-diseq      11
;  :arith-assert-lower      37
;  :arith-assert-upper      24
;  :arith-bound-prop        10
;  :arith-conflicts         5
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            34
;  :conflicts               10
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   41
;  :datatype-splits         15
;  :decisions               27
;  :del-clause              102
;  :final-checks            26
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             683
;  :mk-clause               102
;  :num-allocs              172350
;  :num-checks              29
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            203176)
(push) ; 4
(assert (not (< 0 V@25@06)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      37
;  :arith-assert-upper      25
;  :arith-bound-prop        10
;  :arith-conflicts         6
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               11
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   41
;  :datatype-splits         15
;  :decisions               27
;  :del-clause              102
;  :final-checks            26
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             684
;  :mk-clause               102
;  :num-allocs              172424
;  :num-checks              30
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            203245)
; [then-branch: 19 | 0 < V@25@06 | live]
; [else-branch: 19 | !(0 < V@25@06) | dead]
(push) ; 4
; [then-branch: 19 | 0 < V@25@06]
(assert (< 0 V@25@06))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies
  (< 0 V@25@06)
  (not (= visited@23@06 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      37
;  :arith-assert-upper      25
;  :arith-bound-prop        10
;  :arith-conflicts         6
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               11
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 23
;  :datatype-occurs-check   41
;  :datatype-splits         15
;  :decisions               27
;  :del-clause              102
;  :final-checks            26
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             684
;  :mk-clause               102
;  :num-allocs              172454
;  :num-checks              31
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            203276)
(assert (implies
  (< 0 V@25@06)
  (not (= visited@23@06 (as None<option<array>>  option<array>)))))
; [eval] 0 < V ==> alen(opt_get1(visited)) == V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@25@06))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               310
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      38
;  :arith-assert-upper      25
;  :arith-bound-prop        10
;  :arith-conflicts         6
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               11
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   42
;  :datatype-splits         15
;  :decisions               28
;  :del-clause              102
;  :final-checks            27
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             685
;  :mk-clause               102
;  :num-allocs              172960
;  :num-checks              32
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            203810)
(push) ; 4
(assert (not (< 0 V@25@06)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               310
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      38
;  :arith-assert-upper      26
;  :arith-bound-prop        10
;  :arith-conflicts         7
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               12
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   42
;  :datatype-splits         15
;  :decisions               28
;  :del-clause              102
;  :final-checks            27
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             686
;  :mk-clause               102
;  :num-allocs              173034
;  :num-checks              33
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            203863)
; [then-branch: 20 | 0 < V@25@06 | live]
; [else-branch: 20 | !(0 < V@25@06) | dead]
(push) ; 4
; [then-branch: 20 | 0 < V@25@06]
(assert (< 0 V@25@06))
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
  (< 0 V@25@06)
  (= (alen<Int> (opt_get1 $Snap.unit visited@23@06)) V@25@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               310
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      39
;  :arith-assert-upper      26
;  :arith-bound-prop        10
;  :arith-conflicts         7
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               12
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 24
;  :datatype-occurs-check   42
;  :datatype-splits         15
;  :decisions               28
;  :del-clause              102
;  :final-checks            27
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             687
;  :mk-clause               102
;  :num-allocs              173116
;  :num-checks              34
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            203949)
(assert (implies
  (< 0 V@25@06)
  (= (alen<Int> (opt_get1 $Snap.unit visited@23@06)) V@25@06)))
; [eval] 0 < V ==> 0 <= s
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@25@06))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               313
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      40
;  :arith-assert-upper      26
;  :arith-bound-prop        10
;  :arith-conflicts         7
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               12
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   43
;  :datatype-splits         15
;  :decisions               29
;  :del-clause              102
;  :final-checks            28
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             688
;  :mk-clause               102
;  :num-allocs              173629
;  :num-checks              35
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            204481)
(push) ; 4
(assert (not (< 0 V@25@06)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               313
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      40
;  :arith-assert-upper      27
;  :arith-bound-prop        10
;  :arith-conflicts         8
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               13
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   43
;  :datatype-splits         15
;  :decisions               29
;  :del-clause              102
;  :final-checks            28
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             689
;  :mk-clause               102
;  :num-allocs              173703
;  :num-checks              36
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            204534)
; [then-branch: 21 | 0 < V@25@06 | live]
; [else-branch: 21 | !(0 < V@25@06) | dead]
(push) ; 4
; [then-branch: 21 | 0 < V@25@06]
(assert (< 0 V@25@06))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@25@06) (<= 0 s@24@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               313
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      40
;  :arith-assert-upper      27
;  :arith-bound-prop        10
;  :arith-conflicts         8
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               13
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 25
;  :datatype-occurs-check   43
;  :datatype-splits         15
;  :decisions               29
;  :del-clause              102
;  :final-checks            28
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             689
;  :mk-clause               102
;  :num-allocs              173737
;  :num-checks              37
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            204584)
(assert (implies (< 0 V@25@06) (<= 0 s@24@06)))
; [eval] 0 < V ==> s < V
; [eval] 0 < V
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (< 0 V@25@06))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               316
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      41
;  :arith-assert-upper      27
;  :arith-bound-prop        10
;  :arith-conflicts         8
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               13
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   44
;  :datatype-splits         15
;  :decisions               30
;  :del-clause              102
;  :final-checks            29
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             690
;  :mk-clause               102
;  :num-allocs              174294
;  :num-checks              38
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            205139)
(push) ; 4
(assert (not (< 0 V@25@06)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               316
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      41
;  :arith-assert-upper      28
;  :arith-bound-prop        10
;  :arith-conflicts         9
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               14
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   44
;  :datatype-splits         15
;  :decisions               30
;  :del-clause              102
;  :final-checks            29
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             691
;  :mk-clause               102
;  :num-allocs              174368
;  :num-checks              39
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            205192)
; [then-branch: 22 | 0 < V@25@06 | live]
; [else-branch: 22 | !(0 < V@25@06) | dead]
(push) ; 4
; [then-branch: 22 | 0 < V@25@06]
(assert (< 0 V@25@06))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(set-option :timeout 0)
(push) ; 3
(assert (not (implies (< 0 V@25@06) (< s@24@06 V@25@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               316
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      41
;  :arith-assert-upper      28
;  :arith-bound-prop        10
;  :arith-conflicts         9
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               14
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   44
;  :datatype-splits         15
;  :decisions               30
;  :del-clause              102
;  :final-checks            29
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             691
;  :mk-clause               102
;  :num-allocs              174402
;  :num-checks              40
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            205245)
(assert (implies (< 0 V@25@06) (< s@24@06 V@25@06)))
(declare-const i1@40@06 Int)
(push) ; 3
; [eval] 0 <= i1 && i1 < V
; [eval] 0 <= i1
(push) ; 4
; [then-branch: 23 | 0 <= i1@40@06 | live]
; [else-branch: 23 | !(0 <= i1@40@06) | live]
(push) ; 5
; [then-branch: 23 | 0 <= i1@40@06]
(assert (<= 0 i1@40@06))
; [eval] i1 < V
(pop) ; 5
(push) ; 5
; [else-branch: 23 | !(0 <= i1@40@06)]
(assert (not (<= 0 i1@40@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(assert (and (< i1@40@06 V@25@06) (<= 0 i1@40@06)))
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
(assert (not (< i1@40@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               316
;  :arith-add-rows          70
;  :arith-assert-diseq      11
;  :arith-assert-lower      43
;  :arith-assert-upper      28
;  :arith-bound-prop        10
;  :arith-conflicts         9
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            35
;  :conflicts               14
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   44
;  :datatype-splits         15
;  :decisions               30
;  :del-clause              102
;  :final-checks            29
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             693
;  :mk-clause               102
;  :num-allocs              174549
;  :num-checks              41
;  :propagations            51
;  :quant-instantiations    84
;  :rlimit-count            205457)
(assert (< i1@40@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 4
; Joined path conditions
(assert (< i1@40@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 3
(declare-fun inv@41@06 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((i1@40@06 Int)) (!
  (< i1@40@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i1@40@06))
  :qid |bool-aux|)))
; Definitional axioms for snapshot map values
; Check receiver injectivity
(push) ; 3
(assert (not (forall ((i11@40@06 Int) (i12@40@06 Int)) (!
  (implies
    (and
      (and
        (and (< i11@40@06 V@25@06) (<= 0 i11@40@06))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@31@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i11@40@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i11@40@06)))
      (and
        (and (< i12@40@06 V@25@06) (<= 0 i12@40@06))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@31@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i12@40@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i12@40@06)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i11@40@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i12@40@06)))
    (= i11@40@06 i12@40@06))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               324
;  :arith-add-rows          74
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      28
;  :arith-bound-prop        10
;  :arith-conflicts         9
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        8
;  :arith-pivots            37
;  :conflicts               15
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 26
;  :datatype-occurs-check   44
;  :datatype-splits         15
;  :decisions               30
;  :del-clause              113
;  :final-checks            29
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.38
;  :mk-bool-var             720
;  :mk-clause               113
;  :num-allocs              175091
;  :num-checks              42
;  :propagations            51
;  :quant-instantiations    97
;  :rlimit-count            206480)
; Definitional axioms for inverse functions
(assert (forall ((i1@40@06 Int)) (!
  (implies
    (and (< i1@40@06 V@25@06) (<= 0 i1@40@06))
    (=
      (inv@41@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i1@40@06))
      i1@40@06))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) i1@40@06))
  :qid |bool-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@41@06 r) V@25@06) (<= 0 (inv@41@06 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) (inv@41@06 r))
      r))
  :pattern ((inv@41@06 r))
  :qid |bool-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@41@06 r) V@25@06) (<= 0 (inv@41@06 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@31@06  $FVF<Bool>) r) r))
  :pattern ((inv@41@06 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@42@06 ((r $Ref)) $Perm
  (ite
    (and (< (inv@41@06 r) V@25@06) (<= 0 (inv@41@06 r)))
    ($Perm.min
      (ite
        (and (< (inv@30@06 r) V@25@06) (<= 0 (inv@30@06 r)))
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
        (and (< (inv@30@06 r) V@25@06) (<= 0 (inv@30@06 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@42@06 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-add-rows          98
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      41
;  :arith-bound-prop        12
;  :arith-conflicts         13
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        11
;  :arith-pivots            51
;  :conflicts               23
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   45
;  :datatype-splits         15
;  :decisions               38
;  :del-clause              172
;  :final-checks            30
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             817
;  :mk-clause               172
;  :num-allocs              176683
;  :num-checks              44
;  :propagations            91
;  :quant-instantiations    135
;  :rlimit-count            209455
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 3
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@41@06 r) V@25@06) (<= 0 (inv@41@06 r)))
    (= (- $Perm.Write (pTaken@42@06 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               407
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      73
;  :arith-assert-upper      46
;  :arith-bound-prop        13
;  :arith-conflicts         14
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               24
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 28
;  :datatype-occurs-check   45
;  :datatype-splits         15
;  :decisions               38
;  :del-clause              192
;  :final-checks            30
;  :max-generation          3
;  :max-memory              4.40
;  :memory                  4.39
;  :mk-bool-var             853
;  :mk-clause               192
;  :num-allocs              177072
;  :num-checks              45
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            210426)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
(declare-const exc@43@06 $Ref)
(declare-const res@44@06 void)
(declare-const $t@45@06 $Snap)
(assert (= $t@45@06 ($Snap.combine ($Snap.first $t@45@06) ($Snap.second $t@45@06))))
(assert (= ($Snap.first $t@45@06) $Snap.unit))
; [eval] exc == null
(assert (= exc@43@06 $Ref.null))
(assert (=
  ($Snap.second $t@45@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@45@06))
    ($Snap.second ($Snap.second $t@45@06)))))
(assert (= ($Snap.first ($Snap.second $t@45@06)) $Snap.unit))
; [eval] exc == null && 0 < V ==> visited != (None(): option[array])
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 24 | exc@43@06 == Null | live]
; [else-branch: 24 | exc@43@06 != Null | live]
(push) ; 4
; [then-branch: 24 | exc@43@06 == Null]
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 24 | exc@43@06 != Null]
(assert (not (= exc@43@06 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               427
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      74
;  :arith-assert-upper      46
;  :arith-bound-prop        13
;  :arith-conflicts         14
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               24
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 30
;  :datatype-occurs-check   48
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              192
;  :final-checks            32
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             860
;  :mk-clause               192
;  :num-allocs              177753
;  :num-checks              46
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            211295)
(push) ; 4
(assert (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               427
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      74
;  :arith-assert-upper      47
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               25
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 30
;  :datatype-occurs-check   48
;  :datatype-splits         16
;  :decisions               40
;  :del-clause              192
;  :final-checks            32
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.39
;  :mk-bool-var             861
;  :mk-clause               192
;  :num-allocs              177827
;  :num-checks              47
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            211352)
; [then-branch: 25 | 0 < V@25@06 && exc@43@06 == Null | live]
; [else-branch: 25 | !(0 < V@25@06 && exc@43@06 == Null) | dead]
(push) ; 4
; [then-branch: 25 | 0 < V@25@06 && exc@43@06 == Null]
(assert (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and (< 0 V@25@06) (= exc@43@06 $Ref.null))
  (not (= visited@23@06 (as None<option<array>>  option<array>)))))
(assert (=
  ($Snap.second ($Snap.second $t@45@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@45@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@45@06))) $Snap.unit))
; [eval] exc == null && 0 < V ==> alen(opt_get1(visited)) == V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 26 | exc@43@06 == Null | live]
; [else-branch: 26 | exc@43@06 != Null | live]
(push) ; 4
; [then-branch: 26 | exc@43@06 == Null]
(assert (= exc@43@06 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 26 | exc@43@06 != Null]
(assert (not (= exc@43@06 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               441
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      75
;  :arith-assert-upper      47
;  :arith-bound-prop        13
;  :arith-conflicts         15
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               25
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 32
;  :datatype-occurs-check   51
;  :datatype-splits         17
;  :decisions               42
;  :del-clause              192
;  :final-checks            34
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             865
;  :mk-clause               192
;  :num-allocs              178454
;  :num-checks              48
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            212123)
(push) ; 4
(assert (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               441
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      75
;  :arith-assert-upper      48
;  :arith-bound-prop        13
;  :arith-conflicts         16
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               26
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 32
;  :datatype-occurs-check   51
;  :datatype-splits         17
;  :decisions               42
;  :del-clause              192
;  :final-checks            34
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.39
;  :mk-bool-var             866
;  :mk-clause               192
;  :num-allocs              178528
;  :num-checks              49
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            212180)
; [then-branch: 27 | 0 < V@25@06 && exc@43@06 == Null | live]
; [else-branch: 27 | !(0 < V@25@06 && exc@43@06 == Null) | dead]
(push) ; 4
; [then-branch: 27 | 0 < V@25@06 && exc@43@06 == Null]
(assert (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))
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
  (and (< 0 V@25@06) (= exc@43@06 $Ref.null))
  (= (alen<Int> (opt_get1 $Snap.unit visited@23@06)) V@25@06)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@45@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@45@06))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> 0 <= s
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 28 | exc@43@06 == Null | live]
; [else-branch: 28 | exc@43@06 != Null | live]
(push) ; 4
; [then-branch: 28 | exc@43@06 == Null]
(assert (= exc@43@06 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 28 | exc@43@06 != Null]
(assert (not (= exc@43@06 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               456
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      77
;  :arith-assert-upper      48
;  :arith-bound-prop        13
;  :arith-conflicts         16
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               26
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   54
;  :datatype-splits         18
;  :decisions               44
;  :del-clause              192
;  :final-checks            36
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             871
;  :mk-clause               192
;  :num-allocs              179221
;  :num-checks              50
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            213019)
(push) ; 4
(assert (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               456
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      77
;  :arith-assert-upper      49
;  :arith-bound-prop        13
;  :arith-conflicts         17
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               27
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 34
;  :datatype-occurs-check   54
;  :datatype-splits         18
;  :decisions               44
;  :del-clause              192
;  :final-checks            36
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.39
;  :mk-bool-var             872
;  :mk-clause               192
;  :num-allocs              179295
;  :num-checks              51
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            213076)
; [then-branch: 29 | 0 < V@25@06 && exc@43@06 == Null | live]
; [else-branch: 29 | !(0 < V@25@06 && exc@43@06 == Null) | dead]
(push) ; 4
; [then-branch: 29 | 0 < V@25@06 && exc@43@06 == Null]
(assert (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))
; [eval] 0 <= s
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@25@06) (= exc@43@06 $Ref.null)) (<= 0 s@24@06)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06)))))
  $Snap.unit))
; [eval] exc == null && 0 < V ==> s < V
; [eval] exc == null && 0 < V
; [eval] exc == null
(push) ; 3
; [then-branch: 30 | exc@43@06 == Null | live]
; [else-branch: 30 | exc@43@06 != Null | live]
(push) ; 4
; [then-branch: 30 | exc@43@06 == Null]
(assert (= exc@43@06 $Ref.null))
; [eval] 0 < V
(pop) ; 4
(push) ; 4
; [else-branch: 30 | exc@43@06 != Null]
(assert (not (= exc@43@06 $Ref.null)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(push) ; 4
(assert (not (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               472
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      78
;  :arith-assert-upper      49
;  :arith-bound-prop        13
;  :arith-conflicts         17
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               27
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   59
;  :datatype-splits         19
;  :decisions               46
;  :del-clause              192
;  :final-checks            38
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             876
;  :mk-clause               192
;  :num-allocs              179940
;  :num-checks              52
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            213883)
(push) ; 4
(assert (not (and (< 0 V@25@06) (= exc@43@06 $Ref.null))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               472
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      78
;  :arith-assert-upper      50
;  :arith-bound-prop        13
;  :arith-conflicts         18
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               28
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   59
;  :datatype-splits         19
;  :decisions               46
;  :del-clause              192
;  :final-checks            38
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.39
;  :mk-bool-var             877
;  :mk-clause               192
;  :num-allocs              180014
;  :num-checks              53
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            213940)
; [then-branch: 31 | 0 < V@25@06 && exc@43@06 == Null | live]
; [else-branch: 31 | !(0 < V@25@06 && exc@43@06 == Null) | dead]
(push) ; 4
; [then-branch: 31 | 0 < V@25@06 && exc@43@06 == Null]
(assert (and (< 0 V@25@06) (= exc@43@06 $Ref.null)))
; [eval] s < V
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies (and (< 0 V@25@06) (= exc@43@06 $Ref.null)) (< s@24@06 V@25@06)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06)))))))))
; [eval] exc == null
(push) ; 3
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               489
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      78
;  :arith-assert-upper      50
;  :arith-bound-prop        13
;  :arith-conflicts         18
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               28
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   64
;  :datatype-splits         21
;  :decisions               49
;  :del-clause              192
;  :final-checks            40
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             880
;  :mk-clause               192
;  :num-allocs              180605
;  :num-checks              54
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            214666)
(push) ; 3
(assert (not (= exc@43@06 $Ref.null)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               489
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      78
;  :arith-assert-upper      50
;  :arith-bound-prop        13
;  :arith-conflicts         18
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               28
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   64
;  :datatype-splits         21
;  :decisions               49
;  :del-clause              192
;  :final-checks            40
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             880
;  :mk-clause               192
;  :num-allocs              180621
;  :num-checks              55
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            214677)
; [then-branch: 32 | exc@43@06 == Null | live]
; [else-branch: 32 | exc@43@06 != Null | dead]
(push) ; 3
; [then-branch: 32 | exc@43@06 == Null]
(assert (= exc@43@06 $Ref.null))
(declare-const unknown@46@06 Int)
(push) ; 4
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 5
; [then-branch: 33 | 0 <= unknown@46@06 | live]
; [else-branch: 33 | !(0 <= unknown@46@06) | live]
(push) ; 6
; [then-branch: 33 | 0 <= unknown@46@06]
(assert (<= 0 unknown@46@06))
; [eval] unknown < V
(pop) ; 6
(push) ; 6
; [else-branch: 33 | !(0 <= unknown@46@06)]
(assert (not (<= 0 unknown@46@06)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (and (< unknown@46@06 V@25@06) (<= 0 unknown@46@06)))
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
(assert (not (< unknown@46@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               489
;  :arith-add-rows          105
;  :arith-assert-diseq      22
;  :arith-assert-lower      80
;  :arith-assert-upper      50
;  :arith-bound-prop        13
;  :arith-conflicts         18
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               28
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   64
;  :datatype-splits         21
;  :decisions               49
;  :del-clause              192
;  :final-checks            40
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             882
;  :mk-clause               192
;  :num-allocs              180723
;  :num-checks              56
;  :propagations            96
;  :quant-instantiations    148
;  :rlimit-count            214865)
(assert (< unknown@46@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 5
; Joined path conditions
(assert (< unknown@46@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 4
(declare-fun inv@47@06 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((unknown@46@06 Int)) (!
  (< unknown@46@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@46@06))
  :qid |bool-aux|)))
; Check receiver injectivity
(push) ; 4
(assert (not (forall ((unknown1@46@06 Int) (unknown2@46@06 Int)) (!
  (implies
    (and
      (and (< unknown1@46@06 V@25@06) (<= 0 unknown1@46@06))
      (and (< unknown2@46@06 V@25@06) (<= 0 unknown2@46@06))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown1@46@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown2@46@06)))
    (= unknown1@46@06 unknown2@46@06))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               498
;  :arith-add-rows          107
;  :arith-assert-diseq      23
;  :arith-assert-lower      84
;  :arith-assert-upper      50
;  :arith-bound-prop        13
;  :arith-conflicts         18
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               29
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   64
;  :datatype-splits         21
;  :decisions               49
;  :del-clause              198
;  :final-checks            40
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.39
;  :mk-bool-var             903
;  :mk-clause               198
;  :num-allocs              181238
;  :num-checks              57
;  :propagations            96
;  :quant-instantiations    163
;  :rlimit-count            215782)
; Definitional axioms for inverse functions
(assert (forall ((unknown@46@06 Int)) (!
  (implies
    (and (< unknown@46@06 V@25@06) (<= 0 unknown@46@06))
    (=
      (inv@47@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@46@06))
      unknown@46@06))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@46@06))
  )))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) (inv@47@06 r))
      r))
  :pattern ((inv@47@06 r))
  :qid |bool-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((unknown@46@06 Int)) (!
  (implies
    (and (< unknown@46@06 V@25@06) (<= 0 unknown@46@06))
    (not
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@46@06)
        $Ref.null)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@46@06))
  :qid |bool-permImpliesNonNull|)))
(declare-const sm@48@06 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
    (=
      ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))) r))
  :qid |qp.fvfValDef7|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))) r) r)
  :pattern (($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef8|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) r) r))
  :pattern ((inv@47@06 r))
  )))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))
  $Snap.unit))
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(visited), unknown).bool == false)
; [eval] exc == null
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               510
;  :arith-add-rows          107
;  :arith-assert-diseq      23
;  :arith-assert-lower      84
;  :arith-assert-upper      50
;  :arith-bound-prop        13
;  :arith-conflicts         18
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               29
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   69
;  :datatype-splits         22
;  :decisions               51
;  :del-clause              198
;  :final-checks            42
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             911
;  :mk-clause               198
;  :num-allocs              182610
;  :num-checks              58
;  :propagations            96
;  :quant-instantiations    163
;  :rlimit-count            218061)
; [then-branch: 34 | exc@43@06 == Null | live]
; [else-branch: 34 | exc@43@06 != Null | dead]
(push) ; 5
; [then-branch: 34 | exc@43@06 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V ==> aloc(opt_get1(visited), unknown).bool == false)
(declare-const unknown@49@06 Int)
(push) ; 6
; [eval] 0 <= unknown && unknown < V ==> aloc(opt_get1(visited), unknown).bool == false
; [eval] 0 <= unknown && unknown < V
; [eval] 0 <= unknown
(push) ; 7
; [then-branch: 35 | 0 <= unknown@49@06 | live]
; [else-branch: 35 | !(0 <= unknown@49@06) | live]
(push) ; 8
; [then-branch: 35 | 0 <= unknown@49@06]
(assert (<= 0 unknown@49@06))
; [eval] unknown < V
(pop) ; 8
(push) ; 8
; [else-branch: 35 | !(0 <= unknown@49@06)]
(assert (not (<= 0 unknown@49@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 36 | unknown@49@06 < V@25@06 && 0 <= unknown@49@06 | live]
; [else-branch: 36 | !(unknown@49@06 < V@25@06 && 0 <= unknown@49@06) | live]
(push) ; 8
; [then-branch: 36 | unknown@49@06 < V@25@06 && 0 <= unknown@49@06]
(assert (and (< unknown@49@06 V@25@06) (<= 0 unknown@49@06)))
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
(assert (not (< unknown@49@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               510
;  :arith-add-rows          107
;  :arith-assert-diseq      23
;  :arith-assert-lower      86
;  :arith-assert-upper      50
;  :arith-bound-prop        13
;  :arith-conflicts         18
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        11
;  :arith-pivots            55
;  :conflicts               29
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   69
;  :datatype-splits         22
;  :decisions               51
;  :del-clause              198
;  :final-checks            42
;  :max-generation          3
;  :max-memory              4.41
;  :memory                  4.40
;  :mk-bool-var             913
;  :mk-clause               198
;  :num-allocs              182712
;  :num-checks              59
;  :propagations            96
;  :quant-instantiations    163
;  :rlimit-count            218254)
(assert (< unknown@49@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 9
; Joined path conditions
(assert (< unknown@49@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06)))
(push) ; 9
(assert (not (and
  (<
    (inv@47@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))
    V@25@06)
  (<=
    0
    (inv@47@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               521
;  :arith-add-rows          118
;  :arith-assert-diseq      23
;  :arith-assert-lower      89
;  :arith-assert-upper      54
;  :arith-bound-prop        16
;  :arith-conflicts         19
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        11
;  :arith-pivots            59
;  :conflicts               30
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 41
;  :datatype-occurs-check   69
;  :datatype-splits         22
;  :decisions               51
;  :del-clause              198
;  :final-checks            42
;  :max-generation          3
;  :max-memory              4.45
;  :memory                  4.44
;  :mk-bool-var             947
;  :mk-clause               213
;  :num-allocs              183054
;  :num-checks              60
;  :propagations            96
;  :quant-instantiations    179
;  :rlimit-count            219176)
(pop) ; 8
(push) ; 8
; [else-branch: 36 | !(unknown@49@06 < V@25@06 && 0 <= unknown@49@06)]
(assert (not (and (< unknown@49@06 V@25@06) (<= 0 unknown@49@06))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
(assert (implies
  (and (< unknown@49@06 V@25@06) (<= 0 unknown@49@06))
  (and
    (< unknown@49@06 V@25@06)
    (<= 0 unknown@49@06)
    (< unknown@49@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06)))))
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@49@06 Int)) (!
  (implies
    (and (< unknown@49@06 V@25@06) (<= 0 unknown@49@06))
    (and
      (< unknown@49@06 V@25@06)
      (<= 0 unknown@49@06)
      (< unknown@49@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (= exc@43@06 $Ref.null)
  (forall ((unknown@49@06 Int)) (!
    (implies
      (and (< unknown@49@06 V@25@06) (<= 0 unknown@49@06))
      (and
        (< unknown@49@06 V@25@06)
        (<= 0 unknown@49@06)
        (< unknown@49@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))
    :qid |prog.l<no position>-aux|))))
(assert (implies
  (= exc@43@06 $Ref.null)
  (forall ((unknown@49@06 Int)) (!
    (implies
      (and (< unknown@49@06 V@25@06) (<= 0 unknown@49@06))
      (=
        ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@49@06))
    :qid |prog.l<no position>|))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] exc != null
; [then-branch: 37 | exc@43@06 != Null | dead]
; [else-branch: 37 | exc@43@06 == Null | live]
(push) ; 4
; [else-branch: 37 | exc@43@06 == Null]
(pop) ; 4
; [eval] !(exc != null)
; [eval] exc != null
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               543
;  :arith-add-rows          122
;  :arith-assert-diseq      23
;  :arith-assert-lower      89
;  :arith-assert-upper      54
;  :arith-bound-prop        16
;  :arith-conflicts         19
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        11
;  :arith-pivots            63
;  :conflicts               30
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   79
;  :datatype-splits         24
;  :decisions               55
;  :del-clause              213
;  :final-checks            46
;  :max-generation          3
;  :max-memory              4.46
;  :memory                  4.45
;  :mk-bool-var             951
;  :mk-clause               213
;  :num-allocs              184376
;  :num-checks              62
;  :propagations            96
;  :quant-instantiations    179
;  :rlimit-count            220991)
; [then-branch: 38 | exc@43@06 == Null | live]
; [else-branch: 38 | exc@43@06 != Null | dead]
(push) ; 4
; [then-branch: 38 | exc@43@06 == Null]
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
(assert (not (< s@24@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               543
;  :arith-add-rows          122
;  :arith-assert-diseq      23
;  :arith-assert-lower      89
;  :arith-assert-upper      54
;  :arith-bound-prop        16
;  :arith-conflicts         19
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         16
;  :arith-offset-eqs        11
;  :arith-pivots            63
;  :conflicts               30
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 45
;  :datatype-occurs-check   79
;  :datatype-splits         24
;  :decisions               55
;  :del-clause              213
;  :final-checks            46
;  :max-generation          3
;  :max-memory              4.46
;  :memory                  4.45
;  :mk-bool-var             951
;  :mk-clause               213
;  :num-allocs              184403
;  :num-checks              63
;  :propagations            96
;  :quant-instantiations    179
;  :rlimit-count            221026)
(assert (< s@24@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 5
; Joined path conditions
(assert (< s@24@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
; Definitional axioms for snapshot map values
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@48@06  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)))
; Precomputing data for removing quantified permissions
(define-fun pTaken@50@06 ((r $Ref)) $Perm
  (ite
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
    ($Perm.min
      (ite
        (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
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
        (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
        $Perm.Write
        $Perm.No)
      (pTaken@50@06 r))
    $Perm.No)
  
  ))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               664
;  :arith-add-rows          154
;  :arith-assert-diseq      26
;  :arith-assert-lower      107
;  :arith-assert-upper      64
;  :arith-bound-prop        26
;  :arith-conflicts         21
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        21
;  :arith-pivots            76
;  :conflicts               33
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   91
;  :datatype-splits         30
;  :decisions               84
;  :del-clause              326
;  :final-checks            52
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1131
;  :mk-clause               354
;  :num-allocs              187053
;  :num-checks              65
;  :propagations            142
;  :quant-instantiations    234
;  :rlimit-count            225310
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 5
(assert (not (forall ((r $Ref)) (!
  (implies
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
    (= (- $Perm.Write (pTaken@50@06 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               677
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 54
;  :datatype-occurs-check   91
;  :datatype-splits         30
;  :decisions               84
;  :del-clause              336
;  :final-checks            52
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1149
;  :mk-clause               364
;  :num-allocs              187347
;  :num-checks              66
;  :propagations            147
;  :quant-instantiations    234
;  :rlimit-count            225930)
; Final check if taken enough permissions
; Done removing quantified permissions
(declare-const sm@51@06 $FVF<Bool>)
; Definitional axioms for singleton-FVF's value
(assert (=
  ($FVF.lookup_bool (as sm@51@06  $FVF<Bool>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
  true))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@51@06  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)))
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
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               694
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   97
;  :datatype-splits         33
;  :decisions               92
;  :del-clause              352
;  :final-checks            55
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.73
;  :mk-bool-var             1166
;  :mk-clause               380
;  :num-allocs              188121
;  :num-checks              67
;  :propagations            155
;  :quant-instantiations    236
;  :rlimit-count            226806)
; [then-branch: 39 | exc@43@06 == Null | live]
; [else-branch: 39 | exc@43@06 != Null | dead]
(push) ; 6
; [then-branch: 39 | exc@43@06 == Null]
; [eval] visited != (None(): option[array])
; [eval] (None(): option[array])
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies
  (= exc@43@06 $Ref.null)
  (not (= visited@23@06 (as None<option<array>>  option<array>))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               694
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 58
;  :datatype-occurs-check   97
;  :datatype-splits         33
;  :decisions               92
;  :del-clause              352
;  :final-checks            55
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.73
;  :mk-bool-var             1166
;  :mk-clause               380
;  :num-allocs              188144
;  :num-checks              68
;  :propagations            155
;  :quant-instantiations    236
;  :rlimit-count            226826)
(assert (implies
  (= exc@43@06 $Ref.null)
  (not (= visited@23@06 (as None<option<array>>  option<array>)))))
; [eval] exc == null ==> alen(opt_get1(visited)) == V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               711
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   103
;  :datatype-splits         36
;  :decisions               100
;  :del-clause              368
;  :final-checks            58
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1181
;  :mk-clause               396
;  :num-allocs              188850
;  :num-checks              69
;  :propagations            163
;  :quant-instantiations    238
;  :rlimit-count            227597)
; [then-branch: 40 | exc@43@06 == Null | live]
; [else-branch: 40 | exc@43@06 != Null | dead]
(push) ; 6
; [then-branch: 40 | exc@43@06 == Null]
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
  (= exc@43@06 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@23@06)) V@25@06))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               711
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    30
;  :datatype-constructor-ax 62
;  :datatype-occurs-check   103
;  :datatype-splits         36
;  :decisions               100
;  :del-clause              368
;  :final-checks            58
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1181
;  :mk-clause               396
;  :num-allocs              188867
;  :num-checks              70
;  :propagations            163
;  :quant-instantiations    238
;  :rlimit-count            227622)
(assert (implies
  (= exc@43@06 $Ref.null)
  (= (alen<Int> (opt_get1 $Snap.unit visited@23@06)) V@25@06)))
; [eval] exc == null ==> 0 <= s
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               728
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 66
;  :datatype-occurs-check   109
;  :datatype-splits         39
;  :decisions               108
;  :del-clause              384
;  :final-checks            61
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1196
;  :mk-clause               412
;  :num-allocs              189573
;  :num-checks              71
;  :propagations            171
;  :quant-instantiations    240
;  :rlimit-count            228393)
; [then-branch: 41 | exc@43@06 == Null | live]
; [else-branch: 41 | exc@43@06 != Null | dead]
(push) ; 6
; [then-branch: 41 | exc@43@06 == Null]
; [eval] 0 <= s
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies (= exc@43@06 $Ref.null) (<= 0 s@24@06))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               728
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 66
;  :datatype-occurs-check   109
;  :datatype-splits         39
;  :decisions               108
;  :del-clause              384
;  :final-checks            61
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1196
;  :mk-clause               412
;  :num-allocs              189594
;  :num-checks              72
;  :propagations            171
;  :quant-instantiations    240
;  :rlimit-count            228419)
(assert (implies (= exc@43@06 $Ref.null) (<= 0 s@24@06)))
; [eval] exc == null ==> s < V
; [eval] exc == null
(push) ; 5
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               745
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   115
;  :datatype-splits         42
;  :decisions               116
;  :del-clause              400
;  :final-checks            64
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1211
;  :mk-clause               428
;  :num-allocs              190344
;  :num-checks              73
;  :propagations            179
;  :quant-instantiations    242
;  :rlimit-count            229206)
; [then-branch: 42 | exc@43@06 == Null | live]
; [else-branch: 42 | exc@43@06 != Null | dead]
(push) ; 6
; [then-branch: 42 | exc@43@06 == Null]
; [eval] s < V
(pop) ; 6
(pop) ; 5
; Joined path conditions
(set-option :timeout 0)
(push) ; 5
(assert (not (implies (= exc@43@06 $Ref.null) (< s@24@06 V@25@06))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               745
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 70
;  :datatype-occurs-check   115
;  :datatype-splits         42
;  :decisions               116
;  :del-clause              400
;  :final-checks            64
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1211
;  :mk-clause               428
;  :num-allocs              190371
;  :num-checks              74
;  :propagations            179
;  :quant-instantiations    242
;  :rlimit-count            229235)
(assert (implies (= exc@43@06 $Ref.null) (< s@24@06 V@25@06)))
; [eval] exc == null
(set-option :timeout 10)
(push) ; 5
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          167
;  :arith-assert-diseq      28
;  :arith-assert-lower      108
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   121
;  :datatype-splits         45
;  :decisions               124
;  :del-clause              416
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1226
;  :mk-clause               444
;  :num-allocs              191121
;  :num-checks              75
;  :propagations            187
;  :quant-instantiations    244
;  :rlimit-count            230022)
; [then-branch: 43 | exc@43@06 == Null | live]
; [else-branch: 43 | exc@43@06 != Null | dead]
(push) ; 5
; [then-branch: 43 | exc@43@06 == Null]
(declare-const k@52@06 Int)
(push) ; 6
; [eval] 0 <= k && k < V
; [eval] 0 <= k
(push) ; 7
; [then-branch: 44 | 0 <= k@52@06 | live]
; [else-branch: 44 | !(0 <= k@52@06) | live]
(push) ; 8
; [then-branch: 44 | 0 <= k@52@06]
(assert (<= 0 k@52@06))
; [eval] k < V
(pop) ; 8
(push) ; 8
; [else-branch: 44 | !(0 <= k@52@06)]
(assert (not (<= 0 k@52@06)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(assert (and (< k@52@06 V@25@06) (<= 0 k@52@06)))
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
(assert (not (< k@52@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          168
;  :arith-assert-diseq      28
;  :arith-assert-lower      110
;  :arith-assert-upper      68
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        23
;  :arith-pivots            79
;  :conflicts               34
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   121
;  :datatype-splits         45
;  :decisions               124
;  :del-clause              416
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1228
;  :mk-clause               444
;  :num-allocs              191223
;  :num-checks              76
;  :propagations            187
;  :quant-instantiations    244
;  :rlimit-count            230206)
(assert (< k@52@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 7
; Joined path conditions
(assert (< k@52@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 6
(declare-fun inv@53@06 ($Ref) Int)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
(assert (forall ((k@52@06 Int)) (!
  (< k@52@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@52@06))
  :qid |bool-aux|)))
(declare-const sm@54@06 $FVF<Bool>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (implies
    (=
      r
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
    (=
      ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) r)
      ($FVF.lookup_bool (as sm@51@06  $FVF<Bool>) r)))
  :pattern (($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool (as sm@51@06  $FVF<Bool>) r))
  :qid |qp.fvfValDef9|)))
(assert (forall ((r $Ref)) (!
  (implies
    (<
      $Perm.No
      (-
        (ite
          (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@50@06 r)))
    (=
      ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) r)
      ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))) r)))
  :pattern (($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) r))
  :pattern (($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))) r))
  :qid |qp.fvfValDef10|)))
(assert (forall ((r $Ref)) (!
  (and
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@51@06  $FVF<Bool>) r) r)
    ($FVF.loc_bool ($FVF.lookup_bool ($SortWrappers.$SnapTo$FVF<Bool> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))) r) r))
  :pattern (($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) r))
  :qid |qp.fvfResTrgDef11|)))
; Check receiver injectivity
(push) ; 6
(assert (not (forall ((k1@52@06 Int) (k2@52@06 Int)) (!
  (implies
    (and
      (and
        (and (< k1@52@06 V@25@06) (<= 0 k1@52@06))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k1@52@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k1@52@06)))
      (and
        (and (< k2@52@06 V@25@06) (<= 0 k2@52@06))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k2@52@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k2@52@06)))
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k1@52@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k2@52@06)))
    (= k1@52@06 k2@52@06))
  
  :qid |bool-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               782
;  :arith-add-rows          175
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      70
;  :arith-bound-prop        27
;  :arith-conflicts         22
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        23
;  :arith-pivots            82
;  :conflicts               35
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 74
;  :datatype-occurs-check   121
;  :datatype-splits         45
;  :decisions               124
;  :del-clause              444
;  :final-checks            67
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.72
;  :mk-bool-var             1291
;  :mk-clause               481
;  :num-allocs              192350
;  :num-checks              77
;  :propagations            194
;  :quant-instantiations    270
;  :rlimit-count            232787)
; Definitional axioms for inverse functions
(assert (forall ((k@52@06 Int)) (!
  (implies
    (and (< k@52@06 V@25@06) (<= 0 k@52@06))
    (=
      (inv@53@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@52@06))
      k@52@06))
  :pattern ((aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) k@52@06))
  :qid |bool-invOfFct|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@53@06 r) V@25@06) (<= 0 (inv@53@06 r)))
    (=
      (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) (inv@53@06 r))
      r))
  :pattern ((inv@53@06 r))
  :qid |bool-fctOfInv|)))
(assert (forall ((r $Ref)) (!
  (implies
    (and (< (inv@53@06 r) V@25@06) (<= 0 (inv@53@06 r)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) r) r))
  :pattern ((inv@53@06 r))
  )))
; Precomputing data for removing quantified permissions
(define-fun pTaken@55@06 ((r $Ref)) $Perm
  (ite
    (and (< (inv@53@06 r) V@25@06) (<= 0 (inv@53@06 r)))
    ($Perm.min
      (ite
        (=
          r
          (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
        $Perm.Write
        $Perm.No)
      $Perm.Write)
    $Perm.No))
(define-fun pTaken@56@06 ((r $Ref)) $Perm
  (ite
    (and (< (inv@53@06 r) V@25@06) (<= 0 (inv@53@06 r)))
    ($Perm.min
      (-
        (ite
          (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@50@06 r))
      (- $Perm.Write (pTaken@55@06 r)))
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
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
      $Perm.Write
      $Perm.No)
    (pTaken@55@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)))
  $Perm.No)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               806
;  :arith-add-rows          178
;  :arith-assert-diseq      29
;  :arith-assert-lower      119
;  :arith-assert-upper      71
;  :arith-bound-prop        29
;  :arith-conflicts         22
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        25
;  :arith-pivots            83
;  :conflicts               36
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 78
;  :datatype-occurs-check   127
;  :datatype-splits         48
;  :decisions               132
;  :del-clause              473
;  :final-checks            70
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.75
;  :mk-bool-var             1319
;  :mk-clause               501
;  :num-allocs              193849
;  :num-checks              79
;  :propagations            202
;  :quant-instantiations    274
;  :rlimit-count            234716)
; Intermediate check if already taken enough permissions
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@53@06 r) V@25@06) (<= 0 (inv@53@06 r)))
    (= (- $Perm.Write (pTaken@55@06 r)) $Perm.No))
  
  ))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               873
;  :arith-add-rows          202
;  :arith-assert-diseq      32
;  :arith-assert-lower      128
;  :arith-assert-upper      78
;  :arith-bound-prop        35
;  :arith-conflicts         23
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        32
;  :arith-pivots            92
;  :conflicts               37
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 82
;  :datatype-occurs-check   133
;  :datatype-splits         51
;  :decisions               147
;  :del-clause              548
;  :final-checks            73
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.79
;  :mk-bool-var             1410
;  :mk-clause               576
;  :num-allocs              195300
;  :num-checks              80
;  :propagations            228
;  :quant-instantiations    302
;  :rlimit-count            237288
;  :time                    0.00)
; Chunk depleted?
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (=
    (-
      (-
        (ite
          (and (< (inv@47@06 r) V@25@06) (<= 0 (inv@47@06 r)))
          $Perm.Write
          $Perm.No)
        (pTaken@50@06 r))
      (pTaken@56@06 r))
    $Perm.No)
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1092
;  :arith-add-rows          356
;  :arith-assert-diseq      45
;  :arith-assert-lower      196
;  :arith-assert-upper      134
;  :arith-bound-prop        61
;  :arith-conflicts         29
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         59
;  :arith-offset-eqs        54
;  :arith-pivots            131
;  :conflicts               56
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 83
;  :datatype-occurs-check   133
;  :datatype-splits         51
;  :decisions               170
;  :del-clause              801
;  :final-checks            73
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.81
;  :minimized-lits          2
;  :mk-bool-var             1810
;  :mk-clause               829
;  :num-allocs              197172
;  :num-checks              81
;  :propagations            375
;  :quant-instantiations    378
;  :rlimit-count            242259
;  :time                    0.00)
; Intermediate check if already taken enough permissions
(push) ; 6
(assert (not (forall ((r $Ref)) (!
  (implies
    (and (< (inv@53@06 r) V@25@06) (<= 0 (inv@53@06 r)))
    (= (- (- $Perm.Write (pTaken@55@06 r)) (pTaken@56@06 r)) $Perm.No))
  
  ))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1235
;  :arith-add-rows          427
;  :arith-assert-diseq      52
;  :arith-assert-lower      223
;  :arith-assert-upper      157
;  :arith-bound-prop        72
;  :arith-conflicts         34
;  :arith-eq-adapter        158
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        69
;  :arith-pivots            152
;  :conflicts               70
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 84
;  :datatype-occurs-check   133
;  :datatype-splits         51
;  :decisions               183
;  :del-clause              954
;  :final-checks            73
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.81
;  :minimized-lits          3
;  :mk-bool-var             2001
;  :mk-clause               982
;  :num-allocs              198160
;  :num-checks              82
;  :propagations            428
;  :quant-instantiations    405
;  :rlimit-count            245368
;  :time                    0.00)
; Final check if taken enough permissions
; Done removing quantified permissions
; Definitional axioms for snapshot map values
; [eval] exc == null ==> (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1252
;  :arith-add-rows          427
;  :arith-assert-diseq      52
;  :arith-assert-lower      223
;  :arith-assert-upper      157
;  :arith-bound-prop        72
;  :arith-conflicts         34
;  :arith-eq-adapter        158
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        69
;  :arith-pivots            152
;  :conflicts               70
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 88
;  :datatype-occurs-check   139
;  :datatype-splits         54
;  :decisions               191
;  :del-clause              970
;  :final-checks            76
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.82
;  :minimized-lits          3
;  :mk-bool-var             2016
;  :mk-clause               998
;  :num-allocs              198902
;  :num-checks              83
;  :propagations            436
;  :quant-instantiations    407
;  :rlimit-count            246141)
; [then-branch: 45 | exc@43@06 == Null | live]
; [else-branch: 45 | exc@43@06 != Null | dead]
(push) ; 7
; [then-branch: 45 | exc@43@06 == Null]
; [eval] (forall unknown: Int :: { aloc(opt_get1(visited), unknown) } 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false)
(declare-const unknown@57@06 Int)
(push) ; 8
; [eval] 0 <= unknown && unknown < V && unknown != s ==> aloc(opt_get1(visited), unknown).bool == false
; [eval] 0 <= unknown && unknown < V && unknown != s
; [eval] 0 <= unknown
(push) ; 9
; [then-branch: 46 | 0 <= unknown@57@06 | live]
; [else-branch: 46 | !(0 <= unknown@57@06) | live]
(push) ; 10
; [then-branch: 46 | 0 <= unknown@57@06]
(assert (<= 0 unknown@57@06))
; [eval] unknown < V
(push) ; 11
; [then-branch: 47 | unknown@57@06 < V@25@06 | live]
; [else-branch: 47 | !(unknown@57@06 < V@25@06) | live]
(push) ; 12
; [then-branch: 47 | unknown@57@06 < V@25@06]
(assert (< unknown@57@06 V@25@06))
; [eval] unknown != s
(pop) ; 12
(push) ; 12
; [else-branch: 47 | !(unknown@57@06 < V@25@06)]
(assert (not (< unknown@57@06 V@25@06)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 46 | !(0 <= unknown@57@06)]
(assert (not (<= 0 unknown@57@06)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 48 | unknown@57@06 != s@24@06 && unknown@57@06 < V@25@06 && 0 <= unknown@57@06 | live]
; [else-branch: 48 | !(unknown@57@06 != s@24@06 && unknown@57@06 < V@25@06 && 0 <= unknown@57@06) | live]
(push) ; 10
; [then-branch: 48 | unknown@57@06 != s@24@06 && unknown@57@06 < V@25@06 && 0 <= unknown@57@06]
(assert (and
  (and (not (= unknown@57@06 s@24@06)) (< unknown@57@06 V@25@06))
  (<= 0 unknown@57@06)))
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
(assert (not (< unknown@57@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1253
;  :arith-add-rows          429
;  :arith-assert-diseq      55
;  :arith-assert-lower      226
;  :arith-assert-upper      157
;  :arith-bound-prop        72
;  :arith-conflicts         34
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        69
;  :arith-pivots            152
;  :conflicts               70
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 88
;  :datatype-occurs-check   139
;  :datatype-splits         54
;  :decisions               191
;  :del-clause              970
;  :final-checks            76
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.82
;  :minimized-lits          3
;  :mk-bool-var             2023
;  :mk-clause               1002
;  :num-allocs              199093
;  :num-checks              84
;  :propagations            436
;  :quant-instantiations    407
;  :rlimit-count            246463)
(assert (< unknown@57@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(pop) ; 11
; Joined path conditions
(assert (< unknown@57@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06))))
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)))
(push) ; 11
(assert (not (<
  $Perm.No
  (+
    (ite
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
      $Perm.Write
      $Perm.No)
    (-
      (ite
        (and
          (<
            (inv@47@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))
            V@25@06)
          (<=
            0
            (inv@47@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))))
        $Perm.Write
        $Perm.No)
      (pTaken@50@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1336
;  :arith-add-rows          444
;  :arith-assert-diseq      56
;  :arith-assert-lower      239
;  :arith-assert-upper      167
;  :arith-bound-prop        79
;  :arith-conflicts         36
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         73
;  :arith-offset-eqs        79
;  :arith-pivots            158
;  :conflicts               83
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 89
;  :datatype-occurs-check   139
;  :datatype-splits         54
;  :decisions               207
;  :del-clause              1018
;  :final-checks            76
;  :max-generation          4
;  :max-memory              4.84
;  :memory                  4.81
;  :minimized-lits          3
;  :mk-bool-var             2133
;  :mk-clause               1088
;  :num-allocs              199677
;  :num-checks              85
;  :propagations            521
;  :quant-instantiations    434
;  :rlimit-count            248488)
(pop) ; 10
(push) ; 10
; [else-branch: 48 | !(unknown@57@06 != s@24@06 && unknown@57@06 < V@25@06 && 0 <= unknown@57@06)]
(assert (not
  (and
    (and (not (= unknown@57@06 s@24@06)) (< unknown@57@06 V@25@06))
    (<= 0 unknown@57@06))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
(assert (implies
  (and
    (and (not (= unknown@57@06 s@24@06)) (< unknown@57@06 V@25@06))
    (<= 0 unknown@57@06))
  (and
    (not (= unknown@57@06 s@24@06))
    (< unknown@57@06 V@25@06)
    (<= 0 unknown@57@06)
    (< unknown@57@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
    ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)))))
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((unknown@57@06 Int)) (!
  (implies
    (and
      (and (not (= unknown@57@06 s@24@06)) (< unknown@57@06 V@25@06))
      (<= 0 unknown@57@06))
    (and
      (not (= unknown@57@06 s@24@06))
      (< unknown@57@06 V@25@06)
      (<= 0 unknown@57@06)
      (< unknown@57@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
      ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)) (aloc ($Snap.combine
        $Snap.unit
        $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))))
  :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))
  :qid |prog.l<no position>-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (= exc@43@06 $Ref.null)
  (forall ((unknown@57@06 Int)) (!
    (implies
      (and
        (and (not (= unknown@57@06 s@24@06)) (< unknown@57@06 V@25@06))
        (<= 0 unknown@57@06))
      (and
        (not (= unknown@57@06 s@24@06))
        (< unknown@57@06 V@25@06)
        (<= 0 unknown@57@06)
        (< unknown@57@06 (alen<Int> (opt_get1 $Snap.unit visited@23@06)))
        ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06)) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))
    :qid |prog.l<no position>-aux|))))
(push) ; 6
(assert (not (implies
  (= exc@43@06 $Ref.null)
  (forall ((unknown@57@06 Int)) (!
    (implies
      (and
        (and (not (= unknown@57@06 s@24@06)) (< unknown@57@06 V@25@06))
        (<= 0 unknown@57@06))
      (=
        ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))
    :qid |prog.l<no position>|)))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1396
;  :arith-add-rows          492
;  :arith-assert-diseq      60
;  :arith-assert-lower      254
;  :arith-assert-upper      177
;  :arith-bound-prop        88
;  :arith-conflicts         38
;  :arith-eq-adapter        183
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        89
;  :arith-pivots            177
;  :conflicts               95
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 90
;  :datatype-occurs-check   139
;  :datatype-splits         54
;  :decisions               222
;  :del-clause              1158
;  :final-checks            76
;  :max-generation          4
;  :max-memory              4.90
;  :memory                  4.86
;  :minimized-lits          3
;  :mk-bool-var             2239
;  :mk-clause               1186
;  :num-allocs              200448
;  :num-checks              86
;  :propagations            580
;  :quant-instantiations    466
;  :rlimit-count            251400
;  :time                    0.00)
(assert (implies
  (= exc@43@06 $Ref.null)
  (forall ((unknown@57@06 Int)) (!
    (implies
      (and
        (and (not (= unknown@57@06 s@24@06)) (< unknown@57@06 V@25@06))
        (<= 0 unknown@57@06))
      (=
        ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
          $Snap.unit
          $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))
        false))
    :pattern ((aloc%limited ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) unknown@57@06))
    :qid |prog.l<no position>|))))
; [eval] exc == null ==> aloc(opt_get1(visited), s).bool == true
; [eval] exc == null
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= exc@43@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1413
;  :arith-add-rows          492
;  :arith-assert-diseq      60
;  :arith-assert-lower      254
;  :arith-assert-upper      177
;  :arith-bound-prop        88
;  :arith-conflicts         38
;  :arith-eq-adapter        183
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        89
;  :arith-pivots            177
;  :conflicts               95
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   145
;  :datatype-splits         57
;  :decisions               230
;  :del-clause              1174
;  :final-checks            79
;  :max-generation          4
;  :max-memory              4.90
;  :memory                  4.87
;  :minimized-lits          3
;  :mk-bool-var             2255
;  :mk-clause               1202
;  :num-allocs              201379
;  :num-checks              87
;  :propagations            588
;  :quant-instantiations    468
;  :rlimit-count            252503)
; [then-branch: 49 | exc@43@06 == Null | live]
; [else-branch: 49 | exc@43@06 != Null | dead]
(push) ; 7
; [then-branch: 49 | exc@43@06 == Null]
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
(assert ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)) (aloc ($Snap.combine
  $Snap.unit
  $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)))
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  $Perm.No
  (+
    (ite
      (=
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)
        (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
      $Perm.Write
      $Perm.No)
    (-
      (ite
        (and
          (<
            (inv@47@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
            V@25@06)
          (<=
            0
            (inv@47@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))))
        $Perm.Write
        $Perm.No)
      (pTaken@50@06 (aloc ($Snap.combine $Snap.unit $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1413
;  :arith-add-rows          492
;  :arith-assert-diseq      60
;  :arith-assert-lower      255
;  :arith-assert-upper      177
;  :arith-bound-prop        88
;  :arith-conflicts         39
;  :arith-eq-adapter        183
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        89
;  :arith-pivots            177
;  :conflicts               96
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   145
;  :datatype-splits         57
;  :decisions               230
;  :del-clause              1174
;  :final-checks            79
;  :max-generation          4
;  :max-memory              4.90
;  :memory                  4.86
;  :minimized-lits          3
;  :mk-bool-var             2256
;  :mk-clause               1202
;  :num-allocs              201614
;  :num-checks              88
;  :propagations            588
;  :quant-instantiations    468
;  :rlimit-count            252887)
(pop) ; 7
(pop) ; 6
; Joined path conditions
(assert (implies
  (= exc@43@06 $Ref.null)
  ($FVF.loc_bool ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06)) (aloc ($Snap.combine
    $Snap.unit
    $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))))
(push) ; 6
(assert (not (implies
  (= exc@43@06 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
    true))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1413
;  :arith-add-rows          492
;  :arith-assert-diseq      60
;  :arith-assert-lower      255
;  :arith-assert-upper      177
;  :arith-bound-prop        88
;  :arith-conflicts         39
;  :arith-eq-adapter        183
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        89
;  :arith-pivots            177
;  :conflicts               97
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 94
;  :datatype-occurs-check   145
;  :datatype-splits         57
;  :decisions               230
;  :del-clause              1174
;  :final-checks            79
;  :max-generation          4
;  :max-memory              4.90
;  :memory                  4.86
;  :minimized-lits          3
;  :mk-bool-var             2256
;  :mk-clause               1202
;  :num-allocs              201747
;  :num-checks              89
;  :propagations            588
;  :quant-instantiations    468
;  :rlimit-count            253054)
(assert (implies
  (= exc@43@06 $Ref.null)
  (=
    ($FVF.lookup_bool (as sm@54@06  $FVF<Bool>) (aloc ($Snap.combine
      $Snap.unit
      $Snap.unit) (opt_get1 $Snap.unit visited@23@06) s@24@06))
    true)))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
