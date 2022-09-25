using System;
using BrunoMikoski.AnimationSequencer;
using NarrativeEvents.UI;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using UnityEngine.SceneManagement;
using Utils.Attributes;
using Event = NarrativeEvents.Data.Event;

namespace NarrativeEvents
{
    public class InitialAndFinalEventsTrigger : MonoBehaviour
    {
        [SerializeField] private Event _initialEvent;
        [SerializeField] private Event _finalEvent;
        [SerializeField] private FloatVariable _depth;
        [SerializeField,AutoProperty(AutoPropertyMode.Scene)] private EventDisplayer _eventDisplayer;
        [SerializeField] private AnimationSequencerController _restartAnimation;

        private bool _initialTriggered;
        private bool _finalTriggered;
        
        private void OnEnable()
        {
            _depth.Changed.Register(OnDepthChanged);
        }

        private void OnDepthChanged()
        {
            if (_depth.Value > 0.1 && !_initialTriggered)
            {
                _initialTriggered = true;
                var initialEvent = GetInitialEvent();
                _eventDisplayer.DisplayEvent(initialEvent);
            }

            if (_depth.Value >= 100 && !_finalTriggered)
            {
                _finalTriggered = true;
                var finalEvent = GetFinalEvent();
                _eventDisplayer.DisplayEvent(finalEvent, () => { _restartAnimation.Play(); });
            }
        }

        private Event GetInitialEvent()
        {
            return _initialEvent;
        }

        private Event GetFinalEvent()
        {
            return _finalEvent;
        }
    }
}