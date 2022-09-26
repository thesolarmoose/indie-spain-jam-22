using System;
using BrunoMikoski.AnimationSequencer;
using DG.Tweening;
using UnityEngine;

namespace AnimationSequencerExtensions
{
    [Serializable]
    public class SetSpriteRendererAlpha : DOTweenActionBase
    {
        public override string DisplayName => "Set color Alpha";

        public override Type TargetComponentType => typeof(SpriteRenderer);

        [SerializeField] private float _value;
        
        private float? _previousState;
        private SpriteRenderer _previousTarget;

        private Tweener Empty()
        {
            return DOTween.To(
                () => 0,
                value =>
                {
                },
                _value,
                0
            );
        }
        
        protected override Tweener GenerateTween_Internal(GameObject target, float duration)
        {
            if (target == null)
            {
                return Empty();
            }
            
            var sr = target.GetComponent<SpriteRenderer>();

            if (sr == null)
            {
                return Empty();
            }
            
            var tweener = DOTween.To(
                () => sr.color.a,
                value =>
                {
                    var color = sr.color;
                    color.a = value;
                    sr.color = color;
                },
                _value,
                duration
            );

            return tweener;
        }

        public override void ResetToInitialState()
        {
            if (!_previousState.HasValue)
                return;

            var color = _previousTarget.color;
            color.a = _previousState.Value;
            _previousTarget.color = color;
        }
    }
}