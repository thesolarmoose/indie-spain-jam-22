using System;
using UnityEngine;
using Event = NarrativeEvents.Data.Event;

namespace DefeatConditions
{
    public abstract class DefeatEvaluatorBase : MonoBehaviour
    {
        [SerializeField] private Event _defeatEvent;
        private Action<Event> _onDefeat;

        public Action<Event> OnDefeat
        {
            get => _onDefeat;
            set => _onDefeat = value;
        }

        protected void NotifyDefeat()
        {
            _onDefeat?.Invoke(_defeatEvent);
        }
    }
}