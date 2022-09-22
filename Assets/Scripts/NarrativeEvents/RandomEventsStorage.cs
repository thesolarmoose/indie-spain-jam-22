using System.Collections.Generic;
using NaughtyAttributes;
using UnityEngine;
using Utils.Extensions;
using Event = NarrativeEvents.Data.Event;


namespace NarrativeEvents
{
    [CreateAssetMenu(fileName = "RandomEventsStorage", menuName = "Events/RandomEventsStorage", order = 0)]
    public class RandomEventsStorage : ScriptableObject
    {
        [SerializeField] private List<Event> _eventsPool;
        [SerializeField, DisableIf(nameof(Always))] private List<Event> _triggeredEvents;
        [SerializeField, Range(0, 1)] private float _selectFirstChance;

        public Event Next()
        {
            // TODO
            return _eventsPool.GetRandom();
        }

        private bool Always()
        {
            return true;
        }
    }
}