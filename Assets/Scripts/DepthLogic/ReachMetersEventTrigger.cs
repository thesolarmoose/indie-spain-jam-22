using System;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using UnityEngine.Events;

namespace DepthLogic
{
    public class ReachMetersEventTrigger : MonoBehaviour
    {
        [SerializeField] private FloatVariable _metersVariable;
        [SerializeField] private float _target;
        [SerializeField] private UnityEvent _event;

        private bool _reached;

        private void Update()
        {
            Check();
        }

        private void Check()
        {
            if (_reached)
            {
                return;
            }
            
            if (_metersVariable.Value >= _target)
            {
                _reached = true;
                _event.Invoke();
            }
        }
    }
}