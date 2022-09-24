using UnityAtoms;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DefeatConditions
{
    public class IntDefeatEvaluator : DefeatEvaluatorBase, IAtomListener
    {
        [SerializeField] private IntVariable _variable;
        [SerializeField] private int _limit;

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