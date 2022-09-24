using System;
using UnityEngine;
using UnityEngine.Events;

namespace NarrativeEvents.Data.ConsequecesActions
{
    [Serializable]
    public class ConsequenceUnityEvent : IConsequence
    {
        [SerializeField] private UnityEvent _event;
        public void Execute()
        {
            _event.Invoke();
        }
    }
}