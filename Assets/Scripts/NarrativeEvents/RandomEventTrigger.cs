using System;
using System.Collections.Generic;
using NarrativeEvents.UI;
using UnityAtoms;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Attributes;
using Random = UnityEngine.Random;

namespace NarrativeEvents
{
    public class RandomEventTrigger : MonoBehaviour
    {
        [SerializeField] private List<Range> _ranges;
        [SerializeField] private FloatVariable _depthVariable;
        [SerializeField, AutoProperty(AutoPropertyMode.Asset)] private RandomEventsStorage _storage;
        [SerializeField, AutoProperty(AutoPropertyMode.Scene)] private EventDisplayer _displayer;

        private List<DepthEvent> _depthValuesToTriggerEvents = new List<DepthEvent>();

        private void Start()
        {
            CreateRandomTriggerValues();
        }

        private void OnEnable()
        {
            _depthVariable.Changed.Register(OnReachDepth);
        }

        private void OnDisable()
        {
            _depthVariable.Changed.Unregister(OnReachDepth);
        }

        private void CreateRandomTriggerValues()
        {
            foreach (var range in _ranges)
            {
                var random = Random.Range(range.Min, range.Max);
                var @event = new DepthEvent
                {
                    Depth = random,
                    Raised = false
                };
                _depthValuesToTriggerEvents.Add(@event);
            }
        }

        private void OnReachDepth(float depth)
        {
            foreach (var @event in _depthValuesToTriggerEvents)
            {
                var (triggerDepth, raised) = @event;
                if (!raised)
                {
                    if (depth >= triggerDepth)
                    {
                        @event.Raised = true;
                        RaiseRandomEvent();
                    }
                }
            }
        }

        private void RaiseRandomEvent()
        {
            var @event = _storage.Next();
            _displayer.DisplayEvent(@event);
        }
    }

    [Serializable]
    public class Range
    {
        public float Min;
        public float Max;
    }

    public class DepthEvent
    {
        public float Depth;
        public bool Raised;

        public void Deconstruct(out float depth, out bool raised)
        {
            depth = Depth;
            raised = Raised;
        }
    }
}