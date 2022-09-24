using UnityAtoms;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DefeatConditions
{
    public class IntExactValueDefeatEvaluator : DefeatEvaluatorBase, IAtomListener
    {
        [SerializeField] private IntVariable _variable;
        [SerializeField] private int _value;

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
            if (_variable.Value == _value)
            {
                NotifyDefeat();
            }
        }
    }
}