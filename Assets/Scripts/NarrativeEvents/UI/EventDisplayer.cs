using System;
using System.Threading;
using System.Threading.Tasks;
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

        private bool _displaying;
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

        public void DisplayEvent(Event @event)
        {
            DisplayEvent(@event, null);
        }
        
        public void DisplayEvent(Event @event, Action endCallback)
        {
            DisplayEventAsync(@event, endCallback);
        }
        
        private async void DisplayEventAsync(Event @event, Action endCallback)
        {
            while (_displaying)
            {
                await Task.Yield();  // wait for another event being displayed
            }
            _displaying = true;
            _onDisplayEvent.Invoke();
            var ct = _cts.Token;
            var consequence = await Popups.ShowPopup(_eventPopupPrefab, @event, ct);
            _onEventEnded.Invoke();
            endCallback?.Invoke();
            consequence.ExecuteConsequences();
            _displaying = false;
        }
    }
}