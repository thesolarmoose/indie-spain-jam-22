using System;
using BrunoMikoski.AnimationSequencer;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DefaultNamespace
{
    public class HealthDamageFeedback : MonoBehaviour
    {
        [SerializeField] private IntVariable _health;
        [SerializeField] private AnimationSequencerController _feedback;

        private void OnEnable()
        {
            _health.ChangedWithHistory.Register(OnHealthChanged);
        }

        private void OnHealthChanged(IntPair pair)
        {
            var (newValue, oldValue) = pair;
            bool damaged = newValue < oldValue;
            if (damaged)
            {
                _feedback.Play();
            }
        }
    }
}