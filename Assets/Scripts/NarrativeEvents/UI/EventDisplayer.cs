using System;
using System.Threading;
using AsyncUtils;
using UnityEngine;
using UnityEngine.Serialization;

namespace NarrativeEvents.UI
{
    public class EventDisplayer : MonoBehaviour
    {
        [SerializeField] private EventPopup _eventPopupPrefab;
        [SerializeField] private Event _testEvent;

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
            var ct = _cts.Token;
            Popups.ShowPopup(_eventPopupPrefab, @event, ct);
        }
    }
}