using System;
using BrunoMikoski.AnimationSequencer;
using DG.Tweening;
using DG.Tweening.Core;
using DG.Tweening.Plugins.Options;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace AnimationSequencerExtensions
{
    [Serializable]
    public class ScaleToVariableDOTweenAction : DOTweenActionBase
    {
        public override string DisplayName => "Scale to variable";

        public override Type TargetComponentType => typeof(Transform);

        [SerializeField] private FloatVariable _scaleVariable;
        
        private Vector3? _previousState;
        private GameObject _previousTarget;
        
        protected override Tweener GenerateTween_Internal(GameObject target, float duration)
        {
            _previousState = target.transform.localScale;
            _previousTarget = target;
            
            var scale = new Vector3(_scaleVariable.Value, _scaleVariable.Value, 1);
            TweenerCore<Vector3, Vector3, VectorOptions> scaleTween = target.transform.DOScale(scale, duration).SetEase(ease);

            return scaleTween;
        }

        public override void ResetToInitialState()
        {
            if (!_previousState.HasValue)
                return;

            _previousTarget.transform.localScale = _previousState.Value;
        }
    }
}