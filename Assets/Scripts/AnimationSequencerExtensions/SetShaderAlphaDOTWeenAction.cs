using System;
using BrunoMikoski.AnimationSequencer;
using DG.Tweening;
using UnityEngine;

namespace AnimationSequencerExtensions
{
    [Serializable]
    public class SetShaderAlphaDOTWeenAction : DOTweenActionBase
    {
        public override string DisplayName => "Set Shader Alpha";

        public override Type TargetComponentType => typeof(SpriteRenderer);

        [SerializeField] private float _value;
        [SerializeField] private string _variableName;
        
        private float? _previousState;
        private Material _previousTarget;

        protected override Tweener GenerateTween_Internal(GameObject target, float duration)
        {
            var sr = target.GetComponent<SpriteRenderer>();
            var material = sr.material;

            var tweener = DOTween.To(
                () => material.GetFloat(_variableName),
                value => material.SetFloat(_variableName, value),
                _value,
                duration
            );

            return tweener;
        }

        public override void ResetToInitialState()
        {
            if (!_previousState.HasValue)
                return;

            _previousTarget.SetFloat(_variableName, _previousState.Value);
        }
    }
}