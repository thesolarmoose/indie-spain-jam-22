using System;
using UnityEngine;

namespace NarrativeEvents.UI
{
    public class ConstantLayoutUpdater : MonoBehaviour
    {
        [SerializeField] private RectTransform _transform;

        private bool _lastTimeSum;
        private void Update()
        {
            // This is a hack to constantly update a vertical layout due to children changing their sizes
            // dont do this at home XD
            var delta = _transform.sizeDelta;
            delta.y += _lastTimeSum ? -1 : 1;
            _lastTimeSum = !_lastTimeSum;
            _transform.sizeDelta = delta;
        }
    }
}