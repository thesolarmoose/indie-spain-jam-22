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

        protected override Tweener GenerateTween_Internal(GameObject target, float duration)
        {
            var sr = target.GetComponent<SpriteRenderer>();
            var material = sr.material;

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