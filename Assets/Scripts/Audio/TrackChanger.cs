using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Utils;
using Utils.Tweening;

namespace Audio
{
    public class TrackChanger : MonoBehaviour
    {
        [SerializeField] private float _transitionDuration;
        [SerializeField] private List<AudioSource> _audioSources;

        private int _currentIndexPlaying;

        private AudioSource Current => _audioSources[_currentIndexPlaying];
        private AudioSource Next => _audioSources[++_currentIndexPlaying % _audioSources.Count];

        public void Play()
        {
            Current.UnPause();
        }

        public void Pause()
        {
            Current.Pause();
        }

        public void ChangeTrack(AudioClip clip)
        {
            var current = Current;
            var next = Next;
            next.volume = 0;
            next.clip = clip;
            next.Play();
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
                CoroutineUtils.ActionCoroutine(() => current.Stop())
            });

            StartCoroutine(coroutine);
        }
    }
}