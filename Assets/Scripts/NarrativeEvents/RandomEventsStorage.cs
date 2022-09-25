using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using NaughtyAttributes;
using SaveSystem;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Extensions;
using Event = NarrativeEvents.Data.Event;


namespace NarrativeEvents
{
    [CreateAssetMenu(fileName = "RandomEventsStorage", menuName = "Events/RandomEventsStorage", order = 0)]
    public class RandomEventsStorage : ScriptableObject
    {
        [SerializeField] private EventValueList _eventsPool;
        [SerializeField, DisableIf(nameof(Always))] private List<Event> _triggeredEvents;
        [SerializeField, Range(0, 1)] private float _selectFirstChance;

        public Event Next()
        {
            // TODO
            var remaining = _eventsPool.List.FindAll(ev => !_triggeredEvents.Contains(ev));
            if (remaining.Count == 0)
            {
                _triggeredEvents.Clear();
                remaining = _eventsPool.List;
            }

            var random = remaining.GetRandom();
            _triggeredEvents.Add(random);
            return random;
        }

        private bool Always()
        {
            return true;
        }
    }
}