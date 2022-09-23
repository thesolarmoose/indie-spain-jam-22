using System;
using BrunoMikoski.AnimationSequencer;
using DG.Tweening;
using UnityEngine;
using UnityEngine.U2D;

namespace AnimationSequencerExtensions
{
    [Serializable]
    public class SpriteShapeRendererSetAlpha : DOTweenActionBase
    {
        public override string DisplayName => "Set Shader Alpha";

        public override Type TargetComponentType => typeof(SpriteShapeRenderer);

        [SerializeField] private float _value;
        
        private float? _previousState;
        private SpriteShapeRenderer _previousTarget;

        protected override Tweener GenerateTween_Internal(GameObject target, float duration)
        {
            var sr = target.GetComponent<SpriteShapeRenderer>();

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