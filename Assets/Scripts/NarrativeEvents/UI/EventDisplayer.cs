using System;
using System.Threading;
using AsyncUtils;
using UnityEngine;
using UnityEngine.Events;
using Event = NarrativeEvents.Data.Event;

namespace NarrativeEvents.UI
{
    public class EventDisplayer : MonoBehaviour
    {
        [SerializeField] private EventPopup _eventPopupPrefab;
        [SerializeField] private Event _testEvent;

        [SerializeField] private UnityEvent _onDisplayEvent;
        [SerializeField] private UnityEvent _onEventEnded;

        private CancellationTokenSource _cts;

        private void OnEnable()
        {
            _cts = new CancellationTokenSource();
        }

        private void OnDisable()
        {
            if (!_cts.IsCancellationRequested)
            {
                _cts.Cancel();
            }
            _cts.Dispose();
        }

        [ContextMenu("Display event")]
        private void DisplayEvent()
        {
            DisplayEvent(_testEvent);
        }

        public async void DisplayEvent(Event @event)
        {
            _onDisplayEvent.Invoke();
            var ct = _cts.Token;
            await Popups.ShowPopup(_eventPopupPrefab, @event, ct);
            _onEventEnded.Invoke();
        }
    }
}