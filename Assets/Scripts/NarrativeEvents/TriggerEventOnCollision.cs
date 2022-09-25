using System;
using System.Collections.Generic;
using NarrativeEvents.UI;
using UnityEngine;
using UnityEngine.Events;
using Utils.Attributes;
using Utils.Extensions;
using Event = NarrativeEvents.Data.Event;

namespace NarrativeEvents
{
    public class TriggerEventOnCollision : MonoBehaviour
    {
        [SerializeField, AutoProperty(AutoPropertyMode.Scene)] private EventDisplayer _eventDisplayer;
        [SerializeField] private List<Event> _events;
        [SerializeField] private LayerMask _collisionMask;
        
        [SerializeField] private UnityEvent _onEventStarted;
        [SerializeField] private UnityEvent _onEventEnded;

        private void Start()
        {
            _eventDisplayer = FindObjectOfType<EventDisplayer>();
        }

        private void OnTriggerEnter2D(Collider2D other)
        {
            if (_collisionMask.IsLayerInMask(other.gameObject.layer))
            {
                _onEventStarted.Invoke();
                var randomEvent = _events.GetRandom();
                _eventDisplayer.DisplayEvent(randomEvent, () => _onEventEnded.Invoke());
            }
        }
    }
}