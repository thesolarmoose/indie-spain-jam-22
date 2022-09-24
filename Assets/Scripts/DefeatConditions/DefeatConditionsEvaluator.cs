using System;
using System.Collections.Generic;
using BrunoMikoski.AnimationSequencer;
using NarrativeEvents.UI;
using UnityEngine;
using UnityEngine.SceneManagement;
using Utils.Attributes;
using Event = NarrativeEvents.Data.Event;

namespace DefeatConditions
{
    public class DefeatConditionsEvaluator : MonoBehaviour
    {
        [SerializeField] private List<DefeatEvaluatorBase> _evaluators;

        [SerializeField, AutoProperty(AutoPropertyMode.Scene)] private EventDisplayer _eventDisplayer;
        [SerializeField] private AnimationSequencerController _gameOverAnimation;

        private void Start()
        {
            RegisterListener();
        }

        private void RegisterListener()
        {
            foreach (var evaluator in _evaluators)
            {
                evaluator.OnDefeat += OnDefeat;
            }
        }
        
        private void UnregisterListener()
        {
            foreach (var evaluator in _evaluators)
            {
                evaluator.OnDefeat += OnDefeat;
            }
        }

        private void OnDefeat(Event defeatEvent)
        {
            UnregisterListener();
            
            _eventDisplayer.DisplayEvent(defeatEvent, () =>
            {
                _gameOverAnimation.Play();
            });
        }

        public void RestartGame()
        {
            var currentScene = SceneManager.GetActiveScene();
            SceneManager.LoadScene(currentScene.name);
        }
    }
}
