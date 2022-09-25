using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Utils;
using Utils.Tweening;

namespace Audio
{
    public class VerticalTransitioner : MonoBehaviour, IAudioSource
    {
        [SerializeField] private float _transitionDuration;
        [SerializeField] private List<AudioSource> _sources;

        private int _currentIndexPlaying;

        private AudioSource Current => _sources[_currentIndexPlaying];
        
        public float Volume
        {
            get => Current.volume;
            set => Current.volume = value;
        }
        
        public void Play()
        {
            foreach (var source in _sources)
            {
                source.Play();
            }
        }

        public void Stop()
        {
            foreach (var source in _sources)
            {
                source.Stop();
            }
        }

        public void Change(int index)
        {
            var current = Current;
            _currentIndexPlaying = index;
            
            var next = _sources[index];
            next.volume = 0;
            
            var transitionCoroutine = TweeningUtils.TweenTimeCoroutine(
                time =>
                {
                    current.volume = 1 - time;
                    next.volume = time;
                },
                _transitionDuration,
                Curves.Linear
            );
            var coroutine = CoroutineUtils.CoroutineSequence(new List<IEnumerator>
            {
                transitionCoroutine,
                CoroutineUtils.ActionCoroutine(() =>
                {
                    current.volume = 0;
                    next.volume = 1;
                    current.Stop();
                })
            });

            StartCoroutine(coroutine);
        }
    }
}