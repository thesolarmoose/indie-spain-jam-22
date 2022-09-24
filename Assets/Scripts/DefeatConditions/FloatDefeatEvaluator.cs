using System;
using UnityAtoms;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DefeatConditions
{
    public class FloatDefeatEvaluator : DefeatEvaluatorBase, IAtomListener
    {
        [SerializeField] private FloatVariable _variable;
        [SerializeField] private float _limit;

        private void OnEnable()
        {
            _variable.Changed.RegisterListener(this);
        }

        private void OnDisable()
        {
            _variable.Changed.UnregisterListener(this);
        }

        public void OnEventRaised()
        {
            if (_variable.Value <= _limit)
            {
                NotifyDefeat();
            }
        }
    }
}